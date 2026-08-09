#!/usr/bin/env python3
"""Reject blank or visually empty Simulator proof PNGs without third-party packages."""

from __future__ import annotations

import argparse
import hashlib
import math
import struct
import sys
import zlib
from pathlib import Path


PNG_SIGNATURE = b"\x89PNG\r\n\x1a\n"


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


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("image", type=Path)
    parser.add_argument("--min-width", type=int, default=1600)
    parser.add_argument("--min-height", type=int, default=900)
    parser.add_argument("--min-bytes", type=int, default=100_000)
    parser.add_argument("--min-luma-std", type=float, default=8.0)
    parser.add_argument("--min-centre-nonblack", type=float, default=0.08)
    parser.add_argument("--min-centre-colour", type=float, default=0.003)
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

    digest = hashlib.sha256(args.image.read_bytes()).hexdigest()
    summary = (
        f"width={width} height={height} bytes={byte_count} "
        f"luma_std={measured['luma_std']:.2f} "
        f"centre_nonblack={measured['centre_nonblack_ratio']:.4f} "
        f"centre_colour={measured['centre_colour_ratio']:.4f} sha256={digest}"
    )
    if failures:
        print(f"PROOF_IMAGE=FAIL reasons={','.join(failures)} {summary}", file=sys.stderr)
        return 1
    print(f"PROOF_IMAGE=PASS {summary}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
