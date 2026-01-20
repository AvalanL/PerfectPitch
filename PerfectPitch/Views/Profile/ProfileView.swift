import SwiftUI
import StoreKit
import UserNotifications

struct ProfileView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var showSettings = false
    @State private var showEditProfile = false
    @State private var showNotificationSettings = false

    // GitHub Pages URLs
    private let supportURL = URL(string: "https://avalanl.github.io/PerfectPitch/")!
    private let privacyURL = URL(string: "https://avalanl.github.io/PerfectPitch/privacy.html")!

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: PPSpacing.xxl) {
                    // Profile Header
                    profileHeader

                    // Quick Stats
                    quickStatsSection

                    // Menu Options
                    menuSection
                }
                .padding(.horizontal, PPSpacing.lg)
                .padding(.bottom, PPSpacing.huge)
            }
            .background(
                LinearGradient.ambientGradient
                    .ignoresSafeArea()
            )
            .navigationDestination(isPresented: $showSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showEditProfile) {
                EditProfileView()
            }
            .sheet(isPresented: $showNotificationSettings) {
                NotificationSettingsView()
            }
        }
    }

    // MARK: - Profile Header
    private var profileHeader: some View {
        VStack(spacing: PPSpacing.lg) {
            // Avatar with glow and Edit Button
            ZStack(alignment: .bottomTrailing) {
                // Glow effect
                Circle()
                    .fill(Color.primaryPurple.opacity(0.25))
                    .frame(width: 120, height: 120)
                    .blur(radius: 20)

                // Avatar
                ZStack {
                    Circle()
                        .fill(LinearGradient.primaryGradient)
                        .frame(width: 100, height: 100)
                        .shadow(color: .primaryPurple.opacity(0.4), radius: 8, x: 0, y: 4)

                    Text(String(userManager.currentUser.name.prefix(1)).uppercased())
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }

                // Edit button with gradient border
                Button(action: { showEditProfile = true }) {
                    Image(systemName: "pencil")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(LinearGradient.primaryGradient)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.backgroundElevated, lineWidth: 3)
                        )
                }
            }

            // Name and Level
            VStack(spacing: PPSpacing.xs) {
                Text(userManager.currentUser.name)
                    .font(PPFont.displayMedium())
                    .foregroundColor(.textPrimary)

                HStack(spacing: PPSpacing.sm) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 14))
                        .foregroundStyle(LinearGradient.warmGradient)

                    Text("Level \(userManager.currentUser.level)")
                        .font(PPFont.titleSmall())
                        .foregroundStyle(LinearGradient.primaryGradient)

                    Text("•")
                        .foregroundColor(.textTertiary)

                    Text(userManager.currentUser.levelTitle)
                        .font(PPFont.bodyMedium())
                        .foregroundColor(.textSecondary)
                }
            }

            // XP Bar with glow
            VStack(spacing: PPSpacing.sm) {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.borderLight)
                            .frame(height: 8)

                        RoundedRectangle(cornerRadius: 4)
                            .fill(LinearGradient.primaryGradient)
                            .frame(width: geo.size.width * userManager.currentUser.levelProgress, height: 8)
                            .shadow(color: .primaryPurple.opacity(0.4), radius: 4, x: 0, y: 0)
                    }
                }
                .frame(height: 8)

                Text("\(userManager.currentUser.stats.totalXP) / \(userManager.currentUser.stats.totalXP + userManager.currentUser.xpForNextLevel) XP")
                    .font(PPFont.caption())
                    .foregroundColor(.textTertiary)
            }
            .padding(.horizontal, PPSpacing.xxl)
        }
        .padding(.vertical, PPSpacing.xl)
        .padding(.horizontal, PPSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: PPRadius.xl)
                .fill(Color.backgroundElevated)
                .overlay(
                    RoundedRectangle(cornerRadius: PPRadius.xl)
                        .fill(
                            LinearGradient(
                                colors: [Color.primaryPurple.opacity(0.05), Color.clear],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                )
        )
        .ppShadowLarge()
    }

    // MARK: - Quick Stats Section
    private var quickStatsSection: some View {
        HStack(spacing: PPSpacing.md) {
            ProfileStatItem(
                icon: "flame.fill",
                value: "\(userManager.currentUser.stats.currentStreak)",
                label: "Day Streak",
                color: .orange
            )

            ProfileStatItem(
                icon: "checkmark.circle.fill",
                value: "\(userManager.currentUser.stats.totalSessions)",
                label: "Sessions",
                color: .success
            )

            ProfileStatItem(
                icon: "trophy.fill",
                value: "\(userManager.currentUser.achievements.filter { $0.isUnlocked }.count)",
                label: "Achievements",
                color: .warning
            )
        }
    }

    // MARK: - Menu Section
    private var menuSection: some View {
        VStack(spacing: PPSpacing.sm) {
            ProfileMenuItem(
                icon: "gearshape.fill",
                title: "Settings",
                color: .textSecondary
            ) {
                showSettings = true
            }

            ProfileMenuItem(
                icon: "bell.fill",
                title: "Notifications",
                color: .textSecondary
            ) {
                showNotificationSettings = true
            }

            ProfileMenuItem(
                icon: "star.fill",
                title: "Rate App",
                color: .warning
            ) {
                requestAppReview()
            }

            ProfileMenuItem(
                icon: "questionmark.circle.fill",
                title: "Help & Support",
                color: .info
            ) {
                UIApplication.shared.open(supportURL)
            }

            ProfileMenuItem(
                icon: "doc.text.fill",
                title: "Privacy Policy",
                color: .textSecondary
            ) {
                UIApplication.shared.open(privacyURL)
            }
        }
    }

    // MARK: - Actions

    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

// MARK: - Profile Stat Item
struct ProfileStatItem: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: PPSpacing.sm) {
            // Icon with glow
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 48, height: 48)

                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(color)
            }

            Text(value)
                .font(PPFont.titleLarge())
                .foregroundColor(.textPrimary)

            Text(label)
                .font(PPFont.captionSmall())
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, PPSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: PPRadius.lg)
                .fill(Color.backgroundElevated)
                .overlay(
                    RoundedRectangle(cornerRadius: PPRadius.lg)
                        .fill(
                            LinearGradient(
                                colors: [color.opacity(0.05), Color.clear],
                                startPoint: .top,
                                endPoint: .bottom
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
}

// MARK: - Profile Menu Item
struct ProfileMenuItem: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: PPSpacing.lg) {
                // Icon in colored circle
                ZStack {
                    Circle()
                        .fill(color.opacity(0.1))
                        .frame(width: 36, height: 36)

                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundColor(color)
                }

                Text(title)
                    .font(PPFont.bodyLarge())
                    .foregroundColor(.textPrimary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.textTertiary)
            }
            .padding(PPSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: PPRadius.md)
                    .fill(Color.backgroundElevated)
            )
            .overlay(
                RoundedRectangle(cornerRadius: PPRadius.md)
                    .stroke(Color.borderLight, lineWidth: 1)
            )
        }
        .buttonStyle(PPButtonStyle())
    }
}

// MARK: - Edit Profile View
struct EditProfileView: View {
    @EnvironmentObject var userManager: UserManager
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        var user = userManager.currentUser
                        user.name = name
                        userManager.updateUser(user)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                name = userManager.currentUser.name
            }
        }
    }
}

// MARK: - Settings View
struct SettingsView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var settings: UserSettings = UserSettings()

    var body: some View {
        Form {
            // Sound Settings
            Section("Sound") {
                Picker("Instrument", selection: $settings.instrument) {
                    ForEach(UserSettings.Instrument.allCases, id: \.self) { instrument in
                        Text(instrument.rawValue).tag(instrument)
                    }
                }

                Toggle("Auto-play Next", isOn: $settings.autoPlayNext)
            }

            // Training Settings
            Section("Training") {
                Picker("Questions per Session", selection: $settings.questionsPerSession) {
                    Text("10").tag(10)
                    Text("15").tag(15)
                    Text("20").tag(20)
                    Text("25").tag(25)
                    Text("30").tag(30)
                }

                Toggle("Show Note Names", isOn: $settings.showNoteNames)
                Toggle("Include Sharps/Flats", isOn: $settings.includeAccidentals)
            }

            // Notifications
            Section("Notifications") {
                Toggle("Daily Reminder", isOn: $settings.dailyReminderEnabled)

                if settings.dailyReminderEnabled {
                    DatePicker(
                        "Reminder Time",
                        selection: $settings.dailyReminderTime,
                        displayedComponents: .hourAndMinute
                    )
                }
            }

            // Feedback
            Section("Feedback") {
                Toggle("Haptic Feedback", isOn: $settings.hapticFeedbackEnabled)
                Toggle("Sound Effects", isOn: $settings.soundEffectsEnabled)
            }

            // About
            Section("About") {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.textSecondary)
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            settings = userManager.currentUser.settings
        }
        .onChange(of: settings) { _, newSettings in
            userManager.updateSettings(newSettings)
        }
    }
}

// MARK: - Notification Settings View
struct NotificationSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var notificationStatus: UNAuthorizationStatus = .notDetermined
    @State private var isLoading = true

    var body: some View {
        NavigationStack {
            VStack(spacing: PPSpacing.xxl) {
                // Status Icon
                ZStack {
                    Circle()
                        .fill(statusColor.opacity(0.15))
                        .frame(width: 100, height: 100)

                    Image(systemName: statusIcon)
                        .font(.system(size: 44))
                        .foregroundColor(statusColor)
                }
                .padding(.top, PPSpacing.xxl)

                // Status Text
                VStack(spacing: PPSpacing.sm) {
                    Text(statusTitle)
                        .font(PPFont.displaySmall())
                        .foregroundColor(.textPrimary)

                    Text(statusDescription)
                        .font(PPFont.bodyMedium())
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, PPSpacing.xl)
                }

                Spacer()

                // Action Buttons
                VStack(spacing: PPSpacing.md) {
                    if notificationStatus == .notDetermined {
                        Button(action: requestPermissions) {
                            Text("Enable Notifications")
                                .font(PPFont.titleMedium())
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, PPSpacing.lg)
                                .background(LinearGradient.primaryGradient)
                                .cornerRadius(PPRadius.lg)
                        }
                    } else if notificationStatus == .denied {
                        Button(action: openSettings) {
                            Text("Open Settings")
                                .font(PPFont.titleMedium())
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, PPSpacing.lg)
                                .background(LinearGradient.primaryGradient)
                                .cornerRadius(PPRadius.lg)
                        }

                        Text("Notifications are disabled. Open Settings to enable them.")
                            .font(PPFont.caption())
                            .foregroundColor(.textTertiary)
                            .multilineTextAlignment(.center)
                    } else if notificationStatus == .authorized {
                        Button(action: openSettings) {
                            Text("Manage in Settings")
                                .font(PPFont.bodyLarge())
                                .foregroundColor(.primaryPurple)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, PPSpacing.lg)
                                .background(Color.primaryPurple.opacity(0.1))
                                .cornerRadius(PPRadius.lg)
                        }
                    }
                }
                .padding(.horizontal, PPSpacing.xl)
                .padding(.bottom, PPSpacing.xxl)
            }
            .background(
                LinearGradient.ambientGradient
                    .ignoresSafeArea()
            )
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .onAppear {
                checkNotificationStatus()
            }
        }
    }

    private var statusColor: Color {
        switch notificationStatus {
        case .authorized: return .success
        case .denied: return .error
        case .provisional: return .warning
        default: return .primaryPurple
        }
    }

    private var statusIcon: String {
        switch notificationStatus {
        case .authorized: return "bell.badge.fill"
        case .denied: return "bell.slash.fill"
        case .provisional: return "bell.fill"
        default: return "bell.fill"
        }
    }

    private var statusTitle: String {
        switch notificationStatus {
        case .authorized: return "Notifications Enabled"
        case .denied: return "Notifications Disabled"
        case .provisional: return "Limited Notifications"
        default: return "Stay on Track"
        }
    }

    private var statusDescription: String {
        switch notificationStatus {
        case .authorized:
            return "You'll receive streak reminders and daily practice notifications to help you maintain your progress."
        case .denied:
            return "Enable notifications to receive streak reminders before midnight and daily practice motivation."
        case .provisional:
            return "You have limited notifications enabled. Enable full notifications for the best experience."
        default:
            return "Get notified when your streak is about to end and receive daily reminders to practice. Never lose your progress!"
        }
    }

    private func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.notificationStatus = settings.authorizationStatus
                self.isLoading = false
            }
        }
    }

    private func requestPermissions() {
        Task {
            do {
                let granted = try await UNUserNotificationCenter.current().requestAuthorization(
                    options: [.alert, .badge, .sound, .criticalAlert]
                )
                await MainActor.run {
                    notificationStatus = granted ? .authorized : .denied
                }

                // Schedule notifications if granted
                if granted {
                    NotificationManager.shared.registerNotificationCategories()
                    NotificationManager.shared.scheduleDailyReminders()
                }
            } catch {
                print("Failed to request notification permissions: \(error)")
            }
        }
    }

    private func openSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(UserManager())
}
