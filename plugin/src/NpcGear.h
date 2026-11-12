#pragma once
// Tempered and enchanted NPC gear (the original's _EDNPC script).
namespace NpcGear
{
	void Register();               // event sinks; call once data is loaded
	void RegisterSerialization();  // co-save record of the NPCs already rolled; call at plugin load
}
