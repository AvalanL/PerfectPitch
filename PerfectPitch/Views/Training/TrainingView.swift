import SwiftUI

struct TrainingView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var selectedCategory: ExerciseCategory?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: PPSpacing.xxl) {
                    // Header with gradient accent
                    VStack(alignment: .leading, spacing: PPSpacing.xs) {
                        HStack(spacing: PPSpacing.sm) {
                            Text("Train")
                                .font(PPFont.displayLarge())
                                .foregroundColor(.textPrimary)

                            Image(systemName: "music.note.list")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundStyle(LinearGradient.primaryGradient)
                        }

                        Text("Choose your exercise")
                            .font(PPFont.bodyLarge())
                            .foregroundColor(.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, PPSpacing.lg)

                    // Training Categories
                    VStack(spacing: PPSpacing.lg) {
                        ForEach(ExerciseCategory.allCases) { category in
                            TrainingCategoryRow(
                                category: category,
                                skillLevel: skillLevel(for: category)
                            ) {
                                selectedCategory = category
                            }
                        }
                    }
                }
                .padding(.horizontal, PPSpacing.lg)
                .padding(.bottom, PPSpacing.huge)
            }
            .background(
                LinearGradient.ambientGradient
                    .ignoresSafeArea()
            )
            .navigationDestination(item: $selectedCategory) { category in
                DifficultySelectionView(category: category)
            }
        }
    }

    private func skillLevel(for category: ExerciseCategory) -> Int {
        switch category {
        case .notes: return userManager.currentUser.stats.noteStats.skillLevel
        case .chords: return userManager.currentUser.stats.chordStats.skillLevel
        case .intervals: return userManager.currentUser.stats.intervalStats.skillLevel
        case .scales, .melodicDictation: return userManager.currentUser.stats.scaleStats.skillLevel
        }
    }
}

// MARK: - Training Category Row
struct TrainingCategoryRow: View {
    let category: ExerciseCategory
    let skillLevel: Int
    let action: () -> Void

    private var categoryColor: Color {
        Color(hex: category.color)
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: PPSpacing.lg) {
                // Icon with glow effect
                ZStack {
                    // Glow
                    Circle()
                        .fill(categoryColor.opacity(0.2))
                        .frame(width: 68, height: 68)
                        .blur(radius: 8)

                    RoundedRectangle(cornerRadius: PPRadius.md)
                        .fill(
                            LinearGradient(
                                colors: [categoryColor.opacity(0.15), categoryColor.opacity(0.08)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)

                    Image(systemName: category.icon)
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundColor(categoryColor)
                }

                // Text content
                VStack(alignment: .leading, spacing: PPSpacing.sm) {
                    Text(category.rawValue)
                        .font(PPFont.titleLarge())
                        .foregroundColor(.textPrimary)

                    Text(category.description)
                        .font(PPFont.bodyMedium())
                        .foregroundColor(.textSecondary)
                        .lineLimit(2)

                    // Skill level dots with gradient
                    HStack(spacing: 4) {
                        ForEach(1...5, id: \.self) { level in
                            Circle()
                                .fill(level <= skillLevel ? categoryColor : Color.borderLight)
                                .frame(width: 8, height: 8)
                        }

                        Text(skillLevelName)
                            .font(PPFont.captionSmall())
                            .foregroundColor(.textTertiary)
                            .padding(.leading, PPSpacing.sm)
                    }
                }

                Spacer()

                // Chevron with colored background
                Circle()
                    .fill(categoryColor.opacity(0.1))
                    .frame(width: 32, height: 32)
                    .overlay(
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(categoryColor)
                    )
            }
            .padding(PPSpacing.lg)
            .background(
                RoundedRectangle(cornerRadius: PPRadius.lg)
                    .fill(Color.backgroundElevated)
                    .overlay(
                        RoundedRectangle(cornerRadius: PPRadius.lg)
                            .fill(
                                LinearGradient(
                                    colors: [categoryColor.opacity(0.05), Color.clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: PPRadius.lg)
                    .stroke(categoryColor.opacity(0.1), lineWidth: 1)
            )
            .ppShadowMedium()
        }
        .buttonStyle(PPButtonStyle())
    }

    private var skillLevelName: String {
        switch skillLevel {
        case 1: return "Beginner"
        case 2: return "Novice"
        case 3: return "Intermediate"
        case 4: return "Advanced"
        default: return "Expert"
        }
    }
}

// MARK: - Difficulty Selection View
struct DifficultySelectionView: View {
    let category: ExerciseCategory
    @State private var selectedDifficulty: Difficulty?
    @Environment(\.dismiss) var dismiss

    private var categoryColor: Color {
        Color(hex: category.color)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: PPSpacing.xxl) {
                // Category Header with glow
                VStack(spacing: PPSpacing.md) {
                    ZStack {
                        // Glow effect
                        Circle()
                            .fill(categoryColor.opacity(0.2))
                            .frame(width: 100, height: 100)
                            .blur(radius: 20)

                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [categoryColor.opacity(0.15), categoryColor.opacity(0.08)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 80, height: 80)

                        Image(systemName: category.icon)
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundColor(categoryColor)
                    }

                    Text(category.rawValue)
                        .font(PPFont.displayMedium())
                        .foregroundColor(.textPrimary)

                    Text("Select difficulty")
                        .font(PPFont.bodyLarge())
                        .foregroundColor(.textSecondary)
                }
                .padding(.top, PPSpacing.xxl)

                // Difficulty Options
                VStack(spacing: PPSpacing.md) {
                    ForEach(Difficulty.allCases) { difficulty in
                        DifficultyCard(
                            difficulty: difficulty,
                            categoryColor: categoryColor
                        ) {
                            selectedDifficulty = difficulty
                        }
                    }
                }
                .padding(.horizontal, PPSpacing.lg)
            }
            .padding(.bottom, PPSpacing.huge)
        }
        .background(
            LinearGradient.ambientGradient
                .ignoresSafeArea()
        )
        .navigationTitle(category.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(item: $selectedDifficulty) { difficulty in
            ExerciseView(category: category, difficulty: difficulty)
        }
    }
}

// MARK: - Difficulty Card
struct DifficultyCard: View {
    let difficulty: Difficulty
    let categoryColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: PPSpacing.sm) {
                    Text(difficulty.name)
                        .font(PPFont.titleMedium())
                        .foregroundColor(.textPrimary)

                    Text(difficultyDescription)
                        .font(PPFont.bodyMedium())
                        .foregroundColor(.textSecondary)

                    // XP Multiplier badge
                    HStack(spacing: PPSpacing.xs) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(LinearGradient.warmGradient)

                        Text("\(String(format: "%.1f", difficulty.xpMultiplier))x XP")
                            .font(PPFont.captionSmall())
                            .foregroundColor(.warning)
                    }
                    .padding(.horizontal, PPSpacing.sm)
                    .padding(.vertical, PPSpacing.xs)
                    .background(Color.warning.opacity(0.1))
                    .cornerRadius(PPRadius.full)
                }

                Spacer()

                // Difficulty indicator bars with gradient
                HStack(spacing: 4) {
                    ForEach(1...5, id: \.self) { level in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(level <= difficulty.rawValue ? categoryColor : Color.borderLight)
                            .frame(width: 8, height: 20)
                    }
                }

                // Chevron in colored circle
                Circle()
                    .fill(categoryColor.opacity(0.1))
                    .frame(width: 28, height: 28)
                    .overlay(
                        Image(systemName: "chevron.right")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(categoryColor)
                    )
                    .padding(.leading, PPSpacing.sm)
            }
            .padding(PPSpacing.lg)
            .background(
                RoundedRectangle(cornerRadius: PPRadius.lg)
                    .fill(Color.backgroundElevated)
                    .overlay(
                        RoundedRectangle(cornerRadius: PPRadius.lg)
                            .fill(
                                LinearGradient(
                                    colors: [categoryColor.opacity(0.03), Color.clear],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: PPRadius.lg)
                    .stroke(Color.borderLight, lineWidth: 1)
            )
            .ppShadowSmall()
        }
        .buttonStyle(PPButtonStyle())
    }

    private var difficultyDescription: String {
        switch difficulty {
        case .beginner: return "White keys only, 3 octaves"
        case .intermediate: return "All notes, 4 octaves"
        case .advanced: return "All notes, varied timbres"
        case .expert: return "Microtonal variations"
        case .master: return "Ultimate challenge"
        }
    }
}

#Preview {
    TrainingView()
        .environmentObject(UserManager())
}
