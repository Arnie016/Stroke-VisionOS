#!/usr/bin/env python3
"""Prove that a named Simulator region changes across two captured frames."""

from __future__ import annotations

import argparse
from pathlib import Path

from verify_proof_image import decode_png


def parse_roi(value: str) -> tuple[float, float, float, float]:
    try:
        roi = tuple(float(part) for part in value.split(","))
    except ValueError as error:
        raise argparse.ArgumentTypeError("ROI must contain four decimal values") from error
    if len(roi) != 4 or not (0 <= roi[0] < roi[2] <= 1 and 0 <= roi[1] < roi[3] <= 1):
        raise argparse.ArgumentTypeError("ROI must be normalized x0,y0,x1,y1")
    return roi  # type: ignore[return-value]


parser = argparse.ArgumentParser()
parser.add_argument("before", type=Path)
parser.add_argument("after", type=Path)
parser.add_argument("--roi", type=parse_roi, required=True)
parser.add_argument("--pixel-threshold", type=int, default=6)
parser.add_argument("--min-changed-ratio", type=float, default=0.001)
args = parser.parse_args()

width, height, channels, before, _ = decode_png(args.before)
after_width, after_height, after_channels, after, _ = decode_png(args.after)
if (width, height, channels) != (after_width, after_height, after_channels):
    raise SystemExit("MOTION_PAIR=FAIL reason=dimension-or-channel-mismatch")

x0, y0, x1, y1 = args.roi
changed = sampled = max_delta = 0
delta_sum = 0
for y in range(int(height * y0), int(height * y1)):
    for x in range(int(width * x0), int(width * x1)):
        base = (y * width + x) * channels
        delta = max(
            abs(before[base + channel] - after[base + channel])
            for channel in range(min(channels, 3))
        )
        sampled += 1
        delta_sum += delta
        max_delta = max(max_delta, delta)
        changed += delta >= args.pixel_threshold

changed_ratio = changed / sampled if sampled else 0
mean_delta = delta_sum / sampled if sampled else 0
if changed_ratio < args.min_changed_ratio:
    raise SystemExit(
        "MOTION_PAIR=FAIL "
        f"changed_ratio={changed_ratio:.6f} mean_delta={mean_delta:.4f} "
        f"max_delta={max_delta} threshold={args.min_changed_ratio:.6f}"
    )

print(
    "MOTION_PAIR=PASS "
    f"changed_ratio={changed_ratio:.6f} mean_delta={mean_delta:.4f} "
    f"max_delta={max_delta} roi={','.join(str(value) for value in args.roi)}"
)
