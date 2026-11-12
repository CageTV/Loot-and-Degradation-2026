Assets of Loot and Degradation 2026, taken from the original Loot and Degradation 1.31 by isoku (CC BY-NC-SA); credits: richmondb (whetstone), psychosteve (widget icons).
The unmodified originals of everything changed below are in ../assets-original.

Changes from the original files:
- meshes/lootanddegradation/whetstone.nif and metalscrap.nif: converted from the Skyrim LE format (NiTriShape) to the Skyrim SE format (BSTriShape) with PyNifly 28.1.0 (Blender 4.5).
  Checked after the conversion: same shapes, same vertex and triangle counts, same texture paths and slots, vertex colours, alpha property, collision and inventory marker kept;
  UVs differ only by half-float precision; a render with the textures beside the mesh is identical to the original's. Files are about half the size.
- textures/lootanddegradation/whetstone.dds: 512 -> 1024 (BC1, full mip chain). Upscayl (remacri model) for the fine detail at 60% strength on top of the original's own tones, so the
  brightness and colour match the original (mean luminance 41.4 vs 40.7).
- textures/lootanddegradation/whetstone_n.dds: 256 uncompressed -> 1024 BC7: Lanczos resample, normal vectors renormalised (AI upscaling would distort a normal map).
- textures/lootanddegradation/metalscrap_m.dds: 256 -> 1024 (BC1), Lanczos resample.
- whetstone_m.dds stays 4x4: it is a flat placeholder mask, a larger one would only use memory.
- Everything else is byte-identical to the original: the break sounds (16-bit mono PCM WAV, valid for positional sound), metalscrap.dds / metalscrap_dark.dds / metalscrap_n.dds (already 1024),
  the widget swf and the translations.
