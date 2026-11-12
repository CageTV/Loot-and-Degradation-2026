"""Builds the gear widget icons from psychosteve's silhouettes (extracted from the original equipicons.swf with FFDec at 4x zoom into assets/_swf_export).

legacy_*.png  the original white silhouettes, only normalised to 128x128 (CC BY-NC-SA 4.0, psychosteve)
new_*.png     the same shapes restyled: bronze metal gradient, dark outline and a bevel highlight, to match the mod's logo (changed from the original)

Run:  python tools/make_icons.py   (needs Pillow and numpy)
"""
from pathlib import Path

import numpy as np
from PIL import Image, ImageFilter

root = Path(__file__).resolve().parent.parent
src = root / "assets" / "_swf_export"
out = root / "assets" / "icons"
out.mkdir(parents=True, exist_ok=True)

NAMES = {1: "body", 4: "head", 7: "hands", 10: "feet", 13: "sword", 16: "shield", 19: "axe", 22: "dagger", 25: "mace", 28: "bow",
         31: "staff", 34: "crossbow"}
SIZE = 128
PAD = 10


def normalise(path: Path) -> Image.Image:
    im = Image.open(path).convert("RGBA")
    alpha = im.getchannel("A")
    box = alpha.getbbox()
    im = im.crop(box)
    scale = (SIZE - 2 * PAD) / max(im.size)
    w, h = max(1, round(im.width * scale)), max(1, round(im.height * scale))
    im = im.resize((w, h), Image.LANCZOS)
    canvas = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    canvas.paste(im, ((SIZE - w) // 2, (SIZE - h) // 2), im)
    return canvas


def restyle(white: Image.Image) -> Image.Image:
    mask = np.asarray(white.getchannel("A"), dtype=np.float32) / 255.0
    h, w = mask.shape
    # vertical bronze gradient, light at the top
    y = np.linspace(0.0, 1.0, h, dtype=np.float32)[:, None]
    top = np.array([214, 202, 160], dtype=np.float32)
    bottom = np.array([112, 101, 66], dtype=np.float32)
    fill = top[None, None, :] * (1 - y[:, :, None]) + bottom[None, None, :] * y[:, :, None]
    fill = np.broadcast_to(fill, (h, w, 3)).copy()
    # bevel: bright where the mask is brighter than its blurred self toward the upper left, dark toward the lower right
    blur = np.asarray(white.getchannel("A").filter(ImageFilter.GaussianBlur(3.0)), dtype=np.float32) / 255.0
    shifted_ul = np.roll(np.roll(blur, 2, axis=0), 2, axis=1)
    bevel = np.clip((mask - blur) * 1.6 + (shifted_ul - blur) * 0.0, -1, 1)
    light = np.clip(bevel, 0, 1)[:, :, None]
    dark = np.clip(-bevel, 0, 1)[:, :, None]
    fill = fill + light * 70.0 - dark * 55.0
    # gold rim just inside the edge
    inner = np.asarray(white.getchannel("A").filter(ImageFilter.MinFilter(5)), dtype=np.float32) / 255.0
    rim = np.clip(mask - inner, 0, 1)[:, :, None]
    fill = fill * (1 - rim * 0.5) + np.array([230, 205, 110], dtype=np.float32) * rim * 0.5
    fill = np.clip(fill, 0, 255)
    # dark outline outside the shape
    outline_mask = np.asarray(white.getchannel("A").filter(ImageFilter.MaxFilter(5)), dtype=np.float32) / 255.0
    outline_mask = np.asarray(Image.fromarray((outline_mask * 255).astype(np.uint8)).filter(ImageFilter.GaussianBlur(0.6)), dtype=np.float32) / 255.0
    rgba = np.zeros((h, w, 4), dtype=np.float32)
    dark_col = np.array([36, 31, 20], dtype=np.float32)
    rgba[:, :, :3] = dark_col * (1 - mask[:, :, None]) + fill * mask[:, :, None]
    rgba[:, :, 3] = np.maximum(outline_mask, mask) * 255.0
    return Image.fromarray(np.clip(rgba, 0, 255).astype(np.uint8), "RGBA")


for number, name in NAMES.items():
    white = normalise(src / f"{number}.png")
    white.save(out / f"legacy_{name}.png")
    restyle(white).save(out / f"new_{name}.png")
    print("wrote", name)
