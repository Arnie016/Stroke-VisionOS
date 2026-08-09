import SwiftUI

private struct RBCPreludeChapterText: View {
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
            withAnimation(.easeOut(duration: 1.15)) {
                settled = true
            }
        }
    }
}

struct RBCEntryPreludeHUD: View {
    @Environment(RBCJourneyModel.self) private var model

    var body: some View {
        VStack(spacing: 26) {
            RBCPreludeChapterText(chapter: model.entryPreludeChapter)
                .id(model.entryPreludeChapter.id)

            HStack(spacing: 12) {
                if model.entryPreludeChapter != .threshold {
                    Button("Back", systemImage: "chevron.left") {
                        withAnimation(.easeInOut(duration: 0.45)) {
                            if let previous = RBCEntryPreludeChapter(rawValue: model.entryPreludeChapter.rawValue - 1) {
                                model.entryPreludeChapter = previous
                            }
                        }
                    }
                }

                Button(model.entryPreludeChapter.actionTitle, systemImage: model.entryPreludeChapter == .invitation ? "arrow.down.right.and.arrow.up.left" : "arrow.right") {
                    withAnimation(.easeInOut(duration: 0.55)) {
                        model.advanceEntryPrelude()
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(red: 0.86, green: 0.12, blue: 0.22))

                Button("Skip", systemImage: "forward.end") {
                    withAnimation(.easeInOut(duration: 0.45)) {
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
                withAnimation(.easeInOut(duration: 0.22)) {
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
            VStack(alignment: .leading, spacing: 9) {
                Text(flowRideActive && model.familyNarrationEnabled
                    ? model.familyNarrationProgressLabel
                    : (flowRideActive
                        ? "RIDE  ·  ARTERIAL LUMEN"
                        : (regionCompanionActive
                            ? "FAMILY COMPANION  ·  \(region.shortTitle.uppercased())"
                            : "INSIDE  ·  \(region.shortTitle.uppercased())")))
                    .font(.caption2.monospacedDigit().weight(.bold))
                    .tracking(1.3)
                    .foregroundStyle(Color(red: 0.48, green: 0.93, blue: 0.78))

                Text(flowRideActive && model.familyNarrationEnabled
                    ? model.familyNarrationCue.title
                    : (flowRideActive
                        ? model.activeFlowRideTitle
                        : (willisRouteActive
                            ? model.activeWillisTitle
                            : (cerebellumActive
                                ? model.activeCerebellumTitle
                                : (deepStructuresActive
                                    ? model.activeDeepStructuresTitle
                                    : (occipitalActive
                                        ? model.activeOccipitalTitle
                                        : (brainstemActive
                                            ? model.activeBrainstemTitle
                                            : (exampleClotActive ? "One branch, interrupted" : region.title))))))))
                    .font(.system(size: 34, weight: .semibold, design: .rounded))

                Text(flowRideActive && model.familyNarrationEnabled
                    ? model.familyNarrationCue.caption
                    : (flowRideActive
                        ? model.activeFlowRideSubtitle
                        : (willisRouteActive
                            ? model.activeWillisSubtitle
                            : (cerebellumActive
                                ? model.activeCerebellumSubtitle
                                : (deepStructuresActive
                                    ? model.activeDeepStructuresSubtitle
                                    : (occipitalActive
                                        ? model.activeOccipitalSubtitle
                                        : (brainstemActive
                                            ? model.activeBrainstemSubtitle
                                            : (exampleClotActive
                                                ? "An illustrative obstruction occupies one teaching branch. Flow light holds upstream while the surrounding arterial context stays visible."
                                                : region.subtitle))))))))
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.82))
                    .fixedSize(horizontal: false, vertical: true)

                Label(flowRideActive
                    ? model.activeFlowRideFact
                    : (willisRouteActive
                        ? model.activeWillisFact
                        : (cerebellumActive
                            ? model.activeCerebellumFact
                            : (deepStructuresActive
                                ? model.activeDeepStructuresFact
                                : (occipitalActive
                                    ? model.activeOccipitalFact
                                    : (brainstemActive
                                        ? model.activeBrainstemFact
                                        : (exampleClotActive
                                            ? "An occlusion can reduce downstream blood delivery. Alternative routes vary between people; this scene is not measured flow or a patient scan."
                                            : region.fact)))))),
                    systemImage: flowRideActive ? "arrow.forward.circle.fill" : (exampleClotActive ? "exclamationmark.triangle.fill" : "viewfinder"))
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
                                        withAnimation(.easeInOut(duration: 0.42)) {
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
                                    withAnimation(.easeInOut(duration: 0.32)) {
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
                                withAnimation(.easeInOut(duration: 0.42)) {
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
                                        withAnimation(.easeInOut(duration: 0.42)) {
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
                                    withAnimation(.easeInOut(duration: 0.32)) {
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
                            withAnimation(.easeInOut(duration: 0.42)) {
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
                            withAnimation(.easeInOut(duration: 0.28)) {
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
                        HStack(spacing: 7) {
                            if model.isFlowRideActive {
                                Button(model.isPaused ? "Resume ride" : "Pause ride", systemImage: model.isPaused ? "play.fill" : "pause.fill") {
                                    model.isPaused.toggle()
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(model.isPaused ? .orange : Color(red: 0.23, green: 0.67, blue: 0.60))

                                Button("Leave branch", systemImage: "arrow.uturn.backward") {
                                    model.stopFlowRide()
                                }
                                .buttonStyle(.bordered)

                                Button("Exit", systemImage: "xmark") {
                                    Task { await dismissImmersiveSpace() }
                                }
                                .buttonStyle(.bordered)
                            } else {
                                Button("Ride with flow", systemImage: "arrow.forward.circle.fill") {
                                    model.startFlowRide()
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(Color(red: 0.23, green: 0.67, blue: 0.60))
                            }
                        }
                        .buttonBorderShape(.capsule)

                        if model.isFlowRideActive {
                            HStack(spacing: 7) {
                                ForEach(RBCFlowRideRoute.allCases) { route in
                                    let selected = model.flowRideRoute == route
                                    Button(route.shortTitle, systemImage: route.systemImage) {
                                        model.selectFlowRideRoute(route)
                                    }
                                    .font(.caption.weight(.semibold))
                                    .buttonStyle(.bordered)
                                    .tint(selected
                                        ? (route == .frontal
                                            ? Color(red: 0.92, green: 0.20, blue: 0.28)
                                            : Color(red: 0.23, green: 0.67, blue: 0.60))
                                        : .white.opacity(0.30))
                                    .accessibilityLabel("Show \(route.shortTitle.lowercased()) inside the arterial fork")
                                }
                            }
                            .buttonBorderShape(.capsule)

                            if model.flowRideRoute == .frontal && !model.familyNarrationEnabled {
                                Button(
                                    model.isCapillaryFieldFocused ? "Return to artery" : "Enter capillary field",
                                    systemImage: model.isCapillaryFieldFocused
                                        ? "arrow.down.right.and.arrow.up.left"
                                        : "circle.hexagongrid.fill"
                                ) {
                                    model.toggleCapillaryFieldFocus()
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(model.isCapillaryFieldFocused
                                    ? Color(red: 0.72, green: 0.17, blue: 0.28)
                                    : Color(red: 0.90, green: 0.34, blue: 0.30))
                                .accessibilityLabel(model.isCapillaryFieldFocused
                                    ? "Return from the illustrative capillary field to the artery"
                                    : "Expand the illustrative capillary field around you")
                            }

                            HStack(spacing: 8) {
                                Button(
                                    model.familyNarrationEnabled ? "End guide" : "Family guide",
                                    systemImage: model.familyNarrationEnabled ? "waveform.slash" : "waveform"
                                ) {
                                    model.toggleFamilyNarration()
                                }
                                .buttonStyle(.bordered)
                                .tint(model.familyNarrationEnabled ? Color.indigo : nil)
                                .accessibilityLabel(model.familyNarrationEnabled
                                    ? "Turn off the optional family narration"
                                    : "Start the optional three-part family guide")

                                Text(model.familyNarrationConfigured
                                    ? "Voice follows the matching caption."
                                    : "Captions work now; connect the local guide for voice.")
                                    .font(.caption2)
                                    .foregroundStyle(.white.opacity(0.62))

                                if model.familyNarrationEnabled {
                                    HStack(spacing: 4) {
                                        ForEach(RBCFamilyNarrationMoment.allCases) { moment in
                                            Capsule()
                                                .fill(moment.rawValue <= model.familyNarrationMoment.rawValue
                                                    ? Color.indigo
                                                    : Color.white.opacity(0.16))
                                                .frame(width: 13, height: 3)
                                        }
                                    }
                                    .accessibilityLabel(model.familyNarrationProgressLabel)
                                }
                            }

                            if model.familyNarrationEnabled {
                                HStack(spacing: 8) {
                                    Spacer(minLength: 0)

                                    Button("Hear again", systemImage: "arrow.counterclockwise") {
                                        model.replayFamilyNarration()
                                    }
                                    .font(.caption.weight(.semibold))
                                    .buttonStyle(.bordered)
                                    .disabled(!model.familyNarrationConfigured)
                                    .accessibilityLabel("Hear the current family explanation again")

                                    if model.familyNarrationMoment != .arrival {
                                        Button(
                                            model.familyNarrationAdvanceTitle,
                                            systemImage: model.familyNarrationAdvanceTitle == "Enter field"
                                                ? "circle.hexagongrid.fill"
                                                : "arrow.right"
                                        ) {
                                            model.advanceFamilyNarration()
                                        }
                                        .font(.caption.weight(.semibold))
                                        .buttonStyle(.borderedProminent)
                                        .tint(Color.indigo)
                                        .disabled(model.familyNarrationProofLocked)
                                        .accessibilityLabel(model.familyNarrationAdvanceTitle == "Enter field"
                                            ? "Enter the capillary field and hear why this arrival matters"
                                            : "Move to the next family explanation")
                                    }
                                }
                            }
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

private struct RBCRegionModeButton: View {
    @Environment(RBCJourneyModel.self) private var model
    let mode: RBCRegionVisualizationMode
    let regionTitle: String

    var body: some View {
        let selected = mode == model.regionVisualization
        Button {
            withAnimation(.easeInOut(duration: 0.28)) {
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
            withAnimation(.easeInOut(duration: 0.34)) {
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
