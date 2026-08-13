import SwiftUI

/// A local-only handoff for preparing a generic teaching-model print request.
/// It deliberately does not upload an asset, calculate a price, or place an order.
struct StrokeTeachingModelPrintRequestView: View {
    @Environment(\.dismissWindow) private var dismissWindow

    let closeWindowID: String

    @State private var selectedModel: TeachingPrintModel = .brainAndArteries
    @State private var selectedSize: TeachingPrintSize = .desk
    @State private var selectedPurpose: TeachingPrintPurpose = .familyEducation
    @State private var preparedRequest: PreparedTeachingPrintRequest?

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.055, green: 0.075, blue: 0.105),
                    Color(red: 0.075, green: 0.055, blue: 0.075)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    header
                    modelPicker

                    HStack(alignment: .top, spacing: 18) {
                        configurationCard
                        reviewCard
                    }

                    if let preparedRequest {
                        preparedSummary(preparedRequest)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
                .padding(30)
            }
        }
        .animation(.snappy(duration: 0.35), value: preparedRequest)
        .accessibilityElement(children: .contain)
    }

    private var header: some View {
        HStack(alignment: .top, spacing: 18) {
            Image(systemName: "cube.transparent")
                .font(.system(size: 30, weight: .medium))
                .foregroundStyle(.mint)
                .frame(width: 58, height: 58)
                .background(.mint.opacity(0.12), in: RoundedRectangle(cornerRadius: 17))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 7) {
                Text("Prepare a teaching model")
                    .font(.largeTitle.weight(.semibold))
                Text("Create a review-ready request from generic education assets already catalogued in Stroke Care.")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button {
                dismissWindow(id: closeWindowID)
            } label: {
                Label("Close", systemImage: "xmark")
            }
            .buttonStyle(.bordered)
            .accessibilityHint("Closes the teaching model request window")
        }
    }

    private var modelPicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Choose a generic model")
                .font(.headline)

            HStack(spacing: 14) {
                ForEach(TeachingPrintModel.allCases) { model in
                    Button {
                        selectedModel = model
                        preparedRequest = nil
                    } label: {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: model.symbol)
                                    .font(.title2)
                                    .foregroundStyle(model == selectedModel ? .black : .mint)
                                Spacer()
                                if model == selectedModel {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.black.opacity(0.72))
                                }
                            }

                            Text(model.title)
                                .font(.headline)
                            Text(model.subtitle)
                                .font(.subheadline)
                                .foregroundStyle(model == selectedModel ? .black.opacity(0.72) : .secondary)
                                .multilineTextAlignment(.leading)
                        }
                        .frame(maxWidth: .infinity, minHeight: 112, alignment: .topLeading)
                        .padding(17)
                        .background(
                            model == selectedModel ? AnyShapeStyle(Color.mint) : AnyShapeStyle(.ultraThinMaterial),
                            in: RoundedRectangle(cornerRadius: 20)
                        )
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(model == selectedModel ? Color.white.opacity(0.42) : Color.white.opacity(0.13))
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(model.title)
                    .accessibilityValue(model == selectedModel ? "Selected" : "Not selected")
                    .accessibilityHint(model.subtitle)
                }
            }
        }
    }

    private var configurationCard: some View {
        VStack(alignment: .leading, spacing: 17) {
            Label("Request details", systemImage: "slider.horizontal.3")
                .font(.headline)

            Picker("Target size", selection: $selectedSize) {
                ForEach(TeachingPrintSize.allCases) { size in
                    Text(size.title).tag(size)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: selectedSize) { _, _ in preparedRequest = nil }

            Picker("Teaching purpose", selection: $selectedPurpose) {
                ForEach(TeachingPrintPurpose.allCases) { purpose in
                    Text(purpose.title).tag(purpose)
                }
            }
            .onChange(of: selectedPurpose) { _, _ in preparedRequest = nil }

            Text(selectedPurpose.explanation)
                .font(.callout)
                .foregroundStyle(.secondary)

            Button {
                preparedRequest = PreparedTeachingPrintRequest(
                    model: selectedModel,
                    size: selectedSize,
                    purpose: selectedPurpose
                )
            } label: {
                Label("Prepare print request", systemImage: "doc.badge.gearshape")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.mint)
            .foregroundStyle(.black)
            .controlSize(.large)
            .accessibilityHint("Creates a local review summary; it does not place an order")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22))
    }

    private var reviewCard: some View {
        VStack(alignment: .leading, spacing: 15) {
            Label("Asset readiness", systemImage: "checklist")
                .font(.headline)

            ForEach(selectedModel.assetIDs, id: \.self) { assetID in
                if let record = StrokeAssetCatalog.record(id: assetID) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(readableAssetName(assetID))
                            .font(.subheadline.weight(.semibold))
                        Text("\(record.frameDomain.rawValue) · \(record.bundleStatus.rawValue)")
                            .font(.caption.monospaced())
                            .foregroundStyle(.secondary)
                        Text(record.reviewGate.rawValue.replacingOccurrences(of: "_", with: " ").capitalized)
                            .font(.caption2.weight(.medium))
                            .foregroundStyle(.orange)
                    }
                    .accessibilityElement(children: .combine)
                }
            }

            Divider()

            Label("Generic teaching anatomy only", systemImage: "person.crop.circle.badge.checkmark")
                .font(.callout.weight(.semibold))
            Text("No patient scans, identifiers, treatment planning, or device claims are included.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22))
    }

    private func preparedSummary(_ request: PreparedTeachingPrintRequest) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                Label("Local review summary ready", systemImage: "checkmark.seal.fill")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.mint)
                Spacer()
                Text("NOT AN ORDER")
                    .font(.caption2.weight(.bold))
                    .tracking(1.2)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.orange.opacity(0.16), in: Capsule())
                    .foregroundStyle(.orange)
            }

            Text("\(request.model.title) · \(request.size.reviewLabel) · \(request.purpose.title)")
                .font(.headline)

            Text("Before any export or fabrication, a human must confirm asset licensing, anatomical suitability, mesh integrity, printability, materials, and intended educational use. Shipping and manufacturing are not connected in this prototype.")
                .font(.callout)
                .foregroundStyle(.secondary)

            HStack {
                Label("\(request.model.assetIDs.count) catalogued asset\(request.model.assetIDs.count == 1 ? "" : "s")", systemImage: "cube")
                Spacer()
                Label("Review required", systemImage: "person.badge.shield.checkmark")
            }
            .font(.caption.weight(.semibold))
        }
        .padding(20)
        .background(Color.mint.opacity(0.09), in: RoundedRectangle(cornerRadius: 22))
        .overlay {
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.mint.opacity(0.28))
        }
        .accessibilityElement(children: .combine)
    }

    private func readableAssetName(_ id: String) -> String {
        id
            .replacingOccurrences(of: "_realistic_v2", with: "")
            .replacingOccurrences(of: "_conceptual_v2", with: "")
            .replacingOccurrences(of: "_", with: " ")
            .capitalized
    }
}

private enum TeachingPrintModel: String, CaseIterable, Identifiable {
    case brainAndArteries
    case arterialTree
    case layeredHead

    var id: String { rawValue }

    var title: String {
        switch self {
        case .brainAndArteries: "Brain + arteries"
        case .arterialTree: "Cerebral arteries"
        case .layeredHead: "Layered head study"
        }
    }

    var subtitle: String {
        switch self {
        case .brainAndArteries: "A whole-system orientation model"
        case .arterialTree: "A focused vessel-pathway reference"
        case .layeredHead: "Skull, dura, and brain as separate layers"
        }
    }

    var symbol: String {
        switch self {
        case .brainAndArteries: "brain.head.profile"
        case .arterialTree: "arrow.triangle.branch"
        case .layeredHead: "square.3.layers.3d"
        }
    }

    var assetIDs: [String] {
        switch self {
        case .brainAndArteries:
            ["brain_anatomy_realistic_v2", "cerebral_arteries_realistic_v2"]
        case .arterialTree:
            ["cerebral_arteries_realistic_v2"]
        case .layeredHead:
            ["skull_semantic_realistic_v2", "dura_mater_cutaway_conceptual_v2", "brain_anatomy_realistic_v2"]
        }
    }
}

private enum TeachingPrintSize: String, CaseIterable, Identifiable {
    case tabletop
    case desk
    case study

    var id: String { rawValue }

    var title: String {
        switch self {
        case .tabletop: "15 cm"
        case .desk: "25 cm"
        case .study: "40 cm"
        }
    }

    var reviewLabel: String { "Target longest edge \(title)" }
}

private enum TeachingPrintPurpose: String, CaseIterable, Identifiable {
    case familyEducation
    case clinicianTeaching
    case classroom

    var id: String { rawValue }

    var title: String {
        switch self {
        case .familyEducation: "Family education"
        case .clinicianTeaching: "Clinician teaching"
        case .classroom: "Classroom exhibit"
        }
    }

    var explanation: String {
        switch self {
        case .familyEducation: "A calm, non-patient-specific model for guided conversation."
        case .clinicianTeaching: "A generic anatomical reference for reviewed education sessions."
        case .classroom: "A durable exhibit concept for supervised anatomy learning."
        }
    }
}

private struct PreparedTeachingPrintRequest: Equatable {
    let model: TeachingPrintModel
    let size: TeachingPrintSize
    let purpose: TeachingPrintPurpose
}
