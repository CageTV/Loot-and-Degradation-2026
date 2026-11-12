# Loot and Degradation 2026 - behaviour spec and plan

Derived by reading the original Loot and Degradation 1.31 (isoku) scripts in `reference/original-LE-1.31/`. The unsanctioned SE port (1.32) has the
same code apart from 27 lines (SkyUI_SE check, version stamp), so it is not used. Decisions (user, 2026-11-12): **full native** (SKSE DLL, CommonLibSSE-NG),
settings through **SKSE Menu Framework**, name **Loot and Degradation 2026**. Keep `LootandDegradation.esp` records and FormIDs so existing patches
(Summermyst, Wintermyst, Thaumaturgy, Requiem patch, translations) keep working.

## License and credit (CC BY-NC-SA, author's permission pasted by the user)
Remix allowed; the result must be CC BY-NC-SA, credit the original (isoku; richmondb whetstone; psychosteve widget icons), link the license, say what
changed, no commercial use, no paywalled/Patreon-only download. Donation points allowed.

## The original, as a set of rules

**Temper value.** A worn or carried item's temper is its `ExtraHealth` float: 1.0 untempered, 1.1 Fine, 1.2 Superior, 1.3 Exquisite, 1.4 Flawless,
1.5 Epic, 1.6 Legendary (cap 1.7). The original hides state in the 4th-5th decimals ("buffer health": +0.00099 / +0.00074 for whetstone, "RandomDeg") because
Papyrus cannot tell a freshly set value from a degraded one. Native: use the continuous float directly, no hack.

**Degradation (player, followers when enabled).**
- Per hit taken (not blocked): head (slot 0x1 or 0x2), body 0x4, hands 0x8, feet 0x80 each degrade by `base * material durability`; bases 0.000039, 0.000041,
  0.000038, 0.000023. Power attack taken doubles it. Blocked hit: with a shield equipped the shield (slot 0x200) degrades (0.000085), otherwise the weapon
  (0.000091, counted as a "crit hit" for breaking). Hit delay 3 s (one hit counted per 3 s window).
- Per swing (animation events weaponSwing, weaponLeftSwing, arrowRelease, bashStop): weapon base 0.000034; doubled (0.000068, "aggressive") when
  bAllowRotation is true (power attack) or when bashing with a bow. Swing delay until the 2 s update.
- Everything is gated by `DecayChance` (1..10000 roll, default 6667): `if rand(1,10000) < DecayChance`. New health = health - mag * PlayerDegMult; floored at 1.0.
- Material durability (multiplier, from keywords): cloth 1.0, leather/wood 1.3, iron 1.2, steel 1.1, elven/bonemold 1.05, falmer 0.9, dwarven 0.85,
  glass 0.8, orcish/chitin 0.7, dragon 0.6, daedric/ebony/stalhrim 0.55. Keyword tables in `_EDQuestScript.CheckMaterial` (also the scrap item each material drops).
- Degrade notifications (`DegradeText`: off / when untempering / every level).

**Breaking (off by default).** `PlayerBreakChance` / `FollowerBreakChance`. Break ceiling formula (Requiem variant differs):
`round((96.149*h^2 - 345.42*h + 309.27) * breakChance * (mag*10)^0.75 * 1550)`, compared against the same 1..10000 roll. `BreakType` 0 = only when untempered
(health < 1.1), 1 = tempered items only break on power/crit hits, 2 = any time. `BreakableItems` 0 all / 1 weapons / 2 armor. Never: artifacts (MagicDisallowEnchanting),
`_EDNoBreakList`, names containing "Bound", armor under a Mage Armor effect. A break removes the item, plays a sound, adds 2-4 (weapon) / 4-6 (armor) scraps
(or leather strips / dragon scales / bone meal / chitin), and notifies.

**Whetstone / repair kit.** Using the sharpening wheel or armor table (crafting menu with sit state, or get-up from that furniture) re-seeds health with the whetstone
buffer; the portable Equipment Repair Kit (`_EDWhetstone`, richmondb's mesh) improves or degrades gear anywhere, items improved with it degrade faster. Refused in combat,
sneaking, mounted, swimming.

**NPC loot (tempered / enchanted NPC gear).** On first sight (crosshair) or hit the NPC gets the ability spell `_EDNPCSpell` (script `_EDNPC`): for each equipped
weapon/armor slot (skipping staves, ignore lists, bound items, MagicDisallowEnchanting) it calls `SetRandomTemp` and `SetRandomEnchant`.
- Temper: tier from a level-scaled roll: `max = TemperRarity * LevelIncrementMult * level_adjusted^-1.14` (weapons divided by 1.15), tiers every 8 levels (`LevelIncrementMult`)
  add +0.1; "less leveled loot" option changes the table; result capped at 1.7, plus a small random degradation offset. Dead NPCs keep it (`DeathRandomTemper`).
- Enchant: `EnchantRarity` roll, enchantment picked from per-slot form lists (`_EDEnchant*List`, names from `_EDEnchant*Name` arrays), applied to the worn item.
- Looting: ability `_EDNPCLoot`: NPCs that kill a target within 768 units take items per `LootFilter` gold threshold (potions, ammo, gold, items worth LootFilter..5000); NPCs
  also loot dead allies (weapons, shields, potions, ammo only). Never the player or player teammates; looter must be an NPC (keyword) carrying `_EDNPCEmptySpell`.
- Requiem 1.8+: auto-detected, NPC tempered loot disabled in favour of Requiem's.

**Services (dialogue).** Blacksmiths and fletchers temper the player's items for gold: tiers by NPC skill (Apprentice Fine .. Master Legendary), cost multiplier
`TemperCostMult`, speech/perk discounts per slot (`_ED*Discount` globals), proficiency (orc blacksmiths with Orcish, Baldor with Stalhrim), Eorlund only for artifacts,
fletchers limited to light armor / bows / one-handers; NPC skill rises with the tempering experience (`TemperExp`) and by itself over ~6 in-game months
(`LevelTemper`, daily). Optional delay: items come back by courier after X hours (`TemperDelay`, `_EDCourierHere`). 18 dialogue topics, 11 constructible objects.

**UI.** SkyUI MCM (`_EDSkyUIConfig`, 1100 lines) and an iWant-style widget (`_EDIconWidgetScript`, equipicons.swf, psychosteve's icons) showing equipped gear health.

## Native architecture (target)
| Part | Native replacement | Notes |
|---|---|---|
| Hit handling | `TESHitEvent` sink | player + followers; keeps 3 s hit delay; block/shield/power flags from the event |
| Swing handling | `BSAnimationGraphEvent` sink on the player (and followers) | weaponSwing, weaponLeftSwing, arrowRelease, bashStop |
| Item health | `ExtraHealth` on the worn entry via `InventoryChanges`/`BGSInventoryItem` | no decimal hack; tier = floor(h*10)/10 |
| Material table | keyword FormIDs in code, overridable by ini | |
| NPC temper/enchant | hook on actor 3D load / first equip, done once, remembered per actor (co-save) | replaces the per-NPC ability scripts |
| NPC looting | `TESDeathEvent` sink, nearby-actor search in native | |
| Services | native dialogue-condition functions + result functions; Papyrus quest glue only if unavoidable | see Open questions |
| Settings | SKSE Menu Framework pages + `LootandDegradation.ini` | MCM dropped (SkyUI no longer required) |
| Widget | native HUD element (to design) | |
| Save data | SKSE co-save | tempering experience per vendor, per-actor "done" flags |

## Open questions / risks
- Save compatibility: removing the quest scripts from a mid-playthrough save of 1.3x leaves their old script data; likely "new game or clean save" recommended. To decide, after the engine works.
- Papyrus-visible API for other mods (ModEvents?) - check who uses `_EDQuestScript` properties (patches add FormLists only, so probably nobody).
- Dialogue/services in pure native is the largest risk; fallback is a small Papyrus quest script that calls native functions.
- Requiem and other mods that also write ExtraHealth (tempering/degradation mods in the list: Simple Degradation, Service Your Gear) must not be combined; state it in the description.
- Every in-game claim must be tested through DevBench on the H list before release; DLL needs separate NG (1.6.1170+) and legacy (VR / 1.6.1130-) builds as for Frostfall.

## Phases
0. This spec + repo + ESP source (Spriggit YAML from the original LE plugin converted to SE) - done when the plugin loads clean in the H list without the old scripts.
1. Native degradation engine (hits, swings, material table, breaking, scraps, notifications) with ini settings and Menu Framework page; tested on the player.
2. Followers, whetstone / repair kit, widget.
3. NPC tempering and enchanting, NPC looting.
4. Services (blacksmith/fletcher tempering, experience, courier).
5. Packaging: FOMOD (NG + legacy DLL), README with the license text and credits, Nexus description, GitHub release.
