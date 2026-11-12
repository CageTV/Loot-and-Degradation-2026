#include "PCH.h"
#include "Widget.h"
#include "Gear.h"
#include "Settings.h"

#include "SKSEMenuFramework.h"

namespace Widget
{
	namespace
	{
		using namespace ImGuiMCP;
		using clock = std::chrono::steady_clock;

		struct Slot
		{
			const char* label = "";
			bool        present = false;
			bool        weapon = false;  // weapons and shields count as "weapons" for the Items setting
			float       health = 1.0f;
		};

		std::mutex          g_lock;
		std::array<Slot, 7> g_slots{};
		bool                g_weaponsDrawn = false;
		bool                g_inCombat = false;
		clock::time_point   g_touchedAt{};

		const char* LevelName(float a_health)
		{
			if (a_health < 1.1f) {
				return "";
			}
			if (a_health < 1.2f) {
				return "Fine";
			}
			if (a_health < 1.3f) {
				return "Superior";
			}
			if (a_health < 1.4f) {
				return "Exquisite";
			}
			if (a_health < 1.5f) {
				return "Flawless";
			}
			if (a_health < 1.6f) {
				return "Epic";
			}
			return "Legendary";
		}

		// How much of the current level is left: the original keeps a 0.00099 durability band above each level.
		float Remaining(float a_health)
		{
			const float band = a_health - std::floor(a_health * 10.0f) / 10.0f;
			return std::clamp(band / 0.00099f, 0.0f, 1.0f);
		}

		ImU32 Color(float a_r, float a_g, float a_b, float a_a)
		{
			return ColorConvertFloat4ToU32(ImVec4(a_r, a_g, a_b, a_a));
		}
	}

	void Touch()
	{
		std::scoped_lock l(g_lock);
		g_touchedAt = clock::now();
	}

	void Refresh()
	{
		auto* player = RE::PlayerCharacter::GetSingleton();
		if (!player || !player->Is3DLoaded()) {
			return;
		}
		std::array<Slot, 7> next{};
		auto set = [&](std::size_t i, const char* label, bool weapon, const Gear::Worn& w) {
			next[i].label = label;
			next[i].weapon = weapon;
			next[i].present = static_cast<bool>(w);
			next[i].health = Gear::Health(w);
		};
		auto head = Gear::FindArmor(player, Gear::kHead);
		if (!head) {
			head = Gear::FindArmor(player, Gear::kCirclet);
		}
		set(0, "Head", false, head);
		set(1, "Body", false, Gear::FindArmor(player, Gear::kBody));
		set(2, "Hands", false, Gear::FindArmor(player, Gear::kHands));
		set(3, "Feet", false, Gear::FindArmor(player, Gear::kFeet));
		set(4, "Weapon", true, Gear::FindWeapon(player, false));
		auto offhand = Gear::FindWeapon(player, true);
		if (offhand && offhand.object && offhand.object->As<RE::TESObjectWEAP>() && (offhand.object->As<RE::TESObjectWEAP>()->IsBow() ||
		                                                                             offhand.object->As<RE::TESObjectWEAP>()->IsCrossbow())) {
			offhand = {};  // a bow is already shown as the main weapon
		}
		set(5, "Off-hand", true, offhand);
		set(6, "Shield", true, Gear::FindArmor(player, Gear::kShield));
		const bool drawn = player->AsActorState()->IsWeaponDrawn();
		const bool combat = player->IsInCombat();

		std::scoped_lock l(g_lock);
		for (std::size_t i = 0; i < next.size(); ++i) {
			if (next[i].present != g_slots[i].present || std::floor(next[i].health * 10.0f) != std::floor(g_slots[i].health * 10.0f)) {
				g_touchedAt = clock::now();
			}
		}
		g_slots = next;
		g_weaponsDrawn = drawn;
		g_inCombat = combat;
	}

	void Draw()
	{
		const auto& s = Settings::Get();
		if (s.widgetStyle <= 0) {
			return;
		}
		std::array<Slot, 7> slots;
		bool                visible = true;
		{
			std::scoped_lock l(g_lock);
			slots = g_slots;
			if (s.widgetContextual) {
				const float since = std::chrono::duration<float>(clock::now() - g_touchedAt).count();
				visible = g_weaponsDrawn || g_inCombat || since < s.widgetDelay;
			}
		}
		if (!visible) {
			return;
		}
		auto* ui = RE::UI::GetSingleton();
		if (ui && (ui->GameIsPaused() || ui->IsMenuOpen(RE::LoadingMenu::MENU_NAME) || ui->IsMenuOpen(RE::MainMenu::MENU_NAME))) {
			return;
		}
		auto* io = GetIO();
		auto* dl = GetForegroundDrawList();
		auto* font = GetFont();
		if (!io || !dl || !font) {
			return;
		}
		const float size = GetFontSize() * s.widgetScale;
		const float alpha = std::clamp(s.widgetAlpha, 0.1f, 1.0f);
		const float pad = size * 0.35f;
		const bool  fading = s.widgetStyle >= 2;   // the original's "alpha-based": gear is invisible when fresh and brightens as it wears
		const bool  percent = s.widgetStyle != 2;  // the original's "percentage-based": the share of the level that is left

		struct Cell
		{
			std::string text;
			std::string percent;
			float       alpha;
		};
		std::vector<Cell> cells;
		for (const auto& slot : slots) {
			if (!slot.present) {
				continue;
			}
			if (s.widgetItems == 1 && !slot.weapon) {
				continue;
			}
			if (s.widgetItems == 2 && slot.weapon) {
				continue;
			}
			const char* level = LevelName(slot.health);
			const bool  tempered = *level != 0;
			const float left = tempered ? Remaining(slot.health) : 0.0f;  // untempered gear has nothing left to lose
			const int   pct = static_cast<int>(left * 100.0f + 0.5f);
			Cell        c;
			c.text = tempered ? std::format("{}: {}", slot.label, level) : std::string(slot.label);
			if (percent && tempered && pct < 100) {
				c.percent = std::format("{}%", std::max(pct, 1));
			}
			c.alpha = alpha * (fading ? 1.0f - left : 1.0f);
			if (c.alpha < 0.02f) {
				continue;  // fully fresh gear is not shown in the fading styles
			}
			cells.push_back(std::move(c));
		}
		if (cells.empty()) {
			return;
		}

		const float cellW = size * 11.0f;
		const float cellH = size + pad * 2.0f;
		const bool  column = s.widgetOrient != 0;
		const float totalW = column ? cellW : cellW * static_cast<float>(cells.size());
		const float totalH = column ? cellH * static_cast<float>(cells.size()) : cellH;
		const float x0 = (s.widgetPos == 0 || s.widgetPos == 2) ? s.widgetX : io->DisplaySize.x - s.widgetX - totalW;
		const float y0 = (s.widgetPos == 0 || s.widgetPos == 1) ? s.widgetY : io->DisplaySize.y - s.widgetY - totalH;

		float i = 0.0f;
		for (const auto& c : cells) {
			const float x = column ? x0 : x0 + cellW * i;
			const float y = column ? y0 + cellH * i : y0;
			i += 1.0f;
			ImDrawListManager::AddRectFilled(dl, ImVec2(x, y), ImVec2(x + cellW - pad, y + cellH - pad), Color(0.0f, 0.0f, 0.0f, 0.35f * c.alpha), size * 0.2f, 0);
			ImDrawListManager::AddText(dl, font, size, ImVec2(x + pad, y + pad * 0.6f), Color(0.95f, 0.93f, 0.85f, c.alpha), c.text.c_str());
			if (!c.percent.empty()) {
				const ImVec2 extent = CalcTextSize(c.percent.c_str());
				const float  textW = extent.x * s.widgetScale;
				ImDrawListManager::AddText(dl, font, size, ImVec2(x + cellW - pad * 2.0f - textW, y + pad * 0.6f), Color(0.95f, 0.93f, 0.85f, c.alpha), c.percent.c_str());
			}
		}
	}
}
