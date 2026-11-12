#include "PCH.h"
#include "Menu.h"
#include "Settings.h"
#include "Widget.h"

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

		constexpr const char* kLogoPath = "Data/Interface/LootandDegradation/loot_and_degradation_logo.png";
		constexpr float       kLogoAspect = 319.0f / 850.0f;

		void Logo()
		{
			static ImTextureID tex = SKSEMenuFramework::LoadTexture(kLogoPath);
			if (!tex) {
				return;
			}
			const float avail = GetContentRegionAvail().x;
			const float w = std::min(avail, 380.0f);
			SetCursorPosX(GetCursorPosX() + (avail - w) * 0.5f);
			Image(tex, ImVec2(w, w * kLogoAspect));
			Spacing();
		}

		void Note(const char* a_text)
		{
			TextWrapped("%s", a_text);
			Spacing();
		}

		void __stdcall RenderDegradation()
		{
			Logo();
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
			Logo();
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
			Logo();
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
			Logo();
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

		void __stdcall RenderNpc()
		{
			Logo();
			auto& d = Settings::Get();
			Text("NPC gear");
			Note("NPCs can carry tempered and enchanted weapons and armor, rolled once when they first appear. Stronger gear is more likely the higher the NPC's level. "
				 "Gear that is already tempered or enchanted is left alone, and your followers are never touched. Changes apply to NPCs that load from now on.");
			Separator();

			float temper = static_cast<float>(d.npcTemperRarity) / 125000.0f;
			if (Changed(SliderFloat("Tempered gear", &temper, 0.0f, 300.0f, d.npcTemperRarity <= 0 ? "Off" : "%.0f%% of normal"))) {
				d.npcTemperRarity = std::max(0, static_cast<int>(temper * 125000.0f + 0.5f));
			}
			Note("How much tempered gear NPCs carry. 100% is the original's default; 0 turns it off.");

			float enchant = static_cast<float>(d.npcEnchantRarity) * 2.0f;
			if (Changed(SliderFloat("Enchanted gear", &enchant, 0.0f, 300.0f, d.npcEnchantRarity <= 0 ? "Off" : "%.0f%% of normal"))) {
				d.npcEnchantRarity = std::max(0, static_cast<int>(enchant / 2.0f + 0.5f));
			}
			Note("How much enchanted gear NPCs carry. 100% is the default; 0 turns it off.");

			Changed(SliderInt("Levels per quality step", &d.npcLevelStep, 2, 20));
			Note("The odds restart and the best possible quality goes up one level each time an NPC passes this many levels. Default 8.");

			Changed(Checkbox("Less leveled loot", &d.npcLessLeveled));
			Note("Flattens the odds so tempered gear stays rare at every level, and weak enchantments are not limited by level.");
		}

		void __stdcall RenderWidget()
		{
			Logo();
			auto& d = Settings::Get();
			Text("Gear widget");
			Note("Shows the health of the gear you are wearing on screen: the temper level and how much of it is left before the gear drops to the next level.");
			Separator();
			static const char* const kStyle[] = { "Off", "Percentage based", "Alpha based", "Alpha and percentage based" };
			Changed(Combo("Style", &d.widgetStyle, kStyle, 4));
			Note("Percentage based always shows the level with how much of it is left. Alpha based shows nothing for fresh gear and brightens as it wears down. Both combines them.");
			static const char* const kIcons[] = { "Text only", "New icons", "Original icons" };
			Changed(Combo("Icons", &d.widgetIcons, kIcons, 3));
			static const char* const kColor[] = { "As drawn", "One colour", "By health (green to red)" };
			Changed(Combo("Icon colour", &d.widgetIconColor, kColor, 3));
			Note("Any colour option draws the icons as plain silhouettes (the original shapes) and tints them, so the new bronze look is only used with 'As drawn'.");
			if (d.widgetIconColor == 1) {
				Changed(SliderFloat("Red", &d.widgetIconR, 0.0f, 1.0f, "%.2f"));
				Changed(SliderFloat("Green", &d.widgetIconG, 0.0f, 1.0f, "%.2f"));
				Changed(SliderFloat("Blue", &d.widgetIconB, 0.0f, 1.0f, "%.2f"));
			}
			static const char* const kPreset[] = { "Choose a preset...", "Compact", "Default", "Roomy", "Minimal (no background)", "Large and bold" };
			static int                 preset = 0;
			if (Combo("Layout preset", &preset, kPreset, 6) && preset > 0) {
				struct P { float gap, rows, pad, bg, scale; };
				static constexpr P kP[] = { {}, { 6, 2, 0.2f, 0.35f, 1.1f }, { 14, 4, 0.35f, 0.35f, 1.3f }, { 32, 8, 0.55f, 0.35f, 1.3f }, { 10, 0, 0.1f, 0.0f, 1.2f }, { 18, 6, 0.45f, 0.5f, 1.8f } };
				d.widgetGap = kP[preset].gap;
				d.widgetRowSpacing = kP[preset].rows;
				d.widgetPad = kP[preset].pad;
				d.widgetBg = kP[preset].bg;
				d.widgetScale = kP[preset].scale;
				Settings::Save();
			}
			Note("A preset sets the spacing, padding, background and size; everything below can still be adjusted by hand.");
			static const char* const kItems[] = { "Weapons and armor", "Weapons and shield only", "Armor only" };
			Changed(Combo("Items", &d.widgetItems, kItems, 3));
			static const char* const kOrient[] = { "In a row", "In a column" };
			Changed(Combo("Layout", &d.widgetOrient, kOrient, 2));
			Changed(SliderFloat("Horizontal position", &d.widgetX, 0.0f, 100.0f, "%.0f%%"));
			Changed(SliderFloat("Vertical position", &d.widgetY, 0.0f, 100.0f, "%.0f%%"));
			Note("0% is the left or top edge of the screen and 100% the right or bottom edge; the widget always stays fully on screen.");
			Changed(SliderFloat("Space between level and percent", &d.widgetGap, 0.0f, 120.0f, "%.0f px"));
			Changed(SliderFloat("Space between rows", &d.widgetRowSpacing, 0.0f, 40.0f, "%.0f px"));
			Changed(SliderFloat("Padding", &d.widgetPad, 0.0f, 1.0f, "%.2f"));
			Changed(SliderFloat("Background", &d.widgetBg, 0.0f, 1.0f, d.widgetBg <= 0.0f ? "None" : "%.2f"));
			Changed(SliderFloat("Size", &d.widgetScale, 0.6f, 3.0f, "%.2fx"));
			Changed(SliderFloat("Opacity", &d.widgetAlpha, 0.1f, 1.0f, "%.2f"));
			Changed(Checkbox("Only show it when it matters", &d.widgetContextual));
			Note("Shown while your weapons are drawn or you are in combat, and for a few seconds after your gear changes or wears down a level.");
			if (d.widgetContextual) {
				Changed(SliderFloat("Seconds to keep it visible", &d.widgetDelay, 1.0f, 60.0f, "%.0f s"));
			}
		}

		// Drawn every frame: writes the ini a moment after the last change.
		void __stdcall Frame()
		{
			Widget::Draw();
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
		SKSEMenuFramework::AddSectionItem("NPC gear", RenderNpc);
		SKSEMenuFramework::AddSectionItem("Widget", RenderWidget);
		SKSEMenuFramework::AddSectionItem("About", RenderAbout);
		SKSEMenuFramework::AddHudElement(Frame);
		g_registered = true;
		SKSE::log::info("Registered with SKSE Menu Framework {}", SKSEMenuFramework::GetMenuFrameworkVersion());
	}
}
