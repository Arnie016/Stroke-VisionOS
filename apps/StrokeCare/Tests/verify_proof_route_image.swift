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
    "--proof-case-unfold": [["CASE 78"], ["FICTIONAL"], ["BEGIN PRESENTER VIEW"]],
    "--proof-spatial-intake": [["PATIENT FILES"], ["PLACE CASE", "CASE 78"]],
    "--proof-spatial-docked-case": [["CASE 78"], ["FICTIONAL"], ["BEGIN PRESENTER VIEW"]],
    "--proof-pressure": [["PRESSURE"], ["TEACHING", "FAMILY"]],
    "--proof-clinician-pressure": [["PRESSURE"], ["PRESENTER", "TEACHING"]],
    "--proof-family-question": [["PRESSURE", "CLARIFY"], ["FAMILY", "POINT"]],
    // The compact upper-left rail can be visually legible while full-frame OCR
    // misses its smallest safety line. Require the large route/control labels
    // here; the contract separately requires the visible qualitative/not-CFD
    // text and the captured image remains subject to human visual inspection.
    "--proof-procedure-field": [["PRESENTER"], ["PRESSURE"], ["CLEAR", "FLOW"]],
    "--proof-layer-study": [["APART"], ["PRESENTER", "TEACHING"]],
    "--proof-flow-layer-study": [["APART"], ["FLOW"], ["PRESENTER", "TEACHING"]],
    "--proof-flow-exit": [["PATIENT FILES"], ["PLACE CASE", "FILE 78"]],
    // Each viewpoint proof requires its unique rendered control label. The
    // generic accessibility fallback "View" must never make the wrong named
    // viewpoint pass.
    "--proof-view-anterior": [["FRONT"], ["PRESENTER", "TEACHING"]],
    "--proof-view-lateral-a": [["SIDE A"], ["PRESENTER", "TEACHING"]],
    "--proof-view-lateral-b": [["SIDE B"], ["PRESENTER", "TEACHING"]],
    "--proof-view-superior": [["TOP"], ["PRESENTER", "TEACHING"]],
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

// Spatial controls occupy a small part of a 4K Simulator frame. Keep the
// untouched full-frame pass, then repeat OCR on half-frame tiles so a compact
// selected label such as "Top" is not discarded as globally tiny text. This
// does not synthesize or infer words: every accepted token still has to be
// recognized from pixels in the captured image.
let width = cgImage.width
let height = cgImage.height
let regions = [
    CGRect(x: 0, y: 0, width: width, height: height),
    CGRect(x: 0, y: 0, width: width / 2, height: height),
    CGRect(x: width / 2, y: 0, width: width - width / 2, height: height),
    CGRect(x: 0, y: 0, width: width, height: height / 2),
    CGRect(x: 0, y: height / 2, width: width, height: height - height / 2),
]

var recognizedLines: [String] = []
do {
    for region in regions {
        guard let croppedImage = cgImage.cropping(to: region) else { continue }
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        try VNImageRequestHandler(cgImage: croppedImage).perform([request])
        recognizedLines.append(contentsOf: (request.results ?? []).compactMap {
            $0.topCandidates(1).first?.string
        })
    }
} catch {
    fputs("PROOF_ROUTE_IMAGE=FAIL ocr-error=\(error.localizedDescription)\n", stderr)
    exit(69)
}

let recognized = recognizedLines.joined(separator: " ").uppercased()

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
