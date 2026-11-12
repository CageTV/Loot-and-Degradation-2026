#include "PCH.h"
#include "Menu.h"
#include "Settings.h"

#include "SKSEMenuFramework.h"

namespace Menu
{
	namespace
	{
		using namespace ImGuiMCP;
		using clock = std::chrono::steady_clock;

		std::atomic<bool> g_registered{ false };
		bool              g_dirty = false;
		clock::time_point g_changedAt{};

		// Every change is applied at once (the engine reads the settings when a hit or swing happens) and written to the ini a second after the last change.
		bool Changed(bool a_changed)
		{
			if (a_changed) {
				g_dirty = true;
				g_changedAt = clock::now();
			}
			return a_changed;
		}

		void Note(const char* a_text)
		{
			TextWrapped("%s", a_text);
			Spacing();
		}

		void __stdcall RenderDegradation()
		{
			auto& d = Settings::Get();
			Text("Degradation");
			Note("Tempered weapons and armor slowly lose their temper when you swing, shoot, block or get hit, and fall back one level at a time "
				 "until they are untempered. The rate depends on the material (see Durability).");
			Separator();

			float percent = static_cast<float>(d.decayChance) / 100.0f;
			if (Changed(SliderFloat("Chance a hit or swing wears gear", &percent, 0.0f, 100.0f, d.decayChance <= 0 ? "Off" : "%.1f%%"))) {
				d.decayChance = std::clamp(static_cast<int>(percent * 100.0f + 0.5f), 0, 10000);
			}
			Note("Each counted hit taken or swing rolls against this. 0 turns degradation off. Default 66.7%.");

			Changed(SliderFloat("Degradation speed", &d.degradeMult, 0.1f, 5.0f, "%.2fx"));
			Note("Multiplies how much temper is lost each time gear wears. Default 1.00x.");

			static const char* const kText[] = { "Off", "When an item becomes untempered", "Every time an item loses a level" };
			Changed(Combo("Messages", &d.degradeText, kText, 3));
			Note("Shows a message on screen when gear degrades.");

			Separator();
			Text("Followers");
			float followerPercent = static_cast<float>(d.followerDecayChance) / 100.0f;
			if (Changed(SliderFloat("Chance a follower's gear wears", &followerPercent, 0.0f, 100.0f, d.followerDecayChance <= 0 ? "Off" : "%.1f%%"))) {
				d.followerDecayChance = std::clamp(static_cast<int>(followerPercent * 100.0f + 0.5f), 0, 10000);
			}
			Note("The same wear rules for your followers' weapons, armor and shields. 0 leaves their gear alone (the default).");
			Changed(SliderFloat("Follower degradation speed", &d.followerDegradeMult, 0.1f, 5.0f, "%.2fx"));
		}

		void __stdcall RenderBreaking()
		{
			auto& d = Settings::Get();
			Text("Breaking");
			Note("Worn gear can break into pieces when it wears, leaving scrap you can smelt. The faster something degrades and the lower its temper, "
				 "the more likely it is. Artifacts, items on the no-break list, bound items, and armor under a Mage Armor effect never break. Off by default.");
			Separator();

			Changed(SliderFloat("Break chance", &d.breakChance, 0.0f, 50.0f, d.breakChance <= 0.0f ? "Off" : "%.1f"));
			Changed(SliderFloat("Follower break chance", &d.followerBreakChance, 0.0f, 50.0f, d.followerBreakChance <= 0.0f ? "Off" : "%.1f"));
			Note("0 turns breaking off. Higher is more likely; 1.0 is a rare event, 20 breaks untempered gear within a few hits.");

			static const char* const kType[] = { "Only untempered gear", "Tempered gear only on power attacks and blocked hits", "Any time" };
			Changed(Combo("When can gear break", &d.breakType, kType, 3));

			static const char* const kItems[] = { "Weapons, shields and armor", "Weapons and shields only", "Armor only" };
			Changed(Combo("What can break", &d.breakableItems, kItems, 3));

			if (d.breakChance > 0.0f || d.followerBreakChance > 0.0f) {
				Spacing();
				TextColored(ImVec4(1.0f, 0.75f, 0.35f, 1.0f), "Breaking is on: gear that breaks is gone for good.");
			}
		}

		void __stdcall RenderDurability()
		{
			auto& d = Settings::Get();
			Text("Durability by material");
			Note("How fast each material wears. Lower wears faster and breaks sooner; higher lasts longer. Cloth and leather are the least durable, daedric and ebony the most (the numbers are the original's).");
			Separator();

			struct Row
			{
				const char* name;
				float*      value;
			};
			Row rows[] = {
				{ "Cloth", &d.cloth },
				{ "Leather, hide, fur and wood", &d.leatherWood },
				{ "Iron", &d.iron },
				{ "Steel and Imperial", &d.steel },
				{ "Elven and bonemold", &d.elven },
				{ "Falmer", &d.falmer },
				{ "Dwarven", &d.dwarven },
				{ "Glass", &d.glass },
				{ "Orcish and chitin", &d.orcish },
				{ "Dragon", &d.dragon },
				{ "Daedric, ebony and stalhrim", &d.daedricEbony },
			};
			for (auto& r : rows) {
				Changed(SliderFloat(r.name, r.value, 0.3f, 2.5f, "%.2f"));
			}
			Spacing();
			if (Button("Reset everything to the original defaults")) {
				d = Settings::Data{};
				g_dirty = true;
				g_changedAt = clock::now();
			}
		}

		void __stdcall RenderAbout()
		{
			Text("Loot and Degradation 2026");
			Note("A modernised, native SKSE version of Loot and Degradation by isoku (2014). Settings are read as the game runs; changes are saved to "
				 "Data/SKSE/Plugins/LootandDegradation.ini a second after you stop moving a slider.");
			Separator();
			Text("Credits");
			Note("isoku - original author. richmondb - the whetstone. psychosteve - the widget icons.");
			Text("License");
			Note("Released under CC BY-NC-SA 4.0 (https://creativecommons.org/licenses/by-nc-sa/4.0/): free to copy, redistribute and remix with credit, "
				 "under the same license, and never for commercial use or behind a paywall. Changes are not endorsed by Step Modifications or the original author.");
			Text("What changed");
			Note("The Papyrus scripts are replaced by this plugin; the SkyUI MCM is replaced by these pages; updated for Skyrim SE/AE.");
		}

		// Drawn every frame: writes the ini a moment after the last change.
		void __stdcall Frame()
		{
			if (g_dirty && clock::now() - g_changedAt > 1s) {
				g_dirty = false;
				Settings::Save();
			}
		}
	}

	bool Registered()
	{
		return g_registered;
	}

	void Register()
	{
		if (!SKSEMenuFramework::IsInstalled()) {
			SKSE::log::warn("SKSE Menu Framework not found: no settings pages; edit Data/SKSE/Plugins/LootandDegradation.ini instead");
			return;
		}
		SKSEMenuFramework::SetSection("Loot and Degradation");
		SKSEMenuFramework::AddSectionItem("Degradation", RenderDegradation);
		SKSEMenuFramework::AddSectionItem("Breaking", RenderBreaking);
		SKSEMenuFramework::AddSectionItem("Durability", RenderDurability);
		SKSEMenuFramework::AddSectionItem("About", RenderAbout);
		SKSEMenuFramework::AddHudElement(Frame);
		g_registered = true;
		SKSE::log::info("Registered with SKSE Menu Framework {}", SKSEMenuFramework::GetMenuFrameworkVersion());
	}
}
