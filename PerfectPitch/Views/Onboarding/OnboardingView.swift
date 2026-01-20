import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userManager: UserManager
    @State private var currentPage = 0
    @State private var userName = ""

    private let pages = OnboardingPage.pages

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color.primaryGradientStart.opacity(0.1),
                    Color.backgroundPrimary
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Skip button
                HStack {
                    Spacer()
                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            withAnimation {
                                currentPage = pages.count - 1
                            }
                        }
                        .font(PPFont.bodyMedium())
                        .foregroundColor(.textSecondary)
                        .padding(.trailing, PPSpacing.lg)
                        .padding(.top, PPSpacing.lg)
                    }
                }
                .frame(height: 50)

                // Page content
                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                        if index == pages.count - 1 {
                            // Name entry page
                            nameEntryPage
                                .tag(index)
                        } else {
                            OnboardingPageView(page: page)
                                .tag(index)
                        }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.ppSpring, value: currentPage)

                // Page indicator and button
                VStack(spacing: PPSpacing.xxl) {
                    // Page dots
                    HStack(spacing: PPSpacing.sm) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? Color.primaryPurple : Color.borderLight)
                                .frame(width: 8, height: 8)
                                .scaleEffect(index == currentPage ? 1.2 : 1.0)
                                .animation(.ppSpring, value: currentPage)
                        }
                    }

                    // Continue button
                    PPButton(
                        currentPage == pages.count - 1 ? "Get Started" : "Continue",
                        icon: currentPage == pages.count - 1 ? "arrow.right" : nil
                    ) {
                        if currentPage < pages.count - 1 {
                            withAnimation {
                                currentPage += 1
                            }
                        } else {
                            completeOnboarding()
                        }
                    }
                    .padding(.horizontal, PPSpacing.lg)
                    .disabled(currentPage == pages.count - 1 && userName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding(.bottom, PPSpacing.huge)
            }
        }
    }

    // MARK: - Name Entry Page
    private var nameEntryPage: some View {
        VStack(spacing: PPSpacing.xxl) {
            Spacer()

            // Icon
            ZStack {
                Circle()
                    .fill(LinearGradient.primaryGradient.opacity(0.1))
                    .frame(width: 120, height: 120)

                Image(systemName: "person.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(LinearGradient.primaryGradient)
            }

            // Text
            VStack(spacing: PPSpacing.md) {
                Text("What's your name?")
                    .font(PPFont.displayMedium())
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)

                Text("Let's personalize your experience")
                    .font(PPFont.bodyLarge())
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
            }

            // Text field
            TextField("Your name", text: $userName)
                .font(PPFont.titleLarge())
                .multilineTextAlignment(.center)
                .padding(.vertical, PPSpacing.lg)
                .padding(.horizontal, PPSpacing.xl)
                .background(Color.backgroundSecondary)
                .cornerRadius(PPRadius.md)
                .padding(.horizontal, PPSpacing.xxl)

            Spacer()
            Spacer()
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
        appState.completeOnboarding()
    }
}

// MARK: - Onboarding Page
struct OnboardingPage: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String
    let color: Color

    static let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "ear.fill",
            title: "Train Your Ear",
            subtitle: "Develop perfect pitch through scientifically-backed exercises and daily practice",
            color: .primaryPurple
        ),
        OnboardingPage(
            icon: "music.note.list",
            title: "Notes, Chords & More",
            subtitle: "Master single notes, chords, intervals, and scales at your own pace",
            color: Color(hex: "EC4899")
        ),
        OnboardingPage(
            icon: "chart.line.uptrend.xyaxis",
            title: "Track Progress",
            subtitle: "Watch your skills improve with detailed stats and achievements",
            color: Color(hex: "14B8A6")
        ),
        OnboardingPage(
            icon: "flame.fill",
            title: "Stay Motivated",
            subtitle: "Build streaks, earn XP, and compete on global leaderboards",
            color: .orange
        ),
        OnboardingPage(
            icon: "person.fill",
            title: "Let's Get Started",
            subtitle: "",
            color: .primaryPurple
        )
    ]
}

// MARK: - Onboarding Page View
struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: PPSpacing.xxl) {
            Spacer()

            // Icon
            ZStack {
                Circle()
                    .fill(page.color.opacity(0.1))
                    .frame(width: 150, height: 150)

                Circle()
                    .fill(page.color.opacity(0.2))
                    .frame(width: 120, height: 120)

                Image(systemName: page.icon)
                    .font(.system(size: 50))
                    .foregroundColor(page.color)
            }

            // Text content
            VStack(spacing: PPSpacing.md) {
                Text(page.title)
                    .font(PPFont.displayMedium())
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)

                Text(page.subtitle)
                    .font(PPFont.bodyLarge())
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, PPSpacing.xl)
            }

            Spacer()
            Spacer()
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppState())
        .environmentObject(UserManager())
}
