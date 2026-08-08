#!/usr/bin/env hython
"""Create inspectable Houdini SOP networks for Stroke Care.

This must run inside Houdini/hython. It authors a teaching graph only and does
not generate clinical geometry, patient measurements, treatment eligibility,
or a validated flow simulation.
"""

from __future__ import annotations

import argparse
from pathlib import Path

import hou


BRAIN_REVEAL_VEX = r"""
int side = @P.x < chf("midline_x") ? -1 : 1;
i@hemisphere_id = side;
vector pivot = side < 0 ? set(-0.04, 0, 0) : set(0.04, 0, 0);
float angle = radians(chf("reveal_degrees")) * chf("reveal") * side;
matrix3 rotation = ident();
rotate(rotation, angle, {0, 1, 0});
vector local = @P - pivot;
@P = local * rotation + pivot + set(side * chf("separation") * chf("reveal"), 0, 0);
f@stroke_reveal = chf("reveal");
"""


OCCLUSION_VEX = r"""
float u = f@curveu;
float d = abs(u - chf("clot_u"));
float profile = smooth(chf("width"), 0.0, d);
f@width = lerp(chf("base_radius"), chf("radius_floor"), profile);
f@occlusion_weight = profile;
"""


FLOW_VEX = r"""
float phase = frac(@Time * chf("speed") + @ptnum / max(1.0, @numpt));
float clot_u = chf("clot_u");
f@flow_visibility = phase > clot_u ? chf("downstream_cue") : 1.0;
f@stroke_flow_phase = phase;
"""


def set_any(node: hou.Node, names: tuple[str, ...], value: object) -> bool:
    for name in names:
        parm = node.parm(name)
        if parm is not None:
            parm.set(value)
            return True
    return False


def add_float(node: hou.Node, name: str, label: str, value: float, minimum: float = 0.0, maximum: float = 1.0) -> None:
    group = node.parmTemplateGroup()
    group.append(hou.FloatParmTemplate(name, label, 1, default_value=(value,), min=minimum, max=maximum))
    node.setParmTemplateGroup(group)


def source_node(parent: hou.Node, name: str, path: Path) -> hou.Node:
    node = parent.createNode("file", name)
    set_any(node, ("file",), str(path))
    node.setComment("Reviewed source only. Convert USD upstream if this Houdini build cannot read it through File SOP.")
    node.setGenericFlag(hou.nodeFlag.DisplayComment, True)
    return node


def build(brain_source: Path, vessel_source: Path, output: Path) -> None:
    for path in (brain_source, vessel_source):
        if not path.exists():
            raise FileNotFoundError(path)

    hou.hipFile.clear(suppress_save_prompt=True)
    obj = hou.node("/obj")

    brain = obj.createNode("geo", "stroke_brain_reveal")
    for child in brain.children():
        child.destroy()
    brain_file = source_node(brain, "REVIEWED_BRAIN_SOURCE", brain_source)
    brain_clean = brain.createNode("clean", "NORMALIZE_AND_CLEAN")
    brain_clean.setInput(0, brain_file)
    reveal = brain.createNode("attribwrangle", "BRAIN_REVEAL_RIG")
    reveal.setInput(0, brain_clean)
    set_any(reveal, ("class",), 2)
    set_any(reveal, ("snippet",), BRAIN_REVEAL_VEX)
    for name, label, value, maximum in (
        ("midline_x", "Midline X", 0.0, 1.0),
        ("reveal", "Reveal", 0.0, 1.0),
        ("reveal_degrees", "Reveal degrees", 12.0, 35.0),
        ("separation", "Separation metres", 0.07, 0.25),
    ):
        add_float(reveal, name, label, value, maximum=maximum)
    out_brain = brain.createNode("null", "OUT_BRAIN_REVEAL")
    out_brain.setInput(0, reveal)
    out_brain.setDisplayFlag(True)
    out_brain.setRenderFlag(True)
    brain.layoutChildren()

    vessels = obj.createNode("geo", "stroke_vessel_occlusion")
    for child in vessels.children():
        child.destroy()
    vessel_file = source_node(vessels, "REVIEWED_VESSEL_CURVES", vessel_source)
    resample = vessels.createNode("resample", "RESAMPLE_ARCLENGTH")
    resample.setInput(0, vessel_file)
    set_any(resample, ("curveu", "maintainlastvertex"), 1)
    occlusion = vessels.createNode("attribwrangle", "OCCLUSION_RADIUS_PROFILE")
    occlusion.setInput(0, resample)
    set_any(occlusion, ("class",), 2)
    set_any(occlusion, ("snippet",), OCCLUSION_VEX)
    for name, label, value in (
        ("clot_u", "Clot curve U", 0.72),
        ("width", "Occlusion width", 0.08),
        ("base_radius", "Base radius", 0.0055),
        ("radius_floor", "Radius floor", 0.0012),
    ):
        add_float(occlusion, name, label, value)
    sweep = vessels.createNode("polywire", "SWEEP_VESSEL_TUBES")
    sweep.setInput(0, occlusion)
    set_any(sweep, ("radius",), 0.0055)
    flow = vessels.createNode("attribwrangle", "FLOW_POINTS_ON_CURVE")
    flow.setInput(0, resample)
    set_any(flow, ("class",), 2)
    set_any(flow, ("snippet",), FLOW_VEX)
    for name, label, value in (
        ("speed", "Teaching flow speed", 0.16),
        ("clot_u", "Clot curve U", 0.72),
        ("downstream_cue", "Downstream residual cue", 0.18),
    ):
        add_float(flow, name, label, value)
    merge = vessels.createNode("merge", "MERGE_VESSEL_AND_FLOW")
    merge.setInput(0, sweep)
    merge.setInput(1, flow)
    out_vessels = vessels.createNode("null", "OUT_VESSEL_AND_FLOW")
    out_vessels.setInput(0, merge)
    out_vessels.setDisplayFlag(True)
    out_vessels.setRenderFlag(True)
    vessels.layoutChildren()

    output.parent.mkdir(parents=True, exist_ok=True)
    hou.hipFile.save(str(output))
    print(f"STROKE_HOUDINI_GRAPH={output}")
    print("STATUS=GRAPH_CREATED_NOT_CLINICALLY_VALIDATED")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--brain-source", type=Path, required=True)
    parser.add_argument("--vessel-source", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    build(args.brain_source.expanduser().resolve(), args.vessel_source.expanduser().resolve(), args.output.expanduser().resolve())


if __name__ == "__main__":
    main()
