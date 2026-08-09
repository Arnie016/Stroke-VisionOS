import SwiftUI

@main
struct StrokeTimeApp: App {
    @StateObject private var experience = StrokeExperienceState()
    @State private var immersionStyle: ImmersionStyle = .progressive

    var body: some Scene {
        WindowGroup(id: StrokeSpace.window) {
            if CommandLine.arguments.contains("--proof-evidence-window") {
                StrokeEvidenceWorkspaceView()
                    .environmentObject(experience)
            } else {
                StrokeJourneyLaunchView()
                    .environmentObject(experience)
            }
        }
        .defaultSize(width: 620, height: 360)
        .windowResizability(.contentSize)

        WindowGroup(id: StrokeSpace.family) {
            StrokeJourneyCompanionView()
                .environmentObject(experience)
                .onAppear { experience.audienceLens = .family }
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

        WindowGroup(id: StrokeSpace.presenter) {
            StrokeJourneyCompanionView()
                .environmentObject(experience)
                .onAppear { experience.audienceLens = .clinician }
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

        WindowGroup(id: StrokeSpace.evidence) {
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

        ImmersiveSpace(id: StrokeSpace.immersive) {
            StrokeImmersiveView(immersionStyle: $immersionStyle)
                .environmentObject(experience)
        }
        .immersionStyle(selection: $immersionStyle, in: .mixed, .progressive, .full)
    }
}

enum StrokeSpace {
    static let window = "stroke-time-window"
    static let family = "stroke-family-questions"
    static let presenter = "stroke-presenter-rail"
    static let evidence = "stroke-clinical-evidence"
    static let immersive = "stroke-time-immersive"
}
