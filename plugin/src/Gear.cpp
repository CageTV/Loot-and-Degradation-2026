#include "PCH.h"
#include "Gear.h"

namespace Gear
{
	namespace
	{
		template <class F>
		Worn Search(RE::Actor* a_actor, F&& a_match)
		{
			Worn result;
			auto* changes = a_actor ? a_actor->GetInventoryChanges() : nullptr;
			if (!changes || !changes->entryList) {
				return result;
			}
			for (auto* entry : *changes->entryList) {
				if (!entry || !entry->object || !entry->extraLists) {
					continue;
				}
				for (auto* list : *entry->extraLists) {
					if (list && a_match(entry->object, list)) {
						result.entry = entry;
						result.list = list;
						result.object = entry->object;
						return result;
					}
				}
			}
			return result;
		}
	}

	Worn FindWeapon(RE::Actor* a_actor, bool a_left)
	{
		auto w = Search(a_actor, [&](RE::TESBoundObject* o, RE::ExtraDataList* l) {
			return o->As<RE::TESObjectWEAP>() && (a_left ? l->HasType(RE::ExtraDataType::kWornLeft) : l->HasType(RE::ExtraDataType::kWorn));
		});
		if (!w && !a_left) {  // a bow is worn in the left hand: the right-hand question is about the bow
			w = Search(a_actor, [&](RE::TESBoundObject* o, RE::ExtraDataList* l) {
				auto* weapon = o->As<RE::TESObjectWEAP>();
				return weapon && weapon->IsBow() && l->HasType(RE::ExtraDataType::kWornLeft);
			});
		}
		return w;
	}

	Worn FindArmor(RE::Actor* a_actor, std::uint32_t a_slotMask)
	{
		return Search(a_actor, [&](RE::TESBoundObject* o, RE::ExtraDataList* l) {
			auto* armor = o->As<RE::TESObjectARMO>();
			return armor && l->HasType(RE::ExtraDataType::kWorn) &&
			       armor->HasPartOf(static_cast<RE::BGSBipedObjectForm::BipedObjectSlot>(a_slotMask));
		});
	}

	bool BowEquipped(RE::Actor* a_actor)
	{
		auto w = Search(a_actor, [&](RE::TESBoundObject* o, RE::ExtraDataList* l) {
			auto* weapon = o->As<RE::TESObjectWEAP>();
			return weapon && (weapon->IsBow() || weapon->IsCrossbow()) && (l->HasType(RE::ExtraDataType::kWornLeft) || l->HasType(RE::ExtraDataType::kWorn));
		});
		return static_cast<bool>(w);
	}

	float Health(const Worn& a_worn)
	{
		if (!a_worn) {
			return 1.0f;
		}
		if (auto* h = a_worn.list->GetByType<RE::ExtraHealth>()) {
			return h->health;
		}
		return 1.0f;
	}

	void SetHealth(Worn& a_worn, float a_health)
	{
		if (!a_worn) {
			return;
		}
		if (auto* h = a_worn.list->GetByType<RE::ExtraHealth>()) {
			h->health = a_health;
		} else if (a_health != 1.0f) {
			a_worn.list->Add(new RE::ExtraHealth(a_health));
		}
	}
}
