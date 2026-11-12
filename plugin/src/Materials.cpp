#include "PCH.h"
#include "Materials.h"
#include "Settings.h"

namespace Materials
{
	namespace
	{
		bool Has(const RE::BGSKeywordForm* k, std::initializer_list<std::string_view> names)
		{
			for (auto n : names) {
				if (k->HasKeywordString(n)) {
					return true;
				}
			}
			return false;
		}
	}

	Info Classify(RE::TESBoundObject* a_item)
	{
		Info r;
		if (!a_item) {
			return r;
		}
		const auto& s = Settings::Get();
		if (auto* armor = a_item->As<RE::TESObjectARMO>()) {
			const RE::BGSKeywordForm* k = armor;
			if (Has(k, { "ArmorMaterialDaedric", "ArmorMaterialEbony" })) {
				r = { s.daedricEbony, Scrap::Ebony, 4, 6 };
			} else if (Has(k, { "ArmorMaterialDragonplate", "ArmorMaterialDragonScale" })) {
				r = { s.dragon, Scrap::DragonScales, 1, 1 };
			} else if (Has(k, { "ArmorMaterialDwarven" })) {
				r = { s.dwarven, Scrap::Dwemer, 4, 6 };
			} else if (Has(k, { "ArmorMaterialElven", "ArmorMaterialElvenGilded" })) {
				r = { s.elven, Scrap::Moon, 4, 6 };
			} else if (Has(k, { "DLC2ArmorMaterialBonemoldHeavy" })) {
				r = { s.elven, Scrap::BoneMeal, 4, 6 };
			} else if (Has(k, { "ArmorMaterialGlass" })) {
				r = { s.glass, Scrap::Mala, 4, 6 };
			} else if (Has(k, { "ArmorMaterialOrcish" })) {
				r = { s.orcish, Scrap::Orich, 4, 6 };
			} else if (Has(k, { "DLC2ArmorMaterialChitinLight", "DLC2ArmorMaterialChitinHeavy" })) {
				r = { s.orcish, Scrap::Chitin, 4, 6 };
			} else if (Has(k, { "DLC2ArmorMaterialStalhrimLight", "DLC2ArmorMaterialStalhrimHeavy" })) {
				r = { s.daedricEbony, Scrap::Stal, 4, 6 };
			} else if (Has(k, { "ArmorMaterialFalmer", "DLC1ArmorMaterielFalmerHeavyOriginal" })) {
				r = { s.falmer, Scrap::Chaurus, 4, 6 };
			} else if (Has(k, { "ArmorMaterialIron", "ArmorMaterialIronBanded" })) {
				r = { s.iron, Scrap::Iron, 4, 6 };
			} else if (Has(k, { "ArmorMaterialSteel", "ArmorMaterialScaled", "ArmorMaterialBlades", "ArmorMaterialImperialHeavy",
								"ArmorMaterialImperialLight", "ArmorMaterialImperialStudded", "ArmorMaterialPenitus", "DLC1ArmorMaterialDawnguard",
								"DLC2ArmorMaterialNordicHeavy" })) {
				r = { s.steel, Scrap::Steel, 4, 6 };
			} else if (Has(k, { "VendorItemClothing" })) {
				r = { s.cloth, Scrap::None, 0, 0 };
			} else {
				r = { s.leatherWood, Scrap::LeatherStrips, 3, 13 };
			}
		} else if (auto* weapon = a_item->As<RE::TESObjectWEAP>()) {
			if (static_cast<int>(weapon->GetWeaponType()) <= 0) {
				return r;  // fists
			}
			const RE::BGSKeywordForm* k = weapon;
			if (Has(k, { "WeapMaterialDaedric", "WeapMaterialEbony" })) {
				r = { s.daedricEbony, Scrap::Ebony, 2, 4 };
			} else if (Has(k, { "DLC1WeapMaterialDragonbone" })) {
				r = { s.dragon, Scrap::Ebony, 2, 4 };
			} else if (Has(k, { "WeapMaterialDwarven" })) {
				r = { s.dwarven, Scrap::Dwemer, 2, 4 };
			} else if (Has(k, { "WeapMaterialElven" })) {
				r = { s.elven, Scrap::Moon, 2, 4 };
			} else if (Has(k, { "WeapMaterialFalmer", "WeapMaterialFalmerHoned" })) {
				r = { s.falmer, Scrap::Chaurus, 2, 4 };
			} else if (Has(k, { "WeapMaterialGlass" })) {
				r = { s.glass, Scrap::Mala, 2, 4 };
			} else if (Has(k, { "WeapMaterialOrcish" })) {
				r = { s.orcish, Scrap::Orich, 2, 4 };
			} else if (Has(k, { "DLC2WeaponMaterialStalhrim" })) {
				r = { s.daedricEbony, Scrap::Stal, 2, 4 };
			} else if (!weapon->IsBow()) {
				if (Has(k, { "WeapMaterialIron" })) {
					r = { s.iron, Scrap::Iron, 2, 4 };
				} else {
					r = { s.steel, Scrap::Steel, 2, 4 };
				}
			} else {
				r = { s.leatherWood, Scrap::None, 0, 0 };
			}
		}
		return r;
	}

	RE::TESBoundObject* ScrapForm(Scrap a_scrap)
	{
		auto* dh = RE::TESDataHandler::GetSingleton();
		if (!dh) {
			return nullptr;
		}
		auto own = [&](RE::FormID id) { return dh->LookupForm<RE::TESBoundObject>(id, "LootandDegradation.esp"sv); };
		switch (a_scrap) {
		case Scrap::Ebony:         return own(0x01A73D);
		case Scrap::Dwemer:        return own(0x01A73C);
		case Scrap::Moon:          return own(0x01A73B);
		case Scrap::Mala:          return own(0x01A73A);
		case Scrap::Orich:         return own(0x01A739);
		case Scrap::Stal:          return own(0x01B775);
		case Scrap::Chaurus:       return own(0x01ACA8);
		case Scrap::Iron:          return own(0x01A736);
		case Scrap::Steel:         return own(0x01A738);
		case Scrap::BoneMeal:      return RE::TESForm::LookupByID<RE::TESBoundObject>(0x00034CDF);
		case Scrap::DragonScales:  return RE::TESForm::LookupByID<RE::TESBoundObject>(0x0003ADA4);
		case Scrap::LeatherStrips: return RE::TESForm::LookupByID<RE::TESBoundObject>(0x000800E4);
		case Scrap::Chitin:        return dh->LookupForm<RE::TESBoundObject>(0x02B04E, "Dragonborn.esm"sv);
		default:                   return nullptr;
		}
	}
}
