import SwiftUI

struct ProgressView: View {
    @EnvironmentObject var userManager: UserManager

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: PPSpacing.xxl) {
                    // Header with gradient accent
                    VStack(alignment: .leading, spacing: PPSpacing.xs) {
                        HStack(spacing: PPSpacing.sm) {
                            Text("Progress")
                                .font(PPFont.displayLarge())
                                .foregroundColor(.textPrimary)

                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundStyle(LinearGradient.primaryGradient)
                        }

                        Text("Track your ear training journey")
                            .font(PPFont.bodyLarge())
                            .foregroundColor(.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, PPSpacing.lg)

                    // Level Card
                    levelCard

                    // Overall Stats
                    overallStatsSection

                    // Skills Breakdown
                    skillsBreakdownSection

                    // Achievements
                    achievementsSection
                }
                .padding(.horizontal, PPSpacing.lg)
                .padding(.bottom, PPSpacing.huge)
            }
            .background(
                LinearGradient.ambientGradient
                    .ignoresSafeArea()
            )
        }
    }

    // MARK: - Level Card
    private var levelCard: some View {
        VStack(spacing: PPSpacing.lg) {
            HStack {
                VStack(alignment: .leading, spacing: PPSpacing.xs) {
                    HStack(spacing: PPSpacing.sm) {
                        Text("LEVEL \(userManager.currentUser.level)")
                            .font(PPFont.captionSmall())
                            .foregroundColor(.primaryPurple)
                            .tracking(1.5)

                        Image(systemName: "sparkles")
                            .font(.system(size: 12))
                            .foregroundStyle(LinearGradient.primaryGradient)
                    }

                    Text(userManager.currentUser.levelTitle)
                        .font(PPFont.displayMedium())
                        .foregroundColor(.textPrimary)
                }

                Spacer()

                // Circular progress with glow
                ZStack {
                    // Glow
                    Circle()
                        .fill(Color.primaryPurple.opacity(0.15))
                        .frame(width: 90, height: 90)
                        .blur(radius: 15)

                    Circle()
                        .stroke(Color.borderLight, lineWidth: 6)
                        .frame(width: 70, height: 70)

                    Circle()
                        .trim(from: 0, to: userManager.currentUser.levelProgress)
                        .stroke(
                            LinearGradient.primaryGradient,
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 70, height: 70)
                        .rotationEffect(.degrees(-90))
                        .shadow(color: .primaryPurple.opacity(0.4), radius: 4, x: 0, y: 0)

                    Text("\(userManager.currentUser.level)")
                        .font(PPFont.titleLarge())
                        .foregroundStyle(LinearGradient.primaryGradient)
                }
            }

            // XP Progress
            VStack(spacing: PPSpacing.sm) {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.borderLight)
                            .frame(height: 10)

                        RoundedRectangle(cornerRadius: 5)
                            .fill(LinearGradient.primaryGradient)
                            .frame(width: geo.size.width * userManager.currentUser.levelProgress, height: 10)
                            .shadow(color: .primaryPurple.opacity(0.4), radius: 4, x: 0, y: 0)
                    }
                }
                .frame(height: 10)

                HStack {
                    Text("\(userManager.currentUser.stats.totalXP) XP")
                        .font(PPFont.caption())
                        .foregroundColor(.textSecondary)

                    Spacer()

                    Text("\(userManager.currentUser.xpForNextLevel) XP to level \(userManager.currentUser.level + 1)")
                        .font(PPFont.caption())
                        .foregroundColor(.textTertiary)
                }
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
                                colors: [Color.primaryPurple.opacity(0.08), Color.clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
        )
        .ppShadowLarge()
    }

    // MARK: - Overall Stats Section
    private var overallStatsSection: some View {
        VStack(alignment: .leading, spacing: PPSpacing.md) {
            Text("Overall Stats")
                .font(PPFont.titleLarge())
                .foregroundColor(.textPrimary)

            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: PPSpacing.md),
                GridItem(.flexible(), spacing: PPSpacing.md)
            ], spacing: PPSpacing.md) {
                StatCard(
                    title: "Accuracy",
                    value: "\(Int(userManager.currentUser.stats.overallAccuracy * 100))%",
                    icon: "target"
                )

                StatCard(
                    title: "Sessions",
                    value: "\(userManager.currentUser.stats.totalSessions)",
                    icon: "checkmark.circle"
                )

                StatCard(
                    title: "Streak",
                    value: "\(userManager.currentUser.stats.currentStreak)",
                    subtitle: "days",
                    icon: "flame.fill"
                )

                StatCard(
                    title: "Practice Time",
                    value: userManager.currentUser.stats.formattedPracticeTime,
                    icon: "clock"
                )
            }
        }
    }

    // MARK: - Skills Breakdown Section
    private var skillsBreakdownSection: some View {
        VStack(alignment: .leading, spacing: PPSpacing.md) {
            Text("Skills Breakdown")
                .font(PPFont.titleLarge())
                .foregroundColor(.textPrimary)

            PPCard {
                VStack(spacing: PPSpacing.lg) {
                    SkillProgressBar(
                        title: "Notes",
                        progress: userManager.currentUser.stats.noteStats.accuracy,
                        color: Color(hex: "6366F1")
                    )

                    SkillProgressBar(
                        title: "Chords",
                        progress: userManager.currentUser.stats.chordStats.accuracy,
                        color: Color(hex: "8B5CF6")
                    )

                    SkillProgressBar(
                        title: "Intervals",
                        progress: userManager.currentUser.stats.intervalStats.accuracy,
                        color: Color(hex: "EC4899")
                    )

                    SkillProgressBar(
                        title: "Scales",
                        progress: userManager.currentUser.stats.scaleStats.accuracy,
                        color: Color(hex: "14B8A6")
                    )
                }
            }
        }
    }

    // MARK: - Achievements Section
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: PPSpacing.md) {
            HStack {
                Text("Achievements")
                    .font(PPFont.titleLarge())
                    .foregroundColor(.textPrimary)

                Spacer()

                NavigationLink(destination: AllAchievementsView()) {
                    Text("View All")
                        .font(PPFont.bodyMedium())
                        .foregroundColor(.primaryPurple)
                }
            }

            // Recent achievements
            let unlockedAchievements = userManager.currentUser.achievements.filter { $0.isUnlocked }
            let displayAchievements = Array(unlockedAchievements.prefix(4))

            if displayAchievements.isEmpty {
                PPCard {
                    VStack(spacing: PPSpacing.md) {
                        Image(systemName: "trophy")
                            .font(.system(size: 40))
                            .foregroundColor(.textTertiary)

                        Text("No achievements yet")
                            .font(PPFont.bodyMedium())
                            .foregroundColor(.textSecondary)

                        Text("Complete exercises to unlock achievements!")
                            .font(PPFont.caption())
                            .foregroundColor(.textTertiary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, PPSpacing.xl)
                }
            } else {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: PPSpacing.md) {
                    ForEach(displayAchievements) { achievement in
                        AchievementBadge(achievement: achievement)
                    }
                }
            }
        }
    }
}

// MARK: - Achievement Badge
struct AchievementBadge: View {
    let achievement: Achievement

    var body: some View {
        VStack(spacing: PPSpacing.sm) {
            ZStack {
                Circle()
                    .fill(
                        achievement.isUnlocked ?
                        LinearGradient.primaryGradient :
                        LinearGradient(colors: [.backgroundTertiary], startPoint: .top, endPoint: .bottom)
                    )
                    .frame(width: 56, height: 56)

                Image(systemName: achievement.icon)
                    .font(.system(size: 24))
                    .foregroundColor(achievement.isUnlocked ? .white : .textTertiary)
            }

            Text(achievement.title)
                .font(PPFont.captionSmall())
                .foregroundColor(achievement.isUnlocked ? .textPrimary : .textTertiary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
    }
}

// MARK: - All Achievements View
struct AllAchievementsView: View {
    @EnvironmentObject var userManager: UserManager

    var body: some View {
        ScrollView {
            VStack(spacing: PPSpacing.xl) {
                ForEach(Achievement.Category.allCases, id: \.self) { category in
                    achievementCategorySection(category)
                }
            }
            .padding(.horizontal, PPSpacing.lg)
            .padding(.bottom, PPSpacing.huge)
        }
        .background(
            LinearGradient.ambientGradient
                .ignoresSafeArea()
        )
        .navigationTitle("Achievements")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func achievementCategorySection(_ category: Achievement.Category) -> some View {
        let achievements = userManager.currentUser.achievements.filter { $0.category == category }

        return VStack(alignment: .leading, spacing: PPSpacing.md) {
            HStack(spacing: PPSpacing.sm) {
                Image(systemName: category.icon)
                    .foregroundColor(.primaryPurple)

                Text(category.rawValue)
                    .font(PPFont.titleLarge())
                    .foregroundColor(.textPrimary)

                Spacer()

                Text("\(achievements.filter { $0.isUnlocked }.count)/\(achievements.count)")
                    .font(PPFont.caption())
                    .foregroundColor(.textSecondary)
            }

            VStack(spacing: PPSpacing.sm) {
                ForEach(achievements) { achievement in
                    AchievementRow(achievement: achievement)
                }
            }
        }
    }
}

// MARK: - Achievement Row
struct AchievementRow: View {
    let achievement: Achievement

    var body: some View {
        HStack(spacing: PPSpacing.lg) {
            // Icon with glow for unlocked
            ZStack {
                if achievement.isUnlocked {
                    Circle()
                        .fill(Color.primaryPurple.opacity(0.2))
                        .frame(width: 56, height: 56)
                        .blur(radius: 8)
                }

                Circle()
                    .fill(
                        achievement.isUnlocked ?
                        LinearGradient.primaryGradient :
                        LinearGradient(colors: [.backgroundTertiary], startPoint: .top, endPoint: .bottom)
                    )
                    .frame(width: 48, height: 48)

                Image(systemName: achievement.icon)
                    .font(.system(size: 20))
                    .foregroundColor(achievement.isUnlocked ? .white : .textTertiary)
            }

            // Text
            VStack(alignment: .leading, spacing: PPSpacing.xs) {
                Text(achievement.title)
                    .font(PPFont.titleMedium())
                    .foregroundColor(achievement.isUnlocked ? .textPrimary : .textSecondary)

                Text(achievement.description)
                    .font(PPFont.caption())
                    .foregroundColor(.textTertiary)

                if !achievement.isUnlocked {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.borderLight)
                                .frame(height: 4)

                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.primaryPurple.opacity(0.5))
                                .frame(width: geo.size.width * achievement.progressPercentage, height: 4)
                        }
                    }
                    .frame(height: 4)
                }
            }

            Spacer()

            if achievement.isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(LinearGradient.successGradient)
            } else {
                Text("\(achievement.progress)/\(achievement.requirement)")
                    .font(PPFont.captionSmall())
                    .foregroundColor(.textTertiary)
                    .padding(.horizontal, PPSpacing.sm)
                    .padding(.vertical, PPSpacing.xs)
                    .background(Color.backgroundTertiary)
                    .cornerRadius(PPRadius.full)
            }
        }
        .padding(PPSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: PPRadius.md)
                .fill(Color.backgroundElevated)
        )
        .overlay(
            RoundedRectangle(cornerRadius: PPRadius.md)
                .stroke(achievement.isUnlocked ? Color.primaryPurple.opacity(0.2) : Color.borderLight, lineWidth: 1)
        )
        .ppShadowSmall()
    }
}

#Preview {
    ProgressView()
        .environmentObject(UserManager())
}
