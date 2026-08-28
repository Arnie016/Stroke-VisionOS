import SwiftUI

enum StrokeReferenceWorkspace: String, Identifiable {
    case imagingGallery = "Imaging gallery"
    case medications = "Medications"
    case guides = "Guides & sources"
    case settings = "Settings"
    var id: String { rawValue }
}

/// One centre-field destination. Returning never reopens a second window or
/// changes the selected teaching point, camera, case, or timeline checkpoint.
struct StrokeReferenceWorkspaceView: View {
    @EnvironmentObject private var experience: StrokeExperienceState

    var body: some View {
        if let workspace = experience.focusedReferenceWorkspace {
            VStack(alignment: .leading, spacing: 22) {
                HStack(spacing: 24) {
                    Button("Back", systemImage: "chevron.left") {
                        experience.closeReferenceWorkspace()
                    }
                    .buttonStyle(.bordered)
                    .frame(minHeight: 56)
                    .accessibilityLabel("Back to brain and timeline")
                    Text(workspace.rawValue).font(.largeTitle.weight(.semibold))
                    Spacer()
                    Text("STROKE CARE").font(.caption.weight(.bold)).tracking(2)
                        .foregroundStyle(.mint)
                }
                Divider().overlay(.white.opacity(0.12))
                switch workspace {
                case .imagingGallery: StrokeImagingGalleryView().environmentObject(experience)
                case .settings: settings
                case .guides: guides
                case .medications: medications
                }
            }
            .padding(30)
            .frame(width: workspace == .imagingGallery ? 1_140 : 1_000,
                   height: workspace == .imagingGallery ? 780 : (workspace == .medications ? 760 : 520),
                   alignment: .topLeading)
            .background(Color(white: 0.12), in: RoundedRectangle(cornerRadius: 30))
            .overlay(RoundedRectangle(cornerRadius: 30).stroke(.mint.opacity(0.25)))
            .foregroundStyle(.white)
            .preferredColorScheme(.dark)
        }
    }

    private var settings: some View {
        VStack(alignment: .leading, spacing: 25) {
            HStack {
                settingLabel("Visual detail", detail: "Choose how much anatomy and motion to show.")
                HStack(spacing: 6) {
                    ForEach(StrokeDetailLevel.allCases) { level in
                        settingChoice(level.visualDetailTitle, selected: experience.detailLevel == level) {
                            experience.selectDetailLevel(level)
                        }
                    }
                }.frame(width: 420)
            }
            HStack {
                settingLabel("Background", detail: "Choose the surrounding field.")
                HStack(spacing: 6) {
                    ForEach(StrokeEnvironmentMode.allCases) { mode in
                        settingChoice(mode.shortTitle, selected: experience.environmentMode == mode) {
                            experience.environmentMode = mode
                        }
                    }
                }.frame(width: 420)
            }
            HStack {
                settingLabel("Interface sound", detail: "Quiet feedback and background ambience.")
                Spacer()
                Toggle("Sound", isOn: $experience.soundEnabled).labelsHidden()
                    .tint(.mint)
                    .accessibilityLabel("Interface sound")
            }
            HStack(spacing: 30) {
                settingLabel("Explanation panel size", detail: "Resize the left-side conversation guide.")
                Slider(value: $experience.presenterPanelScale, in: 0.85...1.25, step: 0.05)
                    .tint(.mint).frame(width: 325)
                    .accessibilityLabel("Explanation panel size")
                Text("\(Int((experience.presenterPanelScale * 100).rounded()))%")
                    .font(.callout.monospacedDigit()).frame(width: 60)
            }
            Spacer(minLength: 0)
        }
    }

    private func settingLabel(_ title: String, detail: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.title3.weight(.semibold))
            Text(detail).font(.callout).foregroundStyle(.white.opacity(0.62))
        }.frame(maxWidth: .infinity, alignment: .leading)
    }

    private func settingChoice(_ title: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if selected { Image(systemName: "checkmark").font(.caption.weight(.bold)) }
                Text(title).font(.callout.weight(.semibold))
            }
            .frame(maxWidth: .infinity, minHeight: 56)
            .foregroundStyle(selected ? Color.mint : .white.opacity(0.82))
            .background(selected ? Color.mint.opacity(0.20) : .white.opacity(0.10),
                        in: RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain).hoverEffect(.highlight)
        .accessibilityAddTraits(selected ? [.isSelected] : [])
    }

    private var guides: some View {
        HStack(alignment: .top, spacing: 28) {
            VStack(spacing: 12) {
                ForEach(StrokeEvidenceSource.library) { source in
                    Button {
                        experience.selectEvidence(source)
                    } label: {
                        Text(source.shortTitle).font(.callout.weight(.semibold))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, minHeight: 64, alignment: .leading)
                            .padding(.horizontal, 14)
                            .background(experience.selectedEvidenceID == source.id
                                ? Color.mint.opacity(0.22) : Color.white.opacity(0.07),
                                in: RoundedRectangle(cornerRadius: 14))
                    }.buttonStyle(.plain).hoverEffect(.highlight)
                }
            }.frame(width: 270)
            VStack(alignment: .leading, spacing: 16) {
                Text(experience.selectedEvidence.shortTitle).font(.title2.weight(.semibold))
                Text(experience.selectedEvidence.fullCitation)
                    .font(.callout).foregroundStyle(.white.opacity(0.66))
                Text("What it supports").font(.caption.weight(.bold)).foregroundStyle(.mint)
                Text(experience.selectedEvidence.supports).font(.body)
                Text(experience.selectedEvidence.limitation)
                    .font(.callout).foregroundStyle(.white.opacity(0.62))
                Link(destination: experience.selectedEvidence.stableURL) {
                    Label("Read source", systemImage: "arrow.up.right.square")
                        .frame(minHeight: 48)
                }.buttonStyle(.borderedProminent).tint(.mint)
                Spacer(minLength: 0)
            }.frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var medications: some View {
        let topic = StrokeMedicineTopic.library.first(where: { $0.id == experience.selectedMedicineID })
            ?? StrokeMedicineTopic.library[0]
        return VStack(alignment: .leading, spacing: 18) {
            Text("Select an exhibit. Pinch-drag to turn it.")
                .font(.callout).foregroundStyle(.white.opacity(0.65))
            // The four RealityKit objects occupy this real depth interval in
            // front of the attachment. This is not an image or embedded video.
            Spacer().frame(height: 210)
            HStack(spacing: 12) {
                ForEach(StrokeMedicineTopic.library) { item in
                    Button {
                        experience.selectSpatialMedicine(item.id)
                    } label: {
                        Label(item.title, systemImage: item.symbol)
                            .font(.callout.weight(.semibold))
                            .frame(maxWidth: .infinity, minHeight: 56)
                            .padding(.horizontal, 8)
                            .background(topic.id == item.id ? Color.mint.opacity(0.22) : .white.opacity(0.07),
                                        in: RoundedRectangle(cornerRadius: 14))
                    }.buttonStyle(.plain).hoverEffect(.highlight)
                }
            }
            HStack(alignment: .top, spacing: 30) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(topic.title).font(.title2.weight(.semibold))
                    Text(topic.explanation).font(.body)
                    Text(topic.caution).font(.callout).foregroundStyle(.orange.opacity(0.9))
                }.frame(maxWidth: .infinity, alignment: .leading)
                VStack(alignment: .leading, spacing: 10) {
                    Text("DELIVERY & CONTEXT").font(.caption.weight(.bold)).foregroundStyle(.mint)
                    Text(topic.delivery).font(.body)
                    Text("Hospital stock and local formulary are not connected.")
                        .font(.caption).foregroundStyle(.white.opacity(0.6))
                }.frame(width: 285, alignment: .leading)
            }
            HStack(spacing: 12) {
                Button("Turn", systemImage: "rotate.3d") { experience.rotateSpatialMedicine(by: .pi / 4) }
                    .buttonStyle(.bordered)
                Button("Reset", systemImage: "arrow.counterclockwise") { experience.resetSpatialMedicine() }
                    .buttonStyle(.bordered)
                Spacer()
                Link(destination: topic.source) {
                    Label("NHS medicine reference", systemImage: "arrow.up.right.square")
                        .frame(minHeight: 48)
                }.buttonStyle(.borderedProminent).tint(.mint)
            }
            Text("Generic teaching props · no dose or prescribing · not actual medicine packaging")
                .font(.caption).foregroundStyle(.white.opacity(0.60))
        }
    }
}

/// Primary-source educational copy checked 26 August 2026. This catalog is
/// independent of the fictional case and never chooses a medicine for it.
struct StrokeMedicineTopic: Identifiable {
    let id: String
    let title: String
    let symbol: String
    let explanation: String
    let caution: String
    let source: URL

    var delivery: String {
        switch id {
        case "antiplatelets": "Clopidogrel is taken as a tablet."
        case "anticoagulants": "Tablets or injections, depending on the medicine."
        case "thrombolysis": "Intravenous medicine given by a specialist team."
        default: "Prescribed for longer-term care, with regular review."
        }
    }

    static let library: [Self] = [
        .init(id: "antiplatelets", title: "Antiplatelets", symbol: "pills",
              explanation: "Medicines such as clopidogrel reduce platelets sticking together to form clots.",
              caution: "Bleeding risk matters. These are not the same as anticoagulants.",
              source: URL(string: "https://www.nhs.uk/medicines/clopidogrel/about-clopidogrel/")!),
        .init(id: "anticoagulants", title: "Anticoagulants", symbol: "drop",
              explanation: "These medicines interrupt clot formation. The phrase ‘blood thinner’ does not mean the blood becomes physically thinner.",
              caution: "They can increase bleeding. A clinician decides if they are appropriate.",
              source: URL(string: "https://www.nhs.uk/medicines/anticoagulants/")!),
        .init(id: "thrombolysis", title: "Clot-dissolving medicine", symbol: "ivfluid.bag",
              explanation: "Thrombolysis uses medicine to dissolve a clot. It is different from removing a clot with an instrument.",
              caution: "Treatment depends on the stroke type and clinical assessment. This app does not assess suitability.",
              source: URL(string: "https://www.nhs.uk/conditions/stroke/treatment/")!),
        .init(id: "prevention", title: "Long-term prevention", symbol: "heart.text.clipboard",
              explanation: "Blood-pressure medicines and statins may be part of longer-term stroke care.",
              caution: "There is no universal medicine plan for every stroke.",
              source: URL(string: "https://www.nhs.uk/conditions/stroke/treatment/")!)
    ]
}

struct StrokePresenterConversationTopics: View {
    @EnvironmentObject private var experience: StrokeExperienceState
    @State private var expandedTerm: String?

    private var topics: [(term: String, meaning: String)] {
        switch experience.pointField {
        case .regions:
            return [
                ("Cortex", "The folded outer part helps us sense, think, and move. Different regions work together."),
                ("Cerebellum", "This region helps coordinate movement and balance."),
                ("Brainstem", "This connection with the spinal cord supports vital functions, including breathing."),
                ("Anatomy and imaging", "This model shows the general arrangement. A person's own scan can look different.")
            ]
        case .procedure:
            return [
                ("Artery", "This vessel brings blood to brain tissue. The moving lights show direction, not a measured flow rate."),
                ("Occlusion", "Occlusion means a blockage. Here it interrupts one example blood-supply route."),
                ("Injury", "A blockage and an injury are not the same thing. This model cannot measure how much tissue is injured."),
                ("Swelling", "Swelling takes up space. This is separate from the clot and needs its own explanation.")
            ]
        case .craniotomy:
            if experience.presenterTeachingBeat == .teamChecks {
                return [
                    ("Imaging", "Scans help the clinical team examine the person's situation. The pictures here are teaching examples."),
                    ("Monitoring", "The team follows the person's condition over time. This model is not a monitor."),
                    ("Pressure", "This view explains limited space, but it does not measure pressure."),
                    ("Questions", "Which part would you like me to explain again before we continue?")
                ]
            }
            return [
                ("Skull and bone flap", "The skull is the hard outer protection. A bone flap is the section temporarily removed in a craniotomy."),
                ("Dura", "The dura is a protective covering between the skull and brain."),
                ("Craniotomy or craniectomy?", "In a craniotomy the bone flap is replaced. In a craniectomy it may remain off and be replaced later."),
                ("Making space", "Separating these model layers helps explain the space around the brain. Reset puts the model back, not a surgical plan.")
            ]
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                topicButton("Anatomy", field: .regions)
                topicButton("Flow", field: .procedure)
                topicButton("Access", field: .craniotomy)
            }
            ForEach(Array(topics.enumerated()), id: \.element.term) { index, topic in
                let expanded = expandedTerm == topic.term
                Button {
                    expandedTerm = expanded ? nil : topic.term
                } label: {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(topic.term).font(.title3.weight(.semibold))
                                .foregroundStyle(index == 1 ? Color.orange : Color.mint)
                            Spacer(minLength: 10)
                            Image(systemName: expanded ? "chevron.up" : "text.bubble")
                                .font(.callout).foregroundStyle(.white.opacity(0.6))
                        }
                        if expanded {
                            Text(topic.meaning).font(.body).foregroundStyle(.white.opacity(0.88))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, minHeight: 54, alignment: .leading)
                    .background(.white.opacity(expanded ? 0.09 : 0.035), in: RoundedRectangle(cornerRadius: 12))
                }.buttonStyle(.plain).hoverEffect(.highlight)
                    .accessibilityHint("Show a plain-language explanation")
            }
        }
        .onAppear { if expandedTerm == nil { expandedTerm = topics.first?.term } }
        .onChange(of: experience.pointField) { _, _ in expandedTerm = topics.first?.term }
        .onChange(of: experience.presenterTeachingBeat) { _, _ in expandedTerm = topics.first?.term }
    }

    private func topicButton(_ title: String, field: StrokePointField) -> some View {
        Button(title) {
            expandedTerm = nil
            experience.selectLessonFamily(field)
        }
        .buttonStyle(.bordered)
        .tint(experience.pointField == field ? .mint : .gray)
        .frame(maxWidth: .infinity, minHeight: 48)
    }
}
