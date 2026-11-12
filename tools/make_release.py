"""Builds the Loot and Degradation 2026 release into release/ (git-ignored): the FOMOD zip, the DLL source zip, the Nexus description, the GitHub notes and the
release record (manifest + review record).

  Loot and Degradation 2026 <ver>.zip          main download, FOMOD with the two DLLs
  Loot and Degradation 2026 <ver> DLL source.zip  the source of the DLL (GPL), its own download
  Nexus description / notes / SHIPPED-MANIFEST.json

The package content is the tested mod folder (MO2 mod "Loot and Degradation 2026") except the DLL, which comes from the build folders.
Usage: python tools/make_release.py 0.1.0
"""
import hashlib
import json
import os
import subprocess
import sys
import zipfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
VER = sys.argv[1] if len(sys.argv) > 1 else "0.1.0"
OUT = os.path.join(ROOT, "release")
MOD = r"H:/Modlists/Tabula/mods/Loot and Degradation 2026"
DLL_NEW = os.path.join(ROOT, "..", "ng-build", "build", "release", "out", "LootandDegradation", "LootandDegradation.dll")
DLL_OLD = os.path.join(ROOT, "plugin", "build", "release", "LootandDegradation.dll")
COPYING = os.path.join(ROOT, "..", "CommonLibSSE-NG-alandtse", "COPYING.txt")
EXCEPTIONS = os.path.join(ROOT, "..", "CommonLibSSE-NG-alandtse", "EXCEPTIONS.md")
MIT = os.path.join(ROOT, "..", "CommonLibSSE-NG-alandtse", "licenses", "LICENSE-MIT.txt")
NEW_GAME = "1.6.1170.0"
SKIP = {"SKSE/Plugins/LootandDegradation.dll", "SKSE/Plugins/LootandDegradation.ini"}
REPO = "https://github.com/CageTV/Loot-and-Degradation-2026"

os.makedirs(OUT, exist_ok=True)
read = lambda p: open(p, encoding="utf-8", errors="replace").read()
sha = lambda b: hashlib.sha256(b).hexdigest()


def dll_license():
    return (
        "LootandDegradation.dll - license\n================================\n\n"
        "LootandDegradation.dll is released under the GNU General Public License, version 3 or (at your option) any later version, because it is\n"
        "built with CommonLibSSE-NG, which is released under that license (with the exceptions printed below). The GPL covers this DLL only.\n"
        "Every other file in this download is released under CC BY-NC-SA 4.0 (see LICENSE.txt at the top of the download).\n\n"
        "Source code of this DLL (the complete project, with build instructions):\n  " + REPO + "\nand the download \"Loot and Degradation 2026 " + VER + " DLL source.zip\" next to this mod's files.\n\n"
        "The text of the GPL follows, then the exceptions of the library the DLL is built with.\n\n" + "=" * 78 + "\n\n" + read(COPYING) + "\n" + "=" * 78 +
        "\nCommonLibSSE-NG exceptions (EXCEPTIONS.md of the library)\n" + "=" * 78 + "\n\n" + read(EXCEPTIONS))


def dll_third_party(which):
    lib = ("CommonLibSSE-NG by alandtse and contributors (https://github.com/alandtse/CommonLibSSE-NG), GPL-3.0-or-later with its exceptions; built on the work of\n"
           "  powerof3, CharmedBaryon, colorglass and Ryan-rsm-McKenzie" if which == "new" else
           "CommonLibSSE-NG (vcpkg port, CharmedBaryon / colorglass), built on Ryan-rsm-McKenzie's CommonLibSSE")
    return (
        "LootandDegradation.dll - third-party code\n=========================================\n\n"
        "The DLL is built with these libraries, linked into it:\n"
        "  - " + lib + "\n  - spdlog (MIT), fmt (MIT), xbyak (BSD-3-Clause), rapidcsv (BSD-3-Clause)\n"
        "  - the SKSE Menu Framework 3 SDK header, used unmodified under its own terms\n"
        "  - Dear ImGui, through SKSE Menu Framework\n"
        "The licenses of these libraries are in their own projects. The CommonLibSSE MIT license it descends from:\n\n" + read(MIT))


def info_xml():
    return f"""<fomod>
  <Name>Loot and Degradation 2026</Name>
  <Author>CageTV (remix); isoku (original Loot and Degradation)</Author>
  <Version>{VER}</Version>
  <Website>{REPO}</Website>
  <Description>Native SKSE rebuild of Loot and Degradation.</Description>
</fomod>
"""


def module_config():
    return f"""<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://qconsulting.ca/fo3/ModConfig5.0.xsd">
  <moduleName>Loot and Degradation 2026</moduleName>
  <requiredInstallFiles>
    <folder source="common" destination=""/>
  </requiredInstallFiles>
  <installSteps order="Explicit">
    <installStep name="Game version">
      <optionalFileGroups order="Explicit">
        <group name="Which LootandDegradation.dll do you want?" type="SelectExactlyOne">
          <plugins order="Explicit">
            <plugin name="Skyrim 1.6.1170 and newer (SE / AE)">
              <description>The new build. Works on Skyrim SE/AE 1.6.1170 and on every later version, including 1.7.x. Pre-selected when the installer sees a game version of 1.6.1170 or newer.</description>
              <conditionFlags><flag name="dll">new</flag></conditionFlags>
              <typeDescriptor><dependencyType><defaultType name="Optional"/><patterns>
                <pattern><dependencies><gameDependency version="{NEW_GAME}"/></dependencies><type name="Recommended"/></pattern>
              </patterns></dependencyType></typeDescriptor>
            </plugin>
            <plugin name="Skyrim VR, or 1.6.1130 and older">
              <description>The older build, for Skyrim VR and for SE/AE 1.6.1130 and older (1.5.97 included). Pre-selected when the installer sees an older game version or Skyrim VR. On 1.6.1170 either build works.</description>
              <conditionFlags><flag name="dll">older</flag></conditionFlags>
              <typeDescriptor><dependencyType><defaultType name="Recommended"/><patterns>
                <pattern><dependencies><gameDependency version="{NEW_GAME}"/></dependencies><type name="Optional"/></pattern>
              </patterns></dependencyType></typeDescriptor>
            </plugin>
          </plugins>
        </group>
      </optionalFileGroups>
    </installStep>
  </installSteps>
  <conditionalFileInstalls>
    <patterns>
      <pattern><dependencies><flagDependency flag="dll" value="new"/></dependencies><files><folder source="dll-new" destination=""/></files></pattern>
      <pattern><dependencies><flagDependency flag="dll" value="older"/></dependencies><files><folder source="dll-older" destination=""/></files></pattern>
    </patterns>
  </conditionalFileInstalls>
</config>
"""


def build():
    for d in (DLL_NEW, DLL_OLD):
        assert os.path.isfile(d), "missing " + d
    manifest = []
    name = f"Loot and Degradation 2026 {VER}.zip"
    path = os.path.join(OUT, name)
    docs = lambda n: open(os.path.join(ROOT, "release-docs", n), "rb").read()

    def add(z, arc, data):
        z.writestr(arc, data)
        manifest.append({"file": arc, "sha256": sha(data), "size": len(data), "status": "shipped"})

    with zipfile.ZipFile(path, "w", zipfile.ZIP_DEFLATED) as z:
        add(z, "fomod/info.xml", info_xml().encode())
        add(z, "fomod/ModuleConfig.xml", module_config().encode())
        add(z, "README.txt", docs("README.txt"))
        add(z, "LICENSE.txt", docs("LICENSE-package.txt") + b"\n\n" + open(os.path.join(ROOT, "LICENSE.txt"), "rb").read())
        for base, _, files in os.walk(MOD):
            for f in files:
                full = os.path.join(base, f)
                rel = os.path.relpath(full, MOD).replace(os.sep, "/")
                if rel in SKIP:
                    continue
                add(z, "common/" + rel, open(full, "rb").read())
        for which, dll in (("new", DLL_NEW), ("older", DLL_OLD)):
            add(z, f"dll-{which}/SKSE/Plugins/LootandDegradation.dll", open(dll, "rb").read())
            add(z, f"dll-{which}/SKSE/Plugins/LootandDegradation-LICENSE.txt", dll_license().encode())
            add(z, f"dll-{which}/SKSE/Plugins/LootandDegradation-THIRD-PARTY.txt", dll_third_party(which).encode())
    # the DLL's source: the repository as committed (git archive), as its own download
    src = os.path.join(OUT, f"Loot and Degradation 2026 {VER} DLL source.zip")
    subprocess.run(["git", "archive", "--format=zip", "--prefix=Loot-and-Degradation-2026/", "-o", src, "HEAD"], cwd=ROOT, check=True)
    for fn in ("Nexus description.txt", "notes.md"):
        data = docs("nexus-description.txt" if fn.startswith("Nexus") else "notes.md")
        open(os.path.join(OUT, fn if fn.startswith("Nexus") else f"notes-{VER}.md"), "wb").write(data)
    json.dump({"version": VER, "commit": subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=ROOT).decode().strip(), "files": manifest},
              open(os.path.join(OUT, "SHIPPED-MANIFEST.json"), "w"), indent=1)
    print("built", path, os.path.getsize(path), "bytes;", len(manifest), "files")


build()
