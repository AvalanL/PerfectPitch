import SwiftUI

@main
struct PerfectPitchApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var audioEngine = AudioEngine()
    @StateObject private var userManager = UserManager()
    @StateObject private var notificationManager = NotificationManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environmentObject(audioEngine)
                .environmentObject(userManager)
                .environmentObject(notificationManager)
                .preferredColorScheme(appState.colorScheme)
                .onAppear {
                    setupNotifications()
                }
        }
    }

    private func setupNotifications() {
        Task {
            await notificationManager.onAppLaunch(
                currentStreak: userManager.currentUser.stats.currentStreak,
                hasPracticedToday: userManager.hasPracticedToday,
                lastPracticeDate: userManager.currentUser.stats.lastPracticeDate
            )
        }
    }
}

// MARK: - App State
@MainActor
class AppState: ObservableObject {
    @Published var colorScheme: ColorScheme? = nil
    @Published var isOnboarded: Bool = UserDefaults.standard.bool(forKey: "isOnboarded")
    @Published var selectedTab: Tab = .home

    enum Tab: Int, CaseIterable {
        case home = 0
        case train
        case progress
        case profile
    }

    func completeOnboarding() {
        isOnboarded = true
        UserDefaults.standard.set(true, forKey: "isOnboarded")
    }
}
