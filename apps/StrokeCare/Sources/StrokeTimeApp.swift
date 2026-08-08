import SwiftUI

@main
struct StrokeTimeApp: App {
    @StateObject private var experience = StrokeExperienceState()
    @State private var immersionStyle: ImmersionStyle = .progressive

    var body: some Scene {
        WindowGroup(id: StrokeSpace.window) {
            StrokeJourneyLaunchView()
                .environmentObject(experience)
        }
        .defaultSize(width: 900, height: 620)
        .windowResizability(.contentSize)

        WindowGroup(id: StrokeSpace.family) {
            StrokeJourneyCompanionView()
                .environmentObject(experience)
                .onAppear { experience.audienceLens = .family }
        }
        .defaultSize(width: 600, height: 360)
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
        .defaultSize(width: 540, height: 660)
        .windowResizability(.contentSize)
        .defaultWindowPlacement { _, context in
            if let workspace = context.windows.first(where: { $0.id == StrokeSpace.window }) {
                WindowPlacement(.trailing(workspace))
            } else {
                WindowPlacement(.utilityPanel)
            }
        }

        ImmersiveSpace(id: StrokeSpace.immersive) {
            StrokeImmersiveView()
                .environmentObject(experience)
        }
        .immersionStyle(selection: $immersionStyle, in: .mixed, .progressive)
    }
}

enum StrokeSpace {
    static let window = "stroke-time-window"
    static let family = "stroke-family-questions"
    static let presenter = "stroke-presenter-rail"
    static let immersive = "stroke-time-immersive"
}
