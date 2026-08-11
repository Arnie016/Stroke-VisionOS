import SwiftUI

/// A clinician-only upper evidence plane. Sources stay visually above the
/// anatomy and presenter rail so citations never compete with the patient's
/// shared explanation. This prototype stores no browsing history or patient
/// data and composes only from the fixed, reviewed-source catalog below.
struct StrokeEvidenceWorkspaceView: View {
    @EnvironmentObject private var experience: StrokeExperienceState
    @Environment(\.dismissWindow) private var dismissWindow
    @State private var query = ""

    var body: some View {
        HStack(spacing: 0) {
            sourceShelf
                .frame(width: 285)

            Divider()

            ScrollView {
                sourceDetail
            }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: 900, height: 480)
        .background(.regularMaterial)
        .onAppear {
            if CommandLine.arguments.contains("--proof-evidence") ||
                CommandLine.arguments.contains("--proof-evidence-window") {
                experience.prepareEvidenceProof()
            }
        }
    }

    private var sourceShelf: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Clinical evidence")
                        .font(.title.weight(.bold))
                    Text("Private source space")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button("Return", systemImage: "arrow.uturn.backward") {
                    returnToExplanation()
                }
                .buttonStyle(.borderedProminent)
                .tint(.cyan)
                .accessibilityLabel("Close evidence space")
                .accessibilityHint("Returns to the spatial explanation without changing the selected source")
            }

            TextField("Search sources", text: $query)
                .textFieldStyle(.roundedBorder)
                .accessibilityLabel("Search clinical evidence")

            VStack(spacing: 8) {
                ForEach(filteredSources) { source in
                    Button {
                        experience.selectEvidence(source)
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: source.kind.systemImage)
                                .foregroundStyle(experience.selectedEvidenceID == source.id ? .black : .cyan)
                            VStack(alignment: .leading, spacing: 3) {
                                Text(source.shortTitle)
                                    .font(.callout.weight(.semibold))
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(2)
                                Text(source.kind.rawValue)
                                    .font(.caption2)
                                    .foregroundStyle(experience.selectedEvidenceID == source.id ? .black.opacity(0.58) : .secondary)
                            }
                            Spacer(minLength: 4)
                            if experience.pinnedEvidenceIDs.contains(source.id) {
                                Image(systemName: "pin.fill")
                                    .font(.caption)
                                    .foregroundStyle(.orange)
                            }
                        }
                        .padding(10)
                        .frame(maxWidth: .infinity, minHeight: 62, alignment: .leading)
                        .foregroundStyle(experience.selectedEvidenceID == source.id ? Color.black.opacity(0.84) : .primary)
                        .background(
                            experience.selectedEvidenceID == source.id ? Color.cyan : Color.white.opacity(0.06),
                            in: RoundedRectangle(cornerRadius: 14)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }

            Spacer(minLength: 0)

            Label("Draft catalog · clinical review pending", systemImage: "exclamationmark.shield")
                .font(.caption2.weight(.medium))
                .foregroundStyle(.orange)

            Button("Return to anatomy", systemImage: "arrow.uturn.backward") {
                returnToExplanation()
            }
            .buttonStyle(.borderedProminent)
            .tint(.cyan)
            .frame(maxWidth: .infinity)
            .accessibilityHint("Closes this source space and returns to the spatial explanation")
        }
        .padding(18)
    }

    private var filteredSources: [StrokeEvidenceSource] {
        let needle = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !needle.isEmpty else { return StrokeEvidenceSource.library }
        return StrokeEvidenceSource.library.filter { source in
            source.shortTitle.localizedCaseInsensitiveContains(needle) ||
                source.fullCitation.localizedCaseInsensitiveContains(needle) ||
                source.kind.rawValue.localizedCaseInsensitiveContains(needle) ||
                source.id.localizedCaseInsensitiveContains(needle)
        }
    }

    private var sourceDetail: some View {
        let source = experience.selectedEvidence

        return VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 14) {
                Image(systemName: source.kind.systemImage)
                    .font(.title2)
                    .foregroundStyle(.cyan)
                    .frame(width: 42, height: 42)
                    .background(Color.cyan.opacity(0.10), in: RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 5) {
                    Text(source.shortTitle)
                        .font(.title3.weight(.semibold))
                    Text(source.fullCitation)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                Button("Return to anatomy", systemImage: "arrow.uturn.backward") {
                    returnToExplanation()
                }
                .buttonStyle(.bordered)
                .tint(.cyan)
                .accessibilityHint("Closes this source space and returns to the spatial explanation")
            }

            HStack(alignment: .top, spacing: 12) {
                evidenceMeaning("SUPPORTS", source.supports, tint: .cyan)
                evidenceMeaning("LIMIT", source.limitation, tint: .orange)
            }

            HStack(spacing: 10) {
                Link(destination: source.stableURL) {
                    Label("Open source", systemImage: "arrow.up.right.square")
                }
                .buttonStyle(.bordered)

                Button {
                    experience.togglePinnedEvidence(source)
                } label: {
                    Label(
                        experience.pinnedEvidenceIDs.contains(source.id) ? "Unpin" : "Pin in space",
                        systemImage: experience.pinnedEvidenceIDs.contains(source.id) ? "pin.slash" : "pin"
                    )
                }
                .buttonStyle(.borderedProminent)
                .tint(.cyan)
            }

            Divider()

            HStack(alignment: .center, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("PINNED SOURCES")
                        .font(.caption.weight(.bold))
                        .tracking(1.0)
                    Text(experience.pinnedEvidence.isEmpty ? "Pin a source to begin." : experience.pinnedEvidence.map(\.shortTitle).joined(separator: " · "))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                Spacer()
                Button("Compose draft", systemImage: "wand.and.stars") {
                    experience.composeSourceBoundDraft()
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
                .disabled(experience.pinnedEvidence.isEmpty)
            }

            if experience.sourceBoundDraftVisible {
                VStack(alignment: .leading, spacing: 7) {
                    Label("SOURCE-BOUND TEACHING DRAFT", systemImage: "doc.badge.gearshape")
                        .font(.caption.weight(.bold))
                        .tracking(1.0)
                        .foregroundStyle(.orange)
                    Text("Orient to the fixed space. Show what changed. Explain that making room may reduce pressure but does not restore injured tissue.")
                        .font(.body.weight(.medium))
                    Text("Built only from pinned catalog entries · not approved clinical copy")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .padding(14)
                .background(Color.orange.opacity(0.09), in: RoundedRectangle(cornerRadius: 16))
            } else {
                Spacer(minLength: 0)
            }
        }
        .padding(22)
    }

    private func evidenceMeaning(_ title: String, _ text: String, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption2.weight(.bold))
                .tracking(0.9)
                .foregroundStyle(tint)
            Text(text)
                .font(.callout)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, minHeight: 92, alignment: .topLeading)
        .background(tint.opacity(0.08), in: RoundedRectangle(cornerRadius: 14))
    }

    private func returnToExplanation() {
        // The selected source and pins remain available when the presenter
        // reopens evidence; only the temporary draft presentation is cleared.
        experience.sourceBoundDraftVisible = false
        dismissWindow(id: StrokeSpace.evidence)
    }
}
