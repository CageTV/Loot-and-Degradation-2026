/*
 * Loot and Degradation 2026
 * A remix of Loot and Degradation by isoku (CC BY-NC-SA 4.0); this plugin replaces its Papyrus implementation.
 * Released under CC BY-NC-SA 4.0: https://creativecommons.org/licenses/by-nc-sa/4.0/
 */
#include "PCH.h"
#include "Degrade.h"
#include "Menu.h"
#include "Settings.h"

namespace
{
	void SetupLog()
	{
		const auto dir = SKSE::log::log_directory();
		if (!dir) {
			return;
		}
		auto sink = std::make_shared<spdlog::sinks::basic_file_sink_mt>((*dir / "LootandDegradation.log").string(), true);
		auto log = std::make_shared<spdlog::logger>("LootandDegradation", std::move(sink));
		log->set_level(spdlog::level::info);
		log->flush_on(spdlog::level::info);
		log->set_pattern("[%Y-%m-%d %H:%M:%S.%e] [%l] %v");
		spdlog::set_default_logger(std::move(log));
	}

	void OnMessage(SKSE::MessagingInterface::Message* a_msg)
	{
		switch (a_msg->type) {
		case SKSE::MessagingInterface::kPostLoad:
			Menu::Register();  // SKSE Menu Framework loads after us, so register once every plugin is loaded
			break;
		case SKSE::MessagingInterface::kDataLoaded:
			Degrade::Register();
			break;
		case SKSE::MessagingInterface::kPostLoadGame:
		case SKSE::MessagingInterface::kNewGame:
			Degrade::HookPlayer();
			break;
		default:
			break;
		}
	}
}

SKSEPluginLoad(const SKSE::LoadInterface* a_skse)
{
	SKSE::Init(a_skse);
	SetupLog();
	SKSE::log::info("Loot and Degradation 2026 0.1.0, game {}", a_skse->RuntimeVersion().string());
	Settings::Load();
	SKSE::GetMessagingInterface()->RegisterListener(OnMessage);
	return true;
}
