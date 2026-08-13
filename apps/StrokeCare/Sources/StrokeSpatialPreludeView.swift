import SwiftUI

/// A quiet, windowless-feeling threshold for the curious learner. The artwork
/// is intentionally conceptual: it introduces scales of neuroanatomy without
/// implying that it is a patient scan or a physiological measurement.
struct StrokeSpatialPreludeView: View {
    let beat: Int
    let reduceMotion: Bool

    var body: some View {
        TimelineView(.animation(minimumInterval: reduceMotion ? 1 : 1.0 / 30.0)) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            ZStack {
                Color.clear

                atmosphericField(time: time)

                Group {
                    switch beat {
                    case 0:
                        wholeBrain(time: time)
                    case 1:
                        corticalColumns(time: time)
                    case 2:
                        neuronNetwork(time: time)
                    default:
                        invitationField(time: time)
                    }
                }
                .transition(.opacity.combined(with: .scale(scale: 0.96)))
                .animation(.easeInOut(duration: reduceMotion ? 0.01 : 0.8), value: beat)
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(accessibilityDescription)
        }
    }

    private func atmosphericField(time: TimeInterval) -> some View {
        let pulse = reduceMotion ? CGFloat(1) : CGFloat(1 + sin(time * 0.35) * 0.018)
        return ZStack {
            Ellipse()
                .fill(Color.cyan.opacity(0.055))
                .frame(width: 520, height: 310)
                .blur(radius: 42)
                .offset(x: -120, y: -32)
                .offset(z: -30)
            Ellipse()
                .fill(Color.orange.opacity(0.065))
                .frame(width: 390, height: 260)
                .blur(radius: 48)
                .offset(x: 150, y: 96)
                .offset(z: -22)
        }
        .scaleEffect(pulse)
    }

    private func wholeBrain(time: TimeInterval) -> some View {
        let vesselExtent = reduceMotion
            ? CGFloat(1)
            : CGFloat(0.74 + 0.20 * ((sin(time * 0.7) + 1) / 2))
        let yaw = reduceMotion ? Double(-5) : -5 + sin(time * 0.24) * 2
        return ZStack {
            PreludeBrainShape()
                .fill(
                    LinearGradient(
                        colors: [Color.cyan.opacity(0.22), Color.indigo.opacity(0.30), Color.orange.opacity(0.13)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(PreludeBrainShape().stroke(Color.white.opacity(0.32), lineWidth: 1.2))
                .frame(width: 380, height: 270)
                .shadow(color: .cyan.opacity(0.18), radius: 30)
                .offset(z: 34)

            PreludeVesselShape()
                .trim(from: CGFloat(0), to: vesselExtent)
                .stroke(
                    LinearGradient(colors: [.orange.opacity(0.86), .pink.opacity(0.58)], startPoint: .bottom, endPoint: .top),
                    style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round)
                )
                .frame(width: 310, height: 245)
                .offset(x: 12, y: 18)
                .offset(z: 55)
        }
        .rotation3DEffect(.degrees(yaw), axis: (x: 0, y: 1, z: 0))
    }

    private func corticalColumns(time: TimeInterval) -> some View {
        HStack(alignment: .bottom, spacing: 12) {
            ForEach(0..<11, id: \.self) { index in
                PreludeCorticalColumn(
                    index: index,
                    time: time,
                    reduceMotion: reduceMotion
                )
            }
        }
        .padding(34)
        .background(Color.indigo.opacity(0.055), in: Capsule())
        .overlay(Capsule().stroke(Color.white.opacity(0.10)))
        .rotation3DEffect(.degrees(-8), axis: (x: 1, y: 0, z: 0))
        .offset(z: 42)
    }

    private func neuronNetwork(time: TimeInterval) -> some View {
        Canvas { context, size in
            let points = neuronPoints(in: size)
            var paths = Path()
            for edge in neuronEdges {
                paths.move(to: points[edge.0])
                paths.addLine(to: points[edge.1])
            }
            context.stroke(paths, with: .color(.cyan.opacity(0.27)), lineWidth: 1.4)

            for (index, point) in points.enumerated() {
                let pulse = reduceMotion ? 0 : (sin(time * 1.55 + Double(index) * 0.72) + 1) / 2
                let radius = 5.5 + pulse * 3.2
                let rect = CGRect(x: point.x - radius, y: point.y - radius, width: radius * 2, height: radius * 2)
                context.fill(
                    Path(ellipseIn: rect),
                    with: .color(index.isMultiple(of: 4) ? .orange.opacity(0.82) : .cyan.opacity(0.72))
                )
                context.stroke(Path(ellipseIn: rect.insetBy(dx: -5, dy: -5)), with: .color(.white.opacity(0.10 + pulse * 0.12)), lineWidth: 1)
            }
        }
        .frame(width: 470, height: 280)
        .offset(z: 48)
        .shadow(color: .cyan.opacity(0.18), radius: 18)
    }

    private func invitationField(time: TimeInterval) -> some View {
        ZStack {
            ForEach(0..<4, id: \.self) { index in
                Circle()
                    .stroke(
                        index.isMultiple(of: 2) ? Color.cyan.opacity(0.22) : Color.orange.opacity(0.20),
                        lineWidth: 1.2
                    )
                    .frame(width: 150 + CGFloat(index) * 62, height: 150 + CGFloat(index) * 62)
                    .scaleEffect(reduceMotion ? 1 : 0.97 + CGFloat(sin(time * 0.55 + Double(index))) * 0.025)
                    .offset(z: Double(index) * 13)
            }

            Image(systemName: "brain.fill")
                .font(.system(size: 98, weight: .ultraLight))
                .symbolRenderingMode(.palette)
                .foregroundStyle(.orange.opacity(0.72), .cyan.opacity(0.38))
                .shadow(color: .orange.opacity(0.20), radius: 26)
                .offset(z: 72)
        }
    }

    private var accessibilityDescription: String {
        switch beat {
        case 0: "Conceptual whole brain and branching vessel pathways"
        case 1: "Conceptual cortical columns arranged as a connected field"
        case 2: "Conceptual neurons forming a signalling network"
        default: "A brain surrounded by expanding circles, inviting exploration"
        }
    }

    private func neuronPoints(in size: CGSize) -> [CGPoint] {
        [
            CGPoint(x: size.width * 0.10, y: size.height * 0.48),
            CGPoint(x: size.width * 0.23, y: size.height * 0.24),
            CGPoint(x: size.width * 0.31, y: size.height * 0.69),
            CGPoint(x: size.width * 0.45, y: size.height * 0.42),
            CGPoint(x: size.width * 0.56, y: size.height * 0.16),
            CGPoint(x: size.width * 0.61, y: size.height * 0.73),
            CGPoint(x: size.width * 0.76, y: size.height * 0.39),
            CGPoint(x: size.width * 0.88, y: size.height * 0.63),
            CGPoint(x: size.width * 0.90, y: size.height * 0.20)
        ]
    }

    private var neuronEdges: [(Int, Int)] {
        [(0, 1), (0, 2), (1, 3), (2, 3), (3, 4), (3, 5), (4, 6), (5, 6), (6, 7), (6, 8)]
    }
}

private struct PreludeCorticalColumn: View {
    let index: Int
    let time: TimeInterval
    let reduceMotion: Bool

    var body: some View {
        let phase = time * 1.15 + Double(index) * 0.52
        let wave: Double = reduceMotion ? 0 : sin(phase)
        let baseHeight = Double(112 + (index % 4) * 18)
        let resolvedHeight = CGFloat(baseHeight + wave * 8)
        let waveOffset = CGFloat(wave * -4)
        let depth = Double(index % 3) * 13
        Capsule()
            .fill(
                LinearGradient(
                    colors: [Color.cyan.opacity(0.28), Color.indigo.opacity(0.62), Color.orange.opacity(0.34)],
                    startPoint: .bottom,
                    endPoint: .top
                )
            )
            .frame(width: 22, height: resolvedHeight)
            .overlay(Capsule().stroke(Color.white.opacity(0.22), lineWidth: 0.8))
            .offset(y: waveOffset)
            .offset(z: depth)
    }
}

private struct PreludeBrainShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.52, y: rect.minY + rect.height * 0.10))
        path.addCurve(
            to: CGPoint(x: rect.minX + rect.width * 0.12, y: rect.minY + rect.height * 0.48),
            control1: CGPoint(x: rect.minX + rect.width * 0.28, y: rect.minY - rect.height * 0.02),
            control2: CGPoint(x: rect.minX + rect.width * 0.06, y: rect.minY + rect.height * 0.20)
        )
        path.addCurve(
            to: CGPoint(x: rect.minX + rect.width * 0.48, y: rect.maxY - rect.height * 0.08),
            control1: CGPoint(x: rect.minX + rect.width * 0.04, y: rect.minY + rect.height * 0.77),
            control2: CGPoint(x: rect.minX + rect.width * 0.27, y: rect.maxY)
        )
        path.addCurve(
            to: CGPoint(x: rect.maxX - rect.width * 0.08, y: rect.minY + rect.height * 0.48),
            control1: CGPoint(x: rect.minX + rect.width * 0.79, y: rect.maxY),
            control2: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.78)
        )
        path.addCurve(
            to: CGPoint(x: rect.minX + rect.width * 0.52, y: rect.minY + rect.height * 0.10),
            control1: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.19),
            control2: CGPoint(x: rect.minX + rect.width * 0.76, y: rect.minY - rect.height * 0.02)
        )
        path.closeSubpath()
        return path
    }
}

private struct PreludeVesselShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let base = CGPoint(x: rect.midX, y: rect.maxY)
        let center = CGPoint(x: rect.midX, y: rect.midY * 1.10)
        path.move(to: base)
        path.addCurve(to: center, control1: CGPoint(x: rect.midX - 8, y: rect.maxY * 0.78), control2: CGPoint(x: rect.midX + 8, y: rect.maxY * 0.64))
        path.addCurve(to: CGPoint(x: rect.width * 0.26, y: rect.height * 0.20), control1: CGPoint(x: rect.width * 0.43, y: rect.height * 0.40), control2: CGPoint(x: rect.width * 0.34, y: rect.height * 0.28))
        path.move(to: center)
        path.addCurve(to: CGPoint(x: rect.width * 0.76, y: rect.height * 0.17), control1: CGPoint(x: rect.width * 0.59, y: rect.height * 0.38), control2: CGPoint(x: rect.width * 0.68, y: rect.height * 0.27))
        path.move(to: CGPoint(x: rect.width * 0.41, y: rect.height * 0.44))
        path.addCurve(to: CGPoint(x: rect.width * 0.18, y: rect.height * 0.48), control1: CGPoint(x: rect.width * 0.34, y: rect.height * 0.42), control2: CGPoint(x: rect.width * 0.25, y: rect.height * 0.45))
        path.move(to: CGPoint(x: rect.width * 0.60, y: rect.height * 0.39))
        path.addCurve(to: CGPoint(x: rect.width * 0.88, y: rect.height * 0.45), control1: CGPoint(x: rect.width * 0.70, y: rect.height * 0.37), control2: CGPoint(x: rect.width * 0.80, y: rect.height * 0.41))
        return path
    }
}
