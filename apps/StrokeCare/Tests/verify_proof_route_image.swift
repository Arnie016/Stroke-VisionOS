#!/usr/bin/env swift

import AppKit
import Foundation
import Vision

/// Route-aware OCR gate for Simulator proof images. A generic living-room or
/// wrong-screen capture can have healthy luminance and colour, so visual
/// statistics alone are not proof that the named Stroke Care state rendered.

guard CommandLine.arguments.count == 3 else {
    fputs("usage: verify_proof_route_image.swift <image.png> <proof-route>\n", stderr)
    exit(64)
}

let imageURL = URL(fileURLWithPath: CommandLine.arguments[1])
let route = CommandLine.arguments[2]

let requiredText: [String: [[String]]] = [
    "--proof-case-unfold": [["CASE 78", "CASE REVIEW"], ["BEGIN", "ENTER"]],
    "--proof-spatial-intake": [["PATIENT FILES"], ["PLACE CASE", "CASE 78"]],
    "--proof-spatial-docked-case": [["CASE 78", "CASE REVIEW"], ["BEGIN", "ENTER"]],
    "--proof-pressure": [["PRESSURE"], ["TEACHING", "FAMILY"]],
    "--proof-clinician-pressure": [["PRESSURE"], ["PRESENTER", "TEACHING"]],
    "--proof-family-question": [["PRESSURE", "CLARIFY"], ["FAMILY", "POINT"]],
    // The compact upper-left rail can be visually legible while full-frame OCR
    // misses its smallest safety line. Require the large route/control labels
    // here; the contract separately requires the visible qualitative/not-CFD
    // text and the captured image remains subject to human visual inspection.
    "--proof-procedure-field": [["PRESENTER"], ["PRESSURE"], ["CLEAR", "FLOW"]],
    "--proof-layer-study": [["STUDY", "LAYERS"], ["PRESENTER", "TEACHING"]],
    "--proof-view-anterior": [["FRONT", "VIEW"], ["PRESENTER", "TEACHING"]],
    "--proof-view-lateral-a": [["SIDE A", "VIEW"], ["PRESENTER", "TEACHING"]],
    "--proof-view-lateral-b": [["SIDE B", "VIEW"], ["PRESENTER", "TEACHING"]],
    "--proof-view-superior": [["TOP", "VIEW"], ["PRESENTER", "TEACHING"]],
    "--proof-evidence-window": [["CLINICAL EVIDENCE"], ["SEARCH", "SOURCES"]],
    "--proof-evidence": [["CLINICAL EVIDENCE"], ["SEARCH", "SOURCES"]],
    "--proof-clinician-toolkit": [["TOOLS", "FOCUS"], ["PRESENTER", "TEACHING"]],
    "--proof-care-purpose": [["MAKE SPACE", "MAKING SPACE"], ["TEACHING", "FAMILY"]],
    "--proof-exit-reset": [["RESET"], ["EXIT"]],
]

guard let groups = requiredText[route] else {
    fputs("PROOF_ROUTE_IMAGE=FAIL unsupported-route=\(route)\n", stderr)
    exit(64)
}
guard let image = NSImage(contentsOf: imageURL) else {
    fputs("PROOF_ROUTE_IMAGE=FAIL unreadable-image=\(imageURL.path)\n", stderr)
    exit(66)
}

var proposedRect = NSRect(origin: .zero, size: image.size)
guard let cgImage = image.cgImage(forProposedRect: &proposedRect, context: nil, hints: nil) else {
    fputs("PROOF_ROUTE_IMAGE=FAIL no-cgimage\n", stderr)
    exit(65)
}

let request = VNRecognizeTextRequest()
request.recognitionLevel = .accurate
request.usesLanguageCorrection = true
try VNImageRequestHandler(cgImage: cgImage).perform([request])

let recognized = (request.results ?? [])
    .compactMap { $0.topCandidates(1).first?.string }
    .joined(separator: " ")
    .uppercased()

let missing = groups.filter { alternatives in
    !alternatives.contains { recognized.contains($0) }
}

if !missing.isEmpty {
    let expected = missing.map { $0.joined(separator: "|") }.joined(separator: ",")
    fputs("PROOF_ROUTE_IMAGE=FAIL route=\(route) missing=\(expected) ocr=\(recognized)\n", stderr)
    exit(1)
}

print("PROOF_ROUTE_IMAGE=PASS route=\(route) matched_groups=\(groups.count)")
print("PROOF_ROUTE_BOUNDARY=simulator-render-and-ocr-only;not-action-dispatch-wearer-device-or-clinical-proof")
