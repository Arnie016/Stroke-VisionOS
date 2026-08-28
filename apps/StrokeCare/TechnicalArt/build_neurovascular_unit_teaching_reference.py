"""Build Stroke Care's original magnified neurovascular-unit teaching reference.

Run with Blender in background mode. The asset is deliberately a generic,
cutaway teaching morphology. It is not measured histology, microscopy, patient
tissue, a scan, a permeability model, or a simulation of oxygen delivery.
All dimensions are authored in metres for a room-scale magnified exhibit.
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
BLEND_PATH = GENERATED / "NeurovascularUnitTeachingReference.blend"
USDC_PATH = GENERATED / "NeurovascularUnitTeachingReference.usdc"
PREVIEW_PATH = (
    APP_ROOT.parents[1]
    / "RealityKitContent"
    / "Assets"
    / "vision_pro_stroke_kit_v2"
    / "previews"
    / "20_neurovascular_unit_detailed_conceptual_v3.png"
)

random.seed(280828)


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
    mat.diffuse_color = rgba
    shader = mat.node_tree.nodes.get("Principled BSDF")
    shader.inputs["Base Color"].default_value = rgba
    shader.inputs["Roughness"].default_value = roughness
    shader.inputs["Metallic"].default_value = metallic
    if "Alpha" in shader.inputs:
        shader.inputs["Alpha"].default_value = rgba[3]
    if "Subsurface Weight" in shader.inputs:
        shader.inputs["Subsurface Weight"].default_value = subsurface
    if "Coat Weight" in shader.inputs:
        shader.inputs["Coat Weight"].default_value = 0.14
    if "Coat Roughness" in shader.inputs:
        shader.inputs["Coat Roughness"].default_value = 0.35
    if rgba[3] < 0.999 and hasattr(mat, "surface_render_method"):
        mat.surface_render_method = "DITHERED"
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
    radius: float,
    mat: bpy.types.Material,
    parent: bpy.types.Object,
    vertices: int = 12,
) -> bpy.types.Object:
    delta = end - start
    length = delta.length
    if length <= 1e-7:
        raise ValueError(f"zero-length segment: {name}")
    bpy.ops.mesh.primitive_cylinder_add(
        vertices=vertices,
        radius=radius,
        depth=length,
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


def capillary_center(x: float) -> Vector:
    return Vector((x, 0.010 * math.sin(x * 9.0), 0.010 * math.cos(x * 7.0)))


def add_cutaway_shell(
    name: str,
    x_start: float,
    x_end: float,
    inner_radius: float,
    outer_radius: float,
    mat: bpy.types.Material,
    parent: bpy.types.Object,
    x_segments: int = 26,
    radial_segments: int = 30,
) -> bpy.types.Object:
    """Create a curved vessel shell with a camera-facing longitudinal window."""
    vertices: list[tuple[float, float, float]] = []
    faces: list[tuple[int, int, int, int]] = []
    angle_start = -2.48
    angle_end = 2.48

    for x_index in range(x_segments + 1):
        t = x_index / x_segments
        x = x_start + (x_end - x_start) * t
        center = capillary_center(x)
        for radius in (outer_radius, inner_radius):
            for angle_index in range(radial_segments + 1):
                angle_t = angle_index / radial_segments
                angle = angle_start + (angle_end - angle_start) * angle_t
                organic_radius = radius * (
                    1.0
                    + 0.016 * math.sin(x * 24.0 + angle * 2.4)
                    + 0.010 * math.cos(x * 17.0 - angle * 3.1)
                )
                vertices.append((
                    center.x,
                    center.y + math.cos(angle) * organic_radius,
                    center.z + math.sin(angle) * organic_radius,
                ))

    ring = radial_segments + 1
    stride = ring * 2
    for x_index in range(x_segments):
        base = x_index * stride
        next_base = (x_index + 1) * stride
        for angle_index in range(radial_segments):
            # Outer and inner faces.
            a = base + angle_index
            b = base + angle_index + 1
            c = next_base + angle_index + 1
            d = next_base + angle_index
            faces.append((a, b, c, d))
            ia = base + ring + angle_index
            ib = next_base + ring + angle_index
            ic = next_base + ring + angle_index + 1
            id_ = base + ring + angle_index + 1
            faces.append((ia, ib, ic, id_))

        # Close the two cutaway edges along the vessel.
        for edge_index in (0, radial_segments):
            outer_a = base + edge_index
            outer_b = next_base + edge_index
            inner_b = next_base + ring + edge_index
            inner_a = base + ring + edge_index
            faces.append((outer_a, outer_b, inner_b, inner_a))

    # Close both ends of the shell.
    for end_base in (0, x_segments * stride):
        for angle_index in range(radial_segments):
            outer_a = end_base + angle_index
            outer_b = end_base + angle_index + 1
            inner_b = end_base + ring + angle_index + 1
            inner_a = end_base + ring + angle_index
            faces.append((outer_a, inner_a, inner_b, outer_b))

    mesh = bpy.data.meshes.new(name + "Mesh")
    mesh.from_pydata(vertices, [], faces)
    mesh.update()
    obj = bpy.data.objects.new(name, mesh)
    bpy.context.collection.objects.link(obj)
    obj.data.materials.append(mat)
    obj.parent = parent
    for polygon in obj.data.polygons:
        polygon.use_smooth = True
    return obj


def add_biconcave_rbc(
    name: str,
    location: Vector,
    scale: Vector,
    mat: bpy.types.Material,
    parent: bpy.types.Object,
    rotation_y: float,
) -> bpy.types.Object:
    bpy.ops.mesh.primitive_torus_add(
        align="WORLD",
        major_segments=28,
        minor_segments=10,
        location=location,
        major_radius=0.029,
        minor_radius=0.012,
        rotation=(0.0, math.pi * 0.5 + rotation_y, 0.0),
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


def build_asset() -> bpy.types.Object:
    root = empty("NeurovascularUnitTeachingReferenceRoot")
    root["asset_contract"] = "generic_magnified_neurovascular_unit_teaching_morphology_v3"
    root["clinical_boundary"] = "not_patient_tissue_not_histology_not_permeability_model"
    root["meters_per_unit"] = 1.0

    wall_root = empty("CapillaryWallAssembly", root)
    cell_root = empty("EndothelialCellAssembly", root)
    nucleus_root = empty("EndothelialNucleusAssembly", root)
    junction_root = empty("TightJunctionAssembly", root)
    membrane_root = empty("BasementMembraneAssembly", root)
    pericyte_root = empty("PericyteAssembly", root)
    astrocyte_root = empty("AstrocyteEndfootAssembly", root)
    neuron_root = empty("NearbyNeuronAssembly", root)
    blood_root = empty("FormedBloodElementsAssembly", root)

    wall_mat = material("Capillary_Endothelium_PBR", (0.10, 0.58, 0.66, 0.72), 0.34)
    endothelial_mat = material("Endothelial_Cell_PBR", (0.16, 0.78, 0.76, 1.0), 0.38, subsurface=0.05)
    endothelial_nucleus_mat = material("Endothelial_Nucleus_PBR", (0.10, 0.18, 0.43, 1.0), 0.34, subsurface=0.04)
    junction_mat = material("Tight_Junction_Cue_PBR", (0.95, 0.67, 0.16, 1.0), 0.29, metallic=0.06)
    membrane_mat = material("Basement_Membrane_PBR", (0.33, 0.22, 0.55, 0.80), 0.44)
    pericyte_mat = material("Pericyte_PBR", (0.18, 0.78, 0.52, 1.0), 0.42, subsurface=0.05)
    astrocyte_mat = material("Astrocyte_Endfeet_PBR", (0.42, 0.23, 0.76, 1.0), 0.46, subsurface=0.07)
    neuron_mat = material("Nearby_Neuron_Process_PBR", (0.87, 0.30, 0.18, 1.0), 0.48, subsurface=0.08)
    blood_mat = material("Red_Blood_Cell_PBR", (0.68, 0.035, 0.025, 1.0), 0.34, subsurface=0.10)

    add_cutaway_shell(
        "CapillaryEndothelialWallCutaway",
        -0.31,
        0.31,
        0.061,
        0.076,
        wall_mat,
        wall_root,
    )
    add_cutaway_shell(
        "BasementMembraneCutaway",
        -0.305,
        0.305,
        0.078,
        0.083,
        membrane_mat,
        membrane_root,
    )

    # Named endothelial-cell bodies sit within the wall. They are diagrammatic
    # spatial landmarks, not measured cell counts or tight-junction geometry.
    for index, x in enumerate((-0.24, -0.15, -0.06, 0.04, 0.14, 0.24)):
        # Alternate along both exposed cutaway edges so cell bodies and their
        # nuclei remain visible rather than hiding behind the vessel shell.
        angle = -2.10 if index % 2 == 0 else 2.10
        center = capillary_center(x)
        cell = add_ico_sphere(
            f"EndothelialCell_{index + 1:02d}",
            center + Vector((0.0, math.cos(angle) * 0.069, math.sin(angle) * 0.069)),
            Vector((0.045, 0.014, 0.020)),
            endothelial_mat,
            cell_root,
            subdivisions=2,
        )
        cell.rotation_euler.x = angle * 0.32
        nucleus = add_ico_sphere(
            f"EndothelialNucleus_{index + 1:02d}",
            center + Vector((0.0, math.cos(angle) * 0.062, math.sin(angle) * 0.062)),
            Vector((0.018, 0.0065, 0.009)),
            endothelial_nucleus_mat,
            nucleus_root,
            subdivisions=2,
        )
        nucleus.rotation_euler.x = angle * 0.32

    for index, x in enumerate((-0.205, -0.105, 0.0, 0.105, 0.205)):
        add_cutaway_shell(
            f"TightJunctionBand_{index + 1:02d}",
            x - 0.003,
            x + 0.003,
            0.083,
            0.088,
            junction_mat,
            junction_root,
            x_segments=2,
            radial_segments=24,
        )

    # One generic pericyte and its wrapping processes show adjacency only.
    add_ico_sphere(
        "PericyteCellBody",
        Vector((0.02, 0.072, 0.082)),
        Vector((0.055, 0.021, 0.027)),
        pericyte_mat,
        pericyte_root,
        subdivisions=2,
    )
    for index, (start, end) in enumerate((
        (Vector((-0.19, 0.070, 0.046)), Vector((0.20, 0.074, 0.062))),
        (Vector((-0.13, 0.060, -0.052)), Vector((0.17, 0.077, -0.044))),
        (Vector((-0.02, 0.083, 0.078)), Vector((0.02, -0.026, 0.092))),
    )):
        add_segment(
            f"PericyteProcess_{index + 1:02d}",
            start,
            end,
            0.008,
            pericyte_mat,
            pericyte_root,
            vertices=12,
        )

    # Astrocyte body, branches, and multiple broad endfeet form one inspectable
    # semantic mesh. Contact is spatially explicit but not a permeability claim.
    astro_body = Vector((0.06, 0.19, 0.17))
    add_ico_sphere(
        "AstrocyteCellBody",
        astro_body,
        Vector((0.041, 0.036, 0.035)),
        astrocyte_mat,
        astrocyte_root,
        subdivisions=3,
    )
    endfoot_targets = (
        Vector((-0.14, 0.060, 0.067)),
        Vector((-0.02, 0.071, 0.078)),
        Vector((0.12, 0.066, 0.071)),
        Vector((0.23, 0.051, 0.052)),
    )
    for index, target in enumerate(endfoot_targets):
        elbow = astro_body.lerp(target, 0.52) + Vector((0.0, 0.012, 0.022 * (-1 if index % 2 else 1)))
        add_segment(f"AstrocyteBranch_{index + 1:02d}A", astro_body, elbow, 0.009, astrocyte_mat, astrocyte_root)
        add_segment(f"AstrocyteBranch_{index + 1:02d}B", elbow, target, 0.006, astrocyte_mat, astrocyte_root)
        add_ico_sphere(
            f"AstrocyteEndfoot_{index + 1:02d}",
            target,
            Vector((0.026, 0.010, 0.018)),
            astrocyte_mat,
            astrocyte_root,
            subdivisions=2,
        )

    # Nearby neuron morphology gives the vessel relationship a cellular
    # context without pretending to model a complete cortical circuit.
    neuron_body = Vector((-0.18, 0.18, -0.17))
    add_ico_sphere(
        "NearbyNeuronSoma",
        neuron_body,
        Vector((0.038, 0.034, 0.031)),
        neuron_mat,
        neuron_root,
        subdivisions=3,
    )
    neuron_targets = (
        Vector((-0.31, 0.13, -0.23)),
        Vector((-0.27, 0.25, -0.08)),
        Vector((-0.06, 0.23, -0.23)),
        Vector((0.08, 0.11, -0.10)),
    )
    for index, target in enumerate(neuron_targets):
        elbow = neuron_body.lerp(target, 0.54) + Vector((0.0, 0.015 * (index - 1), 0.012))
        add_segment(f"NearbyNeuronProcess_{index + 1:02d}A", neuron_body, elbow, 0.0065, neuron_mat, neuron_root)
        add_segment(f"NearbyNeuronProcess_{index + 1:02d}B", elbow, target, 0.004, neuron_mat, neuron_root)

    for index, x in enumerate((-0.245, -0.145, -0.045, 0.060, 0.165, 0.255)):
        center = capillary_center(x)
        rbc = add_biconcave_rbc(
            f"RedBloodCell_{index + 1:02d}",
            center + Vector((0.0, -0.008 + (index % 2) * 0.014, -0.004 + (index % 3) * 0.005)),
            Vector((0.86, 0.82, 0.54)),
            blood_mat,
            blood_root,
            rotation_y=(index - 2.5) * 0.055,
        )
        rbc["teaching_role"] = "generic_formed_blood_element"

    return root


def mesh_stats(root: bpy.types.Object) -> dict[str, int | list[float]]:
    descendants = [obj for obj in bpy.context.scene.objects if obj == root or obj.parent is not None]
    meshes = [obj for obj in descendants if obj.type == "MESH"]
    mins = Vector((float("inf"),) * 3)
    maxs = Vector((float("-inf"),) * 3)
    for obj in meshes:
        for corner in obj.bound_box:
            point = obj.matrix_world @ Vector(corner)
            mins = Vector((min(mins[i], point[i]) for i in range(3)))
            maxs = Vector((max(maxs[i], point[i]) for i in range(3)))
    dimensions = maxs - mins
    return {
        "objects": len(descendants),
        "meshObjects": len(meshes),
        "vertices": sum(len(obj.data.vertices) for obj in meshes),
        "polygons": sum(len(obj.data.polygons) for obj in meshes),
        "materials": len({slot.material.name for obj in meshes for slot in obj.material_slots if slot.material}),
        "dimensions_m": [round(value, 6) for value in dimensions],
    }


def join_direct_mesh_children(parent_name: str, merged_name: str) -> None:
    parent = bpy.data.objects[parent_name]
    meshes = [obj for obj in bpy.context.scene.objects if obj.parent == parent and obj.type == "MESH"]
    if not meshes:
        return
    bpy.ops.object.select_all(action="DESELECT")
    for obj in meshes:
        obj.select_set(True)
    bpy.context.view_layer.objects.active = meshes[0]
    if len(meshes) > 1:
        bpy.ops.object.join()
    merged = bpy.context.view_layer.objects.active
    merged.name = merged_name
    merged.parent = parent


def consolidate_for_runtime() -> None:
    for parent_name, merged_name in (
        ("CapillaryWallAssembly", "CapillaryEndothelialWallCutaway"),
        ("EndothelialCellAssembly", "EndothelialCellBodies"),
        ("EndothelialNucleusAssembly", "EndothelialNuclei"),
        ("TightJunctionAssembly", "TightJunctionBands"),
        ("BasementMembraneAssembly", "BasementMembraneCutaway"),
        ("PericyteAssembly", "PericyteAndProcesses"),
        ("AstrocyteEndfootAssembly", "AstrocyteAndEndfeet"),
        ("NearbyNeuronAssembly", "NearbyNeuronAndProcesses"),
        ("FormedBloodElementsAssembly", "RedBloodCellSet"),
    ):
        join_direct_mesh_children(parent_name, merged_name)


def export_asset(root: bpy.types.Object) -> dict[str, int | list[float]]:
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
        root_prim_path="/NeurovascularUnitTeachingReference",
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
    scene.world.color = (0.004, 0.008, 0.014)
    scene.view_settings.look = "AgX - Medium High Contrast"
    scene.view_settings.exposure = -1.18

    bpy.ops.object.camera_add(location=(0.02, -1.06, 0.50))
    camera = bpy.context.object
    camera.name = "PreviewCamera_NotExported"
    camera.data.lens = 58
    look_at(camera, Vector((0.0, 0.045, 0.015)))
    scene.camera = camera

    for index, (location, energy, size, color) in enumerate((
        ((-0.38, -0.30, 0.42), 46.0, 0.44, (0.30, 0.88, 1.0)),
        ((0.35, -0.08, 0.38), 40.0, 0.36, (1.0, 0.48, 0.30)),
        ((0.02, 0.28, 0.22), 30.0, 0.30, (0.62, 0.46, 1.0)),
    )):
        bpy.ops.object.light_add(type="AREA", location=location)
        light = bpy.context.object
        light.name = f"PreviewLight_{index + 1:02d}_NotExported"
        light.data.energy = energy
        light.data.shape = "DISK"
        light.data.size = size
        light.data.color = color
        look_at(light, Vector((0.0, 0.04, 0.01)))

    scene.render.filepath = str(PREVIEW_PATH)
    bpy.ops.render.render(write_still=True)


def main() -> None:
    reset_scene()
    root = build_asset()
    consolidate_for_runtime()
    stats = export_asset(root)
    render_preview()
    print("NEUROVASCULAR_ASSET_STATS=" + json.dumps(stats, sort_keys=True))
    print(f"NEUROVASCULAR_ASSET_USDC={USDC_PATH}")
    print(f"NEUROVASCULAR_ASSET_PREVIEW={PREVIEW_PATH}")


if __name__ == "__main__":
    main()
