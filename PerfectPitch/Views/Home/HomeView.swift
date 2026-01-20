import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var appState: AppState
    @State private var showDailyChallenge = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: PPSpacing.xxl) {
                    // Header with gradient accent
                    headerSection

                    // Daily Challenge Card - Featured
                    dailyChallengeSection

                    // Streak Card - Warm tinted
                    streakSection

                    // Quick Practice - Colorful grid
                    quickPracticeSection

                    // Weekly Stats - Clean elevated cards
                    weeklyStatsSection
                }
                .padding(.horizontal, PPSpacing.lg)
                .padding(.bottom, PPSpacing.huge)
            }
            .background(
                // Ambient gradient background
                LinearGradient.ambientGradient
                    .ignoresSafeArea()
            )
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: PPSpacing.xs) {
            HStack {
                VStack(alignment: .leading, spacing: PPSpacing.xs) {
                    HStack(spacing: PPSpacing.sm) {
                        Text(userManager.greeting)
                            .font(PPFont.bodyLarge())
                            .foregroundColor(.textSecondary)

                        Image(systemName: userManager.greetingIcon)
                            .font(.system(size: 18))
                            .foregroundColor(.warning)
                    }

                    Text(userManager.currentUser.name)
                        .font(PPFont.displayLarge())
                        .foregroundColor(.textPrimary)
                }

                Spacer()

                // Level Badge with glow
                VStack(spacing: PPSpacing.xs) {
                    ZStack {
                        // Glow effect
                        Circle()
                            .fill(Color.primaryPurple.opacity(0.2))
                            .frame(width: 60, height: 60)
                            .blur(radius: 8)

                        Circle()
                            .fill(LinearGradient.primaryGradient)
                            .frame(width: 50, height: 50)

                        Text("\(userManager.currentUser.level)")
                            .font(PPFont.titleLarge())
                            .foregroundColor(.white)
                    }

                    Text("\(userManager.currentUser.stats.totalXP) XP")
                        .font(PPFont.captionSmall())
                        .foregroundColor(.textSecondary)
                }
            }
        }
        .padding(.top, PPSpacing.lg)
    }

    // MARK: - Daily Challenge Section
    private var dailyChallengeSection: some View {
        VStack(alignment: .leading, spacing: PPSpacing.md) {
            if let challenge = userManager.dailyChallenge {
                Button(action: { showDailyChallenge = true }) {
                    VStack(alignment: .leading, spacing: PPSpacing.md) {
                        // Header with flame
                        HStack {
                            HStack(spacing: PPSpacing.sm) {
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundStyle(LinearGradient.warmGradient)

                                Text("DAILY CHALLENGE")
                                    .font(PPFont.captionSmall())
                                    .foregroundColor(.streakOrange)
                                    .tracking(1.5)
                            }

                            Spacer()

                            if challenge.completed {
                                HStack(spacing: 4) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.success)
                                    Text("Complete")
                                        .font(PPFont.captionSmall())
                                        .foregroundColor(.success)
                                }
                            }
                        }

                        // Title
                        Text("Today's Focus")
                            .font(PPFont.titleLarge())
                            .foregroundColor(.textPrimary)

                        // Exercise types with colored pills
                        HStack(spacing: PPSpacing.sm) {
                            ForEach(challenge.exercises, id: \.type.rawValue) { exercise in
                                HStack(spacing: 4) {
                                    Image(systemName: exercise.type.icon)
                                        .font(.system(size: 12))
                                    Text(exercise.type.rawValue)
                                        .font(PPFont.captionSmall())
                                }
                                .padding(.horizontal, PPSpacing.sm)
                                .padding(.vertical, PPSpacing.xs)
                                .background(Color.primaryPurple.opacity(0.1))
                                .foregroundColor(.primaryPurple)
                                .cornerRadius(PPRadius.full)
                            }
                        }

                        // Progress bar with glow
                        VStack(spacing: PPSpacing.sm) {
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.borderLight)
                                        .frame(height: 8)

                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(LinearGradient.warmGradient)
                                        .frame(width: geo.size.width * challenge.progress, height: 8)
                                        .shadow(color: .streakOrange.opacity(0.4), radius: 4, x: 0, y: 0)
                                }
                            }
                            .frame(height: 8)

                            HStack {
                                Text("\(Int(challenge.progress * 100))% complete")
                                    .font(PPFont.caption())
                                    .foregroundColor(.textSecondary)

                                Spacer()

                                Text("\(challenge.score)/\(challenge.totalPossible)")
                                    .font(PPFont.caption())
                                    .foregroundColor(.textTertiary)
                            }
                        }

                        // CTA
                        HStack {
                            Spacer()
                            HStack(spacing: PPSpacing.sm) {
                                Text(challenge.completed ? "View Results" : "Continue")
                                    .font(PPFont.titleMedium())

                                Image(systemName: "arrow.right")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, PPSpacing.lg)
                            .padding(.vertical, PPSpacing.md)
                            .background(LinearGradient.warmGradient)
                            .cornerRadius(PPRadius.full)
                            .ppShadowColored(.streakOrange)
                        }
                    }
                    .padding(PPSpacing.xl)
                    .background(
                        RoundedRectangle(cornerRadius: PPRadius.xl)
                            .fill(Color.backgroundElevated)
                            .overlay(
                                RoundedRectangle(cornerRadius: PPRadius.xl)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.warmGradientStart.opacity(0.08), Color.clear],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            )
                    )
                    .ppShadowLarge()
                }
                .buttonStyle(PPButtonStyle())
            }
        }
        .sheet(isPresented: $showDailyChallenge) {
            DailyChallengeView()
        }
    }

    // MARK: - Streak Section
    private var streakSection: some View {
        HStack(spacing: PPSpacing.lg) {
            // Streak info
            VStack(alignment: .leading, spacing: PPSpacing.md) {
                Text("CURRENT STREAK")
                    .font(PPFont.captionSmall())
                    .foregroundColor(.textSecondary)
                    .tracking(1)

                HStack(alignment: .firstTextBaseline, spacing: PPSpacing.sm) {
                    // Animated flame
                    Image(systemName: "flame.fill")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundStyle(LinearGradient.streakGradient)

                    Text("\(userManager.currentUser.stats.currentStreak)")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(.textPrimary)

                    Text("days")
                        .font(PPFont.bodyMedium())
                        .foregroundColor(.textSecondary)
                }

                Text(streakMessage)
                    .font(PPFont.bodyMedium())
                    .foregroundColor(.textSecondary)
            }

            Spacer()

            // Week indicator
            VStack(alignment: .trailing, spacing: PPSpacing.md) {
                Text("Best: \(userManager.currentUser.stats.longestStreak)")
                    .font(PPFont.caption())
                    .foregroundColor(.textTertiary)

                // Week dots
                HStack(spacing: 6) {
                    ForEach(0..<7, id: \.self) { day in
                        let isActive = day < (userManager.currentUser.stats.currentStreak % 7 == 0 ? 7 : userManager.currentUser.stats.currentStreak % 7)
                        Circle()
                            .fill(isActive ? LinearGradient.streakGradient : LinearGradient(colors: [.borderLight], startPoint: .top, endPoint: .bottom))
                            .frame(width: 10, height: 10)
                    }
                }
            }
        }
        .padding(PPSpacing.xl)
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

    private var streakMessage: String {
        let streak = userManager.currentUser.stats.currentStreak
        switch streak {
        case 0: return "Start your streak today!"
        case 1...6: return "Keep the momentum going!"
        case 7...13: return "One week strong!"
        case 14...29: return "You're unstoppable!"
        case 30...99: return "Incredible dedication!"
        default: return "Legendary streak!"
        }
    }

    // MARK: - Quick Practice Section
    private var quickPracticeSection: some View {
        VStack(alignment: .leading, spacing: PPSpacing.lg) {
            Text("Quick Practice")
                .font(PPFont.titleLarge())
                .foregroundColor(.textPrimary)

            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: PPSpacing.md),
                GridItem(.flexible(), spacing: PPSpacing.md)
            ], spacing: PPSpacing.md) {
                QuickPracticeCard(
                    title: "Notes",
                    icon: "music.note",
                    color: Color.noteA,
                    duration: "5 min"
                ) {
                    appState.selectedTab = .train
                }

                QuickPracticeCard(
                    title: "Chords",
                    icon: "pianokeys",
                    color: Color.noteASharp,
                    duration: "5 min"
                ) {
                    appState.selectedTab = .train
                }

                QuickPracticeCard(
                    title: "Intervals",
                    icon: "arrow.up.arrow.down",
                    color: Color(hex: "EC4899"),
                    duration: "5 min"
                ) {
                    appState.selectedTab = .train
                }

                QuickPracticeCard(
                    title: "Scales",
                    icon: "music.quarternote.3",
                    color: Color.noteFSharp,
                    duration: "5 min"
                ) {
                    appState.selectedTab = .train
                }
            }
        }
    }

    // MARK: - Weekly Stats Section
    private var weeklyStatsSection: some View {
        VStack(alignment: .leading, spacing: PPSpacing.lg) {
            Text("This Week")
                .font(PPFont.titleLarge())
                .foregroundColor(.textPrimary)

            HStack(spacing: PPSpacing.md) {
                WeeklyStatCard(
                    title: "Accuracy",
                    value: "\(Int(userManager.currentUser.stats.overallAccuracy * 100))%",
                    icon: "target",
                    color: .success
                )

                WeeklyStatCard(
                    title: "Sessions",
                    value: "\(userManager.currentUser.stats.totalSessions)",
                    icon: "checkmark.circle.fill",
                    color: .primaryPurple
                )

                WeeklyStatCard(
                    title: "Time",
                    value: userManager.currentUser.stats.formattedPracticeTime,
                    icon: "clock.fill",
                    color: .info
                )
            }
        }
    }
}

// MARK: - Quick Practice Card
struct QuickPracticeCard: View {
    let title: String
    let icon: String
    let color: Color
    let duration: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: PPSpacing.md) {
                // Icon with glow
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 48, height: 48)

                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(color)
                }

                VStack(alignment: .leading, spacing: PPSpacing.xs) {
                    Text(title)
                        .font(PPFont.titleMedium())
                        .foregroundColor(.textPrimary)

                    Text(duration)
                        .font(PPFont.caption())
                        .foregroundColor(.textTertiary)
                }

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(PPSpacing.lg)
            .frame(height: 140)
            .background(
                RoundedRectangle(cornerRadius: PPRadius.lg)
                    .fill(Color.backgroundElevated)
                    .overlay(
                        RoundedRectangle(cornerRadius: PPRadius.lg)
                            .fill(
                                LinearGradient(
                                    colors: [color.opacity(0.08), Color.clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: PPRadius.lg)
                    .stroke(color.opacity(0.1), lineWidth: 1)
            )
            .ppShadowSmall()
        }
        .buttonStyle(PPButtonStyle())
    }
}

// MARK: - Weekly Stat Card
struct WeeklyStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: PPSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(color)

            Text(value)
                .font(PPFont.titleLarge())
                .foregroundColor(.textPrimary)

            Text(title)
                .font(PPFont.captionSmall())
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, PPSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: PPRadius.md)
                .fill(Color.backgroundElevated)
        )
        .ppShadowSmall()
    }
}

// MARK: - Stat Item (kept for compatibility)
struct StatItem: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(spacing: PPSpacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.primaryPurple)

            Text(value)
                .font(PPFont.titleLarge())
                .foregroundColor(.textPrimary)

            Text(title)
                .font(PPFont.caption())
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Daily Challenge View
struct DailyChallengeView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                Text("Daily Challenge")
                    .font(PPFont.displayLarge())
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(UserManager())
        .environmentObject(AppState())
}
