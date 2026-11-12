#pragma once
// The worn weapon and armor of an actor and their temper value (the item's ExtraHealth; 1.0 when it has none).
namespace Gear
{
	struct Worn
	{
		RE::InventoryEntryData* entry = nullptr;
		RE::ExtraDataList*      list = nullptr;
		RE::TESBoundObject*     object = nullptr;
		explicit operator bool() const { return entry && list && object; }
	};

	constexpr std::uint32_t kHead = 0x1, kCirclet = 0x2, kBody = 0x4, kHands = 0x8, kFeet = 0x80, kShield = 0x200;

	// The worn weapon in a hand. A bow is found in whichever hand it is worn in.
	Worn FindWeapon(RE::Actor* a_actor, bool a_left);
	// The worn armor covering a biped slot (a bit of the slot mask).
	Worn FindArmor(RE::Actor* a_actor, std::uint32_t a_slotMask);
	bool BowEquipped(RE::Actor* a_actor);

	float Health(const Worn& a_worn);
	void  SetHealth(Worn& a_worn, float a_health);
}
