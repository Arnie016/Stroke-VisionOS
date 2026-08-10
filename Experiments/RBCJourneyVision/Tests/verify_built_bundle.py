#!/usr/bin/env python3
"""Verify RBCJourneyVision's generated identity and exact packaged resources."""

from pathlib import Path
import hashlib
import plistlib
import sys

ROOT = Path(__file__).resolve().parents[1]
EXPECTED_MODELS = {
    "artery_cutaway_complete_v2.usdz",
    "brain_anatomy_realistic_v2.usdz",
    "brain_deep_structures_v2.usdz",
    "brain_ventricles_v2.usdz",
    "cerebral_arteries_realistic_v2.usdz",
    "cerebral_bloodflow_animation_v2.usdz",
    "circle_of_willis_flow_overlay_v2.usdz",
    "cranial_vascular_registered_assembly_v2.usdz",
    "ischemic_mca_clot_v2.usdz",
    "microcirculation_arterial_venous_v2.usdz",
}
SOURCE_ONLY_MODELS = {
    "artery_interior_bloodflow_v2.usdz",
    "artery_wall_cutaway_v2.usdz",
    "cerebral_bloodflow_teaching_set_v2.usdz",
    "red_blood_cells_closeup_v2.usdz",
}

if len(sys.argv) != 2:
    raise SystemExit("usage: verify_built_bundle.py /path/to/RBCJourneyVision.app")

bundle = Path(sys.argv[1]).resolve()
if not bundle.is_dir():
    raise SystemExit(f"BUNDLE_MISSING|{bundle}")

with (bundle / "Info.plist").open("rb") as stream:
    info = plistlib.load(stream)

checks = {
    "bundle_identifier": info.get("CFBundleIdentifier") == "com.arnav.RBCJourneyVision",
    "display_name": info.get("CFBundleDisplayName") == "Inside the Flow",
    "marketing_version": info.get("CFBundleShortVersionString") == "0.1.0",
    "build_version": info.get("CFBundleVersion") == "1",
    "entry_url_scheme": info.get("CFBundleURLTypes") == [
        {
            "CFBundleTypeRole": "Viewer",
            "CFBundleURLName": "com.arnav.RBCJourneyVision",
            "CFBundleURLSchemes": ["rbcjourney"],
        }
    ],
    "compiled_asset_catalog": (bundle / "Assets.car").is_file(),
    "flow_audio": (bundle / "FlowBed.wav").is_file(),
    "provenance_manifest": (bundle / "portal-anchor-manifest.json").is_file(),
}

packaged_models = {path.name for path in bundle.glob("*.usdz")}
checks["exact_usdz_set"] = packaged_models == EXPECTED_MODELS
checks["source_only_models_excluded"] = not packaged_models.intersection(SOURCE_ONLY_MODELS)
checks["source_bundle_bytes_match"] = all(
    hashlib.sha256((ROOT / "Resources/Models" / name).read_bytes()).digest()
    == hashlib.sha256((bundle / name).read_bytes()).digest()
    for name in EXPECTED_MODELS
)

failed = [name for name, passed in checks.items() if not passed]
for name, passed in checks.items():
    print(f"{name}|{'PASS' if passed else 'FAIL'}")
print("PACKAGED_MODELS|" + ",".join(sorted(packaged_models)))

if failed:
    print("RBC_BUILT_BUNDLE=FAIL|" + ",".join(failed))
    raise SystemExit(1)

print("RBC_BUILT_BUNDLE=PASS|version=0.1.0|build=1|models=10")
