#pragma once
// The settings pages in SKSE Menu Framework (replaces the original's SkyUI MCM).
namespace Menu
{
	void Register();  // on SKSE's kPostLoad: the Menu Framework loads after us
	bool Registered();
}
