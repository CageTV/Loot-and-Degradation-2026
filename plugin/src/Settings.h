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
		int   degradeText = 0;  // 0 off, 1 when an item becomes untempered, 2 every level
		// material durability multipliers
		float cloth = 1.000001f, leatherWood = 1.300001f, iron = 1.200001f, steel = 1.100001f, elven = 1.050001f, falmer = 0.900001f;
		float dwarven = 0.850001f, glass = 0.800001f, orcish = 0.700001f, dragon = 0.600001f, daedricEbony = 0.550001f;
	};

	Data& Get();
	void  Load();
	void  Save();
}
