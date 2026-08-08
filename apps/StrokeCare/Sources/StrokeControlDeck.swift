import SwiftUI

struct StrokeControlDeck: View {
    @EnvironmentObject private var experience: StrokeExperienceState
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    @State private var immersiveOpen = false
    @State private var handledLaunch = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.035, green: 0.05, blue: 0.065),
                    Color(red: 0.018, green: 0.022, blue: 0.032)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 16) {
                header
                stepRail
                intentCue
                activeStep
                    .frame(maxWidth: 1060)
                    .frame(maxWidth: .infinity)
                bottomBar
            }
            .padding(24)
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .task { await openSceneIfRequested() }
    }

    private var header: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.15))
                    .frame(width: 54, height: 54)
                Image(systemName: "brain.head.profile.fill")
                    .font(.system(size: 25, weight: .semibold))
                    .foregroundStyle(.orange)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text("STROKE CARE")
                    .font(.system(size: 25, weight: .bold, design: .rounded))
                    .tracking(2.1)
                Text("A shared case board for one calm conversation")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Picker("Audience", selection: $experience.audienceLens) {
                ForEach(StrokeAudienceLens.allCases) { lens in
                    Text(lens.rawValue).tag(lens)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 260)

            Label("Fictional case", systemImage: "checkmark.shield")
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 13)
                .padding(.vertical, 8)
                .background(Color.orange.opacity(0.12), in: Capsule())
                .foregroundStyle(.orange)
        }
    }

    private var stepRail: some View {
        HStack(spacing: 14) {
            ForEach(StrokeProcedureStep.allCases) { item in
                HStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(item == experience.procedureStep ? Color.orange.opacity(0.22) : Color.white.opacity(0.06))
                            .frame(width: 42, height: 42)

                        if item.rawValue < experience.procedureStep.rawValue {
                            Image(systemName: "checkmark")
                                .font(.headline.bold())
                                .foregroundStyle(.green)
                        } else {
                            Text("\(item.number)")
                                .font(.headline.bold().monospacedDigit())
                                .foregroundStyle(item == experience.procedureStep ? .orange : .secondary)
                        }
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.title)
                            .font(.headline)
                        Text(stepSubtitle(item))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                if item != StrokeProcedureStep.allCases.last {
                    Spacer(minLength: 16)
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.tertiary)
                    Spacer(minLength: 16)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
    }

    private func stepSubtitle(_ step: StrokeProcedureStep) -> String {
        switch step {
        case .chooseCase: "open the file"
        case .inspectOcclusion: "find the blockage"
        case .discussCare: "ask what happens next"
        }
    }

    private var intentCue: some View {
        HStack(spacing: 10) {
            Image(systemName: "scope")
                .foregroundStyle(.cyan)
            Text("INTENT")
                .font(.caption.weight(.bold))
                .tracking(1.4)
                .foregroundStyle(.cyan)
            Text(experience.procedureStep.intent)
                .font(.callout.weight(.semibold))
            Spacer()
            Label("No patient data", systemImage: "lock.shield")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .background(Color.cyan.opacity(0.055), in: Capsule())
        .overlay(Capsule().stroke(Color.cyan.opacity(0.13)))
    }

    @ViewBuilder
    private var activeStep: some View {
        switch experience.procedureStep {
        case .chooseCase:
            chooseCaseStep
        case .inspectOcclusion:
            inspectStep
        case .discussCare:
            discussStep
        }
    }

    private var chooseCaseStep: some View {
        VStack(alignment: .leading, spacing: 18) {
            sectionHeading(
                "Open the case file",
                detail: "Three facts. One fictional scenario. No chart overload."
            )

            HStack(alignment: .top, spacing: 18) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(experience.teachingCase.displayName.uppercased())
                            .font(.headline.weight(.bold))
                            .tracking(1.2)
                        Spacer()
                        Text("FICTIONAL")
                            .font(.caption2.weight(.bold))
                            .tracking(1.1)
                            .foregroundStyle(.orange)
                    }

                    caseDocument(
                        "Reported signs",
                        value: "Speech change\nRight arm weakness",
                        icon: "waveform.path.ecg",
                        accent: .cyan
                    )
                    caseDocument(
                        "Timeline",
                        value: "Last known well\n70 minutes ago",
                        icon: "clock",
                        accent: .orange
                    )
                    caseDocument(
                        "Teaching note",
                        value: "Possible blocked vessel\nOpen the model to inspect",
                        icon: "doc.text.magnifyingglass",
                        accent: .purple
                    )

                    Button {
                        experience.selectTeachingCase()
                    } label: {
                        Label("Open Case 78", systemImage: "arrow.right.circle.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity, minHeight: 52)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                }
                .frame(width: 330)

                StrokeModelBoardView()
                    .environmentObject(experience)
                    .frame(minHeight: 360)
            }
        }
        .stepSurface()
    }

    private var inspectStep: some View {
        VStack(alignment: .leading, spacing: 18) {
            sectionHeading(
                "Find the blockage",
                detail: "Reveal the vessel, then point to one shared landmark."
            )

            HStack(alignment: .top, spacing: 18) {
                VStack(alignment: .leading, spacing: 14) {
                    evidencePin("SIGN", "Speech + arm weakness", tint: .cyan)
                    evidencePin("TIME", "70 minutes reported", tint: .orange)
                    evidencePin("MODEL", "Occlusion is schematic", tint: .purple)

                    Divider().opacity(0.25)

                    HStack {
                        Label("Reveal", systemImage: "view.3d")
                            .font(.headline)
                        Spacer()
                        Text("\(Int((experience.brainRevealProgress * 100).rounded()))%")
                            .font(.headline.monospacedDigit())
                            .foregroundStyle(.orange)
                    }
                    Slider(
                        value: Binding(
                            get: { experience.brainRevealProgress },
                            set: { experience.setBrainReveal($0) }
                        ),
                        in: 0...1
                    )
                    .tint(.orange)

                    Button {
                        experience.focusOcclusion()
                    } label: {
                        Label("Focus vessel", systemImage: "scope")
                            .font(.headline)
                            .frame(maxWidth: .infinity, minHeight: 50)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)

                    Text("Teaching animation · not a scan")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
                .frame(width: 300)

                StrokeModelBoardView()
                    .environmentObject(experience)
                    .frame(minHeight: 370)
            }
        }
        .stepSurface()
    }

    private var discussStep: some View {
        VStack(alignment: .leading, spacing: 18) {
            sectionHeading(
                "Prepare the conversation",
                detail: "Two pathways. No ranking. The stroke team decides."
            )

            HStack(alignment: .top, spacing: 16) {
                VStack(spacing: 12) {
                    ForEach(StrokeCareDiscussion.allCases) { discussion in
                        careCard(discussion)
                    }

                    HStack(spacing: 8) {
                        Button {
                            experience.setPauseRequested(false)
                        } label: {
                            Label("Clear", systemImage: "checkmark.circle")
                        }
                        .buttonStyle(.bordered)
                        .tint(.green)

                        Button {
                            experience.setPauseRequested(true)
                        } label: {
                            Label("Pause", systemImage: "hand.raised.fill")
                        }
                        .buttonStyle(.bordered)
                        .tint(.orange)
                    }
                }
                .frame(width: 285)

                StrokeModelBoardView()
                    .environmentObject(experience)
                    .frame(minHeight: 370)

                VStack(alignment: .leading, spacing: 14) {
                    Label("PATIENT + DOCTOR", systemImage: "person.2.fill")
                        .font(.caption.weight(.bold))
                        .tracking(1.2)
                        .foregroundStyle(.cyan)

                    if let selected = experience.selectedCareDiscussion {
                        Label(selected.title, systemImage: selected.icon)
                            .font(.headline.weight(.bold))
                        Text(experience.audienceLens == .family ? selected.familySummary : selected.clinicianBoundary)
                            .font(.callout)
                            .lineSpacing(3)
                    } else {
                        Text("Choose a pathway to open the questions for the stroke team.")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }

                    if experience.requestedPause {
                        Label("Slow down · one idea · check understanding", systemImage: "heart.text.square.fill")
                            .font(.callout.weight(.semibold))
                            .foregroundStyle(.orange)
                    }

                    if experience.reportIsVisible {
                        Text(experience.discussionReport)
                            .font(.caption.monospaced())
                            .lineSpacing(2)
                    }
                }
                .padding(18)
                .frame(width: 270, alignment: .topLeading)
                .background(Color.cyan.opacity(0.055), in: RoundedRectangle(cornerRadius: 22))
            }
        }
        .stepSurface()
    }

    private func caseDocument(
        _ title: String,
        value: String,
        icon: String,
        accent: Color
    ) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3.weight(.semibold))
                .foregroundStyle(accent)
                .frame(width: 28)
            VStack(alignment: .leading, spacing: 4) {
                Text(title.uppercased())
                    .font(.caption2.weight(.bold))
                    .tracking(1.1)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.callout.weight(.semibold))
            }
            Spacer(minLength: 0)
        }
        .padding(14)
        .background(Color.white.opacity(0.045), in: RoundedRectangle(cornerRadius: 16))
        .overlay(alignment: .topTrailing) {
            Circle().fill(accent).frame(width: 7, height: 7).padding(12)
        }
    }

    private func evidencePin(_ label: String, _ value: String, tint: Color) -> some View {
        HStack(spacing: 10) {
            Text(label)
                .font(.caption2.weight(.bold))
                .tracking(1.2)
                .foregroundStyle(tint)
                .frame(width: 48, alignment: .leading)
            Text(value)
                .font(.callout.weight(.semibold))
            Spacer(minLength: 0)
            Circle().fill(tint).frame(width: 7, height: 7)
        }
        .padding(12)
        .background(Color.white.opacity(0.04), in: RoundedRectangle(cornerRadius: 14))
    }

    private func careCard(_ discussion: StrokeCareDiscussion) -> some View {
        let selected = experience.selectedCareDiscussion == discussion
        return Button {
            experience.selectCareDiscussion(discussion)
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: discussion.icon)
                        .font(.title2)
                    Spacer()
                    Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                }
                Text(discussion.rawValue)
                    .font(.caption.weight(.bold))
                    .tracking(1.2)
                    .foregroundStyle(.orange)
                Text(discussion.title)
                    .font(.title3.weight(.bold))
                    .multilineTextAlignment(.leading)
            }
            .padding(20)
            .frame(maxWidth: .infinity, minHeight: 150, alignment: .leading)
            .background(selected ? Color.cyan.opacity(0.12) : Color.white.opacity(0.04), in: RoundedRectangle(cornerRadius: 22))
            .overlay(RoundedRectangle(cornerRadius: 22).stroke(selected ? Color.cyan.opacity(0.55) : Color.white.opacity(0.08), lineWidth: selected ? 2 : 1))
        }
        .buttonStyle(.plain)
    }

    private func sectionHeading(_ title: String, detail: String) -> some View {
        VStack(alignment: .leading, spacing: 9) {
            Text(title)
                .font(.system(size: 34, weight: .bold, design: .rounded))
            Text(detail)
                .font(.system(size: 18, weight: .regular, design: .rounded))
                .foregroundStyle(.secondary)
                .lineSpacing(4)
        }
    }

    private var bottomBar: some View {
        HStack(spacing: 14) {
            Button {
                Task {
                    if immersiveOpen {
                        await dismissImmersiveSpace()
                        immersiveOpen = false
                    } else {
                        immersiveOpen = await openImmersiveSpace(id: StrokeSpace.immersive) == .opened
                    }
                }
            } label: {
                Label(immersiveOpen ? "Hide room model" : "Place in room", systemImage: immersiveOpen ? "xmark.circle" : "visionpro")
                    .font(.headline)
                    .frame(minHeight: 50)
            }
            .buttonStyle(.bordered)

            if experience.procedureStep != .chooseCase {
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        experience.procedureStep = StrokeProcedureStep(rawValue: experience.procedureStep.rawValue - 1) ?? .chooseCase
                    }
                } label: {
                    Label("Back", systemImage: "chevron.left")
                        .font(.headline)
                        .frame(minHeight: 50)
                }
                .buttonStyle(.bordered)
            }

            Spacer()

            if experience.procedureStep == .inspectOcclusion {
                Button {
                    experience.beginCareDiscussion()
                } label: {
                    Label("Discuss care", systemImage: "arrow.right")
                        .font(.title3.weight(.semibold))
                        .frame(minWidth: 210, minHeight: 54)
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
            } else if experience.procedureStep == .discussCare {
                Button {
                    if experience.reportIsVisible {
                        experience.reset()
                    } else {
                        experience.createDiscussionSummary()
                    }
                } label: {
                    Label(
                        experience.reportIsVisible ? "Start again" : "Create discussion summary",
                        systemImage: experience.reportIsVisible ? "arrow.counterclockwise" : "doc.text"
                    )
                    .font(.title3.weight(.semibold))
                    .frame(minWidth: 250, minHeight: 54)
                }
                .buttonStyle(.borderedProminent)
                .tint(.cyan)
                .disabled(experience.selectedCareDiscussion == nil)
            }
        }
    }

    @MainActor
    private func openSceneIfRequested() async {
        guard !handledLaunch else { return }
        handledLaunch = true

        let arguments = ProcessInfo.processInfo.arguments
        let wantsRigProof = arguments.contains("--proof-rig")
        if arguments.contains("--proof-inspect") {
            experience.prepareProof(step: .inspectOcclusion)
        } else if arguments.contains("--proof-discuss") {
            experience.prepareProof(step: .discussCare)
        } else {
            experience.prepareHackathonDemo()
        }

        let wantsRoomModel = wantsRigProof
            || arguments.contains("--hackathon-demo")
        if wantsRoomModel {
            try? await Task.sleep(for: .milliseconds(500))
            immersiveOpen = await openImmersiveSpace(id: StrokeSpace.immersive) == .opened
        }

        if wantsRigProof {
            try? await Task.sleep(for: .milliseconds(2_000))
            experience.selectTeachingCase()
            try? await Task.sleep(for: .milliseconds(1_300))
            experience.focusOcclusion()
        }
    }
}

private extension View {
    func stepSurface() -> some View {
        self
            .padding(24)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 30))
            .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.white.opacity(0.08)))
    }
}

private extension StrokeProcedureStep {
    var intent: String {
        switch self {
        case .chooseCase: "Start with what the patient and family already know."
        case .inspectOcclusion: "Make one cause visible without overwhelming them."
        case .discussCare: "Turn anxiety into questions the team can answer."
        }
    }
}
