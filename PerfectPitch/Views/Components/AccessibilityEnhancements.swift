import SwiftUI

// MARK: - Accessibility-First Design
// Apple Design Awards prioritize inclusivity - these enhancements make the app
// usable by everyone, including users with visual, motor, and hearing impairments

// MARK: - Accessible Button
struct AccessibleButton<Content: View>: View {
    let action: () -> Void
    let label: String
    let hint: String?
    let content: Content

    init(
        _ label: String,
        hint: String? = nil,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.label = label
        self.hint = hint
        self.action = action
        self.content = content()
    }

    var body: some View {
        Button(action: {
            HapticManager.shared.playSelection()
            action()
        }) {
            content
        }
        .accessibilityLabel(label)
        .accessibilityHint(hint ?? "")
        .accessibilityAddTraits(.isButton)
    }
}

// MARK: - Reduce Motion Support
struct ReduceMotionModifier: ViewModifier {
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    let animation: Animation
    let reducedAnimation: Animation

    func body(content: Content) -> some View {
        content
            .animation(reduceMotion ? reducedAnimation : animation, value: UUID())
    }
}

extension View {
    func adaptiveAnimation(_ animation: Animation, reduced: Animation = .none) -> some View {
        modifier(ReduceMotionModifier(animation: animation, reducedAnimation: reduced))
    }
}

// MARK: - Dynamic Type Support
struct ScaledFont: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory

    let baseSize: CGFloat
    let weight: Font.Weight
    let design: Font.Design

    func body(content: Content) -> some View {
        content
            .font(.system(size: scaledSize, weight: weight, design: design))
    }

    private var scaledSize: CGFloat {
        let multiplier: CGFloat
        switch sizeCategory {
        case .extraSmall: multiplier = 0.8
        case .small: multiplier = 0.9
        case .medium: multiplier = 1.0
        case .large: multiplier = 1.1
        case .extraLarge: multiplier = 1.2
        case .extraExtraLarge: multiplier = 1.3
        case .extraExtraExtraLarge: multiplier = 1.4
        case .accessibilityMedium: multiplier = 1.6
        case .accessibilityLarge: multiplier = 1.8
        case .accessibilityExtraLarge: multiplier = 2.0
        case .accessibilityExtraExtraLarge: multiplier = 2.2
        case .accessibilityExtraExtraExtraLarge: multiplier = 2.4
        @unknown default: multiplier = 1.0
        }
        return baseSize * multiplier
    }
}

extension View {
    func scaledFont(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> some View {
        modifier(ScaledFont(baseSize: size, weight: weight, design: design))
    }
}

// MARK: - VoiceOver Announcements
struct VoiceOverAnnouncement {
    static func announce(_ message: String, after delay: TimeInterval = 0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            UIAccessibility.post(notification: .announcement, argument: message)
        }
    }

    static func announceCorrectAnswer(note: String) {
        announce("Correct! The note was \(note)")
    }

    static func announceIncorrectAnswer(correctNote: String, selectedNote: String) {
        announce("Incorrect. You selected \(selectedNote). The correct answer was \(correctNote)")
    }

    static func announceSessionComplete(score: Int, total: Int) {
        let percentage = Int((Double(score) / Double(total)) * 100)
        announce("Session complete. You scored \(score) out of \(total), that's \(percentage) percent")
    }

    static func announceLevelUp(level: Int) {
        announce("Congratulations! You've reached level \(level)")
    }

    static func announceStreak(days: Int) {
        announce("Your streak is now \(days) days!")
    }
}

// MARK: - High Contrast Mode Support
struct HighContrastColors {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor

    var correctIndicator: some View {
        Group {
            if differentiateWithoutColor {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.success)
            } else {
                Circle()
                    .fill(Color.success)
            }
        }
    }

    var incorrectIndicator: some View {
        Group {
            if differentiateWithoutColor {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.error)
            } else {
                Circle()
                    .fill(Color.error)
            }
        }
    }
}

// MARK: - Accessible Answer Button
struct AccessibleAnswerButton: View {
    let text: String
    let state: AnswerState
    let index: Int
    let action: () -> Void

    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor

    enum AnswerState {
        case normal
        case selected
        case correct
        case incorrect
        case disabled
    }

    var body: some View {
        Button(action: {
            HapticManager.shared.playImpact(.light)
            action()
        }) {
            HStack {
                Text(text)
                    .font(PPFont.titleMedium())
                    .foregroundColor(textColor)

                Spacer()

                // Show icons for accessibility when color isn't sufficient
                if differentiateWithoutColor {
                    stateIcon
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, PPSpacing.lg)
            .padding(.horizontal, PPSpacing.xl)
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: PPRadius.md)
                    .stroke(borderColor, lineWidth: 2)
            )
            .cornerRadius(PPRadius.md)
        }
        .buttonStyle(PPButtonStyle())
        .disabled(state == .disabled)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(accessibilityHint)
        .accessibilityAddTraits(accessibilityTraits)
    }

    @ViewBuilder
    private var stateIcon: some View {
        switch state {
        case .correct:
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.success)
        case .incorrect:
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.error)
        case .selected:
            Image(systemName: "circle.inset.filled")
                .foregroundColor(.primaryPurple)
        default:
            EmptyView()
        }
    }

    private var backgroundColor: Color {
        switch state {
        case .normal: return .backgroundSecondary
        case .selected: return .primaryPurple.opacity(0.1)
        case .correct: return .success.opacity(0.15)
        case .incorrect: return .error.opacity(0.15)
        case .disabled: return .backgroundTertiary
        }
    }

    private var borderColor: Color {
        switch state {
        case .normal: return .borderLight
        case .selected: return .primaryPurple
        case .correct: return .success
        case .incorrect: return .error
        case .disabled: return .borderLight
        }
    }

    private var textColor: Color {
        switch state {
        case .normal, .selected: return .textPrimary
        case .correct: return .success
        case .incorrect: return .error
        case .disabled: return .textTertiary
        }
    }

    private var accessibilityLabel: String {
        switch state {
        case .correct:
            return "\(text), correct answer"
        case .incorrect:
            return "\(text), incorrect"
        case .selected:
            return "\(text), selected"
        default:
            return text
        }
    }

    private var accessibilityHint: String {
        switch state {
        case .normal:
            return "Double tap to select this answer"
        case .disabled:
            return "Answer already submitted"
        default:
            return ""
        }
    }

    private var accessibilityTraits: AccessibilityTraits {
        switch state {
        case .selected:
            return [.isButton, .isSelected]
        case .disabled:
            return [.isButton, .isStaticText]
        default:
            return .isButton
        }
    }
}

// MARK: - Skip Animation Wrapper
struct SkipAnimationWrapper<Content: View>: View {
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    let content: Content
    let animatedContent: Content

    init(
        @ViewBuilder animated: () -> Content,
        @ViewBuilder static: () -> Content
    ) {
        self.animatedContent = animated()
        self.content = `static`()
    }

    var body: some View {
        if reduceMotion {
            content
        } else {
            animatedContent
        }
    }
}

// MARK: - Accessible Progress Indicator
struct AccessibleProgressBar: View {
    let progress: Double
    let label: String

    var body: some View {
        VStack(alignment: .leading, spacing: PPSpacing.sm) {
            PPProgressBar(progress: progress, height: 8)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(label): \(Int(progress * 100)) percent complete")
        .accessibilityValue("\(Int(progress * 100)) percent")
    }
}

// MARK: - Voice Feedback for Notes
struct VoiceFeedbackManager {
    static func speakNote(_ note: PitchClass) {
        let utterance = AVSpeechUtterance(string: spokenName(for: note))
        utterance.rate = 0.5
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }

    private static func spokenName(for note: PitchClass) -> String {
        switch note {
        case .C: return "C"
        case .CSharp: return "C sharp"
        case .D: return "D"
        case .DSharp: return "D sharp"
        case .E: return "E"
        case .F: return "F"
        case .FSharp: return "F sharp"
        case .G: return "G"
        case .GSharp: return "G sharp"
        case .A: return "A"
        case .ASharp: return "A sharp"
        case .B: return "B"
        }
    }
}

import AVFoundation

// MARK: - Accessibility Settings View
struct AccessibilitySettingsSection: View {
    @AppStorage("voiceOverNoteAnnouncements") var voiceOverNotes = false
    @AppStorage("hapticFeedbackIntensity") var hapticIntensity = 1.0
    @AppStorage("highContrastMode") var highContrast = false
    @AppStorage("largerTouchTargets") var largerTargets = false

    var body: some View {
        Section("Accessibility") {
            Toggle("Announce Notes with VoiceOver", isOn: $voiceOverNotes)

            VStack(alignment: .leading) {
                Text("Haptic Feedback Intensity")
                    .font(PPFont.bodyMedium())
                Slider(value: $hapticIntensity, in: 0...1)
                    .accessibilityLabel("Haptic feedback intensity")
                    .accessibilityValue("\(Int(hapticIntensity * 100)) percent")
            }

            Toggle("High Contrast Mode", isOn: $highContrast)

            Toggle("Larger Touch Targets", isOn: $largerTargets)
        }
    }
}

// MARK: - Preview
#Preview("Accessibility Components") {
    VStack(spacing: 20) {
        AccessibleAnswerButton(text: "C", state: .normal, index: 0) {}
        AccessibleAnswerButton(text: "D", state: .correct, index: 1) {}
        AccessibleAnswerButton(text: "E", state: .incorrect, index: 2) {}

        AccessibleProgressBar(progress: 0.65, label: "Session progress")
    }
    .padding()
}
