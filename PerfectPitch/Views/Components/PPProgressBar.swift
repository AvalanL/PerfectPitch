import SwiftUI

// MARK: - Progress Bar
struct PPProgressBar: View {
    let progress: Double
    var height: CGFloat = 8
    var backgroundColor: Color = .backgroundTertiary
    var foregroundColor: Color? = nil
    var showPercentage: Bool = false
    var animated: Bool = true

    @State private var animatedProgress: Double = 0

    var body: some View {
        VStack(spacing: PPSpacing.sm) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(backgroundColor)

                    // Foreground
                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(
                            foregroundColor.map { AnyShapeStyle($0) } ??
                            AnyShapeStyle(LinearGradient.primaryGradient)
                        )
                        .frame(width: geometry.size.width * animatedProgress)
                }
            }
            .frame(height: height)

            if showPercentage {
                Text("\(Int(progress * 100))%")
                    .font(PPFont.captionSmall())
                    .foregroundColor(.textSecondary)
            }
        }
        .onAppear {
            if animated {
                withAnimation(.ppSpring) {
                    animatedProgress = progress
                }
            } else {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { _, newValue in
            if animated {
                withAnimation(.ppSpring) {
                    animatedProgress = newValue
                }
            } else {
                animatedProgress = newValue
            }
        }
    }
}

// MARK: - Circular Progress
struct CircularProgress: View {
    let progress: Double
    var lineWidth: CGFloat = 8
    var size: CGFloat = 100
    var backgroundColor: Color = .backgroundTertiary
    var showPercentage: Bool = true

    @State private var animatedProgress: Double = 0

    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(backgroundColor, lineWidth: lineWidth)

            // Progress circle
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    LinearGradient.primaryGradient,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            // Percentage text
            if showPercentage {
                Text("\(Int(progress * 100))%")
                    .font(PPFont.titleLarge())
                    .foregroundColor(.textPrimary)
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(.ppSpring.delay(0.2)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { _, newValue in
            withAnimation(.ppSpring) {
                animatedProgress = newValue
            }
        }
    }
}

// MARK: - Level Progress
struct LevelProgress: View {
    let level: Int
    let progress: Double
    let xpToNext: Int

    var body: some View {
        VStack(spacing: PPSpacing.sm) {
            HStack {
                Text("Level \(level)")
                    .font(PPFont.titleMedium())
                    .foregroundColor(.textPrimary)

                Spacer()

                Text("\(xpToNext) XP to next")
                    .font(PPFont.caption())
                    .foregroundColor(.textSecondary)
            }

            PPProgressBar(progress: progress, height: 10)
        }
    }
}

// MARK: - Skill Progress Bar
struct SkillProgressBar: View {
    let title: String
    let progress: Double
    let color: Color

    var body: some View {
        VStack(spacing: PPSpacing.sm) {
            HStack {
                Text(title)
                    .font(PPFont.bodyMedium())
                    .foregroundColor(.textPrimary)

                Spacer()

                Text("\(Int(progress * 100))%")
                    .font(PPFont.caption())
                    .foregroundColor(.textSecondary)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.backgroundTertiary)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geometry.size.width * progress)
                }
            }
            .frame(height: 8)
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        PPProgressBar(progress: 0.65, showPercentage: true)

        CircularProgress(progress: 0.75)

        LevelProgress(level: 23, progress: 0.45, xpToNext: 1250)

        SkillProgressBar(title: "Notes", progress: 0.89, color: .primaryPurple)
    }
    .padding()
}
