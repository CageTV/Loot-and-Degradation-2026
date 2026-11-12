#include "PCH.h"
#include "Kit.h"
#include "Degrade.h"
#include "Gear.h"
#include "Materials.h"

// The Equipment Repair Kit: using it from the inventory opens a menu to improve weapons (the grindstone), improve armor (the workbench) or damage
// equipment by one tier. The original's _EDWhetstone script and its message boxes, natively.
namespace Kit
{
	namespace
	{
		constexpr RE::FormID kKitItem = 0x020DA5;    // _EDWhetstoneRepair
		constexpr RE::FormID kOpenSound = 0x02130E;  // _EDWhetstoneOpenSD
		constexpr RE::FormID kRefA = 0x02130B;       // the grindstone and the workbench the original keeps in its empty cell
		constexpr RE::FormID kRefB = 0x02130C;

		RE::TESObjectREFR* FindStation(const char* a_keyword)
		{
			for (auto id : { kRefA, kRefB }) {
				auto* form = Materials::FromFile("LootandDegradation.esp"sv, id);
				auto* ref = form ? form->As<RE::TESObjectREFR>() : nullptr;
				auto* base = ref ? ref->GetBaseObject() : nullptr;
				auto* furniture = base ? base->As<RE::TESFurniture>() : nullptr;
				if (furniture && furniture->HasKeywordString(a_keyword)) {
					return ref;
				}
			}
			return nullptr;
		}

		bool Allowed(RE::PlayerCharacter* a_player)
		{
			if (a_player->IsInCombat()) {
				Notify("Equipment cannot be improved while in combat.");
			} else if (a_player->IsSneaking()) {
				Notify("Equipment cannot be improved while sneaking.");
			} else if (a_player->IsOnMount()) {
				Notify("Equipment cannot be improved while mounted.");
			} else if (a_player->IsSwimming()) {
				Notify("Equipment cannot be improved while swimming.");
			} else {
				return true;
			}
			return false;
		}

		enum class Page { Main, Degrade };
		void Show(Page a_page);

		struct Choice : RE::IMessageBoxCallback
		{
			Page page = Page::Main;

			void Run(std::uint8_t a_button) override
			{
				auto* player = RE::PlayerCharacter::GetSingleton();
				if (!player) {
					return;
				}
				if (page == Page::Main) {
					switch (a_button) {
					case 0:  // improve weapons
					case 1:  // improve armor
						if (Allowed(player)) {
							auto* station = FindStation(a_button == 0 ? "CraftingSmithingSharpeningWheel" : "CraftingSmithingArmorTable");
							if (station) {
								SKSE::GetTaskInterface()->AddTask([station, player] { station->ActivateRef(player, 0, nullptr, 1, false); });
							} else {
								SKSE::log::warn("Kit: the {} was not found in the plugin", a_button == 0 ? "grindstone" : "workbench");
							}
						}
						break;
					case 2:
						Show(Page::Degrade);
						break;
					default:
						break;
					}
					return;
				}
				bool done = true;
				bool found = true;
				switch (a_button) {
				case 0:
					found = Degrade::DegradeTier(player, false, false, Gear::kHead) || Degrade::DegradeTier(player, false, false, Gear::kCirclet);
					break;
				case 1:
					found = Degrade::DegradeTier(player, false, false, Gear::kBody);
					break;
				case 2:
					found = Degrade::DegradeTier(player, false, false, Gear::kHands);
					break;
				case 3:
					found = Degrade::DegradeTier(player, false, false, Gear::kFeet);
					break;
				case 4:
					found = Degrade::DegradeTier(player, true, false, 0);
					break;
				case 5: {  // off-hand weapon, not a bow or staff
					auto off = Gear::FindWeapon(player, true);
					auto* weapon = off.object ? off.object->As<RE::TESObjectWEAP>() : nullptr;
					found = weapon && !weapon->IsBow() && !weapon->IsCrossbow() && !weapon->IsStaff() && Degrade::DegradeTier(player, true, true, 0);
					break;
				}
				case 6:
					found = Degrade::DegradeTier(player, false, false, Gear::kShield);
					break;
				default:  // cancel: back to the main menu
					Show(Page::Main);
					done = false;
					break;
				}
				if (done) {
					if (!found) {
						Notify("This item is not equipped.");
					}
					Show(Page::Degrade);  // the original keeps the degrade menu open until it is cancelled
				}
			}
		};

		void ShowNow(Page a_page)
		{
			auto* queue = RE::UIMessageQueue::GetSingleton();
			auto* data = RE::UIMessageDataFactory::Create<RE::MessageBoxData>();
			if (!queue || !data) {
				SKSE::log::warn("Kit: could not build the message box");
				return;
			}
			auto* cb = new Choice();
			cb->page = a_page;
			if (a_page == Page::Main) {
				data->bodyText = "While not as effective as a grindstone or workbench, this combination of whetstone, hammer and sinew can still get the job done when needed.";
				for (auto* label : { "Improve Weapons", "Improve Armor", "Damage Equipment", "Exit" }) {
					data->buttonText.push_back(label);
				}
				data->cancelButtonIndex = 3;
			} else {
				data->bodyText = "Degrade the selected item by one tier.";
				for (auto* label : { "Headpiece", "Cuirass", "Gloves", "Boots", "Main Weapon", "Off Weapon", "Shield", "Cancel" }) {
					data->buttonText.push_back(label);
				}
				data->cancelButtonIndex = 7;
			}
			data->callback = RE::BSTSmartPointer<RE::IMessageBoxCallback>(cb);
			data->isCancellable = true;
			queue->AddMessage(RE::MessageBoxMenu::MENU_NAME, RE::UI_MESSAGE_TYPE::kShow, data);
		}

		void Show(Page a_page)
		{
			SKSE::GetTaskInterface()->AddTask([a_page] { ShowNow(a_page); });
		}

		class EquipSink final : public RE::BSTEventSink<RE::TESEquipEvent>
		{
		public:
			static EquipSink* Get()
			{
				static EquipSink i;
				return std::addressof(i);
			}

			RE::BSEventNotifyControl ProcessEvent(const RE::TESEquipEvent* a_event, RE::BSTEventSource<RE::TESEquipEvent>*) override
			{
				auto* player = RE::PlayerCharacter::GetSingleton();
				if (!a_event || !a_event->equipped || !player || a_event->actor.get() != player) {
					return RE::BSEventNotifyControl::kContinue;
				}
				auto* kit = Materials::FromFile("LootandDegradation.esp"sv, kKitItem);
				if (!kit || a_event->baseObject != kit->GetFormID()) {
					return RE::BSEventNotifyControl::kContinue;
				}
				SKSE::log::info("Kit: the Equipment Repair Kit was used");
				// the inventory is closed first (a crafting station cannot open over it), then the menu is shown a moment later
				std::thread([] {
					SKSE::GetTaskInterface()->AddTask([] {
						if (auto* queue = RE::UIMessageQueue::GetSingleton()) {
							queue->AddMessage(RE::InventoryMenu::MENU_NAME, RE::UI_MESSAGE_TYPE::kHide, nullptr);
						}
						if (auto* player = RE::PlayerCharacter::GetSingleton()) {
							Degrade::PlaySound(player, kOpenSound);
						}
					});
					std::this_thread::sleep_for(400ms);
					Show(Page::Main);
				}).detach();
				return RE::BSEventNotifyControl::kContinue;
			}
		};
	}

	void Register()
	{
		if (auto* holder = RE::ScriptEventSourceHolder::GetSingleton()) {
			holder->AddEventSink<RE::TESEquipEvent>(EquipSink::Get());
			SKSE::log::info("Kit: listening for the Equipment Repair Kit");
		}
	}
}
