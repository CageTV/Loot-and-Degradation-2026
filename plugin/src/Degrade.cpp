#include "PCH.h"
#include "Degrade.h"
#include "Gear.h"
#include "Materials.h"
#include "Settings.h"

namespace Degrade
{
	namespace
	{
		using clock = std::chrono::steady_clock;

		std::mt19937 g_rng{ std::random_device{}() };
		std::mutex   g_lock;
		bool         g_requiem = false;
		bool         g_whetstone = false;  // the player last improved gear with the repair kit (not at a grindstone or workbench): items seed with a thinner buffer

		// the original's hit / swing timers and break flags, one set for each actor that is being tracked
		struct State
		{
			bool              hitDelay = false;
			bool              weapDelay = false;
			bool              aggressive = false;  // the last swing was a power attack (or a bow bash): used by the break rules
			bool              crit = false;        // the last blocked hit landed on the weapon
			clock::time_point resetAt{};
		};
		std::unordered_map<RE::FormID, State> g_states;
		std::unordered_set<RE::FormID>        g_seeded;  // followers whose gear has been seeded since they were first seen

		State& StateOf(RE::Actor* a_actor)
		{
			return g_states[a_actor->GetFormID()];
		}

		bool IsPlayer(RE::Actor* a_actor)
		{
			return a_actor && a_actor->IsPlayerRef();
		}

		// The player, and (when follower degradation is on) the player's followers.
		bool Tracked(RE::Actor* a_actor)
		{
			if (!a_actor) {
				return false;
			}
			if (a_actor->IsPlayerRef()) {
				return Settings::Get().decayChance > 0;
			}
			return Settings::Get().followerDecayChance > 0 && !a_actor->IsDead() && a_actor->IsPlayerTeammate();
		}

		int RandInt(int a_lo, int a_hi)
		{
			return std::uniform_int_distribution<int>(a_lo, a_hi)(g_rng);
		}

		int RoundI(double a_value)
		{
			return static_cast<int>(std::floor(a_value + 0.5));
		}

		// the original's hit / swing timers: one shared window that frees both counters when it ends
		void ResetIfDue(State& a_state)
		{
			if ((a_state.hitDelay || a_state.weapDelay) && clock::now() >= a_state.resetAt) {
				a_state.hitDelay = false;
				a_state.weapDelay = false;
			}
		}

		struct Target
		{
			bool          weapon = false;
			bool          left = false;
			std::uint32_t mask = 0;
		};

		Gear::Worn Find(RE::Actor* a_actor, const Target& a_t)
		{
			return a_t.weapon ? Gear::FindWeapon(a_actor, a_t.left) : Gear::FindArmor(a_actor, a_t.mask);
		}

		const char* NameOf(RE::TESBoundObject* a_obj)
		{
			const char* n = a_obj ? a_obj->GetName() : nullptr;
			return n ? n : "";
		}

		bool HasKeyword(RE::TESBoundObject* a_obj, std::string_view a_editorId)
		{
			if (auto* armor = a_obj ? a_obj->As<RE::TESObjectARMO>() : nullptr) {
				return armor->HasKeywordString(a_editorId);
			}
			if (auto* weapon = a_obj ? a_obj->As<RE::TESObjectWEAP>() : nullptr) {
				return weapon->HasKeywordString(a_editorId);
			}
			return false;
		}

		bool ContainsBound(RE::TESBoundObject* a_obj)
		{
			return std::string_view(NameOf(a_obj)).find("Bound") != std::string_view::npos;
		}

		bool InNoBreakList(RE::TESBoundObject* a_obj)
		{
			auto* dh = RE::TESDataHandler::GetSingleton();
			if (!dh) {
				return false;
			}
			auto* listForm = Materials::FromFile("LootandDegradation.esp"sv, 0x01C23C);
			if (auto* list = listForm ? listForm->As<RE::BGSListForm>() : nullptr; list && list->HasForm(a_obj)) {
				return true;
			}
			// Dragonborn's Horksbane, Champion's Cudgel and Stormfang (the original adds them to its list at game start)
			const auto id = a_obj->GetLocalFormID();
			if (a_obj->GetFile(0) && a_obj->GetFile(0)->GetFilename() == "Dragonborn.esm"sv) {
				return id == 0x026490 || id == 0x01A578 || id == 0x026B0B;
			}
			return false;
		}

		bool UnderMageArmor(RE::Actor* a_actor)
		{
			auto* target = a_actor->AsMagicTarget();
			auto* effects = target ? target->GetActiveEffectList() : nullptr;
			if (!effects) {
				return false;
			}
			for (auto* effect : *effects) {
				auto* base = effect ? effect->GetBaseObject() : nullptr;
				if (base && base->HasKeywordString("MagicArmorSpell")) {
					return true;
				}
			}
			return false;
		}

		void PlayBreakSound(RE::Actor* a_actor, bool a_weapon)
		{
			auto* dh = RE::TESDataHandler::GetSingleton();
			auto* am = RE::BSAudioManager::GetSingleton();
			if (!dh || !am) {
				return;
			}
			auto* sound = Materials::FromFile("LootandDegradation.esp"sv, a_weapon ? 0x017C1B : 0x0186E1);
			auto* form = sound ? sound->As<RE::BGSSoundDescriptorForm>() : nullptr;
			if (!form || !form->soundDescriptor) {
				SKSE::log::warn("Break: the {} break sound record was not found", a_weapon ? "weapon" : "armor");
				return;
			}
			RE::BSSoundHandle handle;
			if (!am->GetSoundHandle(handle, form->soundDescriptor)) {
				SKSE::log::warn("Break: could not build the {} break sound", a_weapon ? "weapon" : "armor");
				return;
			}
			handle.SetPosition(a_actor->GetPosition());
			if (auto* node = a_actor->Get3D()) {
				handle.SetObjectToFollow(node);
			}
			handle.Play();
		}

		void BreakItem(RE::Actor* a_actor, Gear::Worn& a_worn, bool a_weapon)
		{
			const auto info = Materials::Classify(a_worn.object);
			const std::string name = NameOf(a_worn.object);
			PlayBreakSound(a_actor, a_weapon);
			a_actor->RemoveItem(a_worn.object, 1, RE::ITEM_REMOVE_REASON::kRemove, a_worn.list, nullptr);
			if (info.scrap != Materials::Scrap::None) {
				auto*     scrap = Materials::ScrapForm(info.scrap);
				const int count = RandInt(info.minCount, info.maxCount);
				if (scrap) {
					a_actor->AddObjectToContainer(scrap, nullptr, count, nullptr);
					SKSE::log::info("Break: {} -> {} x{} added ({:08X})", name, scrap->GetName(), count, scrap->GetFormID());
				} else {
					SKSE::log::warn("Break: {} should leave scrap type {} x{} but that item was not found", name, static_cast<int>(info.scrap), count);
				}
			} else {
				SKSE::log::info("Break: {} leaves no scrap", name);
			}
			if (IsPlayer(a_actor)) {
					Notify((name + " has broken into pieces.").c_str());
				}
		}

		// The original's TemperDecay: one roll against the decay chance, then either the item breaks or its temper drops by a_mag.
		void TemperDecay(RE::Actor* a_actor, State& a_state, const Target& a_t, float a_mag, bool a_power)
		{
			const auto& s = Settings::Get();
			const bool  player = IsPlayer(a_actor);
			const int   decayChance = player ? s.decayChance : s.followerDecayChance;
			const float degradeMult = player ? s.degradeMult : s.followerDegradeMult;
			const float breakChance = player ? s.breakChance : s.followerBreakChance;
			const int   chance = RandInt(1, 10000);
			if (chance >= decayChance) {
				return;
			}
			auto w = Find(a_actor, a_t);
			if (!w) {
				return;
			}
			float current = Gear::Health(w);
			if (current < 1.0f) {
				current = 1.0f;
			}
			const float base = std::floor(current * 10.0f) / 10.0f;
			if (a_power) {
				a_mag *= 2.0f;
			}
			bool breaks = false;
			if (breakChance > 0.0f) {
				const double common = breakChance * std::pow(a_mag * 10.0, 0.75) * 1550.0;
				const int    ceiling = g_requiem ? RoundI(60.0 * std::pow(base, -3.0) * common) :
				                                   RoundI((96.149 * base * base - 345.42 * base + 309.27) * common);
				if (s.breakType == 0) {
					breaks = current < 1.1f && chance < ceiling;
				} else if (s.breakType == 1) {
					if (current >= 1.1f) {
						breaks = (a_power || a_state.aggressive || a_state.crit) && chance < ceiling;
					} else {
						breaks = chance < ceiling;
					}
				} else {
					breaks = chance < ceiling;
				}
			}
			if (breaks) {
				const bool shield = !a_t.weapon && a_t.mask == Gear::kShield;
				bool       allowed = false;
				if (a_t.weapon || shield) {
					allowed = s.breakableItems < 2;
				} else {
					allowed = (s.breakableItems == 0 || s.breakableItems == 2) && !UnderMageArmor(a_actor);
				}
				if (allowed && !HasKeyword(w.object, "MagicDisallowEnchanting") && !InNoBreakList(w.object) && !ContainsBound(w.object)) {
					BreakItem(a_actor, w, a_t.weapon);
				}
				return;
			}
			if (current < 1.00099f) {
				return;
			}
			float next = current - a_mag * degradeMult;
			const float buffer = std::floor(next * 10.0f) / 10.0f + 0.00099f;
			if (next > buffer) {
				next = buffer;
			}
			if (player && s.degradeText > 0) {
				const int baseCur = static_cast<int>(current * 10.0f);
				const int baseNew = static_cast<int>(next * 10.0f);
				bool      show = false;
				if (s.degradeText == 1) {
					if (baseNew == 10 && baseCur == 11) {
						if (breakChance > 0.0f && s.breakType == 0) {
							Notify((std::string(NameOf(w.object)) + " is now vulnerable to breaking.").c_str());
						} else {
							show = true;
						}
					}
				} else if (baseNew < baseCur) {
					show = true;
				}
				if (show) {
					Notify((std::string(NameOf(w.object)) + " has degraded in quality.").c_str());
				}
			}
			Gear::SetHealth(w, next);
		}

		// The original's SetBufferHealth: gear that sits exactly on a temper level gets a full durability band above it.
		void SeedOne(RE::Actor* a_actor, const Target& a_t)
		{
			auto w = Find(a_actor, a_t);
			if (!w) {
				return;
			}
			const float health = Gear::Health(w);
			const float buffer = (g_whetstone && IsPlayer(a_actor)) ? 74.0f : 99.0f;
			float       current = health * 100000.0f;
			const float adjusted = static_cast<float>(static_cast<int>(current / 10000.0f)) * 10000.0f;
			if ((current == adjusted || static_cast<int>(current) == static_cast<int>(adjusted)) && current >= 110000.0f) {
				current += buffer;
				Gear::SetHealth(w, current / 100000.0f);
			}
		}

		void SeedAll(RE::Actor* a_actor)
		{
			if (!Tracked(a_actor)) {
				return;
			}
			SeedOne(a_actor, { true, false, 0 });
			SeedOne(a_actor, { true, true, 0 });
			for (auto mask : { Gear::kHead, Gear::kCirclet, Gear::kBody, Gear::kHands, Gear::kFeet, Gear::kShield }) {
				SeedOne(a_actor, { false, false, mask });
			}
		}

		// Seed an actor's gear a moment after something changed (the equipped item shows up in the inventory a little later).
		void SeedLater(RE::FormID a_id)
		{
			std::thread([a_id] {
				std::this_thread::sleep_for(500ms);
				SKSE::GetTaskInterface()->AddTask([a_id] {
					auto* actor = RE::TESForm::LookupByID<RE::Actor>(a_id);
					if (actor && actor->Is3DLoaded()) {
						std::scoped_lock l(g_lock);
						SeedAll(actor);
					}
				});
			}).detach();
		}

		class HitSink final : public RE::BSTEventSink<RE::TESHitEvent>
		{
		public:
			static HitSink* Get()
			{
				static HitSink i;
				return std::addressof(i);
			}

			RE::BSEventNotifyControl ProcessEvent(const RE::TESHitEvent* a_event, RE::BSTEventSource<RE::TESHitEvent>*) override
			{
				auto* actor = (a_event && a_event->target) ? a_event->target->As<RE::Actor>() : nullptr;
				if (!actor || !a_event->cause || !Tracked(actor)) {
					return RE::BSEventNotifyControl::kContinue;
				}
				auto* source = RE::TESForm::LookupByID(a_event->source);
				if (!source || !source->As<RE::TESObjectWEAP>()) {
					return RE::BSEventNotifyControl::kContinue;
				}
				std::scoped_lock l(g_lock);
				auto&            state = StateOf(actor);
				ResetIfDue(state);
				if (state.hitDelay) {
					return RE::BSEventNotifyControl::kContinue;
				}
				const bool power = a_event->flags.any(RE::TESHitEvent::Flag::kPowerAttack);
				const bool blocked = a_event->flags.any(RE::TESHitEvent::Flag::kHitBlocked);
				state.crit = false;
				if (blocked) {
					if (auto shield = Gear::FindArmor(actor, Gear::kShield)) {
						TemperDecay(actor, state, { false, false, Gear::kShield }, 0.000085f * Materials::Classify(shield.object).durability, power);
					} else {
						state.crit = true;
						TemperDecay(actor, state, { true, false, 0 }, 0.000091f * Materials::Classify(Gear::FindWeapon(actor, false).object).durability, power);
					}
				} else {
					auto hit = [&](std::uint32_t mask, float amount) {
						auto w = Gear::FindArmor(actor, mask);
						if (w) {
							TemperDecay(actor, state, { false, false, mask }, amount * Materials::Classify(w.object).durability, power);
						}
					};
					if (Gear::FindArmor(actor, Gear::kHead)) {
						hit(Gear::kHead, 0.000039f);
					} else {
						hit(Gear::kCirclet, 0.000039f);
					}
					hit(Gear::kBody, 0.000041f);
					hit(Gear::kHands, 0.000038f);
					hit(Gear::kFeet, 0.000023f);
				}
				state.hitDelay = true;
				state.resetAt = clock::now() + 3s;
				return RE::BSEventNotifyControl::kContinue;
			}
		};

		class EquipSink final : public RE::BSTEventSink<RE::TESEquipEvent>
		{
		public:
			static EquipSink* Get()
			{
				static EquipSink i;
				return std::addressof(i);
			}

			RE::BSEventNotifyControl ProcessEvent(const RE::TESEquipEvent* a_event, RE::BSTEventSource<RE::TESEquipEvent>*) override
			{
				auto* actor = (a_event && a_event->actor) ? a_event->actor->As<RE::Actor>() : nullptr;
				if (!actor || !Tracked(actor)) {
					return RE::BSEventNotifyControl::kContinue;
				}
				auto* obj = RE::TESForm::LookupByID(a_event->baseObject);
				if (obj && (obj->As<RE::TESObjectWEAP>() || obj->As<RE::TESObjectARMO>())) {
					SeedLater(actor->GetFormID());
				}
				return RE::BSEventNotifyControl::kContinue;
			}
		};

		class AnimSink final : public RE::BSTEventSink<RE::BSAnimationGraphEvent>
		{
		public:
			static AnimSink* Get()
			{
				static AnimSink i;
				return std::addressof(i);
			}

			RE::BSEventNotifyControl ProcessEvent(const RE::BSAnimationGraphEvent* a_event, RE::BSTEventSource<RE::BSAnimationGraphEvent>*) override
			{
				auto* actor = a_event && a_event->holder ? const_cast<RE::TESObjectREFR*>(a_event->holder)->As<RE::Actor>() : nullptr;
				if (!actor || !Tracked(actor)) {
					return RE::BSEventNotifyControl::kContinue;
				}
				const std::string_view tag = a_event->tag.c_str();
				if (tag != "weaponSwing" && tag != "weaponLeftSwing" && tag != "arrowRelease" && tag != "bashStop") {
					return RE::BSEventNotifyControl::kContinue;
				}
				std::scoped_lock l(g_lock);
				auto&            state = StateOf(actor);
				ResetIfDue(state);
				if (state.weapDelay) {
					return RE::BSEventNotifyControl::kContinue;
				}
				const bool bow = Gear::BowEquipped(actor);
				bool       rotating = false;
				actor->GetGraphVariableBool("bAllowRotation", rotating);
				float decay = 0.000034f;
				state.aggressive = false;
				if (rotating || (bow && tag == "bashStop")) {
					decay = 0.000068f;
					state.aggressive = true;
				}
				if (tag == "weaponLeftSwing") {
					auto w = Gear::FindWeapon(actor, true);
					if (w) {
						TemperDecay(actor, state, { true, true, 0 }, decay * Materials::Classify(w.object).durability, false);
					}
				} else if (tag != "bashStop" || bow) {
					auto w = Gear::FindWeapon(actor, false);
					if (w) {
						TemperDecay(actor, state, { true, false, 0 }, decay * Materials::Classify(w.object).durability, false);
					}
				}
				state.weapDelay = true;
				if (!state.hitDelay) {
					state.resetAt = clock::now() + 2s;
				}
				return RE::BSEventNotifyControl::kContinue;
			}
		};

		// Closing the crafting menu while not sitting at a grindstone or workbench means the player used the repair kit; getting up from one
		// of them clears that (the original's OnMenuClose / OnGetUp).
		class MenuSink final : public RE::BSTEventSink<RE::MenuOpenCloseEvent>
		{
		public:
			static MenuSink* Get()
			{
				static MenuSink i;
				return std::addressof(i);
			}

			RE::BSEventNotifyControl ProcessEvent(const RE::MenuOpenCloseEvent* a_event, RE::BSTEventSource<RE::MenuOpenCloseEvent>*) override
			{
				if (!a_event || a_event->opening || a_event->menuName != RE::CraftingMenu::MENU_NAME) {
					return RE::BSEventNotifyControl::kContinue;
				}
				auto* player = RE::PlayerCharacter::GetSingleton();
				if (!player) {
					return RE::BSEventNotifyControl::kContinue;
				}
				const bool kit = player->GetSitSleepState() == RE::SIT_SLEEP_STATE::kNormal;
				SKSE::log::info("Crafting menu closed ({}): {}", kit ? "not sitting" : "at a workbench", kit ? "repair kit thinner buffer" : "normal buffer");
				g_whetstone = kit;
				if (kit) {
					SeedLater(player->GetFormID());
				}
				return RE::BSEventNotifyControl::kContinue;
			}
		};

		bool AtCraftingFurniture(RE::PlayerCharacter* a_player)
		{
			auto handle = a_player->GetOccupiedFurniture();
			auto ref = handle ? handle.get() : nullptr;
			auto* base = ref ? ref->GetBaseObject() : nullptr;
			auto* furniture = base ? base->As<RE::TESFurniture>() : nullptr;
			return furniture && (furniture->HasKeywordString("CraftingSmithingSharpeningWheel") || furniture->HasKeywordString("CraftingSmithingArmorTable"));
		}

		// Once every second: notices when the player gets up from a grindstone or workbench, and finds followers to hook and seed.
		void Poll()
		{
			auto* player = RE::PlayerCharacter::GetSingleton();
			if (!player || !player->Is3DLoaded()) {
				return;
			}
			static bool s_atBench = false;
			const bool  atBench = AtCraftingFurniture(player);
			if (s_atBench && !atBench) {
				g_whetstone = false;
				SKSE::log::info("Left a grindstone or workbench: normal buffer");
				SeedLater(player->GetFormID());
			}
			s_atBench = atBench;

			auto* lists = RE::ProcessLists::GetSingleton();
			if (!lists || Settings::Get().followerDecayChance <= 0) {
				return;
			}
			std::unordered_set<RE::FormID> present;
			for (auto& handle : lists->highActorHandles) {
				auto actor = handle.get();
				if (!actor || actor.get() == player || !Tracked(actor.get())) {
					continue;
				}
				present.insert(actor->GetFormID());
				actor->RemoveAnimationGraphEventSink(AnimSink::Get());
				actor->AddAnimationGraphEventSink(AnimSink::Get());
				std::scoped_lock l(g_lock);
				if (g_seeded.insert(actor->GetFormID()).second) {
					SKSE::log::info("Follower {} ({:08X}) is now tracked", actor->GetName(), actor->GetFormID());
					SeedAll(actor.get());
				}
			}
			std::scoped_lock l(g_lock);
			std::erase_if(g_seeded, [&](RE::FormID id) { return !present.contains(id); });
		}

		void StartPoller()
		{
			static std::atomic<bool> started{ false };
			if (started.exchange(true)) {
				return;
			}
			std::thread([] {
				while (true) {
					std::this_thread::sleep_for(1s);
					SKSE::GetTaskInterface()->AddTask(Poll);
				}
			}).detach();
		}
	}

	void Register()
	{
		g_requiem = Materials::FromFile("Requiem.esp"sv, 0x973D69) != nullptr;
		auto* holder = RE::ScriptEventSourceHolder::GetSingleton();
		if (!holder) {
			SKSE::log::error("Degrade: the game's event source is not available");
			return;
		}
		holder->AddEventSink<RE::TESHitEvent>(HitSink::Get());
		holder->AddEventSink<RE::TESEquipEvent>(EquipSink::Get());
		if (auto* ui = RE::UI::GetSingleton()) {
			ui->AddEventSink<RE::MenuOpenCloseEvent>(MenuSink::Get());
		}
		SKSE::log::info("Degrade: listening for hits taken, equipment changes and the crafting menu (Requiem {})", g_requiem ? "found" : "not found");
	}

	void HookPlayer()
	{
		auto* player = RE::PlayerCharacter::GetSingleton();
		if (!player) {
			return;
		}
		player->RemoveAnimationGraphEventSink(AnimSink::Get());
		const bool ok = player->AddAnimationGraphEventSink(AnimSink::Get());
		SKSE::log::info("Degrade: animation events {}", ok ? "hooked" : "NOT hooked");
		{
			std::scoped_lock l(g_lock);
			g_states.clear();
			g_seeded.clear();
			g_whetstone = false;
		}
		SeedLater(player->GetFormID());
		StartPoller();
	}
}
