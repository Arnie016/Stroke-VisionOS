import SwiftUI

@main
struct StrokeTimeApp: App {
    @StateObject private var experience = StrokeExperienceState()
    @State private var internalJourney = RBCJourneyModel()
    @State private var immersionStyle: ImmersionStyle = .progressive

    init() {
        StrokeSceneFactory.registerCustomComponents()
    }

    var body: some Scene {
        WindowGroup(id: StrokeSpace.window) {
            if CommandLine.arguments.contains("--proof-evidence-window") {
                StrokeEvidenceWorkspaceView()
                    .environmentObject(experience)
            } else if CommandLine.arguments.contains("--proof-imaging-window")
                        || CommandLine.arguments.contains("--proof-imaging-window-term-note")
                        || CommandLine.arguments.contains("--proof-imaging-ct")
                        || CommandLine.arguments.contains("--proof-imaging-mri") {
                StrokeTeachingImagingWorkspaceView()
                    .environmentObject(experience)
                    .onAppear { experience.prepareTeachingImagingProof() }
            } else if CommandLine.arguments.contains("--proof-print-request") {
                StrokeTeachingModelPrintRequestView(closeWindowID: StrokeSpace.window)
            } else {
                StrokeJourneyLaunchView()
                    .environmentObject(experience)
            }
        }
        .defaultSize(
            width: CommandLine.arguments.contains("--proof-print-request") ? 900 : 820,
            height: CommandLine.arguments.contains("--proof-print-request") ? 680 : 520
        )
        .windowResizability(.contentSize)
        .windowStyle(.plain)

        // Auxiliary workspaces are keyed to one stable value. Reopening one
        // brings the same window forward instead of leaving duplicate panels
        // around the room, while retaining the visionOS 2 deployment target.
        // They reflect the role already chosen at the launch threshold and
        // must not rewrite it during scene restoration.
        WindowGroup(id: StrokeSpace.family, for: String.self) { _ in
            StrokeJourneyCompanionView()
                .environmentObject(experience)
        }
        .defaultSize(width: 460, height: 310)
        .windowResizability(.contentSize)
        .defaultWindowPlacement { _, context in
            if let workspace = context.windows.first(where: { $0.id == StrokeSpace.window }) {
                WindowPlacement(.leading(workspace))
            } else {
                WindowPlacement(.utilityPanel)
            }
        }

        WindowGroup(id: StrokeSpace.presenter, for: String.self) { _ in
            StrokeJourneyCompanionView()
                .environmentObject(experience)
        }
        .defaultSize(width: 460, height: 560)
        .windowResizability(.contentSize)
        .defaultWindowPlacement { _, context in
            if let workspace = context.windows.first(where: { $0.id == StrokeSpace.window }) {
                WindowPlacement(.trailing(workspace))
            } else {
                WindowPlacement(.utilityPanel)
            }
        }

        WindowGroup(id: StrokeSpace.evidence, for: String.self) { _ in
            StrokeEvidenceWorkspaceView()
                .environmentObject(experience)
        }
        .defaultSize(width: 900, height: 480)
        .windowResizability(.contentSize)
        .defaultWindowPlacement { _, context in
            if let presenter = context.windows.first(where: { $0.id == StrokeSpace.presenter }) {
                WindowPlacement(.above(presenter))
            } else {
                WindowPlacement(.utilityPanel)
            }
        }

        // This generic 2D reference remains independently placeable without
        // multiplying every time the clinician reopens it.
        WindowGroup(id: StrokeSpace.imaging, for: String.self) { _ in
            StrokeTeachingImagingWorkspaceView()
                .environmentObject(experience)
        }
        .defaultSize(width: 600, height: 470)
        .windowResizability(.contentSize)

        WindowGroup(id: StrokeSpace.printRequest, for: String.self) { _ in
            StrokeTeachingModelPrintRequestView(closeWindowID: StrokeSpace.printRequest)
        }
        .defaultSize(width: 900, height: 680)
        .windowResizability(.contentSize)

        ImmersiveSpace(id: StrokeSpace.immersive) {
            StrokeImmersiveView(immersionStyle: $immersionStyle)
                .environmentObject(experience)
                .environment(internalJourney)
        }
        .immersionStyle(selection: $immersionStyle, in: .mixed, .progressive, .full)
    }
}

enum StrokeSpace {
    static let window = "stroke-time-window"
    static let family = "stroke-family-questions"
    static let presenter = "stroke-presenter-rail"
    static let evidence = "stroke-clinical-evidence"
    static let imaging = "stroke-teaching-imaging"
    static let printRequest = "stroke-teaching-model-print-request"
    static let immersive = "stroke-time-immersive"
}
