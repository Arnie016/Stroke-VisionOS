import SwiftUI

/// A shared schematic radiograph for the current teaching state. This is a
/// communication surface, not a patient scan, diagnostic image, or clinical
/// measurement. Both audience roles open this same window and therefore see
/// the same act, layer presentation, opacity, lesson field, and selected point.
struct StrokeXrayWorkspaceView: View {
    @EnvironmentObject private var experience: StrokeExperienceState
    @Environment(\.dismissWindow) private var dismissWindow

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.025, green: 0.045, blue: 0.060),
                    Color(red: 0.010, green: 0.014, blue: 0.022)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 16) {
                header

                HStack(alignment: .top, spacing: 18) {
                    StrokeTeachingRadiograph()
                        .environmentObject(experience)
                        .frame(width: 540, height: 392)

                    teachingState
                        .frame(width: 270, height: 392, alignment: .top)
                }
            }
            .padding(22)
        }
        .frame(width: 872, height: 510)
    }

    private var header: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.cyan.opacity(0.13))
                    .frame(width: 42, height: 42)
                Image(systemName: "viewfinder")
                    .foregroundStyle(.cyan)
                    .font(.headline)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text("SHARED TEACHING X-RAY")
                    .font(.headline.weight(.bold))
                    .tracking(1.2)
                Text("Schematic teaching radiograph · not a patient scan")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Label("SYNCHRONIZED", systemImage: "arrow.triangle.2.circlepath")
                .font(.caption2.weight(.bold))
                .foregroundStyle(.cyan)
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(Color.cyan.opacity(0.09), in: Capsule())

            Button {
                dismissWindow(id: StrokeSpace.xray)
            } label: {
                Image(systemName: "xmark")
                    .frame(width: 28, height: 28)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.secondary)
            .accessibilityLabel("Close teaching X-ray")
        }
    }

    private var teachingState: some View {
        VStack(alignment: .leading, spacing: 13) {
            stateCard(
                label: "ACT \(experience.procedureStep.number)",
                value: experience.journeyTitle,
                detail: experience.journeyIntent,
                systemImage: "timeline.selection",
                tint: .orange
            )

            stateCard(
                label: "LAYER VIEW",
                value: experience.anatomyPresentation.rawValue,
                detail: "Cortex opacity \(Int((experience.cortexOpacity * 100).rounded()))%",
                systemImage: "square.3.layers.3d",
                tint: .cyan
            )

            stateCard(
                label: "LESSON FIELD",
                value: experience.pointField.rawValue,
                detail: experience.selectedPointLabel ?? "No teaching point selected",
                systemImage: experience.pointField.systemImage,
                tint: .mint
            )

            Spacer(minLength: 0)

            Label("Educational schematic only", systemImage: "checkmark.shield")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            Text("It does not display uploaded imaging, infer a diagnosis, or represent this fictional case as a real radiograph.")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 22))
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(Color.white.opacity(0.09)))
    }

    private func stateCard(
        label: String,
        value: String,
        detail: String,
        systemImage: String,
        tint: Color
    ) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Label(label, systemImage: systemImage)
                .font(.caption2.weight(.bold))
                .tracking(0.9)
                .foregroundStyle(tint)
            Text(value)
                .font(.headline)
            Text(detail)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(tint.opacity(0.07), in: RoundedRectangle(cornerRadius: 15))
    }
}

private struct StrokeTeachingRadiograph: View {
    @EnvironmentObject private var experience: StrokeExperienceState

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            let plate = CGRect(x: 22, y: 22, width: size.width - 44, height: size.height - 44)
            let selectedPoint = selectedPointPosition(in: plate)

            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.black.opacity(0.64))

                Path { path in
                    path.addRoundedRect(in: plate, cornerSize: CGSize(width: 20, height: 20))
                }
                .stroke(Color.cyan.opacity(0.16), lineWidth: 1)

                skullPath(in: plate)
                    .stroke(
                        Color.white.opacity(0.62),
                        style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round)
                    )
                    .shadow(color: .cyan.opacity(0.32), radius: 10)

                brainPath(in: plate)
                    .fill(Color.cyan.opacity(brainOpacity))
                    .overlay {
                        brainPath(in: plate)
                            .stroke(Color.cyan.opacity(0.44), lineWidth: 1.5)
                    }

                midlinePath(in: plate)
                    .stroke(Color.white.opacity(0.24), style: StrokeStyle(lineWidth: 1.4, dash: [6, 7]))

                vesselPath(in: plate)
                    .stroke(
                        Color.orange.opacity(experience.pointField == .procedure ? 0.92 : 0.48),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round)
                    )
                    .shadow(color: .orange.opacity(0.36), radius: 7)

                affectedTerritory(in: plate)
                    .fill(affectedTint.opacity(affectedOpacity))
                    .blur(radius: experience.procedureStep == .chooseCase ? 2 : 7)

                Circle()
                    .fill(Color.orange)
                    .frame(width: 15, height: 15)
                    .overlay(Circle().stroke(Color.white.opacity(0.84), lineWidth: 2))
                    .shadow(color: .orange.opacity(0.8), radius: 9)
                    .position(x: plate.midX + plate.width * 0.11, y: plate.midY - plate.height * 0.04)

                if experience.lessonPointsVisible, experience.selectedPointLabel != nil {
                    Circle()
                        .stroke(Color.mint, lineWidth: 3)
                        .frame(width: 28, height: 28)
                        .shadow(color: .mint.opacity(0.72), radius: 8)
                        .position(selectedPoint)
                }

                VStack {
                    HStack {
                        Text("AP")
                        Spacer()
                        Text("SCHEMATIC")
                    }
                    Spacer()
                    HStack {
                        Text("L")
                        Spacer()
                        Text("R")
                    }
                }
                .font(.caption2.monospaced().weight(.bold))
                .foregroundStyle(Color.white.opacity(0.42))
                .padding(36)
            }
            .overlay(alignment: .bottomLeading) {
                HStack(spacing: 7) {
                    Circle()
                        .fill(affectedTint)
                        .frame(width: 8, height: 8)
                    Text(radiographCaption)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.78))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.ultraThinMaterial, in: Capsule())
                .padding(14)
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Schematic teaching radiograph synchronized to \(experience.journeyTitle), \(experience.anatomyPresentation.rawValue), and \(experience.pointField.rawValue)")
        }
    }

    private var brainOpacity: Double {
        switch experience.anatomyPresentation {
        case .assembled: 0.12
        case .transparent: max(0.06, experience.cortexOpacity * 0.34)
        case .exploded: max(0.10, experience.cortexOpacity * 0.45)
        }
    }

    private var affectedTint: Color {
        switch experience.procedureStep {
        case .chooseCase: .cyan
        case .inspectOcclusion: .orange
        case .discussCare: .mint
        }
    }

    private var affectedOpacity: Double {
        switch experience.procedureStep {
        case .chooseCase: 0.14
        case .inspectOcclusion: 0.34
        case .discussCare: 0.22
        }
    }

    private var radiographCaption: String {
        switch experience.procedureStep {
        case .chooseCase: "Orient to the whole generic model"
        case .inspectOcclusion: "Separate blockage, affected area, and swelling"
        case .discussCare: "Making room does not restore injured tissue"
        }
    }

    private func skullPath(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.08))
            path.addCurve(
                to: CGPoint(x: rect.minX + rect.width * 0.16, y: rect.midY),
                control1: CGPoint(x: rect.minX + rect.width * 0.24, y: rect.minY + rect.height * 0.04),
                control2: CGPoint(x: rect.minX + rect.width * 0.13, y: rect.minY + rect.height * 0.28)
            )
            path.addCurve(
                to: CGPoint(x: rect.midX, y: rect.maxY - rect.height * 0.08),
                control1: CGPoint(x: rect.minX + rect.width * 0.13, y: rect.maxY - rect.height * 0.26),
                control2: CGPoint(x: rect.minX + rect.width * 0.28, y: rect.maxY - rect.height * 0.03)
            )
            path.addCurve(
                to: CGPoint(x: rect.maxX - rect.width * 0.16, y: rect.midY),
                control1: CGPoint(x: rect.maxX - rect.width * 0.28, y: rect.maxY - rect.height * 0.03),
                control2: CGPoint(x: rect.maxX - rect.width * 0.13, y: rect.maxY - rect.height * 0.26)
            )
            path.addCurve(
                to: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.08),
                control1: CGPoint(x: rect.maxX - rect.width * 0.13, y: rect.minY + rect.height * 0.28),
                control2: CGPoint(x: rect.maxX - rect.width * 0.24, y: rect.minY + rect.height * 0.04)
            )
        }
    }

    private func brainPath(in rect: CGRect) -> Path {
        let inset = rect.insetBy(dx: rect.width * 0.19, dy: rect.height * 0.13)
        return Path(ellipseIn: inset)
    }

    private func midlinePath(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.17))
            path.addCurve(
                to: CGPoint(x: rect.midX, y: rect.maxY - rect.height * 0.16),
                control1: CGPoint(x: rect.midX - 10, y: rect.midY - 34),
                control2: CGPoint(x: rect.midX + 10, y: rect.midY + 34)
            )
        }
    }

    private func vesselPath(in rect: CGRect) -> Path {
        Path { path in
            let origin = CGPoint(x: rect.midX, y: rect.maxY - rect.height * 0.20)
            path.move(to: origin)
            path.addCurve(
                to: CGPoint(x: rect.midX + rect.width * 0.11, y: rect.midY - rect.height * 0.04),
                control1: CGPoint(x: rect.midX - rect.width * 0.03, y: rect.midY + rect.height * 0.24),
                control2: CGPoint(x: rect.midX + rect.width * 0.03, y: rect.midY + rect.height * 0.05)
            )
            path.addCurve(
                to: CGPoint(x: rect.maxX - rect.width * 0.24, y: rect.minY + rect.height * 0.29),
                control1: CGPoint(x: rect.midX + rect.width * 0.20, y: rect.midY - rect.height * 0.11),
                control2: CGPoint(x: rect.maxX - rect.width * 0.28, y: rect.minY + rect.height * 0.36)
            )
            path.move(to: CGPoint(x: rect.midX + rect.width * 0.08, y: rect.midY + rect.height * 0.01))
            path.addCurve(
                to: CGPoint(x: rect.minX + rect.width * 0.28, y: rect.minY + rect.height * 0.34),
                control1: CGPoint(x: rect.midX - rect.width * 0.05, y: rect.midY - rect.height * 0.12),
                control2: CGPoint(x: rect.minX + rect.width * 0.34, y: rect.minY + rect.height * 0.40)
            )
        }
    }

    private func affectedTerritory(in rect: CGRect) -> Path {
        let territory = CGRect(
            x: rect.midX + rect.width * 0.02,
            y: rect.minY + rect.height * 0.20,
            width: rect.width * 0.29,
            height: rect.height * 0.43
        )
        return Path(ellipseIn: territory)
    }

    private func selectedPointPosition(in rect: CGRect) -> CGPoint {
        guard let name = experience.selectedPointEntityName,
              let suffix = name.split(separator: "-").last,
              let index = Int(suffix)
        else {
            return CGPoint(x: rect.midX, y: rect.midY)
        }

        let positions: [CGPoint] = experience.pointField == .regions
            ? [
                CGPoint(x: rect.midX + rect.width * 0.17, y: rect.midY - rect.height * 0.12),
                CGPoint(x: rect.midX - rect.width * 0.13, y: rect.midY - rect.height * 0.06),
                CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.24),
                CGPoint(x: rect.midX - rect.width * 0.19, y: rect.midY + rect.height * 0.12)
            ]
            : [
                CGPoint(x: rect.midX - rect.width * 0.03, y: rect.maxY - rect.height * 0.24),
                CGPoint(x: rect.midX + rect.width * 0.05, y: rect.midY + rect.height * 0.05),
                CGPoint(x: rect.midX + rect.width * 0.11, y: rect.midY - rect.height * 0.04),
                CGPoint(x: rect.midX + rect.width * 0.22, y: rect.midY - rect.height * 0.15),
                CGPoint(x: rect.midX + rect.width * 0.19, y: rect.minY + rect.height * 0.27)
            ]

        return positions.indices.contains(index) ? positions[index] : CGPoint(x: rect.midX, y: rect.midY)
    }
}
