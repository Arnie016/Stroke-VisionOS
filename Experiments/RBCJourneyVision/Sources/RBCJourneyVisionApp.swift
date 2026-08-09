import SwiftUI

@main
struct RBCJourneyVisionApp: App {
    @State private var model = RBCJourneyModel()
    @State private var immersionStyle: ImmersionStyle = .full

    var body: some Scene {
        WindowGroup(id: RBCJourneyModel.trailheadID) {
            RBCJourneyTrailheadView()
                .environment(model)
        }
        .windowResizability(.contentSize)

        ImmersiveSpace(id: RBCJourneyModel.immersiveID) {
            RBCJourneyImmersiveView()
                .environment(model)
        }
        .immersionStyle(selection: $immersionStyle, in: .full)
    }
}
