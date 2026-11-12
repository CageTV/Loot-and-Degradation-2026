#pragma once
// Settings read from Data/SKSE/Plugins/LootandDegradation.ini (created with the defaults when missing). Defaults are the original mod's.
namespace Settings
{
	struct Data
	{
		// degradation (0..10000 roll, see Degrade.cpp): chance that a hit or swing degrades gear at all
		int   decayChance = 6667;
		float degradeMult = 1.0f;       // PlayerDegMult
		int   followerDecayChance = 0;  // followers (phase 2)
		float followerDegradeMult = 1.0f;
		// breaking
		float breakChance = 0.0f;  // PlayerBreakChance, 0 = off
		float followerBreakChance = 0.0f;
		int   breakType = 0;       // 0 only when untempered, 1 tempered items break only on power / blocked hits, 2 any time
		int   breakableItems = 0;  // 0 all, 1 weapons only, 2 armor only
		bool  requiemBreak = false;
		// tempered and enchanted NPC gear (the original's TemperRarity / EnchantRarity / LevelIncrementMult / LessLeveledLoot)
		int   npcTemperRarity = 12500000;  // 0 = NPCs get no temper; higher = more (and better) tempered gear
		int   npcEnchantRarity = 50;       // 0 = NPCs get no enchantments
		int   npcLevelStep = 8;            // levels per quality tier
		bool  npcLessLeveled = false;      // flatter odds: tempered gear is rarer at every level
		// the on-screen gear health widget (the original's iWant widget)
		int   widgetStyle = 0;  // 0 off, 1 bars with level names, 2 level names fading with health, 3 both
		float widgetGap = 14.0f;      // pixels between the level name and the percentage
	float widgetRowSpacing = 4.0f;  // pixels between rows
	float widgetBg = 0.35f;       // background opacity, 0 = none
	float widgetPad = 0.35f;      // padding inside each row, in text heights
		int   widgetOrient = 1; // 0 in a row, 1 in a column
		float widgetX = 90.0f, widgetY = 12.0f;  // where on the screen, 0..100 % (the widget always stays fully on screen)
		float widgetAlpha = 0.9f;
		float widgetScale = 1.3f;
		int   widgetIcons = 1;  // 0 text only, 1 new icons, 2 the original icons
		int   widgetIconColor = 0;  // 0 as drawn, 1 one colour of your choice, 2 by health (green when fresh, red when nearly worn)
	float widgetIconR = 0.95f, widgetIconG = 0.8f, widgetIconB = 0.4f;
	int   widgetItems = 0; // 0 weapons and armor, 1 weapons and shield, 2 armor
		bool  widgetContextual = false;  // only show with weapons drawn, or for widgetDelay seconds after gear changes
		float widgetDelay = 8.0f;
		int   degradeText = 0;  // 0 off, 1 when an item becomes untempered, 2 every level
		// material durability multipliers
		float cloth = 1.000001f, leatherWood = 1.300001f, iron = 1.200001f, steel = 1.100001f, elven = 1.050001f, falmer = 0.900001f;
		float dwarven = 0.850001f, glass = 0.800001f, orcish = 0.700001f, dragon = 0.600001f, daedricEbony = 0.550001f;
	};

	Data& Get();
	void  Load();
	void  Save();
}
