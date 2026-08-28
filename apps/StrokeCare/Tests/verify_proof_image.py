#!/usr/bin/env python3
"""Reject blank, visually empty, or wrong-route Simulator proof PNGs."""

from __future__ import annotations

import argparse
import hashlib
import math
import re
import struct
import subprocess
import sys
import unicodedata
import zlib
from pathlib import Path


PNG_SIGNATURE = b"\x89PNG\r\n\x1a\n"

# These are stable labels rendered by each supported deterministic route. The
# shortened "questions to as" stem tolerates Vision reading the small final
# glyph as either K or I while still rejecting an empty Simulator room.
ROUTE_TEXT_TOKENS = {
    "--proof-role-choice": ("curious learner", "doctor presenter"),
    "--proof-spatial-prelude": ("signals become networks", "conceptual teaching anatomy"),
    "--proof-spatial-prelude-hero": ("the brain is not one object", "conceptual teaching anatomy"),
    "--proof-print-request": ("prepare a teaching model", "generic teaching anatomy only"),
    "--proof-realtime-narration": ("want to hear one layer deeper", "brain surface"),
    "--proof-family-read-more": ("plain words", "folded outer surface"),
    "--proof-spatial-intake": ("patient files",),
    "--proof-selected-case-handoff": ("f 168", "elena"),
    "--proof-pressure": ("pressure", "questions to as"),
    "--proof-family-pressure-story": ("outside the brain", "begin here"),
    # The first-action cue is deliberately small and peripheral, so whole-frame
    # OCR anchors this route to the one direct family entry action. Contract
    # checks preserve the transient cue; human screenshot inspection confirms
    # its visual placement.
    "--proof-family-entry-hint": ("begin here", "start with one glowing point"),
    "--proof-clinician-pressure-story": (
        "explain this",
        "pressure",
    ),
    "--proof-clinician-protective-covering": (
        "explain this",
        "covering",
    ),
    "--proof-presenter-plain-language": (
        "explain this",
        "pressure",
        "occlusion",
        "swelling",
    ),
    "--proof-presenter-controls": ("resume", "black"),
    "--proof-presentation-settings": ("settings", "visual detail"),
    "--proof-clinician-toolkit": ("catheter set", "microcatheter"),
    "--proof-clinician-toolkit-full": ("microcatheter", "full geometry"),
    "--proof-clinician-toolkit-motion": ("microcatheter", "approach concept"),
    "--proof-clinician-craniotomy": ("craniotomy layers", "dura model", "back"),
    "--proof-access-layer-open": ("craniotomy layers", "dura model", "lifted", "back"),
    "--proof-access-layer-closed": ("craniotomy layers", "bone model", "in place", "back"),
    "--proof-imaging-gallery": ("imaging gallery", "add scans", "research atlas", "back"),
    "--proof-imaging-gallery-nine": ("imaging gallery", "add scans", "research atlas", "back"),
    "--proof-imaging-gallery-sixteen": ("imaging gallery", "add scans", "research atlas", "back"),
    "--proof-imaging-gallery-detail": ("imaging gallery", "ct research atlas", "annotate", "back"),
    "--proof-imaging-gallery-return": ("explain this", "anatomy", "imaging"),
    "--proof-imaging-gallery-placed": ("ct research atlas", "annotate scan", "back"),
    "--proof-imaging-gallery-placed-local": ("mri atlas local test copy", "memory only", "back"),
    "--proof-imaging-gallery-placement-return": ("explain this", "anatomy", "imaging"),
    "--proof-reference-medications": ("medications", "antiplatelets", "nhs medicine reference", "back"),
    "--proof-reference-guides": ("guides", "what it supports", "read source", "back"),
    "--proof-reference-return": ("explain this", "anatomy", "imaging"),
    # The default image-first toolbar keeps import/comparison in Study tools.
    # Verify the focused image actions, not those deliberately hidden controls.
    "--proof-imaging-room": (
        "imaging", "study tools", "studies", "gallery",
        "annotate scan", "place beside brain", "back",
    ),
    "--proof-imaging-import-lifecycle": ("focused local image", "local image", "memory only", "back"),
    "--proof-imaging-import-return": ("explain this", "anatomy", "imaging"),
    "--proof-teaching-imaging": ("mri template", "done"),
    "--proof-imaging-window": ("2d teaching reference", "vessel map"),
    "--proof-imaging-window-term-note": (
        "term note",
        "ct angiography",
        "back to study",
        "cerebrovascular diseases",
    ),
    "--proof-imaging-modality-reference": (
        "cta",
        "term note",
        "ct angiography",
        "back to study",
        "generic teaching reference",
    ),
    "--proof-imaging-pet-term-note": (
        "term note",
        "positron emission tomography",
        "read science overview",
        "back to study",
        "generic teaching reference",
    ),
    "--proof-imaging-study-deck": (
        "study deck",
        "structure",
        "vessel",
        "functional",
        "close study deck",
    ),
    "--proof-imaging-return-to-anatomy": (
        "explain this",
        "pressure",
    ),
    "--proof-imaging-return-reopen": (
        "placed teaching image",
        "study",
        "back",
    ),
    "--proof-imaging-term-return-reopen": (
        "placed teaching image",
        "ct angiography",
        "study",
        "back",
    ),
    "--proof-imaging-local-import": ("focused local image", "discussion prompt", "manual marker", "return beside brain"),
    "--proof-spatial-annotation": ("pinned note", "example blockage", "ct template"),
    "--proof-spatial-ink": ("ink overlay", "pinch drag over the teaching model", "undo", "clear"),
    "--proof-family-make-space-purpose": ("make space", "explore next"),
    "--proof-family-affected-reference": ("what this opens", "full arterial tree"),
    "--proof-family-surface-reference": ("brain surface", "teaching view"),
    "--proof-family-neuron-reference": ("one neuron", "3d teaching model"),
    "--proof-family-neuron-plain-words": (
        "plain words",
        "one neuron",
        "ask next",
        "did this make sense",
    ),
    "--proof-family-neuron-unsure": (
        "one neuron",
        "ask next",
        "still unsure",
        "teal branches",
    ),
    "--proof-family-nearby-reference": ("nearby brain tissue", "teaching view"),
    "--proof-family-explore-nearby": ("nearby brain tissue", "teaching view"),
    "--proof-family-opposite-reference": ("opposite side context", "teaching view"),
    "--proof-family-arterial-reference": (
        "arterial tree",
        "example blockage",
    ),
    "--proof-family-arterial-supply-reference": (
        "blood supply approaches",
        "full arterial tree",
    ),
    "--proof-family-arterial-branch-reference": (
        "arteries branch",
        "full arterial tree",
    ),
    "--proof-family-arterial-beyond-reference": (
        "flow beyond the blockage",
        "full arterial tree",
    ),
    "--proof-family-explore-beyond": (
        "flow beyond the blockage",
        "full arterial tree",
    ),
    "--proof-family-arterial-territory-reference": (
        "affected territory",
        "full arterial tree",
    ),
    "--proof-family-vessel-route-trace": (
        "route",
        "flow beyond the blockage",
        "4 of 5",
    ),
    "--proof-family-blockage-interior": (
        "you are inside a cerebral artery",
        "arterial fork",
    ),
    "--proof-family-blockage-return": (
        "arterial tree",
        "example blockage",
    ),
    "--proof-family-layer-reference": ("generic craniotomy", "hide layer view"),
    "--proof-family-atlas-surface-cue": ("frontal lobe", "whole brain surface"),
    "--proof-family-atlas-direct-surface-pick": ("selected on brain", "temporal lobe"),
    "--proof-family-atlas-temporal-cue": ("temporal lobe", "whole brain surface"),
    "--proof-family-atlas-internal-reference": ("thalamus", "internal structures"),
    "--proof-family-atlas-internal-plain-words": ("thalamus", "plain words"),
    "--proof-family-atlas-cerebellum-journey": ("inside", "cerebellum"),
    "--proof-anatomy-internal": ("internal", "anatomy"),
    "--proof-integrated-interior": ("supply network", "choose a region below"),
    "--proof-integrated-ventricles": ("ventricular system", "fluid filled"),
    "--proof-integrated-cortex": ("cortical microarchitecture", "six layers many variations"),
    "--proof-integrated-cortex-flow": ("cortical microarchitecture", "surface route turns inward"),
    "--proof-integrated-neural-gradient": ("ion gradient stores potential", "sodium and potassium"),
    "--proof-integrated-neural": ("neural signalling", "synaptic gaps"),
    "--proof-integrated-loading": ("building the brain around you", "generic teaching anatomy"),
}

OCR_SWIFT_SOURCE = r"""
import Foundation
import ImageIO
import Vision

let url = URL(fileURLWithPath: CommandLine.arguments[1])
guard let source = CGImageSourceCreateWithURL(url as CFURL, nil),
      let image = CGImageSourceCreateImageAtIndex(source, 0, nil) else {
    exit(2)
}

let width = CGFloat(image.width)
let height = CGFloat(image.height)
let cropRects = [
    CGRect(x: 0, y: 0, width: width, height: height),
    CGRect(x: 0, y: 0, width: width * 0.58, height: height * 0.58),
    CGRect(x: width * 0.42, y: 0, width: width * 0.58, height: height * 0.58),
    CGRect(x: 0, y: height * 0.42, width: width * 0.58, height: height * 0.58),
    CGRect(x: width * 0.42, y: height * 0.42, width: width * 0.58, height: height * 0.58),
]

for rect in cropRects {
    guard let crop = image.cropping(to: rect) else { continue }
    let request = VNRecognizeTextRequest()
    request.recognitionLevel = .accurate
    request.recognitionLanguages = ["en-US"]
    request.usesLanguageCorrection = false
    try VNImageRequestHandler(cgImage: crop).perform([request])

    for observation in request.results ?? [] {
        if let candidate = observation.topCandidates(1).first {
            print(candidate.string)
        }
    }
}
"""


def paeth(a: int, b: int, c: int) -> int:
    prediction = a + b - c
    pa = abs(prediction - a)
    pb = abs(prediction - b)
    pc = abs(prediction - c)
    if pa <= pb and pa <= pc:
        return a
    if pb <= pc:
        return b
    return c


def decode_png(path: Path) -> tuple[int, int, int, bytes, int]:
    data = path.read_bytes()
    if not data.startswith(PNG_SIGNATURE):
        raise ValueError("not a PNG file")

    offset = len(PNG_SIGNATURE)
    width = height = bit_depth = color_type = interlace = None
    payload = bytearray()
    while offset + 12 <= len(data):
        length = struct.unpack(">I", data[offset : offset + 4])[0]
        kind = data[offset + 4 : offset + 8]
        body = data[offset + 8 : offset + 8 + length]
        offset += 12 + length
        if kind == b"IHDR":
            width, height, bit_depth, color_type, _, _, interlace = struct.unpack(
                ">IIBBBBB", body
            )
        elif kind == b"IDAT":
            payload.extend(body)
        elif kind == b"IEND":
            break

    if None in (width, height, bit_depth, color_type, interlace):
        raise ValueError("PNG is missing IHDR")
    if bit_depth != 8 or interlace != 0:
        raise ValueError("only non-interlaced 8-bit PNGs are supported")

    channels_by_type = {0: 1, 2: 3, 4: 2, 6: 4}
    if color_type not in channels_by_type:
        raise ValueError(f"unsupported PNG colour type {color_type}")
    channels = channels_by_type[color_type]
    stride = width * channels
    raw = zlib.decompress(bytes(payload))
    expected = height * (stride + 1)
    if len(raw) != expected:
        raise ValueError(f"unexpected decoded size {len(raw)} != {expected}")

    reconstructed = bytearray(height * stride)
    previous = bytearray(stride)
    cursor = 0
    for row_index in range(height):
        filter_kind = raw[cursor]
        cursor += 1
        filtered = raw[cursor : cursor + stride]
        cursor += stride
        row = bytearray(stride)
        for index, value in enumerate(filtered):
            left = row[index - channels] if index >= channels else 0
            above = previous[index]
            upper_left = previous[index - channels] if index >= channels else 0
            if filter_kind == 0:
                restored = value
            elif filter_kind == 1:
                restored = value + left
            elif filter_kind == 2:
                restored = value + above
            elif filter_kind == 3:
                restored = value + ((left + above) // 2)
            elif filter_kind == 4:
                restored = value + paeth(left, above, upper_left)
            else:
                raise ValueError(f"unsupported PNG filter {filter_kind}")
            row[index] = restored & 0xFF
        start = row_index * stride
        reconstructed[start : start + stride] = row
        previous = row

    return width, height, channels, bytes(reconstructed), len(data)


def metrics(width: int, height: int, channels: int, pixels: bytes) -> dict[str, float]:
    total = width * height
    sample_step = max(1, total // 250_000)
    sampled = 0
    luma_sum = 0.0
    luma_sq_sum = 0.0
    nonblack = 0
    centre_sampled = 0
    centre_nonblack = 0
    centre_colour = 0

    x0, x1 = int(width * 0.18), int(width * 0.82)
    y0, y1 = int(height * 0.14), int(height * 0.86)
    for pixel_index in range(0, total, sample_step):
        base = pixel_index * channels
        if channels in (1, 2):
            r = g = b = pixels[base]
        else:
            r, g, b = pixels[base], pixels[base + 1], pixels[base + 2]
        luma = 0.2126 * r + 0.7152 * g + 0.0722 * b
        sampled += 1
        luma_sum += luma
        luma_sq_sum += luma * luma
        if luma >= 18:
            nonblack += 1

        y, x = divmod(pixel_index, width)
        if x0 <= x < x1 and y0 <= y < y1:
            centre_sampled += 1
            if luma >= 18:
                centre_nonblack += 1
            if luma >= 18 and max(r, g, b) - min(r, g, b) >= 12:
                centre_colour += 1

    mean = luma_sum / sampled
    variance = max(0.0, luma_sq_sum / sampled - mean * mean)
    return {
        "luma_std": math.sqrt(variance),
        "nonblack_ratio": nonblack / sampled,
        "centre_nonblack_ratio": centre_nonblack / max(1, centre_sampled),
        "centre_colour_ratio": centre_colour / max(1, centre_sampled),
    }


def recognize_text(path: Path) -> str:
    """Use the macOS Vision framework already present beside simctl/Xcode."""
    try:
        result = subprocess.run(
            ["xcrun", "swift", "-e", OCR_SWIFT_SOURCE, str(path.resolve())],
            check=False,
            capture_output=True,
            text=True,
            timeout=30,
        )
    except (FileNotFoundError, subprocess.TimeoutExpired) as error:
        raise RuntimeError("Vision OCR could not be started") from error
    if result.returncode != 0:
        raise RuntimeError(f"Vision OCR exited {result.returncode}")
    return result.stdout


def normalize_text(text: str) -> str:
    ascii_text = unicodedata.normalize("NFKD", text).encode("ascii", "ignore").decode()
    return " ".join(re.findall(r"[a-z0-9]+", ascii_text.casefold()))


def missing_route_tokens(route: str, recognized_text: str) -> list[str]:
    normalized = normalize_text(recognized_text)
    return [token for token in ROUTE_TEXT_TOKENS[route] if token not in normalized]


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("image", type=Path)
    parser.add_argument("--min-width", type=int, default=1600)
    parser.add_argument("--min-height", type=int, default=900)
    parser.add_argument("--min-bytes", type=int, default=100_000)
    parser.add_argument("--min-luma-std", type=float, default=8.0)
    parser.add_argument("--min-centre-nonblack", type=float, default=0.08)
    parser.add_argument("--min-centre-colour", type=float, default=0.003)
    parser.add_argument("--route", choices=sorted(ROUTE_TEXT_TOKENS))
    args = parser.parse_args()

    try:
        width, height, channels, pixels, byte_count = decode_png(args.image)
        measured = metrics(width, height, channels, pixels)
    except (OSError, ValueError, zlib.error) as error:
        print(f"PROOF_IMAGE=FAIL reason={error}", file=sys.stderr)
        return 2

    failures = []
    if width < args.min_width or height < args.min_height:
        failures.append("dimensions")
    if byte_count < args.min_bytes:
        failures.append("file-size")
    if measured["luma_std"] < args.min_luma_std:
        failures.append("low-variance")
    if measured["centre_nonblack_ratio"] < args.min_centre_nonblack:
        failures.append("empty-centre")
    if measured["centre_colour_ratio"] < args.min_centre_colour:
        failures.append("colourless-centre")

    route_summary = ""
    if args.route:
        expected_tokens = ROUTE_TEXT_TOKENS[args.route]
        try:
            missing_tokens = missing_route_tokens(args.route, recognize_text(args.image))
        except RuntimeError as error:
            failures.append("route-ocr-unavailable")
            route_summary = f" route={args.route} route_ocr_error={error}"
        else:
            matched_count = len(expected_tokens) - len(missing_tokens)
            route_summary = (
                f" route={args.route} route_tokens={matched_count}/{len(expected_tokens)}"
            )
            if missing_tokens:
                failures.append("wrong-route-content")
                route_summary += " missing_route_tokens=" + "+".join(
                    token.replace(" ", "_") for token in missing_tokens
                )

    digest = hashlib.sha256(args.image.read_bytes()).hexdigest()
    summary = (
        f"width={width} height={height} bytes={byte_count} "
        f"luma_std={measured['luma_std']:.2f} "
        f"centre_nonblack={measured['centre_nonblack_ratio']:.4f} "
        f"centre_colour={measured['centre_colour_ratio']:.4f} sha256={digest}"
        f"{route_summary}"
    )
    if failures:
        print(f"PROOF_IMAGE=FAIL reasons={','.join(failures)} {summary}", file=sys.stderr)
        return 1
    print(f"PROOF_IMAGE=PASS {summary}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
