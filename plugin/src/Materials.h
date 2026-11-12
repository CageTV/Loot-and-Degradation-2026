#pragma once
// Which material an item is made of: its durability multiplier and what it breaks into (the original's _EDQuestScript.CheckMaterial).
namespace Materials
{
	enum class Scrap
	{
		None, Ebony, Dwemer, Moon, BoneMeal, Mala, Orich, Chitin, Stal, Chaurus, Iron, Steel, DragonScales, LeatherStrips
	};

	struct Info
	{
		float durability = 0.0f;  // 0 = not a weapon or armor this mod handles
		Scrap scrap = Scrap::None;
		int   minCount = 0;
		int   maxCount = 0;
	};

	Info                Classify(RE::TESBoundObject* a_item);
	RE::TESBoundObject* ScrapForm(Scrap a_scrap);

	// A record of a plugin by its file-local FormID: the plugin's load index is read from the load order and the full FormID is built from it.
	RE::TESForm* FromFile(std::string_view a_file, RE::FormID a_localId);
}
