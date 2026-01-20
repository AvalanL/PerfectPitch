import SwiftUI

// MARK: - Streak Danger Banner
/// Duolingo-style urgent banner when streak is about to end
struct StreakDangerBanner: View {
    @EnvironmentObject var userManager: UserManager
    let onPracticeNow: () -> Void

    @State private var isAnimating = false
    @State private var timeRemaining: String = ""
    @State private var timer: Timer?

    var body: some View {
        if userManager.isStreakInDanger {
            dangerBanner
                .onAppear {
                    startTimer()
                    withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                        isAnimating = true
                    }
                }
                .onDisappear {
                    timer?.invalidate()
                }
        }
    }

    private var dangerBanner: some View {
        Button(action: onPracticeNow) {
            HStack(spacing: PPSpacing.md) {
                // Animated warning icon
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 44, height: 44)
                        .scaleEffect(isAnimating ? 1.1 : 1.0)

                    Image(systemName: "flame.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                        .offset(y: isAnimating ? -2 : 2)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("🚨 STREAK IN DANGER!")
                        .font(PPFont.titleMedium())
                        .foregroundColor(.white)

                    Text("Only \(userManager.formattedTimeUntilMidnight) left to save your \(userManager.currentUser.stats.currentStreak)-day streak!")
                        .font(PPFont.caption())
                        .foregroundColor(.white.opacity(0.9))
                }

                Spacer()

                // Practice button
                Text("GO!")
                    .font(PPFont.titleMedium())
                    .foregroundColor(.streakOrange)
                    .padding(.horizontal, PPSpacing.md)
                    .padding(.vertical, PPSpacing.sm)
                    .background(Color.white)
                    .cornerRadius(PPRadius.full)
            }
            .padding(PPSpacing.md)
            .background(
                LinearGradient.warmGradient
                    .overlay(
                        RoundedRectangle(cornerRadius: PPRadius.lg)
                            .fill(Color.white.opacity(isAnimating ? 0.05 : 0))
                    )
            )
            .cornerRadius(PPRadius.lg)
            .shadow(color: .streakOrange.opacity(0.4), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PPButtonStyle())
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            // Update the view by triggering a state change
            // The formattedTimeUntilMidnight is computed so it auto-updates
        }
    }
}

// MARK: - Streak Celebration View
/// Shows when user extends their streak
struct StreakCelebrationView: View {
    let streak: Int
    let onDismiss: () -> Void

    @State private var showContent = false
    @State private var showConfetti = false

    var body: some View {
        ZStack {
            // Background blur
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture { onDismiss() }

            // Content
            VStack(spacing: PPSpacing.xxl) {
                // Flame animation
                ZStack {
                    // Glow
                    Circle()
                        .fill(Color.streakOrange.opacity(0.3))
                        .frame(width: 160, height: 160)
                        .blur(radius: 30)
                        .scaleEffect(showContent ? 1 : 0)

                    Image(systemName: "flame.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(LinearGradient.streakGradient)
                        .scaleEffect(showContent ? 1 : 0.5)
                        .opacity(showContent ? 1 : 0)
                }

                VStack(spacing: PPSpacing.md) {
                    Text("\(streak)")
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    Text("Day Streak!")
                        .font(PPFont.displayMedium())
                        .foregroundColor(.white)

                    Text(motivationalText)
                        .font(PPFont.bodyLarge())
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)

                Button(action: onDismiss) {
                    Text("Keep Going!")
                        .font(PPFont.titleMedium())
                        .foregroundColor(.streakOrange)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, PPSpacing.lg)
                        .background(Color.white)
                        .cornerRadius(PPRadius.lg)
                }
                .padding(.horizontal, PPSpacing.xxl)
                .opacity(showContent ? 1 : 0)
            }
            .padding(PPSpacing.xxl)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                showContent = true
            }
            HapticManager.shared.playSuccess()
        }
    }

    private var motivationalText: String {
        switch streak {
        case 1...3: return "Great start! Keep building momentum!"
        case 4...6: return "You're on fire! Keep it up!"
        case 7: return "ONE WEEK! You're officially committed!"
        case 8...13: return "Incredible consistency!"
        case 14: return "TWO WEEKS! You're unstoppable!"
        case 15...29: return "You're in the zone!"
        case 30: return "ONE MONTH! Legend status unlocked!"
        case 31...99: return "You're an inspiration!"
        case 100: return "TRIPLE DIGITS! You're legendary!"
        default: return "UNBELIEVABLE dedication!"
        }
    }
}

// MARK: - Streak Freeze Warning
/// Mini warning that appears before streak resets
struct StreakFreezeWarning: View {
    @EnvironmentObject var userManager: UserManager

    var body: some View {
        HStack(spacing: PPSpacing.sm) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 14))
                .foregroundColor(.warning)

            Text("Practice now to keep your streak!")
                .font(PPFont.caption())
                .foregroundColor(.textPrimary)

            Spacer()

            Text(userManager.formattedTimeUntilMidnight)
                .font(PPFont.captionSmall())
                .foregroundColor(.warning)
                .padding(.horizontal, PPSpacing.sm)
                .padding(.vertical, PPSpacing.xs)
                .background(Color.warning.opacity(0.1))
                .cornerRadius(PPRadius.full)
        }
        .padding(PPSpacing.md)
        .background(Color.warning.opacity(0.08))
        .cornerRadius(PPRadius.md)
    }
}

// MARK: - Practice Streak Widget
/// Home screen widget showing streak status
struct PracticeStreakWidget: View {
    @EnvironmentObject var userManager: UserManager

    var body: some View {
        VStack(alignment: .leading, spacing: PPSpacing.md) {
            // Header
            HStack {
                Image(systemName: "flame.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(LinearGradient.streakGradient)

                Text("Daily Streak")
                    .font(PPFont.titleMedium())
                    .foregroundColor(.textPrimary)

                Spacer()

                if userManager.hasPracticedToday {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 12))
                        Text("Done")
                            .font(PPFont.captionSmall())
                    }
                    .foregroundColor(.success)
                }
            }

            // Streak count
            HStack(alignment: .firstTextBaseline, spacing: PPSpacing.sm) {
                Text("\(userManager.currentUser.stats.currentStreak)")
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                    .foregroundColor(.textPrimary)

                Text("days")
                    .font(PPFont.bodyMedium())
                    .foregroundColor(.textSecondary)
            }

            // Week progress
            HStack(spacing: 6) {
                ForEach(0..<7, id: \.self) { day in
                    let isCompleted = day < (userManager.currentUser.stats.currentStreak % 7 == 0 ? 7 : userManager.currentUser.stats.currentStreak % 7)
                    let isToday = day == (userManager.currentUser.stats.currentStreak % 7)

                    Circle()
                        .fill(isCompleted ? LinearGradient.streakGradient : LinearGradient(colors: [.borderLight], startPoint: .top, endPoint: .bottom))
                        .frame(width: 12, height: 12)
                        .overlay(
                            isToday && !userManager.hasPracticedToday ?
                            Circle()
                                .stroke(Color.streakOrange, lineWidth: 2) : nil
                        )
                }

                Spacer()

                Text("Best: \(userManager.currentUser.stats.longestStreak)")
                    .font(PPFont.captionSmall())
                    .foregroundColor(.textTertiary)
            }

            // Warning if hasn't practiced
            if !userManager.hasPracticedToday && userManager.currentUser.stats.currentStreak > 0 {
                StreakFreezeWarning()
            }
        }
        .padding(PPSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: PPRadius.lg)
                .fill(Color.backgroundElevated)
                .overlay(
                    RoundedRectangle(cornerRadius: PPRadius.lg)
                        .fill(
                            LinearGradient(
                                colors: [Color.streakOrange.opacity(0.05), Color.clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
        )
        .ppShadowMedium()
    }
}

#Preview("Streak Danger") {
    VStack(spacing: 20) {
        StreakDangerBanner(onPracticeNow: {})

        StreakFreezeWarning()

        PracticeStreakWidget()
    }
    .padding()
    .background(Color.backgroundSecondary)
    .environmentObject(UserManager())
}
