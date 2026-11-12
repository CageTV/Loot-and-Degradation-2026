#include "PCH.h"
#include "Settings.h"

namespace Settings
{
	namespace
	{
		Data g_data;

		std::filesystem::path IniPath()
		{
			return std::filesystem::path("Data/SKSE/Plugins/LootandDegradation.ini");
		}

		std::string Trim(std::string s)
		{
			const auto b = s.find_first_not_of(" \t\r\n");
			if (b == std::string::npos) {
				return {};
			}
			const auto e = s.find_last_not_of(" \t\r\n");
			return s.substr(b, e - b + 1);
		}
	}

	Data& Get()
	{
		return g_data;
	}

	void Load()
	{
		std::ifstream in(IniPath());
		if (!in) {
			Save();
			SKSE::log::info("Settings: no ini found, wrote the defaults to {}", IniPath().string());
			return;
		}
		std::unordered_map<std::string, std::string> kv;
		std::string                                   line;
		while (std::getline(in, line)) {
			line = Trim(line);
			if (line.empty() || line[0] == ';' || line[0] == '#' || line[0] == '[') {
				continue;
			}
			const auto eq = line.find('=');
			if (eq == std::string::npos) {
				continue;
			}
			kv[Trim(line.substr(0, eq))] = Trim(line.substr(eq + 1));
		}
		auto getI = [&](const char* k, int& v) { if (auto it = kv.find(k); it != kv.end()) { try { v = std::stoi(it->second); } catch (...) {} } };
		auto getF = [&](const char* k, float& v) { if (auto it = kv.find(k); it != kv.end()) { try { v = std::stof(it->second); } catch (...) {} } };
		auto getB = [&](const char* k, bool& v) { if (auto it = kv.find(k); it != kv.end()) { v = it->second == "1" || it->second == "true"; } };
		auto& d = g_data;
		getI("DecayChance", d.decayChance);
		getF("DegradeMult", d.degradeMult);
		getI("FollowerDecayChance", d.followerDecayChance);
		getF("FollowerDegradeMult", d.followerDegradeMult);
		getF("BreakChance", d.breakChance);
		getF("FollowerBreakChance", d.followerBreakChance);
		getI("BreakType", d.breakType);
		getI("BreakableItems", d.breakableItems);
		getB("RequiemBreak", d.requiemBreak);
		getI("DegradeText", d.degradeText);
		getI("WidgetStyle", d.widgetStyle);
		getI("WidgetPos", d.widgetPos);
		getI("WidgetOrient", d.widgetOrient);
		getF("WidgetX", d.widgetX);
		getF("WidgetY", d.widgetY);
		getF("WidgetAlpha", d.widgetAlpha);
		getF("WidgetScale", d.widgetScale);
		getI("WidgetItems", d.widgetItems);
		getB("WidgetContextual", d.widgetContextual);
		getF("WidgetDelay", d.widgetDelay);
		getF("Cloth", d.cloth);
		getF("LeatherWood", d.leatherWood);
		getF("Iron", d.iron);
		getF("Steel", d.steel);
		getF("Elven", d.elven);
		getF("Falmer", d.falmer);
		getF("Dwarven", d.dwarven);
		getF("Glass", d.glass);
		getF("Orcish", d.orcish);
		getF("Dragon", d.dragon);
		getF("DaedricEbony", d.daedricEbony);
		d.decayChance = std::clamp(d.decayChance, 0, 10000);
		SKSE::log::info("Settings: decay chance {}, degrade x{}, break chance {}", d.decayChance, d.degradeMult, d.breakChance);
	}

	void Save()
	{
		std::filesystem::create_directories(IniPath().parent_path());
		std::ofstream out(IniPath(), std::ios::trunc);
		const auto&   d = g_data;
		out << "; Loot and Degradation 2026 (a remix of Loot and Degradation by isoku, CC BY-NC-SA 4.0)\n";
		out << "; These are also on the Loot and Degradation pages of the SKSE Menu Framework; changes there are written here.\n";
		out << std::format("[Degradation]\nDecayChance={}\nDegradeMult={}\nFollowerDecayChance={}\nFollowerDegradeMult={}\nDegradeText={}\n\n", d.decayChance,
			d.degradeMult, d.followerDecayChance, d.followerDegradeMult, d.degradeText);
		out << std::format("[Breaking]\nBreakChance={}\nFollowerBreakChance={}\nBreakType={}\nBreakableItems={}\nRequiemBreak={}\n\n", d.breakChance, d.followerBreakChance, d.breakType, d.breakableItems,
			d.requiemBreak ? 1 : 0);
		out << std::format("[Widget]\nWidgetStyle={}\nWidgetPos={}\nWidgetOrient={}\nWidgetX={}\nWidgetY={}\nWidgetAlpha={}\nWidgetScale={}\nWidgetItems={}\nWidgetContextual={}\nWidgetDelay={}\n\n",
			d.widgetStyle, d.widgetPos, d.widgetOrient, d.widgetX, d.widgetY, d.widgetAlpha, d.widgetScale, d.widgetItems, d.widgetContextual ? 1 : 0, d.widgetDelay);
		out << std::format("[Durability]\nCloth={}\nLeatherWood={}\nIron={}\nSteel={}\nElven={}\nFalmer={}\nDwarven={}\nGlass={}\nOrcish={}\nDragon={}\nDaedricEbony={}\n",
			d.cloth, d.leatherWood, d.iron, d.steel, d.elven, d.falmer, d.dwarven, d.glass, d.orcish, d.dragon, d.daedricEbony);
	}
}
