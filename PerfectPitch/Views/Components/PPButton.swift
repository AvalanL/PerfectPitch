import SwiftUI

// MARK: - Primary Button
struct PPButton: View {
    let title: String
    let icon: String?
    let style: ButtonStyle
    let isLoading: Bool
    let action: () -> Void

    enum ButtonStyle {
        case primary
        case secondary
        case ghost
        case destructive

        var backgroundColor: Color {
            switch self {
            case .primary: return .primaryPurple
            case .secondary: return .backgroundTertiary
            case .ghost: return .clear
            case .destructive: return .error
            }
        }

        var foregroundColor: Color {
            switch self {
            case .primary, .destructive: return .white
            case .secondary: return .textPrimary
            case .ghost: return .primaryPurple
            }
        }
    }

    init(
        _ title: String,
        icon: String? = nil,
        style: ButtonStyle = .primary,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.isLoading = isLoading
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: PPSpacing.sm) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: style.foregroundColor))
                        .scaleEffect(0.8)
                } else {
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(.system(size: 16, weight: .semibold))
                    }
                    Text(title)
                        .font(PPFont.titleMedium())
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, PPSpacing.lg)
            .background(style.backgroundColor)
            .foregroundColor(style.foregroundColor)
            .cornerRadius(PPRadius.md)
        }
        .buttonStyle(PPButtonStyle())
        .disabled(isLoading)
    }
}

// MARK: - Button Style
struct PPButtonStyle: SwiftUI.ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.ppFast, value: configuration.isPressed)
    }
}

// MARK: - Answer Button
struct AnswerButton: View {
    let text: String
    let state: AnswerState
    let action: () -> Void

    enum AnswerState {
        case normal
        case selected
        case correct
        case incorrect
        case disabled

        var backgroundColor: Color {
            switch self {
            case .normal: return .backgroundSecondary
            case .selected: return .primaryPurple.opacity(0.1)
            case .correct: return .success.opacity(0.15)
            case .incorrect: return .error.opacity(0.15)
            case .disabled: return .backgroundTertiary
            }
        }

        var borderColor: Color {
            switch self {
            case .normal: return .borderLight
            case .selected: return .primaryPurple
            case .correct: return .success
            case .incorrect: return .error
            case .disabled: return .borderLight
            }
        }

        var textColor: Color {
            switch self {
            case .normal, .selected: return .textPrimary
            case .correct: return .success
            case .incorrect: return .error
            case .disabled: return .textTertiary
            }
        }
    }

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(PPFont.titleMedium())
                .foregroundColor(state.textColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, PPSpacing.lg)
                .background(state.backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: PPRadius.md)
                        .stroke(state.borderColor, lineWidth: 2)
                )
                .cornerRadius(PPRadius.md)
        }
        .buttonStyle(PPButtonStyle())
        .disabled(state == .disabled)
    }
}

// MARK: - Icon Button
struct PPIconButton: View {
    let icon: String
    let size: CGFloat
    let action: () -> Void

    init(_ icon: String, size: CGFloat = 24, action: @escaping () -> Void) {
        self.icon = icon
        self.size = size
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size, weight: .medium))
                .foregroundColor(.textSecondary)
                .frame(width: 44, height: 44)
                .background(Color.backgroundSecondary)
                .clipShape(Circle())
        }
        .buttonStyle(PPButtonStyle())
    }
}

#Preview {
    VStack(spacing: 20) {
        PPButton("Continue", icon: "arrow.right", action: {})
        PPButton("Secondary", style: .secondary, action: {})
        PPButton("Loading", isLoading: true, action: {})

        HStack(spacing: 12) {
            AnswerButton(text: "C", state: .normal, action: {})
            AnswerButton(text: "D", state: .correct, action: {})
            AnswerButton(text: "E", state: .incorrect, action: {})
        }
    }
    .padding()
}
