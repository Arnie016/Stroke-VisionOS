#!/usr/bin/env swift

import CoreGraphics
import Darwin
import Foundation
import ImageIO

private let projectRoot = URL(fileURLWithPath: #filePath)
    .deletingLastPathComponent()
    .deletingLastPathComponent()

private let stackURL: URL = {
    if CommandLine.arguments.count == 2 {
        return URL(fileURLWithPath: CommandLine.arguments[1]).standardizedFileURL
    }
    guard CommandLine.arguments.count == 1 else {
        fputs("usage: verify_app_icon_layers.swift [/path/to/AppIcon.solidimagestack]\n", stderr)
        exit(64)
    }
    return projectRoot
        .appendingPathComponent("Resources/Assets.xcassets/AppIcon.solidimagestack")
        .standardizedFileURL
}()

private struct LayerReceipt {
    let name: String
    let width: Int
    let height: Int
    let sourceHasAlpha: Bool
    let transparentFraction: Double
    let visibleFraction: Double
    let coloredVisibleFraction: Double
    let blackVisibleFraction: Double
    let uniqueRGBA: Int
    let failures: [String]
}

private func jsonDictionary(at url: URL) throws -> [String: Any] {
    let data = try Data(contentsOf: url)
    guard let dictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
        throw NSError(
            domain: "RBCAppIconVerifier",
            code: 1,
            userInfo: [NSLocalizedDescriptionKey: "JSON root is not an object: \(url.path)"]
        )
    }
    return dictionary
}

private func sourceContainsAlpha(_ image: CGImage) -> Bool {
    switch image.alphaInfo {
    case .premultipliedLast, .premultipliedFirst, .last, .first, .alphaOnly:
        return true
    case .none, .noneSkipLast, .noneSkipFirst:
        return false
    @unknown default:
        return false
    }
}

private func inspectLayer(name: String, imageURL: URL) throws -> LayerReceipt {
    guard
        let source = CGImageSourceCreateWithURL(imageURL as CFURL, nil),
        let image = CGImageSourceCreateImageAtIndex(source, 0, nil)
    else {
        throw NSError(
            domain: "RBCAppIconVerifier",
            code: 2,
            userInfo: [NSLocalizedDescriptionKey: "cannot decode PNG: \(imageURL.path)"]
        )
    }

    let width = image.width
    let height = image.height
    let pixelCount = width * height
    let bytesPerRow = width * 4
    var rgba = [UInt8](repeating: 0, count: pixelCount * 4)
    let rendered = rgba.withUnsafeMutableBytes { bytes -> Bool in
        guard let context = CGContext(
            data: bytes.baseAddress,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
                | CGBitmapInfo.byteOrder32Big.rawValue
        ) else {
            return false
        }
        context.setBlendMode(.copy)
        context.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
        return true
    }
    guard rendered, pixelCount > 0 else {
        throw NSError(
            domain: "RBCAppIconVerifier",
            code: 3,
            userInfo: [NSLocalizedDescriptionKey: "cannot render RGBA pixels: \(imageURL.path)"]
        )
    }

    var transparentPixels = 0
    var visiblePixels = 0
    var coloredVisiblePixels = 0
    var blackVisiblePixels = 0
    var uniqueRGBA = Set<UInt32>()
    uniqueRGBA.reserveCapacity(512)

    for offset in stride(from: 0, to: rgba.count, by: 4) {
        let red = rgba[offset]
        let green = rgba[offset + 1]
        let blue = rgba[offset + 2]
        let alpha = rgba[offset + 3]

        if alpha <= 8 {
            transparentPixels += 1
        }
        if alpha > 8 {
            visiblePixels += 1
            let maximum = max(red, max(green, blue))
            let minimum = min(red, min(green, blue))
            if maximum >= 24, maximum - minimum >= 8 {
                coloredVisiblePixels += 1
            }
            if red <= 8, green <= 8, blue <= 8 {
                blackVisiblePixels += 1
            }
        }

        let quantized = UInt32(red >> 4) << 12
            | UInt32(green >> 4) << 8
            | UInt32(blue >> 4) << 4
            | UInt32(alpha >> 4)
        uniqueRGBA.insert(quantized)
    }

    let total = Double(pixelCount)
    let visibleTotal = Double(max(visiblePixels, 1))
    let transparentFraction = Double(transparentPixels) / total
    let visibleFraction = Double(visiblePixels) / total
    let coloredVisibleFraction = Double(coloredVisiblePixels) / total
    let blackVisibleFraction = Double(blackVisiblePixels) / visibleTotal
    let isOverlay = name != "Back"
    let hasAlpha = sourceContainsAlpha(image)
    var failures: [String] = []

    if width != 1024 || height != 1024 {
        failures.append("dimensions")
    }
    if uniqueRGBA.count < 64 {
        failures.append("insufficient-variation")
    }
    if isOverlay {
        if !hasAlpha {
            failures.append("missing-alpha")
        }
        if transparentFraction < 0.10 {
            failures.append("insufficient-transparency")
        }
        if visibleFraction < 0.01 || visibleFraction > 0.85 {
            failures.append("invalid-visible-coverage")
        }
        if coloredVisibleFraction < 0.005 {
            failures.append("insufficient-colored-content")
        }
        if blackVisibleFraction >= 0.90 {
            failures.append("opaque-black")
        }
    }

    return LayerReceipt(
        name: name,
        width: width,
        height: height,
        sourceHasAlpha: hasAlpha,
        transparentFraction: transparentFraction,
        visibleFraction: visibleFraction,
        coloredVisibleFraction: coloredVisibleFraction,
        blackVisibleFraction: blackVisibleFraction,
        uniqueRGBA: uniqueRGBA.count,
        failures: failures
    )
}

do {
    let stack = try jsonDictionary(at: stackURL.appendingPathComponent("Contents.json"))
    guard let layers = stack["layers"] as? [[String: Any]] else {
        throw NSError(
            domain: "RBCAppIconVerifier",
            code: 4,
            userInfo: [NSLocalizedDescriptionKey: "AppIcon stack has no layers array"]
        )
    }

    let expectedNames = ["Front", "Middle", "Back"]
    let layerDirectories = try layers.map { layer -> String in
        guard let filename = layer["filename"] as? String else {
            throw NSError(
                domain: "RBCAppIconVerifier",
                code: 5,
                userInfo: [NSLocalizedDescriptionKey: "AppIcon layer has no filename"]
            )
        }
        return filename
    }
    let names = layerDirectories.map { $0.replacingOccurrences(of: ".solidimagestacklayer", with: "") }
    guard names == expectedNames else {
        throw NSError(
            domain: "RBCAppIconVerifier",
            code: 6,
            userInfo: [NSLocalizedDescriptionKey: "expected Front,Middle,Back; found \(names.joined(separator: ","))"]
        )
    }

    var receipts: [LayerReceipt] = []
    for (name, layerDirectory) in zip(names, layerDirectories) {
        let imageSetURL = stackURL
            .appendingPathComponent(layerDirectory)
            .appendingPathComponent("Content.imageset")
        let imageSet = try jsonDictionary(at: imageSetURL.appendingPathComponent("Contents.json"))
        guard
            let images = imageSet["images"] as? [[String: Any]],
            let imageEntry = images.first(where: {
                $0["idiom"] as? String == "vision" && $0["scale"] as? String == "2x"
            }),
            let filename = imageEntry["filename"] as? String
        else {
            throw NSError(
                domain: "RBCAppIconVerifier",
                code: 7,
                userInfo: [NSLocalizedDescriptionKey: "\(name) lacks a vision 2x image reference"]
            )
        }
        receipts.append(try inspectLayer(name: name, imageURL: imageSetURL.appendingPathComponent(filename)))
    }

    for receipt in receipts {
        let status = receipt.failures.isEmpty ? "PASS" : "FAIL"
        let failures = receipt.failures.isEmpty ? "none" : receipt.failures.joined(separator: ",")
        print(String(
            format: "APP_ICON_LAYER|%@|%@|dimensions=%dx%d|alpha=%@|transparent=%.4f|visible=%.4f|colored=%.4f|black_visible=%.4f|unique=%d|failures=%@",
            receipt.name,
            status,
            receipt.width,
            receipt.height,
            receipt.sourceHasAlpha ? "yes" : "no",
            receipt.transparentFraction,
            receipt.visibleFraction,
            receipt.coloredVisibleFraction,
            receipt.blackVisibleFraction,
            receipt.uniqueRGBA,
            failures
        ))
    }

    let failed = receipts.filter { !$0.failures.isEmpty }
    if !failed.isEmpty {
        print("RBC_APP_ICON_LAYERS=FAIL|" + failed.map(\.name).joined(separator: ","))
        exit(1)
    }
    print("RBC_APP_ICON_LAYERS=PASS|layers=3")
} catch {
    print("RBC_APP_ICON_LAYERS=FAIL|error=\(error.localizedDescription)")
    exit(1)
}
