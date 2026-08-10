import SwiftUI

struct RBCEducationalBoundaryBadge: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Label("GENERIC SYNTHETIC TEACHING VIEW · NOT A PATIENT SCAN", systemImage: "shield.lefthalf.filled")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundStyle(Color(red: 0.98, green: 0.70, blue: 0.34))
            Text("SPECIALIST REVIEW PENDING · CLINICAL REVIEW PENDING")
                .font(.system(size: 9, weight: .semibold, design: .monospaced))
                .foregroundStyle(.white.opacity(0.64))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.black.opacity(0.34), in: .capsule)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Generic synthetic teaching view. Not a patient scan. Specialist review pending. Clinical review pending.")
    }
}

struct RBCSceneReadinessSurface: View {
    @Environment(RBCJourneyModel.self) private var model
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    private var title: String {
        switch model.sceneReadinessPhase {
        case .loading: "Preparing the teaching space"
        case .ready: "Teaching space ready"
        case .degraded: "Some teaching detail is unavailable"
        case .failed: "Teaching space could not open"
        }
    }

    private var accent: Color {
        switch model.sceneReadinessPhase {
        case .loading, .ready: Color(red: 0.48, green: 0.93, blue: 0.78)
        case .degraded: Color(red: 0.98, green: 0.70, blue: 0.34)
        case .failed: Color(red: 1.0, green: 0.36, blue: 0.34)
        }
    }

    private var systemImage: String {
        switch model.sceneReadinessPhase {
        case .loading: "shippingbox.and.arrow.backward"
        case .ready: "checkmark.seal.fill"
        case .degraded: "exclamationmark.triangle.fill"
        case .failed: "xmark.octagon.fill"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            RBCEducationalBoundaryBadge()

            HStack(spacing: 16) {
                if model.sceneReadinessPhase == .loading {
                    ProgressView()
                        .controlSize(.large)
                        .tint(accent)
                        .accessibilityLabel("Loading full-detail teaching scene")
                } else {
                    Image(systemName: systemImage)
                        .font(.system(size: 34, weight: .semibold))
                        .foregroundStyle(accent)
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text(model.sceneReadinessPhase.rawValue)
                        .font(.caption.monospaced().weight(.bold))
                        .tracking(1.8)
                        .foregroundStyle(accent)
                    Text(title)
                        .font(.system(size: 34, weight: .semibold, design: .rounded))
                }
            }

            Text(model.sceneReadinessDetail)
                .font(.title3)
                .foregroundStyle(.white.opacity(0.76))
                .fixedSize(horizontal: false, vertical: true)

            Label(
                "No patient data is being loaded. This technical check does not provide clinical or specialist validation.",
                systemImage: "lock.shield"
            )
            .font(.footnote.weight(.medium))
            .foregroundStyle(.white.opacity(0.58))
            .fixedSize(horizontal: false, vertical: true)

            if model.sceneReadinessPhase == .degraded || model.sceneReadinessPhase == .failed {
                Button("Leave full space", systemImage: "xmark") {
                    Task {
                        await dismissImmersiveSpace()
                        model.isPresented = false
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(accent)
                .buttonBorderShape(.capsule)
            }
        }
        .padding(32)
        .frame(width: 720, alignment: .leading)
        .frame(minHeight: 390, alignment: .leading)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.055, green: 0.018, blue: 0.030).opacity(0.98),
                    Color(red: 0.12, green: 0.026, blue: 0.042).opacity(0.96),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: .rect(cornerRadius: 32)
        )
        .glassBackgroundEffect(in: .rect(cornerRadius: 32))
        .overlay {
            RoundedRectangle(cornerRadius: 32)
                .stroke(accent.opacity(0.42), lineWidth: 1)
        }
        .accessibilityElement(children: .contain)
    }
}

private struct RBCPreludeChapterText: View {
    @Environment(RBCJourneyModel.self) private var model
    let chapter: RBCEntryPreludeChapter
    @State private var settled = false

    var body: some View {
        VStack(spacing: 16) {
            Text(chapter.number + "  /  04")
                .font(.caption.monospacedDigit().weight(.bold))
                .tracking(2)
                .foregroundStyle(Color(red: 0.48, green: 0.93, blue: 0.78))

            Text(chapter.title)
                .font(.system(size: 52, weight: .medium, design: .rounded))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            Text(chapter.subtitle)
                .font(.title3)
                .foregroundStyle(.white.opacity(0.68))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .opacity(settled ? 1 : 0)
        .scaleEffect(settled ? 1 : 0.84)
        .onAppear {
            withAnimation(model.effectiveReducedMotion ? nil : .easeOut(duration: 1.15)) {
                settled = true
            }
        }
    }
}

struct RBCEntryPreludeHUD: View {
    @Environment(RBCJourneyModel.self) private var model

    var body: some View {
        VStack(spacing: 26) {
            RBCEducationalBoundaryBadge()

            RBCPreludeChapterText(chapter: model.entryPreludeChapter)
                .id(model.entryPreludeChapter.id)

            HStack(spacing: 12) {
                if model.entryPreludeChapter != .threshold {
                    Button("Back", systemImage: "chevron.left") {
                        withAnimation(model.effectiveReducedMotion ? nil : .easeInOut(duration: 0.45)) {
                            if let previous = RBCEntryPreludeChapter(rawValue: model.entryPreludeChapter.rawValue - 1) {
                                model.entryPreludeChapter = previous
                            }
                        }
                    }
                }

                Button(model.entryPreludeChapter.actionTitle, systemImage: model.entryPreludeChapter == .invitation ? "arrow.down.right.and.arrow.up.left" : "arrow.right") {
                    withAnimation(model.effectiveReducedMotion ? nil : .easeInOut(duration: 0.55)) {
                        model.advanceEntryPrelude()
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(red: 0.86, green: 0.12, blue: 0.22))

                Button("Skip", systemImage: "forward.end") {
                    withAnimation(model.effectiveReducedMotion ? nil : .easeInOut(duration: 0.45)) {
                        model.startWondrousJourney()
                    }
                }
                .buttonStyle(.bordered)
            }
            .buttonBorderShape(.capsule)
        }
        .frame(width: 760)
        .padding(24)
        .accessibilityElement(children: .contain)
    }
}

struct RBCJourneyTimelineHUD: View {
    @Environment(RBCJourneyModel.self) private var model

    var body: some View {
        HStack(spacing: 8) {
            ForEach(RBCJourneyStation.allCases) { station in
                Button {
                    model.select(station)
                } label: {
                    VStack(spacing: 4) {
                        HStack(spacing: 5) {
                            Text(station.code)
                                .font(.caption2.monospacedDigit().weight(.bold))
                            Image(systemName: station.systemImage)
                                .font(.caption)
                        }
                        Text(station.shortTitle)
                            .font(.caption2.weight(.semibold))
                            .lineLimit(1)
                    }
                    .frame(width: 74, height: 42)
                }
                .buttonStyle(.plain)
                .foregroundStyle(station == model.station ? .white : .white.opacity(0.48))
                .background(
                    station == model.station
                        ? Color(red: 0.86, green: 0.12, blue: 0.22).opacity(0.88)
                        : Color.white.opacity(0.045),
                    in: .rect(cornerRadius: 12)
                )
            }
        }
        .padding(10)
        .glassBackgroundEffect(in: .rect(cornerRadius: 18))
    }
}

struct RBCJourneyInfoHUD: View {
    @Environment(RBCJourneyModel.self) private var model

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            RBCEducationalBoundaryBadge()

            HStack {
                Text(model.lessonEyebrow)
                    .font(.caption2.monospacedDigit().weight(.bold))
                    .tracking(1.2)
                    .foregroundStyle(.pink)
                Spacer()
                Label(
                    model.isPaused ? "FLOW HELD" : "FLOW LIVE",
                    systemImage: model.isPaused ? "pause.circle.fill" : "waveform.path.ecg"
                )
                .font(.caption2.monospacedDigit().weight(.semibold))
                .foregroundStyle(model.isPaused ? .orange : Color(red: 0.48, green: 0.93, blue: 0.78))
            }

            Text(model.lessonTitle)
                .font(.title2.weight(.semibold))
                .fixedSize(horizontal: false, vertical: true)

            Text(model.lessonSubtitle)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.72))
                .fixedSize(horizontal: false, vertical: true)

            HStack(alignment: .top, spacing: 12) {
                Label(model.lessonFact, systemImage: "sparkles")
                    .font(.footnote)
                    .foregroundStyle(Color(red: 0.48, green: 0.93, blue: 0.78))
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 12)

                Button(model.isCurrentLessonSaved ? "Saved" : "Save", systemImage: model.isCurrentLessonSaved ? "bookmark.fill" : "bookmark") {
                    model.toggleSavedCurrentStation()
                }
                .accessibilityLabel(model.isCurrentLessonSaved ? "Remove saved learning" : "Save this learning")
            }
        }
        .padding(18)
        .frame(width: 680, alignment: .leading)
        .glassBackgroundEffect(in: .rect(cornerRadius: 22))
    }
}

struct RBCExhibitInfoHUD: View {
    @Environment(RBCJourneyModel.self) private var model
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            RBCEducationalBoundaryBadge()

            HStack(spacing: 10) {
                Text(model.lessonEyebrow)
                    .font(.caption2.monospacedDigit().weight(.bold))
                    .tracking(1.4)
                    .foregroundStyle(Color(red: 0.48, green: 0.93, blue: 0.78))

                Spacer()

                Label(
                    model.isPaused ? "MOMENT HELD" : "ROUTE LIVING",
                    systemImage: model.isPaused ? "pause.circle.fill" : "waveform.path.ecg"
                )
                .font(.caption2.monospacedDigit().weight(.semibold))
                .foregroundStyle(model.isPaused ? .orange : Color(red: 0.48, green: 0.93, blue: 0.78))
            }

            Text(model.lessonTitle)
                .font(.system(size: 30, weight: .semibold, design: .rounded))
                .fixedSize(horizontal: false, vertical: true)

            Text(model.lessonSubtitle)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.74))
                .fixedSize(horizontal: false, vertical: true)

            if model.isExhibitFactExpanded {
                Label(model.lessonFact, systemImage: "sparkles")
                    .font(.footnote)
                    .foregroundStyle(Color(red: 0.48, green: 0.93, blue: 0.78))
                    .fixedSize(horizontal: false, vertical: true)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }

            Divider()
                .overlay(.white.opacity(0.10))

            RBCExhibitControlsHUD()
                .environment(model)
        }
        .padding(18)
        .frame(width: 590, alignment: .leading)
        .glassBackgroundEffect(in: .rect(cornerRadius: 24))
        .accessibilityElement(children: .contain)
    }
}

struct RBCExhibitControlsHUD: View {
    @Environment(RBCJourneyModel.self) private var model
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    var body: some View {
        HStack(spacing: 8) {
            Button("Back", systemImage: "chevron.left") {
                model.retreatExhibit()
            }
            .disabled(model.exhibitBeat == .route)

            Button(
                model.isExhibitFactExpanded ? "Close note" : "Explain",
                systemImage: model.isExhibitFactExpanded ? "sparkles" : "questionmark.circle"
            ) {
                withAnimation(model.effectiveReducedMotion ? nil : .easeInOut(duration: 0.22)) {
                    model.isExhibitFactExpanded.toggle()
                }
            }

            Button(model.isCurrentLessonSaved ? "Saved" : "Save", systemImage: model.isCurrentLessonSaved ? "bookmark.fill" : "bookmark") {
                model.toggleSavedCurrentStation()
            }
            .accessibilityLabel(model.isCurrentLessonSaved ? "Remove saved learning" : "Save this learning")

            Button(model.exhibitBeat.actionTitle, systemImage: "arrow.right") {
                model.advanceExhibit()
            }
            .buttonStyle(.borderedProminent)
            .tint(Color(red: 0.86, green: 0.12, blue: 0.22))

            Button("Exit", systemImage: "xmark") {
                Task { await dismissImmersiveSpace() }
            }
            .accessibilityLabel("Exit the wondrous brain journey")
        }
        .buttonBorderShape(.capsule)
        .labelStyle(.titleAndIcon)
    }
}

struct RBCRegionInfoHUD: View {
    @Environment(RBCJourneyModel.self) private var model
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    var body: some View {
        if let region = model.activeRegionDestination {
            let exampleClotActive = region == .frontalLobe && model.isFrontalClotScenarioActive
            let flowRideActive = region == .arterialLumen && model.isFlowRideActive
            let willisRouteActive = region == .circleOfWillis
            let cerebellumActive = region == .cerebellum
            let deepStructuresActive = region == .deepStructures
            let occipitalActive = region == .occipitalLobe
            let brainstemActive = region == .brainstem
            let regionCompanionActive = !flowRideActive && model.familyNarrationEnabled
            let displayTitle = if flowRideActive && model.familyNarrationEnabled {
                model.familyNarrationCue.title
            } else if flowRideActive {
                model.activeFlowRideTitle
            } else if regionCompanionActive {
                model.regionFamilyCompanionTitle
            } else if willisRouteActive {
                model.activeWillisTitle
            } else if cerebellumActive {
                model.activeCerebellumTitle
            } else if deepStructuresActive {
                model.activeDeepStructuresTitle
            } else if occipitalActive {
                model.activeOccipitalTitle
            } else if brainstemActive {
                model.activeBrainstemTitle
            } else if exampleClotActive {
                "One branch, interrupted"
            } else {
                region.title
            }
            let displaySubtitle = if flowRideActive && model.familyNarrationEnabled {
                model.familyNarrationCue.caption
            } else if flowRideActive {
                model.activeFlowRideSubtitle
            } else if regionCompanionActive {
                model.regionFamilyCompanionSubtitle
            } else if willisRouteActive {
                model.activeWillisSubtitle
            } else if cerebellumActive {
                model.activeCerebellumSubtitle
            } else if deepStructuresActive {
                model.activeDeepStructuresSubtitle
            } else if occipitalActive {
                model.activeOccipitalSubtitle
            } else if brainstemActive {
                model.activeBrainstemSubtitle
            } else if exampleClotActive {
                "An illustrative obstruction occupies one teaching branch. Flow light holds upstream while the surrounding arterial context stays visible."
            } else {
                region.subtitle
            }
            let displayFact = if regionCompanionActive {
                model.regionFamilyCompanionFact
            } else if flowRideActive {
                model.activeFlowRideFact
            } else if willisRouteActive {
                model.activeWillisFact
            } else if cerebellumActive {
                model.activeCerebellumFact
            } else if deepStructuresActive {
                model.activeDeepStructuresFact
            } else if occipitalActive {
                model.activeOccipitalFact
            } else if brainstemActive {
                model.activeBrainstemFact
            } else if exampleClotActive {
                "An occlusion can reduce downstream blood delivery. Alternative routes vary between people; this scene is not measured flow or a patient scan."
            } else {
                region.fact
            }
            HStack(alignment: .bottom, spacing: 18) {
                if flowRideActive {
                    RBCFlowRideMiniMapHUD()
                        .environment(model)
                }

                VStack(alignment: .leading, spacing: 9) {
                RBCEducationalBoundaryBadge()

                Text(flowRideActive && model.isGuidedFlowTourActive
                    ? model.guidedFlowTourProgressLabel
                    : (flowRideActive && model.familyNarrationEnabled
                    ? model.familyNarrationProgressLabel
                    : (flowRideActive
                        ? "RIDE  ·  ARTERIAL LUMEN"
                        : (regionCompanionActive
                            ? "FAMILY COMPANION  ·  \(region.shortTitle.uppercased())"
                            : "CLINICIAN DETAIL  ·  INSIDE  ·  \(region.shortTitle.uppercased())"))))
                    .font(.caption2.monospacedDigit().weight(.bold))
                    .tracking(1.3)
                    .foregroundStyle(Color(red: 0.48, green: 0.93, blue: 0.78))

                Text(displayTitle)
                    .font(.system(size: 34, weight: .semibold, design: .rounded))

                Text(displaySubtitle)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.82))
                    .fixedSize(horizontal: false, vertical: true)

                Label(
                    displayFact,
                    systemImage: regionCompanionActive
                        ? "person.2.fill"
                        : (flowRideActive ? "arrow.forward.circle.fill" : (exampleClotActive ? "exclamationmark.triangle.fill" : "viewfinder"))
                )
                    .font(.footnote)
                    .foregroundStyle(exampleClotActive ? Color.orange : Color(red: 0.48, green: 0.93, blue: 0.78))
                    .fixedSize(horizontal: false, vertical: true)

                if willisRouteActive {
                    if let passagePhase = model.anteriorPassagePhase {
                        VStack(alignment: .leading, spacing: 7) {
                            HStack(spacing: 5) {
                                ForEach(RBCAnteriorPassagePhase.allCases) { phase in
                                    Label(phase.shortTitle, systemImage: phase.rawValue <= passagePhase.rawValue
                                        ? "circle.inset.filled"
                                        : "circle")
                                        .font(.caption2.weight(.semibold))
                                        .foregroundStyle(phase.rawValue <= passagePhase.rawValue
                                            ? Color(red: 0.96, green: 0.38, blue: 0.34)
                                            : .white.opacity(0.38))
                                }
                            }
                            .accessibilityLabel("Anterior passage step \(passagePhase.rawValue + 1) of 3")

                            HStack(spacing: 7) {
                                if let nextTitle = passagePhase.nextActionTitle {
                                    Button(nextTitle, systemImage: "arrow.forward.circle.fill") {
                                        withAnimation(model.effectiveReducedMotion ? nil : .easeInOut(duration: 0.42)) {
                                            model.advanceAnteriorPassage()
                                        }
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .tint(Color(red: 0.84, green: 0.18, blue: 0.27))
                                    .accessibilityLabel("Continue the anterior circulation passage")
                                } else {
                                    Button("Enter artery", systemImage: "arrow.down.right.and.arrow.up.left") {
                                        model.chooseAnteriorDestination(.arterialLumen)
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .tint(Color(red: 0.84, green: 0.18, blue: 0.27))
                                    .accessibilityLabel("Enter the inhabited middle cerebral teaching branch")

                                    Button("Open frontal field", systemImage: "brain.head.profile.fill") {
                                        model.chooseAnteriorDestination(.frontalLobe)
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .tint(Color(red: 0.28, green: 0.68, blue: 0.62))
                                    .accessibilityLabel("Open the frontal lobe observatory around the selected route")
                                }

                                Button("Leave passage", systemImage: "arrow.uturn.backward") {
                                    withAnimation(model.effectiveReducedMotion ? nil : .easeInOut(duration: 0.32)) {
                                        model.stopAnteriorPassage()
                                    }
                                }
                                .buttonStyle(.bordered)
                                .accessibilityLabel("Return to the complete Circle of Willis view")
                            }
                            .buttonBorderShape(.capsule)
                        }
                    } else {
                        HStack(spacing: 7) {
                            ForEach(RBCWillisRouteFocus.allCases) { focus in
                                RBCWillisRouteFocusButton(focus: focus)
                            }
                        }
                        .buttonBorderShape(.capsule)

                        if model.willisRouteFocus == .anterior {
                            Button("Enter anterior passage", systemImage: "arrow.forward.circle.fill") {
                                withAnimation(model.effectiveReducedMotion ? nil : .easeInOut(duration: 0.42)) {
                                    model.startAnteriorPassage()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(Color(red: 0.84, green: 0.18, blue: 0.27))
                            .buttonBorderShape(.capsule)
                            .accessibilityLabel("Begin the three-step anterior circulation passage")
                        }
                    }
                }

                if region == .frontalLobe || region == .corticalMicroarchitecture || region == .cerebellum || region == .deepStructures || region == .occipitalLobe || region == .brainstem {
                    HStack(spacing: 7) {
                        ForEach(RBCRegionVisualizationMode.allCases) { mode in
                            RBCRegionModeButton(mode: mode, regionTitle: region.title)
                        }
                    }
                    .buttonBorderShape(.capsule)
                }

                if brainstemActive && model.regionVisualization == .flow {
                    if let voyagePhase = model.posteriorVoyagePhase {
                        VStack(alignment: .leading, spacing: 7) {
                            HStack(spacing: 5) {
                                ForEach(RBCPosteriorVoyagePhase.allCases) { phase in
                                    Label(phase.shortTitle, systemImage: phase.rawValue <= voyagePhase.rawValue
                                        ? "circle.inset.filled"
                                        : "circle")
                                        .font(.caption2.weight(.semibold))
                                        .foregroundStyle(phase.rawValue <= voyagePhase.rawValue
                                            ? Color(red: 0.96, green: 0.48, blue: 0.34)
                                            : .white.opacity(0.38))
                                }
                            }
                            .accessibilityLabel("Posterior route step \(voyagePhase.rawValue + 1) of 3")

                            HStack(spacing: 7) {
                                if let nextTitle = voyagePhase.nextActionTitle {
                                    Button(nextTitle, systemImage: "arrow.forward.circle.fill") {
                                        withAnimation(model.effectiveReducedMotion ? nil : .easeInOut(duration: 0.42)) {
                                            model.advancePosteriorVoyage()
                                        }
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .tint(Color(red: 0.82, green: 0.19, blue: 0.25))
                                    .accessibilityLabel("Continue the posterior circulation voyage")
                                } else {
                                    Button("Cerebellum", systemImage: "point.3.connected.trianglepath.dotted") {
                                        model.choosePosteriorDestination(.cerebellum)
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .tint(Color(red: 0.29, green: 0.65, blue: 0.62))
                                    .accessibilityLabel("Open the cerebellar circulation destination")

                                    Button("Visual cortex", systemImage: "eye.fill") {
                                        model.choosePosteriorDestination(.occipitalLobe)
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .tint(Color(red: 0.42, green: 0.38, blue: 0.82))
                                    .accessibilityLabel("Open the posterior cerebral route to visual cortex")
                                }

                                Button("Leave route", systemImage: "arrow.uturn.backward") {
                                    withAnimation(model.effectiveReducedMotion ? nil : .easeInOut(duration: 0.32)) {
                                        model.stopPosteriorVoyage()
                                    }
                                }
                                .buttonStyle(.bordered)
                                .accessibilityLabel("Return to the complete brainstem flow view")
                            }
                            .buttonBorderShape(.capsule)
                        }
                    } else {
                        Button("Follow posterior route", systemImage: "arrow.triangle.branch") {
                            withAnimation(model.effectiveReducedMotion ? nil : .easeInOut(duration: 0.42)) {
                                model.startPosteriorVoyage()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color(red: 0.82, green: 0.19, blue: 0.25))
                        .buttonBorderShape(.capsule)
                        .accessibilityLabel("Begin the three-step posterior circulation voyage")
                    }
                }

                if region == .frontalLobe && model.regionVisualization == .flow {
                    HStack(spacing: 7) {
                        Button(
                            model.isFrontalClotScenarioActive ? "Clear example" : "Place example clot",
                            systemImage: model.isFrontalClotScenarioActive ? "arrow.counterclockwise" : "drop.triangle.fill"
                        ) {
                            withAnimation(model.effectiveReducedMotion ? nil : .easeInOut(duration: 0.28)) {
                                model.toggleFrontalClotScenario()
                            }
                        }
                        .buttonStyle(.bordered)
                        .tint(model.isFrontalClotScenarioActive ? .orange : .pink)
                        .accessibilityLabel(model.isFrontalClotScenarioActive
                            ? "Clear the illustrative frontal branch obstruction"
                            : "Place an illustrative frontal branch obstruction")

                        Button("Enter this branch", systemImage: "arrow.down.right.and.arrow.up.left") {
                            model.startFlowRide()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color(red: 0.23, green: 0.67, blue: 0.60))
                        .accessibilityLabel("Enter the illustrative arterial branch and ride with its flow")
                    }
                    .buttonBorderShape(.capsule)
                }

                if region == .arterialLumen {
                    VStack(alignment: .leading, spacing: 7) {
                        if model.isGuidedFlowTourActive {
                            HStack(spacing: 7) {
                                if model.guidedFlowTourPhase == .complete {
                                    Label("Journey complete", systemImage: "checkmark.circle.fill")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(Color(red: 0.48, green: 0.93, blue: 0.78))
                                } else {
                                    Button(
                                        model.isPaused ? "Resume journey" : "Pause journey",
                                        systemImage: model.isPaused ? "play.fill" : "pause.fill"
                                    ) {
                                        model.isPaused.toggle()
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .tint(model.isPaused ? .orange : Color(red: 0.23, green: 0.67, blue: 0.60))

                                    Text(model.familyNarrationConfigured
                                        ? "Optional voice follows this exact caption."
                                        : "Caption-led; optional voice is not connected.")
                                        .font(.caption2)
                                        .foregroundStyle(.white.opacity(0.62))
                                }
                            }
                            .buttonBorderShape(.capsule)

                            if model.guidedFlowTourPhase == .complete {
                                HStack(spacing: 8) {
                                    Button("Replay journey", systemImage: "arrow.counterclockwise") {
                                        model.restartGuidedFlowTour()
                                    }

                                    Button("Explore", systemImage: "hand.point.up.left.fill") {
                                        model.enterFreeFlowExploration()
                                    }

                                    Button("Exit", systemImage: "xmark") {
                                        Task { await dismissImmersiveSpace() }
                                    }
                                }
                                .buttonBorderShape(.capsule)
                            }
                        } else if model.isFlowRideActive {
                            HStack(spacing: 7) {
                                ForEach(RBCFlowRideRoute.allCases) { route in
                                    let selected = model.flowRideRoute == route
                                    Button(route.shortTitle, systemImage: route.systemImage) {
                                        model.selectFlowRideRoute(route)
                                    }
                                    .font(.caption.weight(.semibold))
                                    .buttonStyle(.bordered)
                                    .tint(selected ? Color(red: 0.92, green: 0.20, blue: 0.28) : .white.opacity(0.30))
                                }

                                Button("Replay guide", systemImage: "play.circle.fill") {
                                    model.restartGuidedFlowTour()
                                }
                                .buttonStyle(.borderedProminent)

                                Button("Leave", systemImage: "arrow.uturn.backward") {
                                    model.stopFlowRide()
                                }
                            }
                            .buttonBorderShape(.capsule)
                        } else {
                            Button("Start guided journey", systemImage: "play.fill") {
                                model.startFlowRide()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(Color(red: 0.23, green: 0.67, blue: 0.60))
                            .buttonBorderShape(.capsule)
                        }
                    }
                }

                if !flowRideActive {
                    HStack(spacing: 8) {
                        Button(
                            model.familyNarrationEnabled ? "End voice" : "Family companion",
                            systemImage: model.familyNarrationEnabled ? "waveform.slash" : "waveform"
                        ) {
                            model.toggleFamilyNarration()
                        }
                        .buttonStyle(.bordered)
                        .tint(model.familyNarrationEnabled ? Color.indigo : nil)
                        .accessibilityLabel(model.familyNarrationEnabled
                            ? "Turn off the optional family voice companion"
                            : "Hear the reviewed explanation for this brain region")

                        Text(model.familyNarrationConfigured
                            ? "Voice reads this exact view."
                            : "Caption stays visible; voice needs the local guide.")
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.62))

                        if model.familyNarrationEnabled && model.familyNarrationConfigured {
                            Button("Hear again", systemImage: "arrow.counterclockwise") {
                                model.replayFamilyNarration()
                            }
                            .font(.caption.weight(.semibold))
                            .buttonStyle(.bordered)
                            .accessibilityLabel("Hear this region explanation again")
                        }
                    }
                    .buttonBorderShape(.capsule)

                    HStack(spacing: 8) {
                        Button("Return to story", systemImage: "arrow.uturn.backward") {
                            model.startWondrousJourney()
                        }
                        Button(model.isCurrentLessonSaved ? "Saved" : "Save", systemImage: model.isCurrentLessonSaved ? "bookmark.fill" : "bookmark") {
                            model.toggleSavedCurrentStation()
                        }
                        Button("Exit", systemImage: "xmark") {
                            Task { await dismissImmersiveSpace() }
                        }
                    }
                    .buttonBorderShape(.capsule)
                }
                }
                .padding(14)
                .frame(width: 540, alignment: .leading)
                .shadow(color: .black.opacity(0.82), radius: 12, y: 3)
                .accessibilityElement(children: .contain)
            }
        }
    }
}

private struct RBCRegionModeButton: View {
    @Environment(RBCJourneyModel.self) private var model
    let mode: RBCRegionVisualizationMode
    let regionTitle: String

    var body: some View {
        let selected = mode == model.regionVisualization
        Button {
            withAnimation(model.effectiveReducedMotion ? nil : .easeInOut(duration: 0.28)) {
                model.selectRegionVisualization(mode)
            }
        } label: {
            Label(mode.title, systemImage: mode.systemImage)
                .font(.caption.weight(.semibold))
        }
        .buttonStyle(.bordered)
        .tint(selected ? (mode == .flow ? .pink : Color(red: 0.31, green: 0.68, blue: 0.62)) : .white.opacity(0.34))
        .background(selected ? Color.white.opacity(0.08) : .clear, in: .capsule)
        .accessibilityLabel("Show \(mode.title) view for \(regionTitle)")
    }
}

private struct RBCWillisRouteFocusButton: View {
    @Environment(RBCJourneyModel.self) private var model
    let focus: RBCWillisRouteFocus

    var body: some View {
        let selected = focus == model.willisRouteFocus
        Button(focus.shortTitle, systemImage: focus.systemImage) {
            withAnimation(model.effectiveReducedMotion ? nil : .easeInOut(duration: 0.34)) {
                model.selectWillisRouteFocus(focus)
            }
        }
        .font(.caption.weight(.semibold))
        .buttonStyle(.bordered)
        .tint(selected
            ? (focus == .posterior
                ? Color(red: 0.34, green: 0.72, blue: 0.78)
                : Color(red: 0.94, green: 0.28, blue: 0.32))
            : .white.opacity(0.30))
        .accessibilityLabel("Show \(focus.shortTitle.lowercased()) Circle of Willis routes")
    }
}

struct RBCRegionTransferHUD: View {
    @Environment(RBCJourneyModel.self) private var model

    var body: some View {
        if model.pendingRegionDestination != nil {
            VStack(spacing: 10) {
                RBCEducationalBoundaryBadge()

                Text(model.regionTransferFamilyTitle.uppercased())
                    .font(.caption.monospacedDigit().weight(.bold))
                    .tracking(1.8)
                    .foregroundStyle(Color(red: 0.48, green: 0.93, blue: 0.78))

                Text(model.regionTransferFamilySubtitle)
                    .font(.system(size: 38, weight: .medium, design: .rounded))
                    .multilineTextAlignment(.center)

                Text("Watch the next region gather around your point of view.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.70))
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical, 12)
            .frame(width: 590)
            .shadow(color: .black.opacity(0.86), radius: 18, y: 4)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(model.regionTransferFamilyTitle). \(model.regionTransferFamilySubtitle)")
        }
    }
}

struct RBCRegionPortalReelHUD: View {
    @Environment(RBCJourneyModel.self) private var model

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("REGION PORTALS")
                    .font(.caption2.monospacedDigit().weight(.bold))
                    .tracking(1.5)
                    .foregroundStyle(.white.opacity(0.62))
                Spacer()
                Text("ONE ACTIVE · SWIPE FOR MORE")
                    .font(.caption2.monospacedDigit())
                    .foregroundStyle(.white.opacity(0.38))
            }

            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(RBCBrainRegionDestination.allCases) { destination in
                        let selected = model.activeRegionDestination == destination
                        let opening = model.pendingRegionDestination == destination
                        Button {
                            model.requestRegion(destination)
                        } label: {
                            HStack(spacing: 11) {
                                ZStack {
                                    Circle()
                                        .fill(opening
                                            ? Color(red: 0.23, green: 0.67, blue: 0.60).opacity(0.28)
                                            : (selected ? Color.pink.opacity(0.28) : Color.white.opacity(0.06)))
                                    Circle()
                                        .stroke(
                                            opening
                                                ? Color(red: 0.48, green: 0.93, blue: 0.78)
                                                : (selected ? Color.pink : Color.white.opacity(0.18)),
                                            lineWidth: selected || opening ? 2 : 1
                                        )
                                    Image(systemName: destination.systemImage)
                                        .font(.title3)
                                        .foregroundStyle(opening
                                            ? Color(red: 0.48, green: 0.93, blue: 0.78)
                                            : (selected ? .pink : .white.opacity(0.78)))
                                }
                                .frame(width: 46, height: 46)

                                VStack(alignment: .leading, spacing: 3) {
                                    Text(destination.shortTitle)
                                        .font(.subheadline.weight(.semibold))
                                        .lineLimit(1)
                                    Text(opening ? "Opening…" : (selected ? "Inside now" : "Enter region"))
                                        .font(.caption2)
                                        .foregroundStyle(.white.opacity(0.48))
                                }
                                Spacer(minLength: 0)
                            }
                            .padding(10)
                            .frame(width: 180, height: 68)
                            .background(
                                opening
                                    ? Color(red: 0.23, green: 0.67, blue: 0.60).opacity(0.12)
                                    : (selected ? Color.pink.opacity(0.12) : Color.white.opacity(0.035)),
                                in: .rect(cornerRadius: 18)
                            )
                        }
                        .buttonStyle(.plain)
                        .hoverEffect()
                        .disabled(model.pendingRegionDestination != nil || selected)
                        .accessibilityLabel(opening
                            ? "Opening \(destination.title)"
                            : (selected ? "Inside \(destination.title)" : "Enter \(destination.title)"))
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .padding(12)
        .frame(width: 610)
        .glassBackgroundEffect(in: .rect(cornerRadius: 22))
    }
}

/// A compact game-like locator for the arterial ride. It is deliberately
/// non-interactive: route choice remains in the primary lesson, while this
/// lower-corner legend answers “where am I?” beside the registered 3D atlas.
/// The capillary endpoint remains a cortical teaching proxy and must not be
/// read as patient registration, vessel territory, or live gaze.
struct RBCFlowRideMiniMapHUD: View {
    @Environment(RBCJourneyModel.self) private var model

    private var locationTitle: String {
        if model.isCapillaryFieldFocused { return "Frontal lobe · capillary field" }
        return switch model.flowRideRoute {
        case .overview: "Cerebral artery fork"
        case .frontal: "Frontal lobe branch"
        case .neighboring: "Neighboring branch"
        }
    }

    private var locationColor: Color {
        switch model.flowRideRoute {
        case .overview, .frontal: Color(red: 0.98, green: 0.24, blue: 0.28)
        case .neighboring: Color(red: 1.00, green: 0.55, blue: 0.18)
        }
    }

    private var routeDetail: String {
        if model.isCapillaryFieldFocused {
            return "Frontal lobe → representative cortical surface"
        }
        return switch model.flowRideRoute {
        case .overview: "Circle of Willis → cerebral branch fork"
        case .frontal: "Named right-M1 teaching locus → frontal lobe route"
        case .neighboring: "Cerebral fork → neighboring teaching route"
        }
    }

    private var locatorMethod: String {
        model.isCapillaryFieldFocused ? "CORTICAL PROXY" : "GEOMETRY-DERIVED"
    }

    private var activeJourneyStage: Int {
        if model.isCapillaryFieldFocused || model.guidedFlowTourPhase == .capillaryArrival || model.guidedFlowTourPhase == .complete {
            return 2
        }
        if model.flowRideRoute == .frontal
            || model.guidedFlowTourPhase == .chooseFrontal
            || model.guidedFlowTourPhase == .enterFrontal
            || model.guidedFlowTourPhase == .narrowTowardCortex {
            return 1
        }
        return 0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 7) {
                Image(systemName: "brain.head.profile.fill")
                    .foregroundStyle(.white.opacity(0.54))
                Text("BRAIN ATLAS")
                    .font(.caption2.monospaced().weight(.bold))
                    .tracking(1.4)
                Spacer()
                Text("ANTERIOR VIEW")
                    .font(.caption2.monospaced())
                    .foregroundStyle(.white.opacity(0.38))
            }

            Text(locationTitle)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white)

            Text(routeDetail)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.68))
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 5) {
                ForEach(Array(["FORK", "FRONTAL", "CORTEX"].enumerated()), id: \.offset) { index, stage in
                    if index > 0 {
                        Rectangle()
                            .fill(.white.opacity(0.20))
                            .frame(width: 12, height: 1)
                    }
                    Text(stage)
                        .font(.caption2.monospaced().weight(.bold))
                        .tracking(0.7)
                        .foregroundStyle(index == activeJourneyStage
                            ? locationColor
                            : .white.opacity(index < activeJourneyStage ? 0.62 : 0.28))
                }
            }
            .accessibilityLabel("Journey stages: fork, frontal lobe, cortex. Current stage (activeJourneyStage + 1) of 3.")

            HStack(spacing: 6) {
                Image(systemName: model.isCapillaryFieldFocused ? "scope" : "viewfinder")
                Text(locatorMethod)
                    .font(.caption2.monospaced().weight(.bold))
                    .tracking(0.8)
            }
            .foregroundStyle(locationColor)

            HStack(spacing: 7) {
                Circle()
                    .fill(locationColor)
                    .frame(width: 7, height: 7)
                    .shadow(color: locationColor.opacity(0.72), radius: 5)
                VStack(alignment: .leading, spacing: 1) {
                    Text("YOU ARE HERE")
                        .font(.caption2.monospaced().weight(.bold))
                        .tracking(1.0)
                        .foregroundStyle(.white.opacity(0.48))
                    Text(locationTitle)
                        .font(.caption.weight(.semibold))
                }
                Spacer()
                Text("MARKER ABOVE")
                    .font(.caption2.monospaced().weight(.semibold))
                    .foregroundStyle(.white.opacity(0.42))
            }
        }
        .padding(13)
        .frame(width: 260)
        .background(.black.opacity(0.16), in: .rect(cornerRadius: 20))
        .glassBackgroundEffect(in: .rect(cornerRadius: 20))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Three dimensional brain teaching atlas, anterior view. You are inside the \(locationTitle.lowercased()).")
    }
}

struct RBCJourneyControlsHUD: View {
    @Environment(RBCJourneyModel.self) private var model
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Button("Back", systemImage: "chevron.left") { model.back() }
                    .disabled(!model.canGoBack)

                Button(model.isPaused ? "Resume" : "Pause", systemImage: model.isPaused ? "play.fill" : "pause.fill") {
                    model.isPaused.toggle()
                }

                Button("Close portals", systemImage: "xmark.circle") {
                    model.closeAllPortals()
                }
                .disabled(model.openPortalCount == 0)

                if model.canAdvance {
                    Button("Next", systemImage: "chevron.right") { model.advance() }
                        .buttonStyle(.borderedProminent)
                        .tint(Color(red: 0.86, green: 0.12, blue: 0.22))
                } else {
                    Button("Restart", systemImage: "arrow.counterclockwise") { model.restart() }
                        .buttonStyle(.borderedProminent)
                        .tint(Color(red: 0.86, green: 0.12, blue: 0.22))
                }
            }

            HStack(spacing: 10) {
                ForEach(RBCVesselPortal.allCases) { portal in
                    Button {
                        model.togglePortal(portal.id)
                    } label: {
                        Label(portal.title, systemImage: model.openPortalIDs.contains(portal.id) ? "circle.fill" : portal.systemImage)
                    }
                    .tint(model.openPortalIDs.contains(portal.id) ? Color(red: 0.86, green: 0.12, blue: 0.22) : nil)
                    .accessibilityLabel("\(model.openPortalIDs.contains(portal.id) ? "Close" : "Open") \(portal.title) vessel lens")
                }

                Spacer()

                if model.transferredPortal != nil {
                    Button("Return to atlas", systemImage: "arrow.uturn.backward.circle.fill") {
                        model.returnToOverview()
                    }
                    .buttonStyle(.borderedProminent)
                } else if let portal = model.focusedPortal {
                    Button("Overview", systemImage: "brain.head.profile") {
                        model.returnToOverview()
                    }
                    Button("Enter \(portal.region)", systemImage: "arrow.up.left.and.arrow.down.right") {
                        model.transferToFocusedPortal()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }

            HStack(spacing: 10) {
                Label(model.portalSummary, systemImage: "hand.raised.fingers.spread")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.white.opacity(0.72))

                Spacer()

                Button(model.soundEnabled ? "Sound on" : "Sound off", systemImage: model.soundEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill") {
                    model.soundEnabled.toggle()
                }

                Button(model.showTeachingPoints ? "Labels on" : "Labels off", systemImage: model.showTeachingPoints ? "tag.fill" : "tag.slash") {
                    model.showTeachingPoints.toggle()
                }

                Label("\(model.savedLearningCount) saved", systemImage: "bookmark.fill")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.62))

                Button("Exit", systemImage: "xmark") {
                    Task { await dismissImmersiveSpace() }
                }
            }

            Text(model.handTrackingStatus)
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.44))
        }
        .padding(12)
        .frame(width: 720)
        .glassBackgroundEffect(in: .rect(cornerRadius: 20))
    }
}

struct BrainOrientationLandmarkHUD: View {
    let landmark: BrainOrientationLandmark

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(landmark.title)
                .font(.headline.weight(.semibold))
            Text(landmark.subtitle)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.68))
            Text("ORIENTATION GUIDE · SIMPLIFIED")
                .font(.system(size: 8, weight: .bold, design: .monospaced))
                .tracking(0.8)
                .foregroundStyle(Color(red: 0.50, green: 0.92, blue: 0.82).opacity(0.78))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .frame(width: 250, alignment: .leading)
        .glassBackgroundEffect(in: .rect(cornerRadius: 14))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(landmark.title). \(landmark.subtitle). Simplified orientation guide.")
    }
}
