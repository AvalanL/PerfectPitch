import SwiftUI

// MARK: - Card
struct PPCard<Content: View>: View {
    let content: Content
    var padding: CGFloat
    var backgroundColor: Color

    init(
        padding: CGFloat = PPSpacing.lg,
        backgroundColor: Color = .backgroundPrimary,
        @ViewBuilder content: () -> Content
    ) {
        self.padding = padding
        self.backgroundColor = backgroundColor
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .background(backgroundColor)
            .cornerRadius(PPRadius.lg)
            .ppShadowMedium()
    }
}

// MARK: - Feature Card
struct FeatureCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let iconColor: Color
    let progress: Double?
    let action: () -> Void

    init(
        title: String,
        subtitle: String,
        icon: String,
        iconColor: Color = .primaryPurple,
        progress: Double? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.iconColor = iconColor
        self.progress = progress
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: PPSpacing.lg) {
                // Icon
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.1))
                        .frame(width: 56, height: 56)

                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(iconColor)
                }

                // Text
                VStack(alignment: .leading, spacing: PPSpacing.xs) {
                    Text(title)
                        .font(PPFont.titleMedium())
                        .foregroundColor(.textPrimary)

                    Text(subtitle)
                        .font(PPFont.bodyMedium())
                        .foregroundColor(.textSecondary)

                    if let progress = progress {
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.backgroundTertiary)
                                    .frame(height: 6)

                                RoundedRectangle(cornerRadius: 4)
                                    .fill(LinearGradient.primaryGradient)
                                    .frame(width: geo.size.width * progress, height: 6)
                            }
                        }
                        .frame(height: 6)
                        .padding(.top, PPSpacing.xs)
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.textTertiary)
            }
            .padding(PPSpacing.lg)
            .background(Color.backgroundPrimary)
            .cornerRadius(PPRadius.lg)
            .ppShadowMedium()
        }
        .buttonStyle(PPButtonStyle())
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String?
    let icon: String
    let trend: Trend?

    enum Trend {
        case up(String)
        case down(String)
        case neutral

        var color: Color {
            switch self {
            case .up: return .success
            case .down: return .error
            case .neutral: return .textSecondary
            }
        }

        var icon: String {
            switch self {
            case .up: return "arrow.up"
            case .down: return "arrow.down"
            case .neutral: return "minus"
            }
        }
    }

    init(
        title: String,
        value: String,
        subtitle: String? = nil,
        icon: String,
        trend: Trend? = nil
    ) {
        self.title = title
        self.value = value
        self.subtitle = subtitle
        self.icon = icon
        self.trend = trend
    }

    var body: some View {
        VStack(alignment: .leading, spacing: PPSpacing.sm) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primaryPurple)

                Spacer()

                if let trend = trend {
                    HStack(spacing: 2) {
                        Image(systemName: trend.icon)
                            .font(.system(size: 10, weight: .bold))

                        if case .up(let value) = trend {
                            Text(value)
                                .font(PPFont.captionSmall())
                        } else if case .down(let value) = trend {
                            Text(value)
                                .font(PPFont.captionSmall())
                        }
                    }
                    .foregroundColor(trend.color)
                }
            }

            Text(value)
                .font(PPFont.displayMedium())
                .foregroundColor(.textPrimary)

            Text(title)
                .font(PPFont.caption())
                .foregroundColor(.textSecondary)

            if let subtitle = subtitle {
                Text(subtitle)
                    .font(PPFont.captionSmall())
                    .foregroundColor(.textTertiary)
            }
        }
        .padding(PPSpacing.lg)
        .background(Color.backgroundPrimary)
        .cornerRadius(PPRadius.lg)
        .ppShadowSmall()
    }
}

// MARK: - Training Category Card
struct TrainingCategoryCard: View {
    let category: ExerciseCategory
    let skillLevel: Int
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: PPSpacing.md) {
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: PPRadius.md)
                        .fill(Color(hex: category.color).opacity(0.1))
                        .frame(width: 48, height: 48)

                    Image(systemName: category.icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(Color(hex: category.color))
                }

                Spacer()

                // Text
                VStack(alignment: .leading, spacing: PPSpacing.xs) {
                    Text(category.rawValue)
                        .font(PPFont.titleMedium())
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)

                    Text(category.description)
                        .font(PPFont.caption())
                        .foregroundColor(.textSecondary)
                        .lineLimit(2)
                }

                // Skill Level
                HStack(spacing: 4) {
                    ForEach(1...5, id: \.self) { level in
                        Circle()
                            .fill(level <= skillLevel ? Color(hex: category.color) : Color.borderLight)
                            .frame(width: 8, height: 8)
                    }

                    Spacer()

                    Text(skillLevelName)
                        .font(PPFont.captionSmall())
                        .foregroundColor(.textTertiary)
                }
            }
            .padding(PPSpacing.lg)
            .frame(height: 180)
            .background(Color.backgroundPrimary)
            .cornerRadius(PPRadius.lg)
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

#Preview {
    ScrollView {
        VStack(spacing: 20) {
            FeatureCard(
                title: "Daily Challenge",
                subtitle: "Today's Focus: Chord Quality",
                icon: "flame.fill",
                iconColor: .orange,
                progress: 0.6,
                action: {}
            )

            HStack(spacing: 12) {
                StatCard(
                    title: "Accuracy",
                    value: "87%",
                    icon: "target",
                    trend: .up("3%")
                )
                StatCard(
                    title: "Streak",
                    value: "14",
                    subtitle: "days",
                    icon: "flame.fill"
                )
            }

            TrainingCategoryCard(
                category: .notes,
                skillLevel: 3,
                action: {}
            )
        }
        .padding()
    }
    .background(Color.backgroundSecondary)
}
