import SwiftUI

// MARK: - Glassmorphism Card
/// A frosted glass card effect inspired by Apple's visionOS and iOS design language
struct GlassCard<Content: View>: View {
    let content: Content
    var cornerRadius: CGFloat = PPRadius.lg
    var opacity: Double = 0.7

    init(
        cornerRadius: CGFloat = PPRadius.lg,
        opacity: Double = 0.7,
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.opacity = opacity
        self.content = content()
    }

    var body: some View {
        content
            .background(
                ZStack {
                    // Base blur
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(.ultraThinMaterial)

                    // Gradient overlay for depth
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.25),
                                    .white.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    // Inner border highlight
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.6),
                                    .white.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

// MARK: - Animated Gradient Background
/// A beautiful animated gradient that subtly shifts colors
struct AnimatedGradientBackground: View {
    @State private var animateGradient = false

    let colors: [Color]
    var duration: Double = 5.0

    init(colors: [Color] = [.primaryGradientStart, .primaryGradientEnd, .primaryPurple]) {
        self.colors = colors
    }

    var body: some View {
        LinearGradient(
            colors: colors,
            startPoint: animateGradient ? .topLeading : .bottomLeading,
            endPoint: animateGradient ? .bottomTrailing : .topTrailing
        )
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: true)) {
                animateGradient.toggle()
            }
        }
    }
}

// MARK: - Mesh Gradient Background (iOS 18+)
struct MeshGradientBackground: View {
    @State private var animate = false

    var body: some View {
        TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate

            Canvas { context, size in
                // Create animated mesh gradient effect
                let colors: [Color] = [
                    .primaryGradientStart,
                    .primaryGradientEnd,
                    .primaryPurple,
                    Color(hex: "EC4899"),
                    Color(hex: "14B8A6")
                ]

                for (index, color) in colors.enumerated() {
                    let phase = time * 0.5 + Double(index) * 0.8
                    let x = size.width * (0.5 + 0.3 * sin(phase))
                    let y = size.height * (0.5 + 0.3 * cos(phase * 1.2))

                    let gradient = Gradient(colors: [color.opacity(0.6), color.opacity(0)])
                    let center = CGPoint(x: x, y: y)

                    context.fill(
                        Circle().path(in: CGRect(x: x - 200, y: y - 200, width: 400, height: 400)),
                        with: .radialGradient(
                            gradient,
                            center: center,
                            startRadius: 0,
                            endRadius: 200
                        )
                    )
                }
            }
        }
        .ignoresSafeArea()
        .blur(radius: 60)
        .overlay(Color.backgroundPrimary.opacity(0.3))
    }
}

// MARK: - Particle Celebration Effect
struct ParticleEffect: View {
    let isActive: Bool
    let particleCount: Int
    let colors: [Color]

    @State private var particles: [Particle] = []

    struct Particle: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        var scale: CGFloat
        var opacity: Double
        var rotation: Double
        var color: Color
    }

    init(
        isActive: Bool,
        particleCount: Int = 50,
        colors: [Color] = [.primaryPurple, .warning, .success, Color(hex: "EC4899")]
    ) {
        self.isActive = isActive
        self.particleCount = particleCount
        self.colors = colors
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(particle.color)
                        .frame(width: 8 * particle.scale, height: 8 * particle.scale)
                        .position(x: particle.x, y: particle.y)
                        .opacity(particle.opacity)
                        .rotationEffect(.degrees(particle.rotation))
                }
            }
            .onChange(of: isActive) { _, active in
                if active {
                    triggerCelebration(in: geometry.size)
                }
            }
        }
        .allowsHitTesting(false)
    }

    private func triggerCelebration(in size: CGSize) {
        particles = (0..<particleCount).map { _ in
            Particle(
                x: size.width / 2,
                y: size.height / 2,
                scale: CGFloat.random(in: 0.5...1.5),
                opacity: 1,
                rotation: Double.random(in: 0...360),
                color: colors.randomElement()!
            )
        }

        for (index, _) in particles.enumerated() {
            let angle = Double.random(in: 0...360) * .pi / 180
            let distance = CGFloat.random(in: 100...300)
            let endX = size.width / 2 + cos(angle) * distance
            let endY = size.height / 2 + sin(angle) * distance - 100

            withAnimation(.easeOut(duration: Double.random(in: 0.8...1.5)).delay(Double(index) * 0.01)) {
                particles[index].x = endX
                particles[index].y = endY
                particles[index].opacity = 0
                particles[index].rotation += Double.random(in: 180...720)
            }
        }
    }
}

// MARK: - Confetti Burst
struct ConfettiBurst: View {
    @Binding var isActive: Bool

    @State private var confetti: [ConfettiPiece] = []

    struct ConfettiPiece: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        var rotation: Double
        var scale: CGFloat
        let color: Color
        let shape: ConfettiShape
    }

    enum ConfettiShape: CaseIterable {
        case circle, rectangle, triangle
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(confetti) { piece in
                    confettiView(for: piece)
                        .position(x: piece.x, y: piece.y)
                        .rotationEffect(.degrees(piece.rotation))
                        .scaleEffect(piece.scale)
                }
            }
            .onChange(of: isActive) { _, active in
                if active {
                    burst(in: geo.size)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isActive = false
                    }
                }
            }
        }
        .allowsHitTesting(false)
    }

    @ViewBuilder
    private func confettiView(for piece: ConfettiPiece) -> some View {
        switch piece.shape {
        case .circle:
            Circle()
                .fill(piece.color)
                .frame(width: 10, height: 10)
        case .rectangle:
            Rectangle()
                .fill(piece.color)
                .frame(width: 8, height: 12)
        case .triangle:
            Triangle()
                .fill(piece.color)
                .frame(width: 10, height: 10)
        }
    }

    private func burst(in size: CGSize) {
        let colors: [Color] = [
            .primaryPurple, .warning, .success,
            Color(hex: "EC4899"), Color(hex: "06B6D4"), .orange
        ]

        confetti = (0..<60).map { _ in
            ConfettiPiece(
                x: size.width / 2,
                y: size.height + 20,
                rotation: 0,
                scale: CGFloat.random(in: 0.8...1.2),
                color: colors.randomElement()!,
                shape: ConfettiShape.allCases.randomElement()!
            )
        }

        for i in confetti.indices {
            let randomX = CGFloat.random(in: 20...(size.width - 20))
            let randomY = CGFloat.random(in: -50...size.height * 0.6)

            withAnimation(
                .interpolatingSpring(stiffness: 50, damping: 8)
                .delay(Double.random(in: 0...0.3))
            ) {
                confetti[i].x = randomX
                confetti[i].y = randomY
                confetti[i].rotation = Double.random(in: 0...720)
            }

            // Fall down
            withAnimation(
                .easeIn(duration: 2)
                .delay(0.5 + Double.random(in: 0...0.5))
            ) {
                confetti[i].y = size.height + 50
                confetti[i].rotation += Double.random(in: 180...540)
            }
        }
    }
}

// MARK: - Triangle Shape
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// MARK: - Pulsing Glow Effect
struct PulsingGlow: ViewModifier {
    let color: Color
    let radius: CGFloat

    @State private var isAnimating = false

    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(isAnimating ? 0.6 : 0.2), radius: isAnimating ? radius : radius / 2)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    isAnimating = true
                }
            }
    }
}

extension View {
    func pulsingGlow(color: Color = .primaryPurple, radius: CGFloat = 20) -> some View {
        modifier(PulsingGlow(color: color, radius: radius))
    }
}

// MARK: - Shimmer Effect
struct ShimmerEffect: ViewModifier {
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        colors: [
                            .clear,
                            .white.opacity(0.4),
                            .clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geo.size.width * 0.7)
                    .offset(x: -geo.size.width + phase * geo.size.width * 2)
                    .onAppear {
                        withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                            phase = 1
                        }
                    }
                }
            )
            .mask(content)
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerEffect())
    }
}

// MARK: - Musical Visualizer
struct MusicalVisualizer: View {
    @Binding var isPlaying: Bool
    let barCount: Int
    let color: Color

    init(isPlaying: Binding<Bool>, barCount: Int = 7, color: Color = .primaryPurple) {
        self._isPlaying = isPlaying
        self.barCount = barCount
        self.color = color
    }

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<barCount, id: \.self) { index in
                VisualizerBar(
                    isPlaying: isPlaying,
                    delay: Double(index) * 0.1,
                    color: color
                )
            }
        }
    }
}

struct VisualizerBar: View {
    let isPlaying: Bool
    let delay: Double
    let color: Color

    @State private var height: CGFloat = 8

    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(
                LinearGradient(
                    colors: [color, color.opacity(0.6)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(width: 4, height: height)
            .animation(
                isPlaying ?
                    .easeInOut(duration: 0.3)
                    .repeatForever(autoreverses: true)
                    .delay(delay) :
                    .easeOut(duration: 0.2),
                value: height
            )
            .onChange(of: isPlaying) { _, playing in
                height = playing ? CGFloat.random(in: 16...40) : 8
            }
            .onAppear {
                if isPlaying {
                    height = CGFloat.random(in: 16...40)
                }
            }
    }
}

// MARK: - Premium Play Button
struct PremiumPlayButton: View {
    let isPlaying: Bool
    let action: () -> Void

    @State private var isPressed = false
    @State private var ringScale: CGFloat = 1.0
    @State private var ringOpacity: Double = 0.0

    var body: some View {
        Button(action: {
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()

            // Ripple animation
            withAnimation(.easeOut(duration: 0.6)) {
                ringScale = 1.5
                ringOpacity = 0
            }
            ringScale = 1.0
            ringOpacity = 0.5

            action()
        }) {
            ZStack {
                // Outer pulsing ring
                Circle()
                    .stroke(
                        LinearGradient.primaryGradient,
                        lineWidth: 2
                    )
                    .frame(width: 100, height: 100)
                    .scaleEffect(ringScale)
                    .opacity(ringOpacity)

                // Outer ring
                Circle()
                    .stroke(
                        LinearGradient.primaryGradient,
                        lineWidth: 3
                    )
                    .frame(width: 100, height: 100)

                // Inner filled circle
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.backgroundPrimary, Color.backgroundSecondary],
                            center: .center,
                            startRadius: 0,
                            endRadius: 50
                        )
                    )
                    .frame(width: 90, height: 90)
                    .ppShadowLarge()

                // Content
                if isPlaying {
                    MusicalVisualizer(isPlaying: .constant(true), barCount: 5)
                } else {
                    Image(systemName: "play.fill")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundStyle(LinearGradient.primaryGradient)
                        .offset(x: 3)
                }
            }
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .pressEvents {
            withAnimation(.ppFast) { isPressed = true }
        } onRelease: {
            withAnimation(.ppFast) { isPressed = false }
        }
    }
}

// MARK: - Press Events Modifier
struct PressEventsModifier: ViewModifier {
    var onPress: () -> Void
    var onRelease: () -> Void

    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in onPress() }
                    .onEnded { _ in onRelease() }
            )
    }
}

extension View {
    func pressEvents(onPress: @escaping () -> Void, onRelease: @escaping () -> Void) -> some View {
        modifier(PressEventsModifier(onPress: onPress, onRelease: onRelease))
    }
}

// MARK: - Animated Score Counter
struct AnimatedScoreCounter: View {
    let score: Int
    let total: Int

    @State private var displayedScore: Int = 0

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            Text("\(displayedScore)")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(LinearGradient.primaryGradient)
                .contentTransition(.numericText())

            Text("/ \(total)")
                .font(PPFont.titleLarge())
                .foregroundColor(.textSecondary)
        }
        .onAppear {
            animateScore()
        }
        .onChange(of: score) { _, _ in
            animateScore()
        }
    }

    private func animateScore() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            displayedScore = score
        }
    }
}

// MARK: - Star Rating View
struct StarRatingView: View {
    let rating: Int
    let maxRating: Int

    @State private var animatedStars: [Bool] = []

    init(rating: Int, maxRating: Int = 3) {
        self.rating = rating
        self.maxRating = maxRating
        self._animatedStars = State(initialValue: Array(repeating: false, count: maxRating))
    }

    var body: some View {
        HStack(spacing: PPSpacing.sm) {
            ForEach(0..<maxRating, id: \.self) { index in
                Image(systemName: index < rating ? "star.fill" : "star")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(index < rating ? .warning : .borderLight)
                    .scaleEffect(animatedStars[index] ? 1.3 : 1.0)
                    .rotationEffect(.degrees(animatedStars[index] ? 360 : 0))
            }
        }
        .onAppear {
            animateStars()
        }
    }

    private func animateStars() {
        for index in 0..<rating {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.2) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
                    if index < animatedStars.count {
                        animatedStars[index] = true
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        if index < animatedStars.count {
                            animatedStars[index] = false
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Circular Note Indicator
struct CircularNoteIndicator: View {
    let note: PitchClass
    let isCorrect: Bool?
    let isSelected: Bool

    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .fill(backgroundColor)
                .frame(width: 64, height: 64)

            // Border
            Circle()
                .stroke(borderColor, lineWidth: 3)
                .frame(width: 64, height: 64)

            // Note name
            Text(note.name)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(textColor)
        }
        .ppShadowSmall()
    }

    private var backgroundColor: Color {
        if let correct = isCorrect {
            return correct ? .success.opacity(0.15) : .error.opacity(0.15)
        }
        return isSelected ? Color.noteColor(for: Note(pitchClass: note, octave: 4)).opacity(0.15) : .backgroundSecondary
    }

    private var borderColor: Color {
        if let correct = isCorrect {
            return correct ? .success : .error
        }
        return isSelected ? Color.noteColor(for: Note(pitchClass: note, octave: 4)) : .borderLight
    }

    private var textColor: Color {
        if let correct = isCorrect {
            return correct ? .success : .error
        }
        return isSelected ? Color.noteColor(for: Note(pitchClass: note, octave: 4)) : .textPrimary
    }
}

// MARK: - Haptic Manager
class HapticManager {
    static let shared = HapticManager()

    private init() {}

    func playSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    func playError() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }

    func playSelection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }

    func playImpact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    func playNote() {
        // Custom haptic pattern for musical feedback
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred(intensity: 0.7)
    }

    func playLevelUp() {
        // Celebratory haptic sequence
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let impact = UIImpactFeedbackGenerator(style: .heavy)
            impact.impactOccurred()
        }
    }
}

// MARK: - Preview
#Preview("Premium Components") {
    ScrollView {
        VStack(spacing: 40) {
            GlassCard {
                VStack(spacing: 16) {
                    Text("Glass Card")
                        .font(PPFont.titleLarge())
                    Text("Beautiful frosted glass effect")
                        .font(PPFont.bodyMedium())
                        .foregroundColor(.textSecondary)
                }
                .padding(24)
            }
            .padding(.horizontal)

            PremiumPlayButton(isPlaying: false) {}

            AnimatedScoreCounter(score: 17, total: 20)

            StarRatingView(rating: 3)

            HStack(spacing: 12) {
                CircularNoteIndicator(note: .C, isCorrect: nil, isSelected: false)
                CircularNoteIndicator(note: .E, isCorrect: true, isSelected: true)
                CircularNoteIndicator(note: .G, isCorrect: false, isSelected: true)
            }
        }
        .padding(.vertical, 40)
    }
    .background(AnimatedGradientBackground())
}
