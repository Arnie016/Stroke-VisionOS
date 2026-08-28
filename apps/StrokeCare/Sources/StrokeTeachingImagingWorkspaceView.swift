import Foundation
import SwiftUI

enum StrokeTeachingImageReference: String, CaseIterable, Identifiable {
    case vesselMap = "Vessel map"
    case ctGuide = "CT (X-ray)"
    case ctaGuide = "CT angiography"
    case mriGuide = "MRI"
    case mraGuide = "MR angiography"
    case petOverview = "PET overview"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .vesselMap: "Vessel map"
        case .ctGuide: "CT: an X-ray-based cross-section"
        case .ctaGuide: "CTA: a CT-based vessel overview"
        case .mriGuide: "MRI: a soft-tissue template"
        case .mraGuide: "MRA: an MR-based vessel overview"
        case .petOverview: "PET: a functional imaging overview"
        }
    }

    var technicalTerm: String {
        switch self {
        case .vesselMap: "vascular route"
        case .ctGuide: "computed tomography (CT)"
        case .ctaGuide: "CT angiography (CTA)"
        case .mriGuide: "magnetic resonance imaging (MRI)"
        case .mraGuide: "MR angiography (MRA)"
        case .petOverview: "positron emission tomography (PET)"
        }
    }

    var plainLanguage: String {
        switch self {
        case .vesselMap:
            "A simplified route map of larger blood vessels. It gives conversation context, not a measurement or an image finding."
        case .ctGuide:
            "CT uses X-rays to make cross-sectional pictures. This plate is a de-identified atlas example, not this case's scan."
        case .ctaGuide:
            "CTA is a CT-based way to show blood vessels. Here it is a generic vessel reference, not a study recommendation or result."
        case .mriGuide:
            "MRI uses a magnetic field and radio waves to make cross-sectional pictures. This plate is a de-identified atlas example."
        case .mraGuide:
            "MRA uses MRI techniques to show blood vessels. Here it is a generic vessel reference, not a study recommendation or result."
        case .petOverview:
            "PET uses radiotracers to create images of functional molecular processes. This is a generic teaching concept, not a patient study or care choice."
        }
    }

    var sourceLabel: String {
        switch self {
        case .vesselMap:
            "Authored generic vascular teaching diagram"
        case .ctGuide, .mriGuide:
            "Kaffenberger et al. 2022 · CC BY 4.0 research atlas"
        case .ctaGuide, .mraGuide:
            "ACR Appropriateness Criteria · cerebrovascular diseases"
        case .petOverview:
            "NIH NIBIB · nuclear medicine overview"
        }
    }

    /// Make the provenance legible before a presenter leaves the teaching
    /// space. A guideline, a research atlas, and a public-science explainer
    /// are useful in different ways; none is a patient result or a care rule.
    var sourceKind: String {
        switch self {
        case .vesselMap:
            "AUTHORED TEACHING DIAGRAM"
        case .ctGuide, .mriGuide:
            "OPEN RESEARCH ATLAS"
        case .ctaGuide, .mraGuide:
            "GUIDELINE CONTEXT"
        case .petOverview:
            "PUBLIC SCIENCE OVERVIEW"
        }
    }

    var sourceActionTitle: String? {
        switch self {
        case .vesselMap:
            nil
        case .ctGuide, .mriGuide:
            "Read open research atlas"
        case .ctaGuide, .mraGuide:
            "Read guideline context"
        case .petOverview:
            "Read science overview"
        }
    }

    var sourceURL: URL? {
        switch self {
        case .vesselMap:
            nil
        case .ctGuide, .mriGuide:
            URL(string: "https://pmc.ncbi.nlm.nih.gov/articles/PMC9271109/")
        case .ctaGuide, .mraGuide:
            URL(string: "https://acsearch.acr.org/docs/3149012/Narrative/")
        case .petOverview:
            URL(string: "https://www.nibib.nih.gov/science-education/science-topics/nuclear-medicine")
        }
    }

    var systemImage: String {
        switch self {
        case .vesselMap: "point.3.connected.trianglepath.dotted"
        case .ctGuide: "circle.grid.cross"
        case .ctaGuide: "point.3.connected.trianglepath.dotted"
        case .mriGuide: "waveform.path.ecg.rectangle"
        case .mraGuide: "waveform.path.ecg.rectangle"
        case .petOverview: "atom"
        }
    }

    /// Short categories keep the in-space study deck legible without turning
    /// it into a dense reading panel. They describe the teaching reference,
    /// never what a particular person's image shows.
    var deckCategory: String {
        switch self {
        case .vesselMap:
            "ROUTE"
        case .ctGuide, .mriGuide:
            "STRUCTURE"
        case .ctaGuide, .mraGuide:
            "VESSELS"
        case .petOverview:
            "FUNCTION"
        }
    }

    var deckSummary: String {
        switch self {
        case .vesselMap:
            "Illustrative vessel routes"
        case .ctGuide:
            "X-ray cross-section"
        case .ctaGuide:
            "CT vessel overview"
        case .mriGuide:
            "Soft-tissue template"
        case .mraGuide:
            "MR vessel overview"
        case .petOverview:
            "Functional-imaging concept"
        }
    }

    var hasBundledAtlasImage: Bool {
        self == .ctGuide || self == .mriGuide
    }
}

/// The study deck has only three visual jobs: show structural context, trace
/// vessel routes, or introduce a separate functional-imaging concept. Grouping
/// the generic references this way prevents a flat modality list from looking
/// like a clinical worklist or a set of care choices.
enum StrokeTeachingImageDeckSection: CaseIterable, Identifiable {
    case structure
    case vessels
    case functional

    var id: String { title }

    var title: String {
        switch self {
        case .structure: "STRUCTURE"
        case .vessels: "VESSEL ROUTES"
        case .functional: "FUNCTIONAL OVERVIEW"
        }
    }

    var summary: String {
        switch self {
        case .structure: "Cross-sections of generic anatomy"
        case .vessels: "Route and vessel-focused references"
        case .functional: "A separate non-diagnostic concept"
        }
    }

    var references: [StrokeTeachingImageReference] {
        switch self {
        case .structure: [.ctGuide, .mriGuide]
        case .vessels: [.vesselMap, .ctaGuide, .mraGuide]
        case .functional: [.petOverview]
        }
    }
}

/// A small, anatomy-attached source note. The visible technical term is the
/// target: a presenter can pinch it to reveal plainer language and, when a
/// verified source exists, deliberately open that source. No source is treated
/// as a patient-specific finding or as a treatment-selection rule.
struct StrokeTeachingImagingReferenceDetails: View {
    let reference: StrokeTeachingImageReference
    /// The in-space plate supplies this only while a presenter is deliberately
    /// reading a term. Keeping the local return inside the note avoids making
    /// them search the wider study surface for an exit.
    var onReturnToStudy: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("TERM NOTE")
                .font(.caption2.weight(.black))
                .tracking(0.95)
                .foregroundStyle(.cyan)

            Text(reference.technicalTerm)
                .font(.caption.weight(.black))
                .foregroundStyle(.white)

            Text(reference.plainLanguage)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.white.opacity(0.82))
                .fixedSize(horizontal: false, vertical: true)

            Text(reference.sourceKind)
                .font(.caption2.monospaced().weight(.black))
                .foregroundStyle(.cyan.opacity(0.82))

            if let sourceURL = reference.sourceURL,
               let sourceActionTitle = reference.sourceActionTitle {
                Link(destination: sourceURL) {
                    Label(sourceActionTitle, systemImage: "arrow.up.right.square")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.cyan)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .accessibilityHint("Opens the named external source after a deliberate pinch")

                Text(reference.sourceLabel)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.58))
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                Text(reference.sourceLabel)
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.white.opacity(0.58))
            }

            Text("Generic teaching reference · not a patient scan, result, or care recommendation")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.orange.opacity(0.86))
                .fixedSize(horizontal: false, vertical: true)

            if let onReturnToStudy {
                Button(action: onReturnToStudy) {
                    Label("Back to study", systemImage: "chevron.backward")
                        .font(.caption.weight(.bold))
                        .frame(maxWidth: .infinity, minHeight: 44)
                }
                .buttonStyle(.bordered)
                .tint(.orange)
                .accessibilityLabel("Back to study")
                .accessibilityHint("Closes this term note and restores the selected teaching study")
            }
        }
        .padding(11)
        .background(.black.opacity(0.88), in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.cyan.opacity(0.32)))
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Term note for \(reference.technicalTerm)")
    }
}

/// A moveable, deliberately generic 2D companion to the right-side 3D
/// reference. It offers visual language for the CT/MRI/CTA images that may be
/// discussed in a stroke conversation; it is never a patient image or result.
/// Standard visionOS window placement lets the clinician put it wherever it
/// best supports the conversation.
struct StrokeTeachingImagingWorkspaceView: View {
    @EnvironmentObject private var experience: StrokeExperienceState
    @Environment(\.dismissWindow) private var dismissWindow
    @State private var reference: StrokeTeachingImageReference
    @State private var referenceDetailsVisible = false

    init() {
        if CommandLine.arguments.contains("--proof-imaging-window-term-note") {
            _reference = State(initialValue: .ctaGuide)
            _referenceDetailsVisible = State(initialValue: true)
        } else if CommandLine.arguments.contains("--proof-imaging-mri") {
            _reference = State(initialValue: .mriGuide)
        } else if CommandLine.arguments.contains("--proof-imaging-ct") {
            _reference = State(initialValue: .ctGuide)
        } else {
            _reference = State(initialValue: .vesselMap)
        }
    }

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
                Button("Back", systemImage: "chevron.backward", action: returnToAnatomy)
                .buttonStyle(.bordered)
                .accessibilityLabel("Back to anatomy")
                .accessibilityHint("Closes this optional teaching reference and returns to the anatomy explanation")
            }

            HStack(spacing: 10) {
                if !referenceDetailsVisible {
                    Menu {
                        ForEach(StrokeTeachingImageReference.allCases) { item in
                            Button {
                                reference = item
                                referenceDetailsVisible = false
                            } label: {
                                Label(item.rawValue, systemImage: item.systemImage)
                            }
                        }
                    } label: {
                        Label(reference.rawValue, systemImage: reference.systemImage)
                            .font(.callout.weight(.bold))
                            .frame(minHeight: 44)
                    }
                    .buttonStyle(.bordered)
                    .tint(.cyan)
                    .accessibilityLabel("Teaching study, \(reference.rawValue)")
                    .accessibilityHint("Pinch to choose CT, CTA, MRI, MRA, PET, or a vessel map")

                    Button {
                        referenceDetailsVisible = true
                    } label: {
                        Label(reference.technicalTerm, systemImage: "text.magnifyingglass")
                            .font(.caption.weight(.bold))
                            .lineLimit(1)
                    }
                    .buttonStyle(.bordered)
                    .tint(.gray)
                    .accessibilityHint("Pinch to show a plain-language annotation and source")
                } else {
                    Label("SOURCE NOTE", systemImage: "doc.text.magnifyingglass")
                        .font(.caption.weight(.black))
                        .tracking(0.9)
                        .foregroundStyle(.orange)

                    Text("Back to study is below")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 0)
            }

            if referenceDetailsVisible {
                StrokeTeachingImagingReferenceDetails(
                    reference: reference,
                    onReturnToStudy: {
                        closeTermNote()
                    }
                )
            }

            teachingGraphic
                .frame(maxWidth: .infinity, minHeight: 248)
                .background(.black.opacity(0.80), in: RoundedRectangle(cornerRadius: 24))
                .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.cyan.opacity(0.28)))

            VStack(alignment: .leading, spacing: 3) {
                Text(pointCaption)
                    .font(.callout.weight(.semibold))
                Text("Open research atlas · generic teaching reference · not a patient scan or result · does not diagnose or recommend care")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(22)
        // The source note is a deliberate second reading layer. Let the
        // optional window expand for it instead of compressing the image or
        // hiding the named source below the fold.
        .frame(width: 600, height: referenceDetailsVisible ? 620 : 470)
        .background(.regularMaterial)
        .accessibilityElement(children: .contain)
    }

    private func closeTermNote() {
        withAnimation(.easeInOut(duration: 0.20)) {
            referenceDetailsVisible = false
        }
    }

    private func returnToAnatomy() {
        // The window can be reopened without inheriting a hidden source-note
        // state. The spatial plate owns the shared anatomy return; this local
        // view only clears its own nested reading state first.
        referenceDetailsVisible = false
        experience.returnToAnatomyFromSpatialImaging()
        dismissWindow(id: StrokeSpace.imaging)
    }

    @ViewBuilder
    private var teachingGraphic: some View {
        switch reference {
        case .vesselMap:
            VesselMapSchematic()
        case .ctGuide:
            CTTeachingSchematic()
        case .ctaGuide:
            CTATeachingSchematic()
        case .mriGuide:
            MRITeachingSchematic()
        case .mraGuide:
            MRATeachingSchematic()
        case .petOverview:
            PETTeachingSchematic()
        }
    }

    private var pointCaption: String {
        if let label = experience.selectedPointLabel {
            return "Linked from: \(label)"
        }
        return "Select an anatomy point to link this reference."
    }
}

struct VesselMapSchematic: View {
    var tint: Color = .cyan
    var label: String = "QUALITATIVE VASCULAR MAP"

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
                context.stroke(path, with: .color(tint.opacity(0.82)), style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
            }
            let focus = CGRect(x: 263, y: 132, width: 34, height: 34)
            context.fill(Path(ellipseIn: focus), with: .color(.orange.opacity(0.92)))
            context.stroke(Path(ellipseIn: focus.insetBy(dx: -7, dy: -7)), with: .color(.orange.opacity(0.42)), lineWidth: 2)
        }
        .overlay(alignment: .bottomTrailing) {
            Text(label)
                .font(.caption2.monospaced().weight(.bold))
                .tracking(0.7)
                .foregroundStyle(tint.opacity(0.80))
                .padding(14)
        }
    }
}

struct CTTeachingSchematic: View {
    var body: some View {
        StrokeAtlasTeachingImage(
            assetName: "StrokeCTTemplate",
            modalityLabel: "X-RAY-BASED CT TEMPLATE"
        )
    }
}

struct MRITeachingSchematic: View {
    var body: some View {
        StrokeAtlasTeachingImage(
            assetName: "StrokeMRITemplate",
            modalityLabel: "MRI TEMPLATE"
        )
    }
}

struct CTATeachingSchematic: View {
    var body: some View {
        VesselMapSchematic(
            tint: .orange,
            label: "CTA · GENERIC VASCULAR OVERVIEW"
        )
    }
}

struct MRATeachingSchematic: View {
    var body: some View {
        VesselMapSchematic(
            tint: .mint,
            label: "MRA · GENERIC VASCULAR OVERVIEW"
        )
    }
}

struct PETTeachingSchematic: View {
    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width * 0.50, y: size.height * 0.52)
            let outer = CGRect(x: center.x - 98, y: center.y - 98, width: 196, height: 196)
            let inner = outer.insetBy(dx: 24, dy: 24)
            context.fill(Path(ellipseIn: outer), with: .color(.purple.opacity(0.18)))
            context.stroke(Path(ellipseIn: outer), with: .color(.white.opacity(0.24)), lineWidth: 2)
            context.fill(Path(ellipseIn: inner), with: .color(.indigo.opacity(0.28)))

            let spots = [
                CGPoint(x: center.x - 42, y: center.y - 24),
                CGPoint(x: center.x + 34, y: center.y - 36),
                CGPoint(x: center.x - 8, y: center.y + 38),
                CGPoint(x: center.x + 48, y: center.y + 24)
            ]
            for (index, point) in spots.enumerated() {
                let radius = CGFloat(10 + index * 3)
                let spot = CGRect(x: point.x - radius, y: point.y - radius, width: radius * 2, height: radius * 2)
                context.fill(Path(ellipseIn: spot), with: .color(.orange.opacity(0.76)))
                context.stroke(Path(ellipseIn: spot.insetBy(dx: -5, dy: -5)), with: .color(.orange.opacity(0.30)), lineWidth: 2)
            }
        }
        .overlay(alignment: .bottomTrailing) {
            Text("PET · FUNCTIONAL TEACHING OVERVIEW")
                .font(.caption2.monospaced().weight(.bold))
                .tracking(0.65)
                .foregroundStyle(.purple.opacity(0.88))
                .padding(14)
        }
        .accessibilityLabel("Generic PET functional-imaging overview, not a patient scan or result")
    }
}

/// An openly licensed, de-identified atlas image—not a generated stand-in.
/// The source boundary remains visible wherever the image is reused so a
/// clinician cannot mistake the teaching plate for case imaging.
private struct StrokeAtlasTeachingImage: View {
    let assetName: String
    let modalityLabel: String

    var body: some View {
        ZStack {
            Color.black
            Image(assetName)
                .resizable()
                .interpolation(.high)
                .scaledToFit()
                .padding(.vertical, 7)
        }
        .overlay(alignment: .topLeading) {
            Text(modalityLabel)
                .font(.caption2.monospaced().weight(.black))
                .tracking(0.7)
                .foregroundStyle(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(.black.opacity(0.72), in: Capsule())
                .padding(10)
        }
        .overlay(alignment: .bottomTrailing) {
            Text("Kaffenberger et al. · CC BY 4.0")
                .font(.caption2.monospaced().weight(.semibold))
                .foregroundStyle(.white.opacity(0.78))
                .padding(.horizontal, 9)
                .padding(.vertical, 6)
                .background(.black.opacity(0.70), in: Capsule())
                .padding(10)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(modalityLabel), generic de-identified research atlas image, not a patient scan")
    }
}
