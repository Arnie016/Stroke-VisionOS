import SwiftUI

@main
struct StrokeTimeApp: App {
    @StateObject private var experience = StrokeExperienceState()
    @State private var immersionStyle: ImmersionStyle = .progressive

    var body: some Scene {
        WindowGroup(id: StrokeSpace.window) {
            Group {
                if experience.isImmersivePresented {
                    StrokeJourneyCompanionView()
                } else {
                    StrokeJourneyLaunchView()
                }
            }
            .environmentObject(experience)
        }
        .defaultSize(width: 820, height: 620)
        .windowResizability(.contentSize)

        ImmersiveSpace(id: StrokeSpace.immersive) {
            StrokeImmersiveView()
                .environmentObject(experience)
        }
        .immersionStyle(selection: $immersionStyle, in: .mixed, .progressive)
    }
}

enum StrokeSpace {
    static let window = "stroke-time-window"
    static let immersive = "stroke-time-immersive"
}
