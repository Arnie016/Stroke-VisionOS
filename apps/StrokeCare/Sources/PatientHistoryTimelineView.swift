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
