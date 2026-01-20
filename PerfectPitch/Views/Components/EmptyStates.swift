import SwiftUI

// MARK: - Empty State View
/// Beautiful empty states are a hallmark of Apple Design Award winners.
/// They turn moments of "nothing to show" into delightful branded experiences.

struct EmptyStateView: View {
    let type: EmptyStateType
    let action: (() -> Void)?

    init(type: EmptyStateType, action: (() -> Void)? = nil) {
        self.type = type
        self.action = action
    }

    var body: some View {
        VStack(spacing: PPSpacing.xxl) {
            // Animated illustration
            EmptyStateIllustration(type: type)
                .frame(width: 200, height: 200)

            // Text content
            VStack(spacing: PPSpacing.md) {
                Text(type.title)
                    .font(PPFont.titleLarge())
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)

                Text(type.subtitle)
                    .font(PPFont.bodyMedium())
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, PPSpacing.xxl)
            }

            // Action button (if applicable)
            if let action = action, let buttonTitle = type.buttonTitle {
                PPButton(buttonTitle, icon: type.buttonIcon) {
                    action()
                }
                .padding(.horizontal, PPSpacing.xxl)
            }
        }
        .padding(PPSpacing.xxl)
    }
}

// MARK: - Empty State Types
enum EmptyStateType {
    case noAchievements
    case noSessions
    case noStreak
    case noFriends
    case offlineMode
    case comingSoon

    var title: String {
        switch self {
        case .noAchievements: return "No Achievements Yet"
        case .noSessions: return "Start Your Journey"
        case .noStreak: return "Build Your Streak"
        case .noFriends: return "Train With Friends"
        case .offlineMode: return "You're Offline"
        case .comingSoon: return "Coming Soon"
        }
    }

    var subtitle: String {
        switch self {
        case .noAchievements: return "Complete exercises to unlock achievements and track your progress"
        case .noSessions: return "Your ear training journey begins with a single note. Start practicing today!"
        case .noStreak: return "Practice daily to build your streak and earn bonus XP"
        case .noFriends: return "Connect with friends to compete on leaderboards and stay motivated"
        case .offlineMode: return "Don't worry - all training exercises work offline. Your progress will sync when you're back online."
        case .comingSoon: return "We're working on something exciting. Stay tuned!"
        }
    }

    var buttonTitle: String? {
        switch self {
        case .noAchievements: return "Start Training"
        case .noSessions: return "Begin Practice"
        case .noStreak: return "Practice Now"
        case .noFriends: return "Find Friends"
        case .offlineMode: return nil
        case .comingSoon: return nil
        }
    }

    var buttonIcon: String? {
        switch self {
        case .noAchievements: return "play.fill"
        case .noSessions: return "music.note"
        case .noStreak: return "flame.fill"
        case .noFriends: return "person.2.fill"
        default: return nil
        }
    }
}

// MARK: - Empty State Illustration
struct EmptyStateIllustration: View {
    let type: EmptyStateType
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            // Background circles
            backgroundCircles

            // Main icon
            mainIcon
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }

    private var backgroundCircles: some View {
        ZStack {
            Circle()
                .fill(iconColor.opacity(0.05))
                .frame(width: 180, height: 180)
                .scaleEffect(isAnimating ? 1.1 : 1.0)

            Circle()
                .fill(iconColor.opacity(0.1))
                .frame(width: 140, height: 140)
                .scaleEffect(isAnimating ? 1.05 : 1.0)

            Circle()
                .fill(iconColor.opacity(0.15))
                .frame(width: 100, height: 100)
        }
    }

    private var mainIcon: some View {
        Image(systemName: iconName)
            .font(.system(size: 44, weight: .medium))
            .foregroundStyle(
                LinearGradient(
                    colors: [iconColor, iconColor.opacity(0.7)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .offset(y: isAnimating ? -5 : 5)
    }

    private var iconName: String {
        switch type {
        case .noAchievements: return "trophy"
        case .noSessions: return "music.note.list"
        case .noStreak: return "flame"
        case .noFriends: return "person.2"
        case .offlineMode: return "wifi.slash"
        case .comingSoon: return "sparkles"
        }
    }

    private var iconColor: Color {
        switch type {
        case .noAchievements: return .warning
        case .noSessions: return .primaryPurple
        case .noStreak: return .orange
        case .noFriends: return .info
        case .offlineMode: return .textSecondary
        case .comingSoon: return .primaryPurple
        }
    }
}

// MARK: - Loading State
struct LoadingStateView: View {
    let message: String

    @State private var rotation: Double = 0

    var body: some View {
        VStack(spacing: PPSpacing.xl) {
            // Custom animated loader
            ZStack {
                // Outer ring
                Circle()
                    .stroke(Color.primaryPurple.opacity(0.2), lineWidth: 4)
                    .frame(width: 60, height: 60)

                // Animated arc
                Circle()
                    .trim(from: 0, to: 0.3)
                    .stroke(
                        LinearGradient.primaryGradient,
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(rotation))

                // Inner icon
                Image(systemName: "music.note")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.primaryPurple)
            }
            .onAppear {
                withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }

            Text(message)
                .font(PPFont.bodyMedium())
                .foregroundColor(.textSecondary)
        }
    }
}

// MARK: - Error State
struct ErrorStateView: View {
    let title: String
    let message: String
    let retryAction: () -> Void

    @State private var isShaking = false

    var body: some View {
        VStack(spacing: PPSpacing.xxl) {
            // Error icon with shake animation
            ZStack {
                Circle()
                    .fill(Color.error.opacity(0.1))
                    .frame(width: 100, height: 100)

                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.error)
                    .offset(x: isShaking ? -3 : 3)
            }

            VStack(spacing: PPSpacing.md) {
                Text(title)
                    .font(PPFont.titleLarge())
                    .foregroundColor(.textPrimary)

                Text(message)
                    .font(PPFont.bodyMedium())
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, PPSpacing.xxl)
            }

            PPButton("Try Again", icon: "arrow.clockwise") {
                retryAction()
            }
            .padding(.horizontal, PPSpacing.xxl)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.1).repeatCount(3)) {
                isShaking = true
            }
        }
    }
}

// MARK: - Skeleton Loading
struct SkeletonView: View {
    var height: CGFloat = 20
    var cornerRadius: CGFloat = PPRadius.sm

    @State private var isAnimating = false

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.backgroundTertiary)
            .frame(height: height)
            .overlay(
                GeometryReader { geo in
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(
                            LinearGradient(
                                colors: [
                                    .clear,
                                    .white.opacity(0.4),
                                    .clear
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .offset(x: isAnimating ? geo.size.width : -geo.size.width)
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
    }
}

// MARK: - Skeleton Card
struct SkeletonCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: PPSpacing.md) {
            HStack(spacing: PPSpacing.md) {
                SkeletonView(height: 50, cornerRadius: 25)
                    .frame(width: 50)

                VStack(alignment: .leading, spacing: PPSpacing.sm) {
                    SkeletonView(height: 16)
                        .frame(width: 120)
                    SkeletonView(height: 12)
                        .frame(width: 80)
                }
            }

            SkeletonView(height: 8)
        }
        .padding(PPSpacing.lg)
        .background(Color.backgroundPrimary)
        .cornerRadius(PPRadius.lg)
    }
}

// MARK: - Preview
#Preview("Empty States") {
    ScrollView {
        VStack(spacing: 40) {
            EmptyStateView(type: .noAchievements) {
                print("Start training")
            }

            Divider()

            EmptyStateView(type: .noStreak) {
                print("Practice now")
            }

            Divider()

            LoadingStateView(message: "Loading your progress...")

            Divider()

            ErrorStateView(
                title: "Connection Error",
                message: "Unable to sync your progress. Please check your internet connection.",
                retryAction: {}
            )

            Divider()

            VStack(spacing: 16) {
                SkeletonCard()
                SkeletonCard()
            }
            .padding()
        }
    }
    .background(Color.backgroundSecondary)
}
