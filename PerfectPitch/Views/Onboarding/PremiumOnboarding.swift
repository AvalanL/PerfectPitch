import SwiftUI

// MARK: - Premium Onboarding
/// A stunning, Apple Design Award-worthy onboarding experience
/// with fluid animations, delightful interactions, and clear value proposition

struct PremiumOnboardingView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userManager: UserManager

    @State private var currentPage = 0
    @State private var userName = ""
    @State private var dragOffset: CGFloat = 0
    @State private var showNameInput = false

    private let pages = PremiumOnboardingPage.allPages

    var body: some View {
        ZStack {
            // Animated background
            AnimatedOnboardingBackground(currentPage: currentPage)

            VStack(spacing: 0) {
                // Skip button
                skipButton
                    .opacity(currentPage < pages.count - 1 ? 1 : 0)
                    .animation(.easeOut(duration: 0.3), value: currentPage)

                // Content
                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                        if index == pages.count - 1 {
                            nameInputPage
                                .tag(index)
                        } else {
                            OnboardingPageContent(page: page, isActive: currentPage == index)
                                .tag(index)
                        }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: currentPage)

                // Bottom section
                bottomSection
            }
        }
        .ignoresSafeArea(.keyboard)
    }

    // MARK: - Skip Button
    private var skipButton: some View {
        HStack {
            Spacer()
            Button("Skip") {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    currentPage = pages.count - 1
                }
            }
            .font(PPFont.bodyMedium())
            .foregroundColor(.white.opacity(0.8))
            .padding(.trailing, PPSpacing.xl)
            .padding(.top, PPSpacing.lg)
        }
        .frame(height: 50)
    }

    // MARK: - Name Input Page
    private var nameInputPage: some View {
        VStack(spacing: PPSpacing.xxl) {
            Spacer()

            // Animated avatar
            AnimatedAvatarPlaceholder(name: userName)
                .frame(width: 120, height: 120)

            VStack(spacing: PPSpacing.md) {
                Text("What should we call you?")
                    .font(PPFont.displayMedium())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                Text("Personalize your experience")
                    .font(PPFont.bodyLarge())
                    .foregroundColor(.white.opacity(0.7))
            }

            // Name input field
            HStack {
                Image(systemName: "person.fill")
                    .foregroundColor(.white.opacity(0.5))

                TextField("", text: $userName, prompt: Text("Enter your name").foregroundColor(.white.opacity(0.5)))
                    .font(PPFont.titleMedium())
                    .foregroundColor(.white)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()

                if !userName.isEmpty {
                    Button(action: { userName = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
            }
            .padding(PPSpacing.lg)
            .background(.white.opacity(0.15))
            .cornerRadius(PPRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: PPRadius.md)
                    .stroke(.white.opacity(0.3), lineWidth: 1)
            )
            .padding(.horizontal, PPSpacing.xxl)

            Spacer()
            Spacer()
        }
    }

    // MARK: - Bottom Section
    private var bottomSection: some View {
        VStack(spacing: PPSpacing.xxl) {
            // Page indicators
            HStack(spacing: PPSpacing.sm) {
                ForEach(0..<pages.count, id: \.self) { index in
                    Capsule()
                        .fill(index == currentPage ? .white : .white.opacity(0.3))
                        .frame(width: index == currentPage ? 24 : 8, height: 8)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
                }
            }

            // Action button
            Button(action: handleContinue) {
                HStack(spacing: PPSpacing.sm) {
                    Text(buttonTitle)
                        .font(PPFont.titleMedium())

                    if currentPage == pages.count - 1 {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, PPSpacing.lg)
                .background(.white)
                .foregroundColor(.primaryPurple)
                .cornerRadius(PPRadius.lg)
            }
            .padding(.horizontal, PPSpacing.xl)
            .disabled(currentPage == pages.count - 1 && userName.trimmingCharacters(in: .whitespaces).isEmpty)
            .opacity(currentPage == pages.count - 1 && userName.trimmingCharacters(in: .whitespaces).isEmpty ? 0.6 : 1)
        }
        .padding(.bottom, PPSpacing.huge)
    }

    private var buttonTitle: String {
        if currentPage == pages.count - 1 {
            return "Start Training"
        }
        return "Continue"
    }

    private func handleContinue() {
        HapticManager.shared.playImpact(.medium)

        if currentPage < pages.count - 1 {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                currentPage += 1
            }
        } else {
            completeOnboarding()
        }
    }

    private func completeOnboarding() {
        let name = userName.trimmingCharacters(in: .whitespaces)
        if !name.isEmpty {
            var user = userManager.currentUser
            user.name = name
            userManager.updateUser(user)
        }
        userManager.initializeAchievements()

        HapticManager.shared.playSuccess()

        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            appState.completeOnboarding()
        }
    }
}

// MARK: - Animated Background
struct AnimatedOnboardingBackground: View {
    let currentPage: Int

    private let gradients: [[Color]] = [
        [Color(hex: "6366F1"), Color(hex: "8B5CF6")],
        [Color(hex: "EC4899"), Color(hex: "8B5CF6")],
        [Color(hex: "14B8A6"), Color(hex: "6366F1")],
        [Color(hex: "F59E0B"), Color(hex: "EF4444")],
        [Color(hex: "6366F1"), Color(hex: "8B5CF6")]
    ]

    var body: some View {
        ZStack {
            // Main gradient
            LinearGradient(
                colors: gradients[min(currentPage, gradients.count - 1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .animation(.easeInOut(duration: 0.5), value: currentPage)

            // Floating orbs
            FloatingOrbs()

            // Noise texture overlay
            Rectangle()
                .fill(.white.opacity(0.03))
                .background(
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 2, height: 2)
                )
        }
        .ignoresSafeArea()
    }
}

// MARK: - Floating Orbs
struct FloatingOrbs: View {
    @State private var animate = false

    var body: some View {
        ZStack {
            // Large blurred orb 1
            Circle()
                .fill(.white.opacity(0.1))
                .frame(width: 300, height: 300)
                .blur(radius: 60)
                .offset(x: animate ? 50 : -50, y: animate ? -100 : 100)

            // Large blurred orb 2
            Circle()
                .fill(.white.opacity(0.08))
                .frame(width: 250, height: 250)
                .blur(radius: 50)
                .offset(x: animate ? -80 : 80, y: animate ? 150 : -50)

            // Small accent orb
            Circle()
                .fill(.white.opacity(0.15))
                .frame(width: 100, height: 100)
                .blur(radius: 30)
                .offset(x: animate ? 100 : -100, y: animate ? -200 : 200)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}

// MARK: - Page Content
struct OnboardingPageContent: View {
    let page: PremiumOnboardingPage
    let isActive: Bool

    @State private var showContent = false

    var body: some View {
        VStack(spacing: PPSpacing.xxl) {
            Spacer()

            // Animated illustration
            OnboardingIllustration(icon: page.icon, color: page.iconColor, isActive: isActive)
                .frame(width: 200, height: 200)
                .scaleEffect(showContent ? 1 : 0.8)
                .opacity(showContent ? 1 : 0)

            // Text content
            VStack(spacing: PPSpacing.md) {
                Text(page.title)
                    .font(PPFont.displayMedium())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .offset(y: showContent ? 0 : 20)
                    .opacity(showContent ? 1 : 0)

                Text(page.subtitle)
                    .font(PPFont.bodyLarge())
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, PPSpacing.xxl)
                    .offset(y: showContent ? 0 : 20)
                    .opacity(showContent ? 1 : 0)
            }

            // Feature highlights
            if !page.features.isEmpty {
                VStack(spacing: PPSpacing.md) {
                    ForEach(Array(page.features.enumerated()), id: \.offset) { index, feature in
                        FeatureRow(icon: feature.icon, text: feature.text)
                            .offset(y: showContent ? 0 : 20)
                            .opacity(showContent ? 1 : 0)
                            .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(Double(index) * 0.1 + 0.3), value: showContent)
                    }
                }
                .padding(.horizontal, PPSpacing.xxl)
            }

            Spacer()
            Spacer()
        }
        .onChange(of: isActive) { _, active in
            if active {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    showContent = true
                }
            } else {
                showContent = false
            }
        }
        .onAppear {
            if isActive {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        showContent = true
                    }
                }
            }
        }
    }
}

// MARK: - Feature Row
struct FeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: PPSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(.white.opacity(0.2))
                .clipShape(Circle())

            Text(text)
                .font(PPFont.bodyMedium())
                .foregroundColor(.white.opacity(0.9))

            Spacer()
        }
    }
}

// MARK: - Onboarding Illustration
struct OnboardingIllustration: View {
    let icon: String
    let color: Color
    let isActive: Bool

    @State private var animate = false
    @State private var pulseScale: CGFloat = 1.0

    var body: some View {
        ZStack {
            // Pulsing background circles
            ForEach(0..<3) { index in
                Circle()
                    .stroke(.white.opacity(0.1), lineWidth: 2)
                    .frame(width: CGFloat(120 + index * 30), height: CGFloat(120 + index * 30))
                    .scaleEffect(pulseScale)
                    .opacity(Double(3 - index) * 0.3)
            }

            // Inner glow
            Circle()
                .fill(.white.opacity(0.15))
                .frame(width: 140, height: 140)
                .blur(radius: 20)

            // Main circle
            Circle()
                .fill(.white.opacity(0.2))
                .frame(width: 120, height: 120)

            // Icon
            Image(systemName: icon)
                .font(.system(size: 48, weight: .medium))
                .foregroundColor(.white)
                .offset(y: animate ? -5 : 5)
        }
        .onAppear {
            if isActive {
                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                    animate = true
                }
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    pulseScale = 1.1
                }
            }
        }
        .onChange(of: isActive) { _, active in
            if active {
                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                    animate = true
                }
            }
        }
    }
}

// MARK: - Animated Avatar Placeholder
struct AnimatedAvatarPlaceholder: View {
    let name: String

    var body: some View {
        ZStack {
            Circle()
                .fill(.white.opacity(0.2))

            if name.isEmpty {
                Image(systemName: "person.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white.opacity(0.5))
            } else {
                Text(String(name.prefix(1)).uppercased())
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
        }
    }
}

// MARK: - Page Data
struct PremiumOnboardingPage {
    let title: String
    let subtitle: String
    let icon: String
    let iconColor: Color
    let features: [Feature]

    struct Feature {
        let icon: String
        let text: String
    }

    static let allPages: [PremiumOnboardingPage] = [
        PremiumOnboardingPage(
            title: "Develop Perfect Pitch",
            subtitle: "Train your ear to recognize any note, chord, or interval instantly",
            icon: "ear.fill",
            iconColor: .white,
            features: [
                Feature(icon: "music.note", text: "Identify single notes"),
                Feature(icon: "pianokeys", text: "Recognize chord qualities"),
                Feature(icon: "arrow.up.arrow.down", text: "Master intervals")
            ]
        ),
        PremiumOnboardingPage(
            title: "Track Your Progress",
            subtitle: "Watch your skills improve with detailed analytics and insights",
            icon: "chart.line.uptrend.xyaxis",
            iconColor: .white,
            features: [
                Feature(icon: "target", text: "Accuracy tracking"),
                Feature(icon: "clock", text: "Practice time stats"),
                Feature(icon: "chart.bar.fill", text: "Skill breakdowns")
            ]
        ),
        PremiumOnboardingPage(
            title: "Stay Motivated",
            subtitle: "Build streaks, earn achievements, and compete with friends",
            icon: "flame.fill",
            iconColor: .white,
            features: [
                Feature(icon: "flame.fill", text: "Daily streaks"),
                Feature(icon: "trophy.fill", text: "Achievements"),
                Feature(icon: "person.2.fill", text: "Leaderboards")
            ]
        ),
        PremiumOnboardingPage(
            title: "Let's Begin",
            subtitle: "",
            icon: "person.fill",
            iconColor: .white,
            features: []
        )
    ]
}

// MARK: - Preview
#Preview {
    PremiumOnboardingView()
        .environmentObject(AppState())
        .environmentObject(UserManager())
}
