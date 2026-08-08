r"""Build a reproducible semantic-layer study from the registered stroke USDZ set.

Run with Blender, not system Python:

  /Applications/Blender\ 5.2.app/Contents/MacOS/Blender --background \
    --python Scripts/build_blender_layer_study.py -- \
    --output-dir TechnicalArt/Generated

The generated .blend/.usdc are technical-art review artifacts, not approved
clinical anatomy and not runtime proof. The JSON manifest is the verifier.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

import bpy
from mathutils import Vector


LAYERS = (
    ("CORTEX", "brain_anatomy_realistic_v2.usdz", (0.78, 0.57, 0.54, 1.0)),
    ("ARTERIES", "cerebral_arteries_realistic_v2.usdz", (0.78, 0.12, 0.16, 1.0)),
    ("BLOCKAGE", "ischemic_mca_clot_v2.usdz", (0.96, 0.48, 0.10, 1.0)),
    ("DURA", "dura_mater_cutaway_conceptual_v2.usdz", (0.22, 0.72, 0.88, 0.30)),
)

REGION_DIRECTIONS = (
    (-0.66, 0.56, 0.62), (-0.24, 0.88, 0.42), (0.28, 0.86, 0.43),
    (0.69, 0.56, 0.54), (-0.88, 0.16, 0.45), (-0.43, 0.20, 0.82),
    (0.27, 0.24, 0.86), (0.84, 0.06, 0.47), (-0.56, -0.43, 0.60),
    (0.46, -0.44, 0.65),
)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output-dir", default="TechnicalArt/Generated")
    argv = sys.argv[sys.argv.index("--") + 1 :] if "--" in sys.argv else []
    return parser.parse_args(argv)


def scene_bounds(objects: list[bpy.types.Object]) -> tuple[Vector, Vector]:
    corners: list[Vector] = []
    for obj in objects:
        if obj.type != "MESH":
            continue
        corners.extend(obj.matrix_world @ Vector(corner) for corner in obj.bound_box)
    if not corners:
        return Vector((-0.1, -0.1, -0.1)), Vector((0.1, 0.1, 0.1))
    return (
        Vector(tuple(min(point[index] for point in corners) for index in range(3))),
        Vector(tuple(max(point[index] for point in corners) for index in range(3))),
    )


def import_layer(asset: Path, layer_name: str, color: tuple[float, ...]) -> dict:
    before = set(bpy.data.objects)
    bpy.ops.wm.usd_import(filepath=str(asset))
    imported = sorted(set(bpy.data.objects) - before, key=lambda obj: obj.name)

    collection = bpy.data.collections.new(f"LAYER_{layer_name}")
    bpy.context.scene.collection.children.link(collection)
    anchor = bpy.data.objects.new(f"VISIONOS_{layer_name}_ROOT", None)
    collection.objects.link(anchor)
    anchor["visionosSemanticLayer"] = layer_name.lower()
    anchor["canonicalTransform"] = "identity"
    anchor["clinicalReview"] = "pending"

    for obj in imported:
        for existing in list(obj.users_collection):
            existing.objects.unlink(obj)
        collection.objects.link(obj)
        if obj.parent is None:
            obj.parent = anchor
        obj.color = color
        obj["sourceUSDZ"] = asset.name
        obj["visionosSemanticLayer"] = layer_name.lower()

    minimum, maximum = scene_bounds(imported)
    return {
        "layer": layer_name.lower(),
        "source": str(asset),
        "root": anchor.name,
        "objects": len(imported),
        "meshes": sum(obj.type == "MESH" for obj in imported),
        "boundsMin": list(minimum),
        "boundsMax": list(maximum),
        "anchor": anchor,
        "objectsList": imported,
    }


def add_region_anchors(cortex_record: dict) -> list[str]:
    minimum = Vector(cortex_record["boundsMin"])
    maximum = Vector(cortex_record["boundsMax"])
    center = (minimum + maximum) * 0.5
    radii = (maximum - minimum) * 0.5 * 0.98
    anchor = cortex_record["anchor"]
    names: list[str] = []

    for index, raw_direction in enumerate(REGION_DIRECTIONS):
        direction = Vector(raw_direction).normalized()
        point = bpy.data.objects.new(f"REGION_ANCHOR_{index + 1:02d}", None)
        point.empty_display_type = "SPHERE"
        point.empty_display_size = max(radii) * 0.018
        point.location = center + Vector((
            radii.x * direction.x,
            radii.y * direction.y,
            radii.z * direction.z,
        ))
        point.parent = anchor
        point["visionosRole"] = "selectable-region-anchor"
        point["clinicalReview"] = "position-pending"
        bpy.context.scene.collection.objects.link(point)
        names.append(point.name)
    return names


def main() -> None:
    args = parse_args()
    app_root = Path(__file__).resolve().parents[1]
    repo_root = app_root.parents[1]
    asset_root = repo_root / "RealityKitContent/Assets/vision_pro_stroke_kit_v2/exports/usdz"
    output_dir = (app_root / args.output_dir).resolve()
    output_dir.mkdir(parents=True, exist_ok=True)

    bpy.ops.object.select_all(action="SELECT")
    bpy.ops.object.delete(use_global=False)
    for collection in list(bpy.data.collections):
        if collection.name != "Collection":
            bpy.data.collections.remove(collection)

    records: list[dict] = []
    for layer_name, filename, color in LAYERS:
        asset = asset_root / filename
        if not asset.exists():
            raise FileNotFoundError(asset)
        records.append(import_layer(asset, layer_name, color))

    cortex = next(record for record in records if record["layer"] == "cortex")
    region_anchors = add_region_anchors(cortex)

    scene = bpy.context.scene
    scene["product"] = "Stroke Care"
    scene["pipelineContract"] = "semantic-sibling-layers-v1"
    scene["clinicalReview"] = "pending"
    scene["runtimeTarget"] = "RealityKit visionOS"
    scene["authoringOnly"] = True

    blend_path = output_dir / "StrokeLayerStudy.blend"
    usdc_path = output_dir / "StrokeLayerStudy.usdc"
    bpy.ops.wm.save_as_mainfile(filepath=str(blend_path))

    usd_export = "PASS"
    try:
        bpy.ops.wm.usd_export(filepath=str(usdc_path), export_animation=False)
    except Exception as error:  # Blender build differences must remain explicit.
        usd_export = f"BLOCKED: {type(error).__name__}: {error}"

    serialized_layers = []
    for record in records:
        serialized = {
            key: value for key, value in record.items()
            if key not in {"anchor", "objectsList"}
        }
        serialized["source"] = str(Path(serialized["source"]).relative_to(repo_root))
        serialized_layers.append(serialized)

    manifest = {
        "status": "BLENDER_LAYER_STUDY=PASS",
        "blenderVersion": bpy.app.version_string,
        "sourceAssetRoot": str(asset_root.relative_to(repo_root)),
        "outputBlend": str(blend_path.relative_to(app_root)),
        "outputUSDC": str(usdc_path.relative_to(app_root)),
        "usdExport": usd_export,
        "semanticLayers": serialized_layers,
        "regionAnchors": region_anchors,
        "pointCount": len(region_anchors),
        "boundaries": [
            "authoring artifact only",
            "not a patient scan",
            "layer and point positions require clinician review",
            "runtime transforms remain owned by StrokeExperienceState",
        ],
    }
    manifest_path = output_dir / "StrokeLayerStudy.manifest.json"
    manifest_path.write_text(json.dumps(manifest, indent=2) + "\n")
    print("BLENDER_LAYER_STUDY=PASS")
    print(f"BLENDER_OUTPUT={blend_path}")
    print(f"USD_EXPORT={usd_export}")
    print(f"MANIFEST={manifest_path}")


if __name__ == "__main__":
    main()
