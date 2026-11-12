# Loot and Degradation 2026

A modernised, native SKSE version of **Loot and Degradation** by **isoku** (Skyrim, 2014): NPCs carry tempered and enchanted gear, your tempered gear
degrades with use, blacksmiths and fletchers temper it for a price.

Status: 0.1.0 pre-release (degradation, followers, NPC gear, repair kit, widget). NPC looting and the tempering services are still to do. See `docs/SPEC.md`.

## License and credits
The full license text is in LICENSE.txt.

This is a remix of Loot and Degradation, released by its author under **CC BY-NC-SA** (https://creativecommons.org/licenses/by-nc-sa/4.0/). This work
is released under the same license: you may copy, redistribute and remix it, you must give credit and link the license, you must say what was changed, you
may not use it commercially or paywall it. Changes are not endorsed by Step Modifications or the original author.

The plugin source in `plugin/` (LootandDegradation.dll) is released under the **GNU General Public License 3.0 or later**, because it is built with CommonLibSSE-NG. The GPL covers the DLL only; the rest of the mod is under the original license above.

- isoku - original author of Loot and Degradation
- richmondb - the whetstone
- psychosteve - the widget icons

Changes from the original: the Papyrus implementation is replaced by a native SKSE plugin; settings use SKSE Menu Framework; updated for Skyrim SE/AE/1.7.x.

Third party: plugin/include/SKSEMenuFramework.h is the SKSE Menu Framework 3 project's SDK header, unmodified, under its own terms (it is not covered by the license above).
