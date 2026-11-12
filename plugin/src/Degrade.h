#pragma once
// The degradation engine: the player's gear loses temper when hit and when swinging (the original's _EDDegradation script, natively).
namespace Degrade
{
	void Register();    // event sinks that live for the whole session (hits, equips); call once data is loaded
	void HookPlayer();  // the player's animation graph sink; call after a game is loaded or started
}
