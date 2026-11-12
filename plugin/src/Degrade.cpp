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
		bool         g_hitDelay = false;
		bool         g_weapDelay = false;
		bool         g_aggressive = false;  // the last swing was a power attack (or a bow bash): used by the break rules
		bool         g_crit = false;        // the last blocked hit landed on the weapon
		bool         g_requiem = false;
		clock::time_point g_resetAt{};

		int RandInt(int a_lo, int a_hi)
		{
			return std::uniform_int_distribution<int>(a_lo, a_hi)(g_rng);
		}

		int RoundI(double a_value)
		{
			return static_cast<int>(std::floor(a_value + 0.5));
		}

		// the original's hit / swing timers: one shared window that frees both counters when it ends
		void ResetIfDue()
		{
			if ((g_hitDelay || g_weapDelay) && clock::now() >= g_resetAt) {
				g_hitDelay = false;
				g_weapDelay = false;
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
			if (auto* list = dh->LookupForm<RE::BGSListForm>(0x01C23C, "LootandDegradation.esp"sv); list && list->HasForm(a_obj)) {
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
			auto* form = dh->LookupForm<RE::BGSSoundDescriptorForm>(a_weapon ? 0x017C1B : 0x0186E1, "LootandDegradation.esp"sv);
			if (!form || !form->soundDescriptor) {
				return;
			}
			RE::BSSoundHandle handle;
			if (!am->GetSoundHandle(handle, form->soundDescriptor)) {
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
				if (auto* scrap = Materials::ScrapForm(info.scrap)) {
					a_actor->AddObjectToContainer(scrap, nullptr, RandInt(info.minCount, info.maxCount), nullptr);
				}
			}
			Notify((name + " has broken into pieces.").c_str());
		}

		// The original's TemperDecay: one roll against the decay chance, then either the item breaks or its temper drops by a_mag.
		void TemperDecay(RE::Actor* a_actor, const Target& a_t, float a_mag, bool a_power)
		{
			const auto& s = Settings::Get();
			const int   chance = RandInt(1, 10000);
			if (chance >= s.decayChance) {
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
			if (s.breakChance > 0.0f) {
				const double common = s.breakChance * std::pow(a_mag * 10.0, 0.75) * 1550.0;
				const int    ceiling = g_requiem ? RoundI(60.0 * std::pow(base, -3.0) * common) :
				                                   RoundI((96.149 * base * base - 345.42 * base + 309.27) * common);
				if (s.breakType == 0) {
					breaks = current < 1.1f && chance < ceiling;
				} else if (s.breakType == 1) {
					if (current >= 1.1f) {
						breaks = (a_power || g_aggressive || g_crit) && chance < ceiling;
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
			float next = current - a_mag * s.degradeMult;
			const float buffer = std::floor(next * 10.0f) / 10.0f + 0.00099f;
			if (next > buffer) {
				next = buffer;
			}
			if (s.degradeText > 0) {
				const int baseCur = static_cast<int>(current * 10.0f);
				const int baseNew = static_cast<int>(next * 10.0f);
				bool      show = false;
				if (s.degradeText == 1) {
					if (baseNew == 10 && baseCur == 11) {
						if (s.breakChance > 0.0f && s.breakType == 0) {
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
			float       current = health * 100000.0f;
			const float adjusted = static_cast<float>(static_cast<int>(current / 10000.0f)) * 10000.0f;
			if ((current == adjusted || static_cast<int>(current) == static_cast<int>(adjusted)) && current >= 110000.0f) {
				current += 99.0f;
				Gear::SetHealth(w, current / 100000.0f);
			}
		}

		void SeedAll(RE::Actor* a_actor)
		{
			if (Settings::Get().decayChance <= 0) {
				return;
			}
			SeedOne(a_actor, { true, false, 0 });
			SeedOne(a_actor, { true, true, 0 });
			for (auto mask : { Gear::kHead, Gear::kCirclet, Gear::kBody, Gear::kHands, Gear::kFeet, Gear::kShield }) {
				SeedOne(a_actor, { false, false, mask });
			}
		}

		void SeedLater()
		{
			std::thread([] {
				std::this_thread::sleep_for(500ms);
				SKSE::GetTaskInterface()->AddTask([] {
					if (auto* player = RE::PlayerCharacter::GetSingleton()) {
						std::scoped_lock l(g_lock);
						SeedAll(player);
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
				auto* player = RE::PlayerCharacter::GetSingleton();
				if (!a_event || !player || a_event->target.get() != player || !a_event->cause) {
					return RE::BSEventNotifyControl::kContinue;
				}
				auto* source = RE::TESForm::LookupByID(a_event->source);
				if (!source || !source->As<RE::TESObjectWEAP>() || Settings::Get().decayChance <= 0) {
					return RE::BSEventNotifyControl::kContinue;
				}
				std::scoped_lock l(g_lock);
				ResetIfDue();
				if (g_hitDelay) {
					return RE::BSEventNotifyControl::kContinue;
				}
				const bool power = a_event->flags.any(RE::TESHitEvent::Flag::kPowerAttack);
				const bool blocked = a_event->flags.any(RE::TESHitEvent::Flag::kHitBlocked);
				g_crit = false;
				if (blocked) {
					if (Gear::FindArmor(player, Gear::kShield)) {
						TemperDecay(player, { false, false, Gear::kShield }, 0.000085f * Materials::Classify(Gear::FindArmor(player, Gear::kShield).object).durability, power);
					} else {
						g_crit = true;
						TemperDecay(player, { true, false, 0 }, 0.000091f * Materials::Classify(Gear::FindWeapon(player, false).object).durability, power);
					}
				} else {
					auto hit = [&](std::uint32_t mask, float amount) {
						auto w = Gear::FindArmor(player, mask);
						if (w) {
							TemperDecay(player, { false, false, mask }, amount * Materials::Classify(w.object).durability, power);
						}
					};
					if (Gear::FindArmor(player, Gear::kHead)) {
						hit(Gear::kHead, 0.000039f);
					} else {
						hit(Gear::kCirclet, 0.000039f);
					}
					hit(Gear::kBody, 0.000041f);
					hit(Gear::kHands, 0.000038f);
					hit(Gear::kFeet, 0.000023f);
				}
				g_hitDelay = true;
				g_resetAt = clock::now() + 3s;
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
				auto* player = RE::PlayerCharacter::GetSingleton();
				if (!a_event || !player || a_event->actor.get() != player) {
					return RE::BSEventNotifyControl::kContinue;
				}
				auto* obj = RE::TESForm::LookupByID(a_event->baseObject);
				if (obj && (obj->As<RE::TESObjectWEAP>() || obj->As<RE::TESObjectARMO>())) {
					SeedLater();
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
				auto* player = RE::PlayerCharacter::GetSingleton();
				if (!a_event || !player || a_event->holder != player || Settings::Get().decayChance <= 0) {
					return RE::BSEventNotifyControl::kContinue;
				}
				const std::string_view tag = a_event->tag.c_str();
				if (tag != "weaponSwing" && tag != "weaponLeftSwing" && tag != "arrowRelease" && tag != "bashStop") {
					return RE::BSEventNotifyControl::kContinue;
				}
				std::scoped_lock l(g_lock);
				ResetIfDue();
				if (g_weapDelay) {
					return RE::BSEventNotifyControl::kContinue;
				}
				const bool bow = Gear::BowEquipped(player);
				bool       rotating = false;
				player->GetGraphVariableBool("bAllowRotation", rotating);
				float decay = 0.000034f;
				g_aggressive = false;
				if (rotating || (bow && tag == "bashStop")) {
					decay = 0.000068f;
					g_aggressive = true;
				}
				if (tag == "weaponLeftSwing") {
					auto w = Gear::FindWeapon(player, true);
					if (w) {
						TemperDecay(player, { true, true, 0 }, decay * Materials::Classify(w.object).durability, false);
					}
				} else if (tag != "bashStop" || bow) {
					auto w = Gear::FindWeapon(player, false);
					if (w) {
						TemperDecay(player, { true, false, 0 }, decay * Materials::Classify(w.object).durability, false);
					}
				}
				g_weapDelay = true;
				if (!g_hitDelay) {
					g_resetAt = clock::now() + 2s;
				}
				return RE::BSEventNotifyControl::kContinue;
			}
		};
	}

	void Register()
	{
		if (auto* dh = RE::TESDataHandler::GetSingleton()) {
			g_requiem = dh->LookupForm(0x973D69, "Requiem.esp"sv) != nullptr;
		}
		auto* holder = RE::ScriptEventSourceHolder::GetSingleton();
		if (!holder) {
			SKSE::log::error("Degrade: the game's event source is not available");
			return;
		}
		holder->AddEventSink<RE::TESHitEvent>(HitSink::Get());
		holder->AddEventSink<RE::TESEquipEvent>(EquipSink::Get());
		SKSE::log::info("Degrade: listening for hits taken and equipment changes (Requiem {})", g_requiem ? "found" : "not found");
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
		SeedLater();
	}
}
