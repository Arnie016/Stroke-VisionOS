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
            VStack(alignment: .leading, spacing: 9) {
                Text(flowRideActive && model.familyNarrationEnabled
                    ? model.familyNarrationProgressLabel
                    : (flowRideActive ? "RIDE  ·  ARTERIAL LUMEN" : "INSIDE  ·  \(region.shortTitle.uppercased())"))
                    .font(.caption2.monospacedDigit().weight(.bold))
                    .tracking(1.3)
                    .foregroundStyle(Color(red: 0.48, green: 0.93, blue: 0.78))

                Text(flowRideActive && model.familyNarrationEnabled
                    ? model.familyNarrationCue.title
                    : (flowRideActive
                        ? model.activeFlowRideTitle
                        : (exampleClotActive ? "One branch, interrupted" : region.title)))
                    .font(.system(size: 34, weight: .semibold, design: .rounded))

                Text(flowRideActive && model.familyNarrationEnabled
                    ? model.familyNarrationCue.caption
                    : (flowRideActive
                        ? model.activeFlowRideSubtitle
                        : (exampleClotActive
                            ? "An illustrative obstruction occupies one teaching branch. Flow light holds upstream while the surrounding arterial context stays visible."
                            : region.subtitle)))
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.82))
                    .fixedSize(horizontal: false, vertical: true)

                Label(flowRideActive
                    ? model.activeFlowRideFact
                    : (exampleClotActive
                        ? "An occlusion can reduce downstream blood delivery. Alternative routes vary between people; this scene is not measured flow or a patient scan."
                        : region.fact),
                    systemImage: flowRideActive ? "arrow.forward.circle.fill" : (exampleClotActive ? "exclamationmark.triangle.fill" : "viewfinder"))
                    .font(.footnote)
                    .foregroundStyle(exampleClotActive ? Color.orange : Color(red: 0.48, green: 0.93, blue: 0.78))
                    .fixedSize(horizontal: false, vertical: true)

                if region == .frontalLobe {
                    HStack(spacing: 7) {
                        ForEach(RBCRegionVisualizationMode.allCases) { mode in
                            RBCRegionModeButton(mode: mode, regionTitle: region.title)
                        }
                    }
                    .buttonBorderShape(.capsule)
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

                            if model.flowRideRoute == .frontal {
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
                        }
                    }
                }

                if !flowRideActive {
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
                model.regionVisualization = mode
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
                        Button {
                            model.enterRegion(destination)
                        } label: {
                            HStack(spacing: 11) {
                                ZStack {
                                    Circle()
                                        .fill(selected ? Color.pink.opacity(0.28) : Color.white.opacity(0.06))
                                    Circle()
                                        .stroke(selected ? Color.pink : Color.white.opacity(0.18), lineWidth: selected ? 2 : 1)
                                    Image(systemName: destination.systemImage)
                                        .font(.title3)
                                        .foregroundStyle(selected ? .pink : .white.opacity(0.78))
                                }
                                .frame(width: 46, height: 46)

                                VStack(alignment: .leading, spacing: 3) {
                                    Text(destination.shortTitle)
                                        .font(.subheadline.weight(.semibold))
                                        .lineLimit(1)
                                    Text(selected ? "Inside now" : "Enter region")
                                        .font(.caption2)
                                        .foregroundStyle(.white.opacity(0.48))
                                }
                                Spacer(minLength: 0)
                            }
                            .padding(10)
                            .frame(width: 180, height: 68)
                            .background(selected ? Color.pink.opacity(0.12) : Color.white.opacity(0.035), in: .rect(cornerRadius: 18))
                        }
                        .buttonStyle(.plain)
                        .hoverEffect()
                        .accessibilityLabel("Enter \(destination.title)")
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
