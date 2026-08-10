import SwiftUI

private enum StrokeXrayProofRoute: String, Hashable {
    case orient
    case pressure
    case makeSpace
    case selectedPoint

    static func requested(in arguments: [String]) -> Self? {
        if arguments.contains("--proof-xray-orient") {
            return .orient
        }
        if arguments.contains("--proof-xray-make-space") {
            return .makeSpace
        }
        if arguments.contains("--proof-xray-selected-point") {
            return .selectedPoint
        }
        if arguments.contains("--proof-xray-pressure")
            || arguments.contains("--proof-xray-window") {
            // Preserve the original issue-34 route as a pressure-state alias.
            return .pressure
        }
        return nil
    }

    @MainActor
    func prepare(_ experience: StrokeExperienceState) {
        switch self {
        case .orient:
            experience.prepareProof(step: .chooseCase)
        case .pressure:
            experience.prepareProof(step: .inspectOcclusion)
        case .makeSpace:
            experience.prepareProof(step: .discussCare)
        case .selectedPoint:
            experience.prepareProcedureFieldProof()
        }
        let pointLabel = experience.selectedPointLabel ?? "none"
        print(
            "XRAY_PROOF_ROUTE=\(rawValue) "
                + "title=\(experience.journeyTitle) "
                + "point=\(pointLabel) "
                + "boundary=synthetic-not-patient"
        )
    }
}

@main
struct StrokeTimeApp: App {
    @StateObject private var experience = StrokeExperienceState()
    @State private var immersionStyle: ImmersionStyle = .progressive

    init() {
        StrokeSceneFactory.registerCustomComponents()
    }

    var body: some Scene {
        WindowGroup(id: StrokeSpace.window) {
            if let xrayProofRoute = StrokeXrayProofRoute.requested(
                in: CommandLine.arguments
            ) {
                StrokeXrayWorkspaceView()
                    .environmentObject(experience)
                    .task(id: xrayProofRoute) {
                        xrayProofRoute.prepare(experience)
                    }
            } else if CommandLine.arguments.contains("--proof-evidence-window") {
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

        WindowGroup(id: StrokeSpace.xray) {
            StrokeXrayWorkspaceView(tracksXrayWindowLifecycle: true)
                .environmentObject(experience)
        }
        .defaultSize(width: 872, height: 510)
        .windowResizability(.contentSize)
        .defaultWindowPlacement { _, context in
            if let presenter = context.windows.first(where: { $0.id == StrokeSpace.presenter }) {
                WindowPlacement(.above(presenter))
            } else if let family = context.windows.first(where: { $0.id == StrokeSpace.family }) {
                WindowPlacement(.above(family))
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
    static let xray = "stroke-shared-teaching-xray"
    static let immersive = "stroke-time-immersive"
}
