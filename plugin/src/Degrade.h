#pragma once
// The degradation engine: the player's gear loses temper when hit and when swinging (the original's _EDDegradation script, natively).
namespace Degrade
{
	void Register();    // event sinks that live for the whole session (hits, equips); call once data is loaded
	void HookPlayer();  // the player's animation graph sink; call after a game is loaded or started
	void PlaySound(RE::Actor* a_actor, RE::FormID a_localId);  // a sound descriptor of this plugin, played at the actor
	bool DegradeTier(RE::Actor* a_actor, bool a_weapon, bool a_left, std::uint32_t a_mask);
}
