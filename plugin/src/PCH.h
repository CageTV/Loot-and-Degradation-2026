/*
 * Loot and Degradation 2026
 * A remix of Loot and Degradation by isoku (CC BY-NC-SA 4.0); this plugin replaces its Papyrus implementation.
 * Released under CC BY-NC-SA 4.0: https://creativecommons.org/licenses/by-nc-sa/4.0/
 */
#pragma once

#include <RE/Skyrim.h>
#include <SKSE/SKSE.h>

#include <spdlog/sinks/basic_file_sink.h>

#include <Windows.h>

#include <algorithm>
#include <array>
#include <atomic>
#include <chrono>
#include <cmath>
#include <filesystem>
#include <format>
#include <fstream>
#include <mutex>
#include <random>
#include <string>
#include <string_view>
#include <unordered_map>
#include <unordered_set>
#include <thread>
#include <vector>

using namespace std::literals;

// One on-screen message, whichever way this CommonLib spells it.
inline void Notify(const char* a_text)
{
#if __has_include(<RE/S/SendHUDMessage.h>)
	RE::SendHUDMessage::ShowHUDMessage(a_text);
#else
	RE::DebugNotification(a_text);
#endif
}
