import SwiftUI

/// A fictional case chronology for the intake room. This is intentionally
/// separate from the three-act anatomy lesson: it helps a clinician and family
/// establish what is known before the shared brain explanation begins.
enum StrokeCaseHistoryMilestone: String, CaseIterable, Identifiable {
    case everydayContext
    case reportedChange
    case teamReview
    case sharedQuestions

    var id: String { rawValue }

    var timeLabel: String {
        switch self {
        case .everydayContext: "BEFORE TODAY"
        case .reportedChange: "70 MIN AGO"
        case .teamReview: "NOW"
        case .sharedQuestions: "NEXT"
        }
    }

    var shortTitle: String {
        switch self {
        case .everydayContext: "Everyday life"
        case .reportedChange: "Change reported"
        case .teamReview: "Pictures reviewed"
        case .sharedQuestions: "Talk together"
        }
    }

    var systemImage: String {
        switch self {
        case .everydayContext: "person.fill"
        case .reportedChange: "waveform.path.ecg"
        case .teamReview: "photo.on.rectangle.angled"
        case .sharedQuestions: "bubble.left.and.bubble.right.fill"
        }
    }

    /// Family copy remains a question, not a conclusion about the fictional
    /// scenario or a prompt to choose a treatment.
    var familyQuestion: String {
        switch self {
        case .everydayContext: "What was everyday life like before this?"
        case .reportedChange: "When were speech and arm changes first noticed?"
        case .teamReview: "What do the reviewed pictures show—and not show?"
        case .sharedQuestions: "What is known, uncertain, and happening next?"
        }
    }

    /// Presenter cues organize a conversation. They are not findings,
    /// eligibility logic, or a substitute for the treating team's record.
    var presenterCue: String {
        switch self {
        case .everydayContext: "Function · medicines · communication needs"
        case .reportedChange: "Reported sequence · source · uncertainty"
        case .teamReview: "Reviewed imaging only · distinguish teaching model"
        case .sharedQuestions: "Purpose · limits · open questions"
        }
    }

    var sourcePlaceholder: String {
        switch self {
        case .everydayContext: "SOURCE SLOT · family + reviewed chart"
        case .reportedChange: "SOURCE SLOT · documented history"
        case .teamReview: "SOURCE SLOT · clinician-reviewed imaging report"
        case .sharedQuestions: "SOURCE SLOT · local reviewed guidance"
        }
    }

    /// Short endpoint copy for the room-scale history web. Detailed context
    /// remains in the selected timeline ribbon rather than four text panels.
    var spatialWebValue: String {
        switch self {
        case .everydayContext: "Baseline context to confirm"
        case .reportedChange: "Speech + arm change reported"
        case .teamReview: "Reviewed pictures · teaching model separate"
        case .sharedQuestions: "Known · uncertain · next"
        }
    }
}

/// A connected spatial ribbon rather than a dashboard. The selected milestone
/// expands in place, so copy remains close to the central case without forcing
/// a large head turn.
struct PatientHistoryTimelineView: View {
    @EnvironmentObject private var experience: StrokeExperienceState

    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 7) {
                Image(systemName: experience.audienceLens == .family
                      ? "heart.text.square.fill"
                      : "person.text.rectangle.fill")
                Text(experience.audienceLens == .family
                     ? "WHAT WE KNOW SO FAR"
                     : "CASE HISTORY · FICTIONAL")
            }
            .font(.caption.weight(.black))
            .tracking(0.9)
            .foregroundStyle(accent)

            ZStack {
                Capsule()
                    .fill(Color.white.opacity(0.16))
                    .frame(height: 2)
                    .padding(.horizontal, 58)

                HStack(spacing: 8) {
                    ForEach(StrokeCaseHistoryMilestone.allCases) { milestone in
                        Button {
                            experience.selectCaseHistoryMilestone(milestone)
                        } label: {
                            PatientHistoryMilestoneNode(
                                milestone: milestone,
                                isSelected: milestone == experience.selectedCaseHistoryMilestone,
                                accent: accent
                            )
                        }
                        .buttonStyle(.plain)
                        .hoverEffect(.highlight)
                        .accessibilityLabel("\(milestone.timeLabel), \(milestone.shortTitle)")
                        .accessibilityValue(
                            milestone == experience.selectedCaseHistoryMilestone
                                ? "Selected case-history milestone"
                                : "Case-history milestone"
                        )
                    }
                }
            }

            roleDetail
                .animation(.easeInOut(duration: 0.24), value: experience.audienceLens)
                .animation(.easeInOut(duration: 0.24), value: experience.selectedCaseHistoryMilestone)

            Text("CASE-078 · FICTIONAL TEACHING HISTORY · NOT A MEDICAL RECORD")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.white.opacity(0.42))
        }
        .frame(maxWidth: 590)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Fictional case-history timeline")
    }

    @ViewBuilder
    private var roleDetail: some View {
        let milestone = experience.selectedCaseHistoryMilestone

        if experience.audienceLens == .family {
            HStack(spacing: 10) {
                Image(systemName: "questionmark.bubble.fill")
                    .font(.headline)
                    .foregroundStyle(accent)
                Text(milestone.familyQuestion)
                    .font(.callout.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.94))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 11)
            .background(.thinMaterial, in: Capsule())
            .overlay(Capsule().stroke(accent.opacity(0.28)))
        } else {
            HStack(spacing: 12) {
                Text(milestone.presenterCue)
                    .font(.callout.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.92))
                    .lineLimit(2)

                Capsule()
                    .fill(Color.white.opacity(0.18))
                    .frame(width: 1, height: 28)

                Label(milestone.sourcePlaceholder, systemImage: "text.book.closed.fill")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.54))
                    .lineLimit(2)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(.thinMaterial, in: Capsule())
            .overlay(Capsule().stroke(accent.opacity(0.24)))
        }
    }

    private var accent: Color {
        experience.audienceLens == .family ? .orange : .mint
    }
}

private struct PatientHistoryMilestoneNode: View {
    let milestone: StrokeCaseHistoryMilestone
    let isSelected: Bool
    let accent: Color

    var body: some View {
        VStack(spacing: 5) {
            ZStack {
                Circle()
                    .fill(isSelected ? accent : Color.white.opacity(0.12))
                Image(systemName: milestone.systemImage)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(isSelected ? Color.black : Color.white.opacity(0.68))
            }
            .frame(width: isSelected ? 38 : 30, height: isSelected ? 38 : 30)
            .overlay(Circle().stroke(Color.white.opacity(isSelected ? 0.30 : 0.10)))

            Text(milestone.timeLabel)
                .font(.caption2.monospacedDigit().weight(.black))
                .foregroundStyle(isSelected ? accent : Color.white.opacity(0.48))

            Text(milestone.shortTitle)
                .font(isSelected ? .caption.weight(.bold) : .caption2.weight(.semibold))
                .foregroundStyle(isSelected ? Color.white : Color.white.opacity(0.58))
                .lineLimit(1)
        }
        .frame(width: isSelected ? 146 : 124, height: 78)
        .contentShape(Rectangle())
    }
}

// MARK: - Clinician case library

/// A deliberately fictional intake library. Only CASE-078 is connected to the
/// current teaching experience; the peripheral cards communicate the future
/// cabinet pattern without pretending that three clinical scenarios exist.
struct StrokeCaseLibraryView: View {
    @Binding var selectedCaseID: String
    let onBack: () -> Void
    let onEnterCase: () -> Void

    private static let profiles: [StrokeCasePreview] = [
        StrokeCasePreview(
            id: "CASE-077",
            displayName: "Michael T.",
            ageAndContext: "62 · retired teacher",
            concern: "Library preview",
            accent: Color(red: 0.45, green: 0.68, blue: 0.65),
            portraitSeed: 0,
            isReady: false
        ),
        StrokeCasePreview(
            id: "CASE-078",
            displayName: "Aisha K.",
            ageAndContext: "57 · graphic designer",
            concern: "Speech + right arm change",
            accent: Color(red: 0.86, green: 0.62, blue: 0.39),
            portraitSeed: 1,
            isReady: true
        ),
        StrokeCasePreview(
            id: "CASE-079",
            displayName: "David L.",
            ageAndContext: "48 · chef",
            concern: "Library preview",
            accent: Color(red: 0.52, green: 0.67, blue: 0.76),
            portraitSeed: 2,
            isReady: false
        )
    ]

    var body: some View {
        ZStack {
            caseLibraryBackdrop

            VStack(spacing: 18) {
                libraryHeader

                HStack(alignment: .center, spacing: 16) {
                    ForEach(orderedProfiles) { profile in
                        if profile.id == selectedCaseID {
                            selectedCase(profile)
                                .accessibilityLabel(
                                    "\(profile.displayName), \(profile.id), \(profile.isReady ? "ready to enter" : "preview only")"
                                )
                        } else {
                            Button {
                                withAnimation(.easeInOut(duration: 0.28)) {
                                    selectedCaseID = profile.id
                                }
                            } label: {
                                peripheralCase(profile)
                            }
                            .buttonStyle(.plain)
                            .hoverEffect(.highlight)
                            .accessibilityLabel("Select \(profile.displayName), \(profile.id), preview only")
                        }
                    }
                }
                .frame(maxHeight: .infinity)

                HStack {
                    Label("FICTIONAL TEACHING CASES", systemImage: "checkmark.shield.fill")
                    Spacer()
                    Text("No patient record · no diagnostic inference")
                }
                .font(.caption2.weight(.semibold))
                .tracking(0.55)
                .foregroundStyle(.white.opacity(0.46))
            }
            .padding(26)
        }
        .clipShape(RoundedRectangle(cornerRadius: 34, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 34, style: .continuous)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Clinician fictional case library")
    }

    private var selectedProfile: StrokeCasePreview {
        Self.profiles.first(where: { $0.id == selectedCaseID }) ?? Self.profiles[1]
    }

    private var orderedProfiles: [StrokeCasePreview] {
        let others = Self.profiles.filter { $0.id != selectedProfile.id }
        guard others.count == 2 else { return Self.profiles }
        return [others[0], selectedProfile, others[1]]
    }

    private var caseLibraryBackdrop: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.19, green: 0.145, blue: 0.115),
                    Color(red: 0.075, green: 0.070, blue: 0.067),
                    Color(red: 0.040, green: 0.045, blue: 0.047)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            RadialGradient(
                colors: [selectedProfile.accent.opacity(0.20), .clear],
                center: .top,
                startRadius: 20,
                endRadius: 560
            )

            Image("CaseCabinetGrain")
                .resizable(resizingMode: .tile)
                .blendMode(.softLight)
                .opacity(0.18)
                .accessibilityHidden(true)
        }
        .ignoresSafeArea()
    }

    private var libraryHeader: some View {
        HStack(spacing: 14) {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.headline.weight(.bold))
                    .frame(width: 36, height: 36)
            }
            .buttonStyle(.plain)
            .background(.thinMaterial, in: Circle())
            .hoverEffect(.highlight)
            .accessibilityLabel("Back to audience choice")

            VStack(alignment: .leading, spacing: 3) {
                Text("STROKE CARE")
                    .font(.caption.weight(.black))
                    .tracking(2.0)
                    .foregroundStyle(selectedProfile.accent)
                Text("Choose one story to explain")
                    .font(.title2.weight(.semibold))
            }

            Spacer()

            Label("PRESENTER VIEW", systemImage: "stethoscope")
                .font(.caption.weight(.bold))
                .tracking(0.7)
                .padding(.horizontal, 13)
                .padding(.vertical, 9)
                .background(.thinMaterial, in: Capsule())
                .foregroundStyle(.white.opacity(0.70))
        }
    }

    private func selectedCase(_ profile: StrokeCasePreview) -> some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 18) {
                FictionalCasePortrait(profile: profile, compact: false)
                    .frame(width: 156, height: 214)

                VStack(alignment: .leading, spacing: 14) {
                    HStack(alignment: .firstTextBaseline) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(profile.displayName)
                                .font(.system(size: 29, weight: .semibold, design: .rounded))
                            Text(profile.ageAndContext)
                                .font(.callout.weight(.medium))
                                .foregroundStyle(.white.opacity(0.64))
                        }
                        Spacer()
                        Text(profile.id)
                            .font(.caption.monospacedDigit().weight(.black))
                            .foregroundStyle(profile.accent)
                    }

                    HStack(alignment: .top, spacing: 18) {
                        caseDetail(
                            "HISTORY",
                            icon: "clock.arrow.circlepath",
                            lines: ["Last known well · 70 min ago", "Change reported by colleague"]
                        )
                        caseDetail(
                            "RELATIONSHIPS",
                            icon: "person.2.fill",
                            lines: ["Family contact available", "Communication needs to confirm"]
                        )
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("TIMELINE")
                            .font(.caption2.weight(.black))
                            .tracking(0.9)
                            .foregroundStyle(.white.opacity(0.48))
                        CaseIntakeTimeline(accent: profile.accent)
                    }
                }
            }
            .padding(20)

            Divider().overlay(Color.white.opacity(0.10))

            HStack(spacing: 14) {
                Label(profile.concern, systemImage: "waveform.path.ecg")
                    .font(.callout.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.78))

                Spacer()

                if profile.isReady {
                    Button(action: onEnterCase) {
                        Label("Enter case", systemImage: "arrow.right")
                            .font(.headline)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(Color.black.opacity(0.82))
                    .background(profile.accent, in: Capsule())
                    .hoverEffect(.highlight)
                    .accessibilityHint("Opens the room-scale fictional case review")
                } else {
                    Label("Preview only", systemImage: "lock.fill")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.white.opacity(0.44))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
        }
        .frame(width: 546, height: 392)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [Color.white.opacity(0.28), profile.accent.opacity(0.22), .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: profile.accent.opacity(0.16), radius: 30, y: 14)
        .contentShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
    }

    private func peripheralCase(_ profile: StrokeCasePreview) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            FictionalCasePortrait(profile: profile, compact: true)
                .frame(height: 156)

            Text(profile.displayName)
                .font(.title3.weight(.semibold))
            Text(profile.ageAndContext)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.58))
            Spacer(minLength: 0)
            HStack {
                Text(profile.id)
                    .font(.caption2.monospacedDigit().weight(.black))
                Spacer()
                Image(systemName: "chevron.right")
            }
            .foregroundStyle(profile.accent.opacity(0.78))
        }
        .padding(14)
        .frame(width: 166, height: 318, alignment: .leading)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 23, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 23, style: .continuous)
                .stroke(Color.white.opacity(0.10))
        )
        .opacity(0.74)
        .scaleEffect(0.96)
        .contentShape(RoundedRectangle(cornerRadius: 23, style: .continuous))
    }

    private func caseDetail(_ title: String, icon: String, lines: [String]) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Label(title, systemImage: icon)
                .font(.caption2.weight(.black))
                .tracking(0.9)
                .foregroundStyle(.white.opacity(0.48))
            ForEach(lines, id: \.self) { line in
                Text(line)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.white.opacity(0.76))
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct StrokeCasePreview: Identifiable {
    let id: String
    let displayName: String
    let ageAndContext: String
    let concern: String
    let accent: Color
    let portraitSeed: Int
    let isReady: Bool
}

/// Abstract, deterministic portrait art avoids real-person likeness and keeps
/// the case library self-contained until licensed diverse busts are reviewed.
private struct FictionalCasePortrait: View {
    let profile: StrokeCasePreview
    let compact: Bool

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            ZStack(alignment: .bottom) {
                LinearGradient(
                    colors: [profile.accent.opacity(0.52), Color.black.opacity(0.80)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                Circle()
                    .fill(Color.white.opacity(0.08))
                    .frame(width: size.width * 0.82)
                    .blur(radius: 18)
                    .offset(y: -size.height * 0.28)

                Capsule(style: .continuous)
                    .fill(Color.white.opacity(0.13))
                    .frame(width: size.width * 0.62, height: size.height * 0.50)
                    .offset(y: size.height * 0.08)

                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.34), Color.black.opacity(0.32)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: size.width * 0.45)
                    .offset(
                        x: CGFloat(profile.portraitSeed - 1) * size.width * 0.03,
                        y: -size.height * 0.36
                    )

                LinearGradient(
                    colors: [.clear, Color.black.opacity(0.42)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .clipShape(RoundedRectangle(cornerRadius: compact ? 16 : 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: compact ? 16 : 20, style: .continuous)
                    .stroke(Color.white.opacity(0.14))
            )
        }
        .accessibilityHidden(true)
    }
}

private struct CaseIntakeTimeline: View {
    let accent: Color

    private let points = ["Known well", "Change", "Review", "Now"]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(points.enumerated()), id: \.offset) { index, point in
                VStack(spacing: 6) {
                    HStack(spacing: 0) {
                        if index > 0 {
                            Rectangle()
                                .fill(accent.opacity(0.34))
                                .frame(height: 1)
                        }
                        Circle()
                            .fill(index == points.count - 1 ? accent : Color.white.opacity(0.34))
                            .frame(width: index == points.count - 1 ? 9 : 6)
                        if index < points.count - 1 {
                            Rectangle()
                                .fill(accent.opacity(0.34))
                                .frame(height: 1)
                        }
                    }
                    Text(point)
                        .font(.caption2.weight(index == points.count - 1 ? .bold : .medium))
                        .foregroundStyle(index == points.count - 1 ? accent : Color.white.opacity(0.50))
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}
