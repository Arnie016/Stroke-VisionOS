#!/usr/bin/env python3
"""Static case-library contract; not Simulator, device, wearer, or clinical proof."""

from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
launch = (ROOT / "Sources" / "StrokeJourneyLaunchView.swift").read_text()
history = (ROOT / "Sources" / "PatientHistoryTimelineView.swift").read_text()
asset = ROOT / "Resources" / "Assets.xcassets" / "CaseCabinetGrain.imageset" / "case-cabinet-grain-v1.png"
technical_art = ROOT / "TechnicalArt" / "CaseCabinetV1"

checks = {
    "doctor_routes_to_library": "showsCaseLibrary = true" in launch,
    "deterministic_proof_route": 'CommandLine.arguments.contains("--proof-case-library")' in launch,
    "family_bypasses_library": "enterSpatialCaseRoom(as: .family)" in launch,
    "dynamic_library_size": "showsCaseLibrary ? 980 : 620" in launch,
    "three_fictional_profiles": all(token in history for token in ("CASE-077", "CASE-078", "CASE-079")),
    "one_ready_case": history.count("isReady: true") == 1 and history.count("isReady: false") == 2,
    "patient_privacy_boundary": "No patient record · no diagnostic inference" in history,
    "abstract_portrait_boundary": "avoids real-person likeness" in history,
    "runtime_grain_exists": asset.exists() and asset.stat().st_size > 0,
    "psd_authoring_source_exists": (technical_art / "case_cabinet_material_source_v1.psd").exists(),
    "roughness_study_exists": (technical_art / "case_cabinet_roughness_v1.png").exists(),
}

for name, passed in checks.items():
    print(f"{name}|{'PASS' if passed else 'FAIL'}")

if not all(checks.values()):
    raise SystemExit("CASE_LIBRARY_CONTRACT=FAIL")

print("CASE_LIBRARY_CONTRACT=PASS")
