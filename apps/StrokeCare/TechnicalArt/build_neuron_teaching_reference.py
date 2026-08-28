"""Build Stroke Care's original, magnified neuron teaching reference.

Run with Blender in background mode. The result is deliberately a generic
teaching morphology rather than measured histology, patient tissue, a neural
recording, or a membrane-voltage simulation. All dimensions are authored in
metres for a room-scale magnified exhibit.
"""

from __future__ import annotations

import json
import math
import random
from pathlib import Path

import bpy
from mathutils import Vector


APP_ROOT = Path(__file__).resolve().parents[1]
GENERATED = APP_ROOT / "TechnicalArt" / "Generated"
BLEND_PATH = GENERATED / "NeuronTeachingReference.blend"
USDC_PATH = GENERATED / "NeuronTeachingReference.usdc"
PREVIEW_PATH = (
    APP_ROOT.parents[1]
    / "RealityKitContent"
    / "Assets"
    / "vision_pro_stroke_kit_v2"
    / "previews"
    / "19_multipolar_neuron_detailed_conceptual_v3.png"
)

random.seed(240828)


def reset_scene() -> None:
    bpy.ops.object.select_all(action="SELECT")
    bpy.ops.object.delete(use_global=False)
    for datablocks in (bpy.data.meshes, bpy.data.curves, bpy.data.materials):
        for datablock in list(datablocks):
            if datablock.users == 0:
                datablocks.remove(datablock)
    bpy.context.scene.unit_settings.system = "METRIC"
    bpy.context.scene.unit_settings.scale_length = 1.0


def material(
    name: str,
    rgba: tuple[float, float, float, float],
    roughness: float,
    metallic: float = 0.0,
    subsurface: float = 0.0,
) -> bpy.types.Material:
    mat = bpy.data.materials.new(name=name)
    mat.use_nodes = True
    shader = mat.node_tree.nodes.get("Principled BSDF")
    shader.inputs["Base Color"].default_value = rgba
    shader.inputs["Roughness"].default_value = roughness
    shader.inputs["Metallic"].default_value = metallic
    if "Subsurface Weight" in shader.inputs:
        shader.inputs["Subsurface Weight"].default_value = subsurface
    if "Coat Weight" in shader.inputs:
        shader.inputs["Coat Weight"].default_value = 0.18
    if "Coat Roughness" in shader.inputs:
        shader.inputs["Coat Roughness"].default_value = 0.32
    return mat


def empty(name: str, parent: bpy.types.Object | None = None) -> bpy.types.Object:
    obj = bpy.data.objects.new(name, None)
    bpy.context.collection.objects.link(obj)
    obj.parent = parent
    return obj


def add_ico_sphere(
    name: str,
    location: Vector,
    scale: Vector,
    mat: bpy.types.Material,
    parent: bpy.types.Object,
    subdivisions: int = 2,
) -> bpy.types.Object:
    bpy.ops.mesh.primitive_ico_sphere_add(
        subdivisions=subdivisions,
        radius=1.0,
        location=location,
    )
    obj = bpy.context.object
    obj.name = name
    obj.scale = scale
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
    obj.data.materials.append(mat)
    obj.parent = parent
    for polygon in obj.data.polygons:
        polygon.use_smooth = True
    return obj


def add_segment(
    name: str,
    start: Vector,
    end: Vector,
    start_radius: float,
    end_radius: float,
    mat: bpy.types.Material,
    parent: bpy.types.Object,
    vertices: int = 12,
) -> bpy.types.Object:
    delta = end - start
    length = delta.length
    if length <= 1e-7:
        raise ValueError(f"zero-length segment: {name}")
    bpy.ops.mesh.primitive_cone_add(
        vertices=vertices,
        radius1=start_radius,
        radius2=end_radius,
        depth=length,
        end_fill_type="NGON",
        location=(start + end) * 0.5,
    )
    obj = bpy.context.object
    obj.name = name
    obj.rotation_mode = "QUATERNION"
    obj.rotation_quaternion = Vector((0.0, 0.0, 1.0)).rotation_difference(delta.normalized())
    obj.data.materials.append(mat)
    obj.parent = parent
    for polygon in obj.data.polygons:
        polygon.use_smooth = True
    return obj


def add_spine(
    name: str,
    base: Vector,
    branch_direction: Vector,
    side: float,
    mat: bpy.types.Material,
    parent: bpy.types.Object,
) -> None:
    normal = Vector((-branch_direction.y, branch_direction.x, 0.34 * side)).normalized()
    if side < 0:
        normal *= -1
    neck_end = base + normal * 0.010
    add_segment(name + "_Neck", base, neck_end, 0.0012, 0.00085, mat, parent, vertices=8)
    add_ico_sphere(
        name + "_Head",
        neck_end + normal * 0.0017,
        Vector((0.0024, 0.0024, 0.0028)),
        mat,
        parent,
        subdivisions=1,
    )


def grow_dendrite(
    prefix: str,
    start: Vector,
    angle: float,
    elevation: float,
    length: float,
    radius: float,
    depth: int,
    branch_parent: bpy.types.Object,
    spine_parent: bpy.types.Object,
    dendrite_mat: bpy.types.Material,
    spine_mat: bpy.types.Material,
) -> None:
    direction = Vector((math.cos(angle), math.sin(angle), elevation)).normalized()
    bend = Vector((
        math.cos(angle + 0.42) * length * 0.11,
        math.sin(angle + 0.42) * length * 0.11,
        math.sin(angle * 1.7) * length * 0.08,
    ))
    end = start + direction * length + bend
    add_segment(
        prefix,
        start,
        end,
        radius,
        max(radius * 0.68, 0.00105),
        dendrite_mat,
        branch_parent,
        vertices=12 if depth > 1 else 10,
    )
    add_ico_sphere(
        prefix + "_Junction",
        end,
        Vector((radius * 0.74,) * 3),
        dendrite_mat,
        branch_parent,
        subdivisions=1,
    )

    if depth <= 2:
        for index, t in enumerate((0.34, 0.68)):
            add_spine(
                f"{prefix}_Spine_{index + 1:02d}",
                start.lerp(end, t),
                direction,
                -1.0 if (index + depth) % 2 else 1.0,
                spine_mat,
                spine_parent,
            )

    if depth == 0:
        add_ico_sphere(
            prefix + "_Bouton",
            end,
            Vector((0.0034, 0.0034, 0.0038)),
            spine_mat,
            spine_parent,
            subdivisions=1,
        )
        return

    separation = 0.36 + (3 - depth) * 0.08
    for child_index, offset in enumerate((-separation, separation)):
        jitter = random.uniform(-0.055, 0.055)
        grow_dendrite(
            f"{prefix}_Branch_{child_index + 1:02d}",
            end,
            angle + offset + jitter,
            elevation * 0.62 + random.uniform(-0.16, 0.16),
            length * random.uniform(0.54, 0.65),
            radius * 0.66,
            depth - 1,
            branch_parent,
            spine_parent,
            dendrite_mat,
            spine_mat,
        )


def build_asset() -> bpy.types.Object:
    root = empty("NeuronTeachingReferenceRoot")
    root["asset_contract"] = "generic_magnified_neuron_teaching_morphology_v3"
    root["clinical_boundary"] = "not_patient_tissue_not_histology_not_recording"
    root["meters_per_unit"] = 1.0

    soma_root = empty("SomaAssembly", root)
    dendrite_root = empty("DendriticTree", root)
    spine_root = empty("DendriticSpines", root)
    axon_root = empty("AxonAssembly", root)
    myelin_root = empty("MyelinSheaths", root)
    node_root = empty("NodesOfRanvier", root)
    terminal_root = empty("AxonTerminals", root)

    soma_mat = material("Neuron_Soma_PBR", (0.54, 0.12, 0.10, 1.0), 0.48, subsurface=0.15)
    nucleus_mat = material("Neuron_Nucleus_PBR", (0.22, 0.045, 0.16, 1.0), 0.38, subsurface=0.08)
    dendrite_mat = material("Neuron_Dendrite_PBR", (0.63, 0.17, 0.13, 1.0), 0.52, subsurface=0.10)
    spine_mat = material("Neuron_Spine_PBR", (0.88, 0.34, 0.20, 1.0), 0.43, subsurface=0.06)
    axon_mat = material("Neuron_Axon_PBR", (0.85, 0.31, 0.08, 1.0), 0.44, subsurface=0.08)
    myelin_mat = material("Myelin_PBR", (0.18, 0.42, 0.55, 1.0), 0.31, metallic=0.02)
    node_mat = material("Node_Of_Ranvier_PBR", (0.97, 0.64, 0.14, 1.0), 0.34)
    terminal_mat = material("Synaptic_Terminal_PBR", (0.87, 0.18, 0.32, 1.0), 0.40, subsurface=0.08)

    soma = add_ico_sphere(
        "Soma",
        Vector((0.0, 0.0, 0.0)),
        Vector((0.043, 0.039, 0.035)),
        soma_mat,
        soma_root,
        subdivisions=3,
    )
    # A second shallow surface volume gives the cell body readable relief in
    # close inspection without claiming microscopy-derived surface texture.
    surface_relief = add_ico_sphere(
        "SomaSurfaceRelief",
        Vector((-0.003, 0.002, 0.002)),
        Vector((0.044, 0.0395, 0.0355)),
        dendrite_mat,
        soma_root,
        subdivisions=2,
    )
    surface_relief.scale = Vector((1.0, 0.995, 0.99))
    nucleus = add_ico_sphere(
        "Nucleus",
        Vector((-0.008, 0.003, 0.006)),
        Vector((0.019, 0.017, 0.015)),
        nucleus_mat,
        soma_root,
        subdivisions=2,
    )
    nucleus["teaching_role"] = "cell_body_internal_landmark"
    soma["teaching_role"] = "cell_body"

    dendrite_angles = (1.12, 1.74, 2.43, 3.05, 3.72, 4.43, 5.02)
    for index, angle in enumerate(dendrite_angles):
        start = Vector((math.cos(angle) * 0.033, math.sin(angle) * 0.030, 0.0))
        grow_dendrite(
            f"Dendrite_{index + 1:02d}",
            start,
            angle,
            math.sin(angle * 1.31) * 0.22,
            0.072 + (index % 3) * 0.009,
            0.0062,
            3,
            dendrite_root,
            spine_root,
            dendrite_mat,
            spine_mat,
        )

    hillock_start = Vector((0.031, -0.006, 0.0))
    hillock_end = Vector((0.070, -0.004, 0.002))
    add_segment(
        "AxonHillock",
        hillock_start,
        hillock_end,
        0.011,
        0.0055,
        axon_mat,
        axon_root,
        vertices=18,
    )

    axon_points = [hillock_end]
    for index in range(1, 14):
        x = 0.070 + index * 0.024
        y = -0.004 + math.sin(index * 0.64) * 0.011
        z = 0.002 + math.cos(index * 0.52) * 0.006
        axon_points.append(Vector((x, y, z)))

    for index in range(1, len(axon_points)):
        start = axon_points[index - 1]
        end = axon_points[index]
        add_segment(
            f"AxonCore_{index:02d}",
            start,
            end,
            0.0045,
            0.0043,
            axon_mat,
            axon_root,
            vertices=12,
        )
        if index % 2 == 1 and index < len(axon_points) - 1:
            inset = (end - start).normalized() * 0.0026
            add_segment(
                f"MyelinSegment_{(index + 1) // 2:02d}",
                start + inset,
                end - inset,
                0.0085,
                0.0085,
                myelin_mat,
                myelin_root,
                vertices=18,
            )
        else:
            midpoint = (start + end) * 0.5
            node = add_ico_sphere(
                f"NodeOfRanvier_{index // 2:02d}",
                midpoint,
                Vector((0.0054, 0.0054, 0.0054)),
                node_mat,
                node_root,
                subdivisions=1,
            )
            node["teaching_role"] = "myelin_gap"

    terminal_origin = axon_points[-1]
    for index, offset in enumerate((-0.74, -0.36, 0.0, 0.36, 0.74)):
        end = terminal_origin + Vector((
            0.054 + abs(offset) * 0.012,
            offset * 0.070,
            math.sin(offset * 2.2) * 0.026,
        ))
        add_segment(
            f"TerminalBranch_{index + 1:02d}",
            terminal_origin,
            end,
            0.0031,
            0.0017,
            terminal_mat,
            terminal_root,
            vertices=10,
        )
        bouton = add_ico_sphere(
            f"SynapticBouton_{index + 1:02d}",
            end,
            Vector((0.0062, 0.0062, 0.0072)),
            terminal_mat,
            terminal_root,
            subdivisions=2,
        )
        bouton["teaching_role"] = "generic_terminal_bouton"

    return root


def mesh_stats(root: bpy.types.Object) -> dict[str, int]:
    descendants = [obj for obj in bpy.context.scene.objects if obj == root or obj.parent is not None]
    meshes = [obj for obj in descendants if obj.type == "MESH"]
    return {
        "objects": len(descendants),
        "meshObjects": len(meshes),
        "vertices": sum(len(obj.data.vertices) for obj in meshes),
        "polygons": sum(len(obj.data.polygons) for obj in meshes),
        "materials": len({slot.material.name for obj in meshes for slot in obj.material_slots if slot.material}),
    }


def join_direct_mesh_children(parent_name: str, merged_name: str) -> None:
    parent = bpy.data.objects[parent_name]
    meshes = [obj for obj in bpy.context.scene.objects if obj.parent == parent and obj.type == "MESH"]
    if len(meshes) <= 1:
        if meshes:
            meshes[0].name = merged_name
        return
    bpy.ops.object.select_all(action="DESELECT")
    for obj in meshes:
        obj.select_set(True)
    bpy.context.view_layer.objects.active = meshes[0]
    bpy.ops.object.join()
    meshes[0].name = merged_name
    meshes[0].parent = parent


def consolidate_for_runtime() -> None:
    # Keep the cell body and nucleus separate for a restrained runtime breath,
    # but collapse hundreds of authored branch/spine pieces into semantic mesh
    # leaves. RealityKit therefore loads nine inspectable parts instead of
    # traversing hundreds of tiny ModelEntities every frame.
    for parent_name, merged_name in (
        ("DendriticTree", "DendriteMorphology"),
        ("DendriticSpines", "DendriticSpineField"),
        ("AxonAssembly", "AxonCoreAndHillock"),
        ("MyelinSheaths", "MyelinSegments"),
        ("NodesOfRanvier", "NodesOfRanvierMesh"),
        ("AxonTerminals", "AxonTerminalArbor"),
    ):
        join_direct_mesh_children(parent_name, merged_name)


def export_asset(root: bpy.types.Object) -> dict[str, int]:
    GENERATED.mkdir(parents=True, exist_ok=True)
    PREVIEW_PATH.parent.mkdir(parents=True, exist_ok=True)
    stats = mesh_stats(root)
    bpy.ops.wm.save_as_mainfile(filepath=str(BLEND_PATH))
    bpy.ops.object.select_all(action="SELECT")
    bpy.ops.wm.usd_export(
        filepath=str(USDC_PATH),
        selected_objects_only=True,
        export_animation=False,
        export_materials=True,
        generate_preview_surface=True,
        generate_materialx_network=False,
        export_cameras=False,
        export_lights=False,
        export_uvmaps=True,
        export_normals=True,
        export_custom_properties=True,
        triangulate_meshes=True,
        relative_paths=True,
        convert_scene_units="METERS",
        meters_per_unit=1.0,
        root_prim_path="/NeuronTeachingReference",
    )
    return stats


def look_at(obj: bpy.types.Object, target: Vector) -> None:
    obj.rotation_euler = (target - obj.location).to_track_quat("-Z", "Y").to_euler()


def render_preview() -> None:
    scene = bpy.context.scene
    scene.render.engine = "BLENDER_EEVEE"
    scene.render.resolution_x = 1200
    scene.render.resolution_y = 800
    scene.render.resolution_percentage = 100
    scene.render.image_settings.file_format = "PNG"
    scene.render.film_transparent = False
    scene.world.color = (0.006, 0.010, 0.018)
    scene.view_settings.look = "AgX - Medium High Contrast"
    scene.view_settings.exposure = -0.85

    bpy.ops.object.camera_add(location=(0.075, -0.035, 1.02))
    camera = bpy.context.object
    camera.name = "PreviewCamera_NotExported"
    camera.data.lens = 55
    look_at(camera, Vector((0.055, 0.0, 0.0)))
    scene.camera = camera

    for index, (location, energy, size, color) in enumerate((
        ((-0.23, -0.12, 0.34), 52.0, 0.42, (1.0, 0.42, 0.30)),
        ((0.34, 0.16, 0.28), 44.0, 0.34, (0.28, 0.68, 1.0)),
        ((0.02, -0.28, 0.12), 28.0, 0.28, (0.62, 0.88, 1.0)),
    )):
        bpy.ops.object.light_add(type="AREA", location=location)
        light = bpy.context.object
        light.name = f"PreviewLight_{index + 1:02d}_NotExported"
        light.data.energy = energy
        light.data.shape = "DISK"
        light.data.size = size
        light.data.color = color
        look_at(light, Vector((0.05, 0.0, 0.0)))

    scene.render.filepath = str(PREVIEW_PATH)
    bpy.ops.render.render(write_still=True)


def main() -> None:
    reset_scene()
    root = build_asset()
    consolidate_for_runtime()
    stats = export_asset(root)
    render_preview()
    print("NEURON_ASSET_STATS=" + json.dumps(stats, sort_keys=True))
    print(f"NEURON_ASSET_USDC={USDC_PATH}")
    print(f"NEURON_ASSET_PREVIEW={PREVIEW_PATH}")


if __name__ == "__main__":
    main()
