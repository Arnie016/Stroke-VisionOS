import SwiftUI

/// A moveable, deliberately generic 2D companion to the right-side 3D
/// reference. It offers visual language for the CT/MRI/CTA images that may be
/// discussed in a stroke conversation; it is never a patient image or result.
/// Standard visionOS window placement lets the clinician put it wherever it
/// best supports the conversation.
struct StrokeTeachingImagingWorkspaceView: View {
    enum Reference: String, CaseIterable, Identifiable {
        case vesselMap = "Vessel map"
        case ctGuide = "CT guide"
        case mriGuide = "MRI guide"

        var id: String { rawValue }
    }

    @EnvironmentObject private var experience: StrokeExperienceState
    @Environment(\.dismissWindow) private var dismissWindow
    @State private var reference: Reference = .vesselMap

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("2D TEACHING REFERENCE")
                        .font(.caption.weight(.black))
                        .tracking(1.05)
                        .foregroundStyle(.cyan)
                    Text(reference.title)
                        .font(.title3.weight(.bold))
                }
                Spacer()
                Button("Close", systemImage: "xmark") {
                    dismissWindow(id: StrokeSpace.imaging)
                }
                .buttonStyle(.bordered)
            }

            Picker("Reference type", selection: $reference) {
                ForEach(Reference.allCases) { item in
                    Text(item.rawValue).tag(item)
                }
            }
            .pickerStyle(.segmented)

            teachingGraphic
                .frame(maxWidth: .infinity, minHeight: 248)
                .background(.black.opacity(0.80), in: RoundedRectangle(cornerRadius: 24))
                .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.cyan.opacity(0.28)))

            VStack(alignment: .leading, spacing: 3) {
                Text(pointCaption)
                    .font(.callout.weight(.semibold))
                Text("Illustrative CT/MRI/CTA teaching view · not a patient scan or result · does not diagnose or recommend care")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(22)
        .frame(width: 600, height: 470)
        .background(.regularMaterial)
        .accessibilityElement(children: .contain)
    }

    @ViewBuilder
    private var teachingGraphic: some View {
        switch reference {
        case .vesselMap:
            VesselMapSchematic()
        case .ctGuide:
            CTTeachingSchematic()
        case .mriGuide:
            MRITeachingSchematic()
        }
    }

    private var pointCaption: String {
        if let label = experience.selectedPointLabel {
            return "Linked from: \(label)"
        }
        return "Select an anatomy point to link this reference."
    }
}

private extension StrokeTeachingImagingWorkspaceView.Reference {
    var title: String {
        switch self {
        case .vesselMap: "Vessel map"
        case .ctGuide: "CT: a cross-section guide"
        case .mriGuide: "MRI: a soft-tissue guide"
        }
    }
}

private struct VesselMapSchematic: View {
    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width * 0.47, y: size.height * 0.52)
            let head = CGRect(x: center.x - 104, y: center.y - 98, width: 208, height: 196)
            context.stroke(Path(ellipseIn: head), with: .color(.white.opacity(0.34)), lineWidth: 2)
            context.fill(Path(ellipseIn: head.insetBy(dx: 13, dy: 13)), with: .color(.indigo.opacity(0.23)))

            let routes: [[CGPoint]] = [
                [CGPoint(x: 124, y: 194), CGPoint(x: 168, y: 142), CGPoint(x: 214, y: 125), CGPoint(x: 267, y: 88)],
                [CGPoint(x: 168, y: 142), CGPoint(x: 230, y: 163), CGPoint(x: 279, y: 201)],
                [CGPoint(x: 214, y: 125), CGPoint(x: 254, y: 152), CGPoint(x: 314, y: 148)],
                [CGPoint(x: 230, y: 163), CGPoint(x: 237, y: 99), CGPoint(x: 200, y: 69)]
            ]
            for route in routes {
                var path = Path()
                path.move(to: route[0])
                for point in route.dropFirst() { path.addLine(to: point) }
                context.stroke(path, with: .color(.cyan.opacity(0.82)), style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
            }
            let focus = CGRect(x: 263, y: 132, width: 34, height: 34)
            context.fill(Path(ellipseIn: focus), with: .color(.orange.opacity(0.92)))
            context.stroke(Path(ellipseIn: focus.insetBy(dx: -7, dy: -7)), with: .color(.orange.opacity(0.42)), lineWidth: 2)
        }
        .overlay(alignment: .bottomTrailing) {
            Text("QUALITATIVE VASCULAR MAP")
                .font(.caption2.monospaced().weight(.bold))
                .tracking(0.7)
                .foregroundStyle(.cyan.opacity(0.80))
                .padding(14)
        }
    }
}

private struct CTTeachingSchematic: View {
    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width * 0.48, y: size.height * 0.50)
            for (index, inset) in [0.0, 17.0, 35.0, 51.0].enumerated() {
                let rect = CGRect(x: center.x - 104 + inset, y: center.y - 104 + inset, width: 208 - inset * 2, height: 208 - inset * 2)
                context.fill(Path(ellipseIn: rect), with: .color(index == 0 ? .white.opacity(0.26) : .indigo.opacity(0.16)))
                context.stroke(Path(ellipseIn: rect), with: .color(.white.opacity(0.20)), lineWidth: 1)
            }
            let focus = CGRect(x: center.x + 22, y: center.y - 38, width: 52, height: 52)
            context.fill(Path(ellipseIn: focus), with: .color(.orange.opacity(0.55)))
            context.stroke(Path(ellipseIn: focus), with: .color(.orange.opacity(0.92)), lineWidth: 2)
        }
        .overlay(alignment: .bottomTrailing) {
            Text("ILLUSTRATIVE CT-STYLE CROSS-SECTION")
            .font(.caption2.monospaced().weight(.bold))
            .tracking(0.7)
            .foregroundStyle(.white.opacity(0.72))
            .padding(14)
        }
    }
}

private struct MRITeachingSchematic: View {
    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width * 0.48, y: size.height * 0.50)
            let outer = CGRect(x: center.x - 112, y: center.y - 96, width: 224, height: 192)
            context.fill(Path(ellipseIn: outer), with: .color(.indigo.opacity(0.34)))
            context.stroke(Path(ellipseIn: outer), with: .color(.cyan.opacity(0.52)), lineWidth: 2)

            let hemispheres = [
                CGRect(x: center.x - 86, y: center.y - 70, width: 74, height: 140),
                CGRect(x: center.x + 12, y: center.y - 70, width: 74, height: 140)
            ]
            for hemisphere in hemispheres {
                context.fill(Path(ellipseIn: hemisphere), with: .color(.purple.opacity(0.28)))
                context.stroke(Path(ellipseIn: hemisphere), with: .color(.white.opacity(0.30)), lineWidth: 1)
            }
            let focus = CGRect(x: center.x + 14, y: center.y - 34, width: 48, height: 48)
            context.fill(Path(ellipseIn: focus), with: .color(.orange.opacity(0.64)))
            context.stroke(Path(ellipseIn: focus.insetBy(dx: -7, dy: -7)), with: .color(.orange.opacity(0.30)), lineWidth: 2)
        }
        .overlay(alignment: .bottomTrailing) {
            Text("ILLUSTRATIVE MRI-STYLE SOFT-TISSUE VIEW")
                .font(.caption2.monospaced().weight(.bold))
                .tracking(0.7)
                .foregroundStyle(.cyan.opacity(0.80))
                .padding(14)
        }
    }
}
