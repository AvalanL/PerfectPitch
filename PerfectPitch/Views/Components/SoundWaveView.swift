import SwiftUI

// MARK: - Sound Wave View
struct SoundWaveView: View {
    @Binding var isPlaying: Bool
    var barCount: Int = 5
    var color: Color = .primaryPurple

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<barCount, id: \.self) { index in
                SoundBar(isPlaying: isPlaying, delay: Double(index) * 0.1, color: color)
            }
        }
    }
}

struct SoundBar: View {
    let isPlaying: Bool
    let delay: Double
    let color: Color

    @State private var height: CGFloat = 8

    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(color)
            .frame(width: 4, height: height)
            .onChange(of: isPlaying) { _, playing in
                if playing {
                    animate()
                } else {
                    withAnimation(.ppFast) {
                        height = 8
                    }
                }
            }
            .onAppear {
                if isPlaying {
                    animate()
                }
            }
    }

    private func animate() {
        guard isPlaying else { return }

        withAnimation(
            .easeInOut(duration: 0.3)
            .repeatForever(autoreverses: true)
            .delay(delay)
        ) {
            height = CGFloat.random(in: 16...32)
        }
    }
}

// MARK: - Play Button
struct PlayButton: View {
    let isPlaying: Bool
    let action: () -> Void
    var size: CGFloat = 80

    var body: some View {
        Button(action: action) {
            ZStack {
                // Outer ring
                Circle()
                    .stroke(
                        LinearGradient.primaryGradient,
                        lineWidth: 3
                    )
                    .frame(width: size, height: size)

                // Inner circle
                Circle()
                    .fill(Color.backgroundPrimary)
                    .frame(width: size - 8, height: size - 8)
                    .ppShadowMedium()

                // Sound wave or play icon
                if isPlaying {
                    SoundWaveView(isPlaying: .constant(true), barCount: 3)
                } else {
                    Image(systemName: "play.fill")
                        .font(.system(size: size * 0.3))
                        .foregroundColor(.primaryPurple)
                        .offset(x: 2)
                }
            }
        }
        .buttonStyle(PPButtonStyle())
    }
}

// MARK: - Animated Checkmark
struct AnimatedCheckmark: View {
    @State private var isAnimated = false

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.success.opacity(0.15))
                .frame(width: 80, height: 80)

            Circle()
                .fill(Color.success)
                .frame(width: 60, height: 60)
                .scaleEffect(isAnimated ? 1 : 0)

            Image(systemName: "checkmark")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.white)
                .scaleEffect(isAnimated ? 1 : 0)
        }
        .onAppear {
            withAnimation(.ppBounce.delay(0.1)) {
                isAnimated = true
            }
        }
    }
}

// MARK: - Animated X
struct AnimatedX: View {
    @State private var isAnimated = false
    @State private var shake = false

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.error.opacity(0.15))
                .frame(width: 80, height: 80)

            Circle()
                .fill(Color.error)
                .frame(width: 60, height: 60)
                .scaleEffect(isAnimated ? 1 : 0)

            Image(systemName: "xmark")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.white)
                .scaleEffect(isAnimated ? 1 : 0)
        }
        .offset(x: shake ? -5 : 0)
        .onAppear {
            withAnimation(.ppBounce.delay(0.1)) {
                isAnimated = true
            }
            withAnimation(.easeInOut(duration: 0.1).repeatCount(3).delay(0.2)) {
                shake = true
            }
        }
    }
}

// MARK: - XP Gain Animation
struct XPGainView: View {
    let amount: Int
    @State private var offset: CGFloat = 0
    @State private var opacity: Double = 1

    var body: some View {
        Text("+\(amount) XP")
            .font(PPFont.titleMedium())
            .foregroundColor(.primaryPurple)
            .offset(y: offset)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeOut(duration: 1.5)) {
                    offset = -50
                    opacity = 0
                }
            }
    }
}

// MARK: - Streak Flame
struct StreakFlame: View {
    let streakCount: Int
    @State private var isAnimating = false

    var body: some View {
        HStack(spacing: PPSpacing.sm) {
            ZStack {
                Image(systemName: "flame.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(LinearGradient.streakGradient)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(
                        .easeInOut(duration: 0.6)
                        .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
            }

            Text("\(streakCount)")
                .font(PPFont.displayMedium())
                .foregroundColor(.textPrimary)
        }
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        SoundWaveView(isPlaying: .constant(true))

        PlayButton(isPlaying: false, action: {})

        AnimatedCheckmark()

        AnimatedX()

        XPGainView(amount: 25)

        StreakFlame(streakCount: 14)
    }
    .padding()
}
