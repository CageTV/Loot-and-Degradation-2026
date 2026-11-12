#include "PCH.h"
#include "NpcGear.h"
#include "EnchantNames.h"
#include "Gear.h"
#include "Materials.h"
#include "Settings.h"

// Tempered and enchanted NPC gear: the original's _EDNPC script and _EDQuestScript settings, done natively. When an NPC's 3D loads for the first time its
// worn weapons and armor are rolled once (temper by level, enchantment from the per-slot lists), and the roll is remembered in the co-save.
namespace NpcGear
{
	namespace
	{
		constexpr RE::FormID kIgnoreFaction = 0x016124;
		constexpr RE::FormID kIgnoreWeaponList = 0x016125;
		constexpr RE::FormID kIgnoreArmorList = 0x00B9E4;
		constexpr std::uint32_t kRecordDone = 'DONE';
		constexpr std::uint32_t kUniqueId = 'LDNG';

		std::mutex                                                       g_lock;
		std::mt19937                                                     g_rng{ std::random_device{}() };
		std::unordered_set<RE::FormID>                                   g_done;     // actors already rolled
		std::unordered_map<RE::FormID, std::unordered_set<RE::FormID>>   g_weapons;  // weapons already rolled when an NPC changes weapon

		int RandInt(int a_lo, int a_hi)
		{
			if (a_hi < a_lo) {
				a_hi = a_lo;
			}
			return std::uniform_int_distribution<int>(a_lo, a_hi)(g_rng);
		}

		float RandFloat(float a_lo, float a_hi)
		{
			return std::uniform_real_distribution<float>(a_lo, a_hi)(g_rng);
		}

		int RoundI(double a_value)
		{
			return static_cast<int>(std::floor(a_value + 0.5));
		}

		struct Roll
		{
			int   level = 1;
			int   mult = 8;
			bool  less = false;
			float randomDeg = 0.0f;
		};

		bool Disallowed(RE::TESBoundObject* a_obj)
		{
			auto* kw = a_obj ? a_obj->As<RE::BGSKeywordForm>() : nullptr;
			if (kw && kw->HasKeywordString("MagicDisallowEnchanting")) {
				return true;
			}
			const char* name = a_obj ? a_obj->GetName() : nullptr;
			return name && std::string_view(name).find("Bound") != std::string_view::npos;
		}

		bool InList(RE::FormID a_localId, RE::TESBoundObject* a_obj)
		{
			auto* form = Materials::FromFile("LootandDegradation.esp"sv, a_localId);
			auto* list = form ? form->As<RE::BGSListForm>() : nullptr;
			return list && list->HasForm(a_obj);
		}

		// the tier a level belongs to (0 for the first a_mult levels, then one more every a_mult levels)
		int Tier(int a_level, int a_mult)
		{
			for (int t = 0; t < 5; ++t) {
				if (a_level <= a_mult * (t + 1)) {
					return t;
				}
			}
			return 5;
		}

		// The original's SetRandomTemp: a roll against a level-scaled ceiling; returns 1.0 when the gear gets no temper.
		float RollTemper(const Roll& a_r, bool a_weapon)
		{
			const auto& s = Settings::Get();
			const int   tier = Tier(a_r.level, a_r.mult);
			const int   adjusted = std::max(1, tier == 0 ? a_r.level : a_r.level - a_r.mult * tier);
			const double rarity = s.npcTemperRarity;
			const int   maxChance = std::max(1, RoundI((a_weapon ? rarity / 1.15 : rarity) * a_r.mult * std::pow(static_cast<double>(adjusted), -1.14)));
			const int   roll = RandInt(1, maxChance);
			float       temper = 1.0f;
			if (a_r.less) {
				if (roll > 7500000) {
				} else if (roll > 3750000) {
					temper = 1.1f;
				} else if (roll > 1875000) {
					temper = 1.2f;
				} else if (roll > 937500) {
					temper = 1.3f;
				} else if (roll > 468750) {
					temper = 1.4f;
				} else if (roll > 234375) {
					temper = 1.5f;
				} else {
					temper = 1.6f;
				}
			} else {
				if (roll <= 7500000) {
					temper = 1.1f;
				} else if (roll > RoundI(0.818 * maxChance + adjusted * 150000.0 / a_r.mult / 8.0)) {
					temper = 0.9f;
				}
			}
			temper += 0.1f * static_cast<float>(tier);
			return temper;
		}

		void TryTemper(Gear::Worn& a_worn, const Roll& a_r, bool a_weapon)
		{
			if (Settings::Get().npcTemperRarity <= 0 || Gear::Health(a_worn) != 1.0f) {
				return;
			}
			float temper = RollTemper(a_r, a_weapon);
			if (temper > 1.0f) {
				temper = std::min(temper, 1.7f);
				Gear::SetHealth(a_worn, temper + a_r.randomDeg);
			}
		}

		float MagMax(const Roll& a_r)
		{
			if (a_r.less) {
				return 70.0f;
			}
			constexpr float table[] = { 12.5f, 15.0f, 20.0f, 30.0f, 45.0f, 70.0f };
			return table[Tier(a_r.level, a_r.mult)];
		}

		// The original's SetRandomEnchant: a random entry of the slot's enchantment list, kept when it is weak enough for the NPC's level.
		template <std::size_t N>
		void TryEnchant(RE::Actor* a_actor, Gear::Worn& a_worn, bool a_weapon, bool a_left, RE::FormID a_listId, const std::array<const char*, N>& a_names, const Roll& a_r)
		{
			const int rarity = Settings::Get().npcEnchantRarity;
			if (rarity <= 0 || a_worn.list->HasType(RE::ExtraDataType::kEnchantment)) {
				return;
			}
			auto* weapon = a_worn.object->As<RE::TESObjectWEAP>();
			auto* armor = a_worn.object->As<RE::TESObjectARMO>();
			if ((weapon && weapon->formEnchanting) || (armor && armor->formEnchanting)) {
				return;
			}
			auto* listForm = Materials::FromFile("LootandDegradation.esp"sv, a_listId);
			auto* list = listForm ? listForm->As<RE::BGSListForm>() : nullptr;
			if (!list || list->forms.empty()) {
				return;
			}
			const double size = static_cast<double>(list->forms.size());
			const double scaled = (a_weapon ? rarity / 1.33 : static_cast<double>(rarity)) * 30.0 * std::pow(1.325, -0.0815 * a_r.level);
			const int    span = static_cast<int>(size * RoundI(scaled) * (a_r.less ? 3 : 1));
			if (span < 1) {
				return;
			}
			const int index = static_cast<int>(std::ceil(RandInt(1, span) / 100.0)) - 1;
			if (index < 0 || index >= static_cast<int>(list->forms.size())) {
				return;
			}
			auto* ench = list->forms[index] ? list->forms[index]->As<RE::EnchantmentItem>() : nullptr;
			if (!ench || ench->effects.empty() || !ench->effects[0]) {
				return;
			}
			if (ench->effects[0]->effectItem.magnitude > MagMax(a_r)) {
				return;
			}
			a_worn.list->Add(new RE::ExtraEnchantment(ench, 500));
			const char* base = a_worn.object->GetName();
			if (base && static_cast<std::size_t>(index) < a_names.size()) {
				const std::string name = std::string(base) + a_names[index];
				if (auto* display = a_worn.list->GetByType<RE::ExtraTextDisplayData>()) {
					display->SetName(name.c_str());
				} else {
					a_worn.list->Add(new RE::ExtraTextDisplayData(name.c_str()));
				}
			}
			if (a_weapon) {
				a_actor->AsActorValueOwner()->SetActorValue(a_left ? RE::ActorValue::kLeftItemCharge : RE::ActorValue::kRightItemCharge, RandFloat(0.0f, 500.0f));
			}
		}

		// returns true when something is worn in that slot (the original's CheckEquipped)
		bool CheckWeapon(RE::Actor* a_actor, bool a_left, const Roll& a_r)
		{
			auto w = Gear::FindWeapon(a_actor, a_left);
			auto* weapon = w.object ? w.object->As<RE::TESObjectWEAP>() : nullptr;
			if (!w || !weapon || weapon->IsStaff() || Disallowed(w.object) || InList(kIgnoreWeaponList, w.object)) {
				return false;
			}
			TryTemper(w, a_r, true);
			TryEnchant(a_actor, w, true, a_left, 0x00DA3E, EnchantNames::kWeapon, a_r);
			return static_cast<int>(weapon->GetWeaponType()) > 4;
		}

		template <std::size_t N>
		bool CheckArmor(RE::Actor* a_actor, std::uint32_t a_mask, RE::FormID a_listId, const std::array<const char*, N>& a_names, const Roll& a_r)
		{
			auto  w = Gear::FindArmor(a_actor, a_mask);
			auto* armor = w.object ? w.object->As<RE::TESObjectARMO>() : nullptr;
			if (!w || !armor) {
				return false;
			}
			if (!Disallowed(w.object) && !InList(kIgnoreArmorList, w.object)) {
				if (!armor->HasKeywordString("VendorItemClothing")) {
					TryTemper(w, a_r, false);
					TryEnchant(a_actor, w, false, false, a_listId, a_names, a_r);
				} else if (a_mask == Gear::kFeet) {
					TryEnchant(a_actor, w, false, false, a_listId, a_names, a_r);
				}
			}
			return true;
		}

		Roll MakeRoll(RE::Actor* a_actor)
		{
			const auto& s = Settings::Get();
			Roll        r;
			r.mult = std::max(1, s.npcLevelStep);
			r.less = s.npcLessLeveled;
			const int ceiling = r.mult * 6 - RoundI(r.mult / 2.0);
			r.level = std::clamp(static_cast<int>(a_actor->GetLevel()), 1, ceiling);
			r.randomDeg = s.decayChance > 0 ? RandFloat(0.00001f, 0.00098f) : 0.0f;
			return r;
		}

		bool Eligible(RE::Actor* a_actor)
		{
			if (!a_actor || a_actor->IsPlayerRef() || a_actor->IsPlayerTeammate() || a_actor->IsDisabled()) {
				return false;
			}
			auto* faction = Materials::FromFile("LootandDegradation.esp"sv, kIgnoreFaction);
			auto* ignore = faction ? faction->As<RE::TESFaction>() : nullptr;
			return !(ignore && a_actor->IsInFaction(ignore));
		}

		void Process(RE::FormID a_id)
		{
			const auto& s = Settings::Get();
			if (s.npcTemperRarity <= 0 && s.npcEnchantRarity <= 0) {
				return;
			}
			auto* actor = RE::TESForm::LookupByID<RE::Actor>(a_id);
			if (!actor || !actor->Is3DLoaded() || !Eligible(actor)) {
				return;
			}
			std::scoped_lock l(g_lock);
			if (!g_done.insert(a_id).second) {
				return;
			}
			const Roll r = MakeRoll(actor);
			if (!CheckWeapon(actor, false, r)) {
				CheckWeapon(actor, true, r);
			}
			if (!CheckArmor(actor, Gear::kHead, 0x014B93, EnchantNames::kHead, r)) {
				CheckArmor(actor, Gear::kCirclet, 0x014B93, EnchantNames::kHead, r);
			}
			CheckArmor(actor, Gear::kBody, 0x014B94, EnchantNames::kBody, r);
			CheckArmor(actor, Gear::kHands, 0x014B95, EnchantNames::kHand, r);
			CheckArmor(actor, Gear::kFeet, 0x014B96, EnchantNames::kFeet, r);
			CheckArmor(actor, Gear::kShield, 0x014B97, EnchantNames::kShield, r);
			SKSE::log::info("NpcGear: rolled gear for {} ({:08X}), level {}", actor->GetName(), a_id, r.level);
		}

		// a weapon an NPC swaps to later (the original's OnObjectEquipped in its WaitingToDie state)
		void ProcessWeapon(RE::FormID a_actorId, RE::FormID a_weaponId)
		{
			auto* actor = RE::TESForm::LookupByID<RE::Actor>(a_actorId);
			if (!actor || !actor->Is3DLoaded()) {
				return;
			}
			std::scoped_lock l(g_lock);
			if (!g_done.contains(a_actorId) || !g_weapons[a_actorId].insert(a_weaponId).second) {
				return;
			}
			const Roll r = MakeRoll(actor);
			if (!CheckWeapon(actor, false, r)) {
				CheckWeapon(actor, true, r);
			}
		}

		void Later(std::function<void()> a_work)
		{
			std::thread([work = std::move(a_work)] {
				std::this_thread::sleep_for(1s);
				SKSE::GetTaskInterface()->AddTask(work);
			}).detach();
		}

		class LoadSink final : public RE::BSTEventSink<RE::TESObjectLoadedEvent>
		{
		public:
			static LoadSink* Get()
			{
				static LoadSink i;
				return std::addressof(i);
			}

			RE::BSEventNotifyControl ProcessEvent(const RE::TESObjectLoadedEvent* a_event, RE::BSTEventSource<RE::TESObjectLoadedEvent>*) override
			{
				if (!a_event || !a_event->loaded) {
					return RE::BSEventNotifyControl::kContinue;
				}
				auto* form = RE::TESForm::LookupByID(a_event->formID);
				if (form && form->Is(RE::FormType::ActorCharacter)) {
					const auto id = a_event->formID;
					Later([id] { Process(id); });
				}
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
				if (!a_event || !a_event->equipped || !a_event->actor) {
					return RE::BSEventNotifyControl::kContinue;
				}
				auto* actor = a_event->actor->As<RE::Actor>();
				auto* obj = RE::TESForm::LookupByID(a_event->baseObject);
				if (actor && !actor->IsPlayerRef() && obj && obj->As<RE::TESObjectWEAP>()) {
					const auto actorId = actor->GetFormID();
					const auto weaponId = obj->GetFormID();
					Later([actorId, weaponId] { ProcessWeapon(actorId, weaponId); });
				}
				return RE::BSEventNotifyControl::kContinue;
			}
		};

		void OnSave(SKSE::SerializationInterface* a_intfc)
		{
			std::scoped_lock l(g_lock);
			if (a_intfc->OpenRecord(kRecordDone, 1)) {
				const std::uint32_t count = static_cast<std::uint32_t>(g_done.size());
				a_intfc->WriteRecordData(count);
				for (auto id : g_done) {
					a_intfc->WriteRecordData(id);
				}
			}
		}

		void OnLoad(SKSE::SerializationInterface* a_intfc)
		{
			std::scoped_lock l(g_lock);
			g_done.clear();
			g_weapons.clear();
			std::uint32_t type, version, length;
			while (a_intfc->GetNextRecordInfo(type, version, length)) {
				if (type != kRecordDone) {
					continue;
				}
				std::uint32_t count = 0;
				a_intfc->ReadRecordData(count);
				for (std::uint32_t i = 0; i < count; ++i) {
					RE::FormID id = 0;
					a_intfc->ReadRecordData(id);
					RE::FormID resolved = 0;
					if (a_intfc->ResolveFormID(id, resolved)) {
						g_done.insert(resolved);
					}
				}
			}
			SKSE::log::info("NpcGear: {} NPCs already rolled in this save", g_done.size());
		}

		void OnRevert(SKSE::SerializationInterface*)
		{
			std::scoped_lock l(g_lock);
			g_done.clear();
			g_weapons.clear();
		}
	}

	void Register()
	{
		auto* holder = RE::ScriptEventSourceHolder::GetSingleton();
		if (!holder) {
			SKSE::log::error("NpcGear: the game's event source is not available");
			return;
		}
		holder->AddEventSink<RE::TESObjectLoadedEvent>(LoadSink::Get());
		holder->AddEventSink<RE::TESEquipEvent>(EquipSink::Get());
		SKSE::log::info("NpcGear: rolling temper and enchantments for NPC gear as NPCs load");
	}

	void RegisterSerialization()
	{
		auto* intfc = SKSE::GetSerializationInterface();
		intfc->SetUniqueID(kUniqueId);
		intfc->SetSaveCallback(OnSave);
		intfc->SetLoadCallback(OnLoad);
		intfc->SetRevertCallback(OnRevert);
	}
}
