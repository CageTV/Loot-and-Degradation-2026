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
			int         icon = -1;       // index into kIconNames
			float       health = 1.0f;
		};

		std::mutex          g_lock;
		std::array<Slot, 7> g_slots{};
		bool                g_weaponsDrawn = false;
		bool                g_inCombat = false;
		clock::time_point   g_touchedAt{};

		// head, body, hands, feet, sword, dagger, axe, mace, bow, crossbow, staff, shield (the file names of the icons)
		constexpr std::array<const char*, 12> kIconNames{ "head", "body", "hands", "feet", "sword", "dagger", "axe", "mace", "bow", "crossbow", "staff", "shield" };

		int WeaponIcon(RE::TESBoundObject* a_object)
		{
			auto* weapon = a_object ? a_object->As<RE::TESObjectWEAP>() : nullptr;
			if (!weapon) {
				return 4;
			}
			switch (weapon->GetWeaponType()) {
			case RE::WEAPON_TYPE::kOneHandDagger:
				return 5;
			case RE::WEAPON_TYPE::kOneHandAxe:
			case RE::WEAPON_TYPE::kTwoHandAxe:
				return 6;
			case RE::WEAPON_TYPE::kOneHandMace:
				return 7;
			case RE::WEAPON_TYPE::kBow:
				return 8;
			case RE::WEAPON_TYPE::kCrossbow:
				return 9;
			case RE::WEAPON_TYPE::kStaff:
				return 10;
			default:
				return 4;
			}
		}

		// set 0 = the new icons, 1 = the original ones; loaded the first time they are drawn
		ImTextureID IconTexture(int a_set, int a_index)
		{
			static std::array<std::array<ImTextureID, 12>, 2> cache{};
			static std::array<std::array<bool, 12>, 2>        tried{};
			auto& tex = cache[a_set][a_index];
			if (!tried[a_set][a_index]) {
				tried[a_set][a_index] = true;
				const auto path = std::format("Data/Interface/LootandDegradation/icons/{}_{}.png", a_set == 0 ? "new" : "legacy", kIconNames[a_index]);
				tex = SKSEMenuFramework::LoadTexture(path);
				if (!tex) {
					SKSE::log::warn("Widget: icon {} could not be loaded", path);
				}
			}
			return tex;
		}

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
		auto set = [&](std::size_t i, const char* label, bool weapon, const Gear::Worn& w, int icon) {
			next[i].label = label;
			next[i].icon = icon;
			next[i].weapon = weapon;
			next[i].present = static_cast<bool>(w);
			next[i].health = Gear::Health(w);
		};
		auto head = Gear::FindArmor(player, Gear::kHead);
		if (!head) {
			head = Gear::FindArmor(player, Gear::kCirclet);
		}
		set(0, "Head", false, head, 0);
		set(1, "Body", false, Gear::FindArmor(player, Gear::kBody), 1);
		set(2, "Hands", false, Gear::FindArmor(player, Gear::kHands), 2);
		set(3, "Feet", false, Gear::FindArmor(player, Gear::kFeet), 3);
		{
			auto main = Gear::FindWeapon(player, false);
			set(4, "Weapon", true, main, WeaponIcon(main.object));
		}
		auto offhand = Gear::FindWeapon(player, true);
		if (offhand && offhand.object && offhand.object->As<RE::TESObjectWEAP>() && (offhand.object->As<RE::TESObjectWEAP>()->IsBow() ||
		                                                                             offhand.object->As<RE::TESObjectWEAP>()->IsCrossbow())) {
			offhand = {};  // a bow is already shown as the main weapon
		}
		set(5, "Off-hand", true, offhand, WeaponIcon(offhand.object));
		set(6, "Shield", true, Gear::FindArmor(player, Gear::kShield), 11);
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
		const float pad = size * std::clamp(s.widgetPad, 0.0f, 1.5f);
		const bool  fading = s.widgetStyle >= 2;   // the original's "alpha-based": gear is invisible when fresh and brightens as it wears
		const bool  percent = s.widgetStyle != 2;  // the original's "percentage-based": the share of the level that is left

		const int iconSet = s.widgetIcons == 1 ? 0 : (s.widgetIcons == 2 ? 1 : -1);  // -1 = text only

		struct Cell
		{
			std::string text;
			std::string percent;
			float       alpha;
			ImTextureID icon;
			float       tint[3];
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
			Cell        c{};
			if (iconSet >= 0 && slot.icon >= 0) {
				c.tint[0] = c.tint[1] = c.tint[2] = 1.0f;
					c.icon = IconTexture(s.widgetIconColor != 0 ? 1 : iconSet, slot.icon);  // colouring needs the plain white silhouettes (set 1)
					if (s.widgetIconColor == 1) {
						c.tint[0] = s.widgetIconR;
						c.tint[1] = s.widgetIconG;
						c.tint[2] = s.widgetIconB;
					} else if (s.widgetIconColor == 2 && tempered) {
						// fresh = green, half = yellow, nearly worn = red
						c.tint[0] = std::clamp(2.0f * (1.0f - left), 0.0f, 1.0f);
						c.tint[1] = std::clamp(2.0f * left, 0.0f, 1.0f);
						c.tint[2] = 0.15f;
					}
			}
			if (c.icon) {
				c.text = level;  // the icon says which piece it is
			} else {
				c.text = tempered ? std::format("{}: {}", slot.label, level) : std::string(slot.label);
			}
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

		const float iconSize = size * 1.9f;
		float       levelW = 0.0f, pctW = 0.0f;
		for (const auto& c : cells) {
			levelW = std::max(levelW, CalcTextSize(c.text.c_str()).x * s.widgetScale);
			if (!c.percent.empty()) {
				pctW = std::max(pctW, CalcTextSize(c.percent.c_str()).x * s.widgetScale);
			}
		}
		const bool  hasIcon = std::any_of(cells.begin(), cells.end(), [](const Cell& c) { return c.icon != nullptr; });
		const float gap = pctW > 0.0f ? s.widgetGap : 0.0f;
		const float cellW = pad + (hasIcon ? iconSize + pad : 0.0f) + levelW + gap + pctW + pad;
		const float cellH = std::max(size, hasIcon ? iconSize : size) + pad * 2.0f;
		const float spacing = s.widgetRowSpacing;
		const bool  column = s.widgetOrient != 0;
		const float n = static_cast<float>(cells.size());
		const float totalW = column ? cellW : cellW * n + spacing * (n - 1.0f);
		const float totalH = column ? cellH * n + spacing * (n - 1.0f) : cellH;
		// the position is a share of the free room, so 0 and 100 are always flush against the screen edges
		const float x0 = std::clamp(s.widgetX, 0.0f, 100.0f) / 100.0f * std::max(0.0f, io->DisplaySize.x - totalW);
		const float y0 = std::clamp(s.widgetY, 0.0f, 100.0f) / 100.0f * std::max(0.0f, io->DisplaySize.y - totalH);

		float i = 0.0f;
		for (const auto& c : cells) {
			const float x = column ? x0 : x0 + (cellW + spacing) * i;
			const float y = column ? y0 + (cellH + spacing) * i : y0;
			i += 1.0f;
			const float mid = y + cellH * 0.5f;
			const float textY = mid - size * 0.5f;
			const ImU32 white = Color(0.95f, 0.93f, 0.85f, c.alpha);
			if (s.widgetBg > 0.0f) {
				ImDrawListManager::AddRectFilled(dl, ImVec2(x, y), ImVec2(x + cellW, y + cellH), Color(0.0f, 0.0f, 0.0f, s.widgetBg * c.alpha), size * 0.2f, 0);
			}
			float left = x + pad;
			if (c.icon) {
				ImDrawListManager::AddImage(dl, c.icon, ImVec2(left, mid - iconSize * 0.5f), ImVec2(left + iconSize, mid + iconSize * 0.5f), ImVec2(0, 0), ImVec2(1, 1),
					Color(c.tint[0], c.tint[1], c.tint[2], c.alpha));
			}
			if (hasIcon) {
				left += iconSize + pad;
			}
			ImDrawListManager::AddText(dl, font, size, ImVec2(left, textY), white, c.text.c_str());
			if (!c.percent.empty()) {
				const float w = CalcTextSize(c.percent.c_str()).x * s.widgetScale;
				ImDrawListManager::AddText(dl, font, size, ImVec2(x + cellW - pad - w, textY), white, c.percent.c_str());
			}
		}
	}
}
