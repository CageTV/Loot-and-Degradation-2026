Loot and Degradation 2026  0.1.0 (pre-release)
=============================================

A native SKSE rebuild of Loot and Degradation by isoku (2014). Tempered gear wears down as you fight, NPCs carry tempered and enchanted gear,
and the Equipment Repair Kit lets you improve or damage gear on the road. The original's Papyrus scripts are replaced by one SKSE plugin;
the settings live in SKSE Menu Framework 3 (Loot and Degradation).

WHAT IS IN THIS VERSION
- Degradation of the player's tempered gear from hits and swings, with the original's levels (Fine ... Legendary), per-material durability
  multipliers, optional breaking (with scrap), and the break and degrade messages.
- Followers use the same engine (off by default; set Follower decay chance above 0).
- Tempered and enchanted weapons and armor on NPCs when they load, using the original's formulas and enchantment lists.
- The Equipment Repair Kit: improve weapons or armor away from a grindstone or workbench (the improvement is shallower than at a bench), or damage
  your equipment by a tier.
- The gear health widget, drawn by the plugin: level and percentage left, optional fading, original or new icons, icon colours, free position and
  layout presets.
Not in this version yet: NPCs looting, and the blacksmith and fletcher tempering services.

REQUIREMENTS
- Skyrim Special Edition / Anniversary Edition (the installer picks the matching DLL), or Skyrim VR with the older DLL
- SKSE64 and Address Library for SKSE Plugins for your game version
- SKSE Menu Framework 3 (Nexus 120352): every setting and the widget are drawn through it. Without it the plugin runs with the settings in
  Data/SKSE/Plugins/LootandDegradation.ini and there is no widget.
Do not use it together with the original Loot and Degradation (any version), Simple Degradation or Service Your Gear. Disable them.

INSTALL
Use the installer (FOMOD). It asks which LootandDegradation.dll to use and pre-selects the right one: the new build for Skyrim 1.6.1170 and newer
(1.7.x included), the older build for VR and for 1.6.1130 and older. Then enable LootandDegradation.esp.
A new game is recommended. Starting from a save that already used the original is not supported.

SETTINGS
Open the SKSE Menu Framework menu and pick Loot and Degradation: Degradation, Breaking, Durability, NPC gear, Widget. Changes apply at once and are
saved to Data/SKSE/Plugins/LootandDegradation.ini.

UNINSTALL
Disable the mod. Tempered and enchanted gear already on NPCs and in your inventory stays as it is.

LICENSE AND CREDITS
Everything in this download except LootandDegradation.dll is released under CC BY-NC-SA 4.0 (https://creativecommons.org/licenses/by-nc-sa/4.0/),
the license the original author released Loot and Degradation under; the full text is in LICENSE.txt. Credit the original author, say what you changed,
share under the same license, and do not use it commercially or behind a paywall.
LootandDegradation.dll is separate work released under the GNU General Public License 3.0 or later; its license, its third-party notices and the link to
its source are next to it in SKSE/Plugins. The GPL covers the DLL only; the rest of the mod stays under the original license.

- isoku: author of Loot and Degradation
- richmondb: the whetstone model
- psychosteve: the widget icons (the original set is included; the "new" set is a restyle of the same shapes, changed from the original)
- SKSE Menu Framework by its authors, used for the settings pages

Changes from the original: the Papyrus implementation is replaced by a native SKSE plugin; settings use SKSE Menu Framework; the whetstone and metal scrap
meshes were converted to the Skyrim SE format; whetstone.dds, whetstone_n.dds and metalscrap_m.dds were enlarged to 1024; the widget is drawn by the plugin;
the plugin is a Skyrim SE plugin without scripts.
This work is not endorsed by the original author or by Step Modifications.
