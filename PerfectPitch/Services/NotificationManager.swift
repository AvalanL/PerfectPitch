import Foundation
import UserNotifications
import UIKit

// MARK: - Notification Manager
/// Duolingo-style aggressive notification system for streak maintenance
@MainActor
class NotificationManager: ObservableObject {
    static let shared = NotificationManager()

    @Published var isAuthorized = false
    @Published var pendingNotifications: [UNNotificationRequest] = []

    private let center = UNUserNotificationCenter.current()

    // MARK: - Notification Identifiers
    enum NotificationID: String {
        // Daily reminders
        case morningReminder = "morning_reminder"
        case afternoonReminder = "afternoon_reminder"
        case eveningReminder = "evening_reminder"

        // Streak danger warnings
        case streakDanger1Hour = "streak_danger_1h"
        case streakDanger30Min = "streak_danger_30m"
        case streakDanger15Min = "streak_danger_15m"
        case streakDanger5Min = "streak_danger_5m"

        // Streak milestones
        case streakMilestone = "streak_milestone"
        case streakLost = "streak_lost"
        case streakSaved = "streak_saved"

        // Engagement
        case comeBack = "come_back"
        case weeklyChallenge = "weekly_challenge"
    }

    // MARK: - Notification Messages (Duolingo-style)
    struct Messages {
        // Morning messages
        static let morningMessages = [
            ("🌅 Rise and train!", "Start your day with a quick ear training session. Your ears will thank you!"),
            ("☀️ Good morning, musician!", "A few minutes of practice keeps your streak alive!"),
            ("🎵 Your ears are waiting!", "Perfect pitch doesn't train itself. Let's go!"),
            ("🔥 Don't let your streak freeze!", "Quick session before your day gets busy?")
        ]

        // Afternoon messages
        static let afternoonMessages = [
            ("🎯 Perfect time for practice!", "Take a break from your day. Train your ears for 5 minutes."),
            ("🎹 Your streak misses you!", "Haven't practiced today? There's still time!"),
            ("⚡ Quick reminder!", "Your musical ears are getting rusty. Time to train!"),
            ("🎵 Lunchtime = Training time!", "Feed your ears some notes while you feed yourself.")
        ]

        // Evening messages
        static let eveningMessages = [
            ("🌙 Evening practice time!", "Wind down your day with some ear training."),
            ("⏰ Day almost over!", "You haven't practiced yet. Don't break your streak!"),
            ("🔥 Streak check!", "Did you train today? Don't forget before bed!"),
            ("🎵 Last chance today!", "A quick session before the day ends?")
        ]

        // Streak danger messages (increasingly urgent)
        static let streakDanger1Hour = [
            ("⚠️ 1 HOUR LEFT!", "Your streak is about to end! Practice NOW to save it!"),
            ("🚨 STREAK EMERGENCY!", "Only 1 hour until midnight. Don't lose your progress!"),
            ("😱 Your streak is crying!", "1 hour left to save your \(placeholder)day streak!")
        ]

        static let streakDanger30Min = [
            ("🔴 30 MINUTES LEFT!", "This is NOT a drill! Your streak needs you RIGHT NOW!"),
            ("😰 URGENT: Streak dying!", "30 minutes until your streak vanishes forever!"),
            ("⏰ FINAL WARNING!", "Half hour left. Your streak is begging for help!")
        ]

        static let streakDanger15Min = [
            ("🆘 15 MINUTES!", "DO IT NOW! Your streak is about to die!"),
            ("💀 STREAK DEATH IMMINENT!", "15 min left. This is your LAST CHANCE!"),
            ("😭 Please don't abandon me!", "Your streak is literally crying. 15 minutes left!")
        ]

        static let streakDanger5Min = [
            ("🚨🚨🚨 5 MINUTES!!!", "DROP EVERYTHING! SAVE YOUR STREAK NOW!!!"),
            ("💔 Streak flatline in 5 min!", "ONE quick answer can save EVERYTHING!"),
            ("⚡ EMERGENCY! 5 MIN LEFT!", "Even 1 correct answer saves your streak!")
        ]

        // Come back messages (for users who've been away)
        static let comeBackMessages = [
            ("😢 We miss you!", "It's been a while. Your ears are getting rusty!"),
            ("🎵 Your notes feel abandoned", "Come back and show them some love!"),
            ("👋 Remember us?", "Your musical journey awaits. Let's continue!"),
            ("🌟 You were doing so well!", "Don't give up now. Every musician has off days.")
        ]

        // Streak milestone messages
        static let milestoneMessages: [Int: (String, String)] = [
            3: ("🔥 3 Day Streak!", "You're building a habit! Keep it going!"),
            7: ("🎉 1 WEEK STREAK!", "You're officially committed! Amazing!"),
            14: ("⭐ 2 WEEK STREAK!", "You're becoming a pro! Incredible dedication!"),
            30: ("🏆 1 MONTH STREAK!", "You're a legend! 30 days of pure dedication!"),
            50: ("💎 50 DAY STREAK!", "Unstoppable! You're in the elite club now!"),
            100: ("👑 100 DAY STREAK!", "LEGENDARY! You've mastered consistency!"),
            365: ("🎖️ 1 YEAR STREAK!", "You are the ultimate musician! Absolutely incredible!")
        ]

        // Streak lost message
        static let streakLostMessages = [
            ("💔 Streak Lost", "Your streak has ended. But every expert was once a beginner. Start fresh!"),
            ("😢 Streak Reset", "Don't worry - today is a new beginning. Let's build an even longer streak!"),
            ("🔄 Fresh Start", "Yesterday is gone. Today, we begin the journey to an even greater streak!")
        ]

        private static let placeholder = "{STREAK}"
    }

    // MARK: - Initialization
    init() {
        Task {
            await checkAuthorizationStatus()
        }
    }

    // MARK: - Authorization
    func requestAuthorization() async -> Bool {
        do {
            let options: UNAuthorizationOptions = [.alert, .sound, .badge, .provisional]
            let granted = try await center.requestAuthorization(options: options)

            await MainActor.run {
                self.isAuthorized = granted
            }

            if granted {
                await registerForRemoteNotifications()
            }

            return granted
        } catch {
            print("Notification authorization error: \(error)")
            return false
        }
    }

    func checkAuthorizationStatus() async {
        let settings = await center.notificationSettings()
        await MainActor.run {
            self.isAuthorized = settings.authorizationStatus == .authorized
        }
    }

    private func registerForRemoteNotifications() async {
        await MainActor.run {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }

    // MARK: - Schedule Daily Reminders
    func scheduleDailyReminders(morningEnabled: Bool = true,
                                 afternoonEnabled: Bool = true,
                                 eveningEnabled: Bool = true,
                                 morningTime: DateComponents = DateComponents(hour: 9, minute: 0),
                                 afternoonTime: DateComponents = DateComponents(hour: 14, minute: 0),
                                 eveningTime: DateComponents = DateComponents(hour: 19, minute: 0)) {

        // Cancel existing daily reminders first
        cancelDailyReminders()

        if morningEnabled {
            scheduleRepeatingNotification(
                id: .morningReminder,
                messages: Messages.morningMessages,
                time: morningTime
            )
        }

        if afternoonEnabled {
            scheduleRepeatingNotification(
                id: .afternoonReminder,
                messages: Messages.afternoonMessages,
                time: afternoonTime
            )
        }

        if eveningEnabled {
            scheduleRepeatingNotification(
                id: .eveningReminder,
                messages: Messages.eveningMessages,
                time: eveningTime
            )
        }
    }

    private func scheduleRepeatingNotification(id: NotificationID,
                                                messages: [(String, String)],
                                                time: DateComponents) {
        let content = UNMutableNotificationContent()
        let message = messages.randomElement()!
        content.title = message.0
        content.body = message.1
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = "STREAK_REMINDER"

        var triggerTime = time
        triggerTime.second = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerTime, repeats: true)
        let request = UNNotificationRequest(identifier: id.rawValue, content: content, trigger: trigger)

        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }

    func cancelDailyReminders() {
        center.removePendingNotificationRequests(withIdentifiers: [
            NotificationID.morningReminder.rawValue,
            NotificationID.afternoonReminder.rawValue,
            NotificationID.eveningReminder.rawValue
        ])
    }

    // MARK: - Streak Danger Countdown Notifications
    /// Call this when user completes a session to reset the danger notifications
    /// Or call at app launch to set up for the day
    func scheduleStreakDangerNotifications(currentStreak: Int, hasPracticedToday: Bool) {
        // Cancel any existing danger notifications
        cancelStreakDangerNotifications()

        // Don't schedule if already practiced today
        guard !hasPracticedToday else { return }

        // Calculate time until midnight
        let calendar = Calendar.current
        let now = Date()
        guard let midnight = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: calendar.date(byAdding: .day, value: 1, to: now)!) else { return }

        let timeUntilMidnight = midnight.timeIntervalSince(now)

        // Schedule notifications at various intervals before midnight
        let intervals: [(TimeInterval, NotificationID, [(String, String)])] = [
            (3600, .streakDanger1Hour, Messages.streakDanger1Hour),   // 1 hour
            (1800, .streakDanger30Min, Messages.streakDanger30Min),   // 30 min
            (900, .streakDanger15Min, Messages.streakDanger15Min),    // 15 min
            (300, .streakDanger5Min, Messages.streakDanger5Min)       // 5 min
        ]

        for (secondsBefore, notificationId, messages) in intervals {
            let triggerInterval = timeUntilMidnight - secondsBefore

            // Only schedule if we have enough time
            if triggerInterval > 0 {
                scheduleStreakDangerNotification(
                    id: notificationId,
                    messages: messages,
                    triggerInterval: triggerInterval,
                    streak: currentStreak
                )
            }
        }
    }

    private func scheduleStreakDangerNotification(id: NotificationID,
                                                   messages: [(String, String)],
                                                   triggerInterval: TimeInterval,
                                                   streak: Int) {
        let content = UNMutableNotificationContent()
        var message = messages.randomElement()!

        // Replace streak placeholder
        message.0 = message.0.replacingOccurrences(of: "{STREAK}", with: "\(streak)")
        message.1 = message.1.replacingOccurrences(of: "{STREAK}", with: "\(streak)")

        content.title = message.0
        content.body = message.1
        content.sound = .defaultCritical // More urgent sound
        content.badge = 1
        content.categoryIdentifier = "STREAK_DANGER"
        content.interruptionLevel = .timeSensitive

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: triggerInterval, repeats: false)
        let request = UNNotificationRequest(identifier: id.rawValue, content: content, trigger: trigger)

        center.add(request) { error in
            if let error = error {
                print("Error scheduling streak danger notification: \(error)")
            }
        }
    }

    func cancelStreakDangerNotifications() {
        center.removePendingNotificationRequests(withIdentifiers: [
            NotificationID.streakDanger1Hour.rawValue,
            NotificationID.streakDanger30Min.rawValue,
            NotificationID.streakDanger15Min.rawValue,
            NotificationID.streakDanger5Min.rawValue
        ])
    }

    // MARK: - Streak Milestone Notifications
    func sendStreakMilestoneNotification(streak: Int) {
        guard let message = Messages.milestoneMessages[streak] else { return }

        let content = UNMutableNotificationContent()
        content.title = message.0
        content.body = message.1
        content.sound = .default
        content.categoryIdentifier = "STREAK_MILESTONE"

        // Send immediately
        let request = UNNotificationRequest(
            identifier: "\(NotificationID.streakMilestone.rawValue)_\(streak)",
            content: content,
            trigger: nil
        )

        center.add(request)
    }

    // MARK: - Streak Lost Notification
    func sendStreakLostNotification(previousStreak: Int) {
        let content = UNMutableNotificationContent()
        let message = Messages.streakLostMessages.randomElement()!
        content.title = message.0
        content.body = message.1
        content.sound = .default
        content.categoryIdentifier = "STREAK_LOST"

        let request = UNNotificationRequest(
            identifier: NotificationID.streakLost.rawValue,
            content: content,
            trigger: nil
        )

        center.add(request)
    }

    // MARK: - Come Back Notifications
    func scheduleComeBackNotification(daysInactive: Int = 2) {
        let content = UNMutableNotificationContent()
        let message = Messages.comeBackMessages.randomElement()!
        content.title = message.0
        content.body = message.1
        content.sound = .default
        content.categoryIdentifier = "COME_BACK"

        // Schedule for 2 days from now
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: TimeInterval(daysInactive * 24 * 60 * 60),
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: NotificationID.comeBack.rawValue,
            content: content,
            trigger: trigger
        )

        center.add(request)
    }

    func cancelComeBackNotification() {
        center.removePendingNotificationRequests(withIdentifiers: [NotificationID.comeBack.rawValue])
    }

    // MARK: - Badge Management
    func clearBadge() {
        Task {
            try? await center.setBadgeCount(0)
        }
    }

    func setBadge(_ count: Int) {
        Task {
            try? await center.setBadgeCount(count)
        }
    }

    // MARK: - Cancel All
    func cancelAllNotifications() {
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
        clearBadge()
    }

    // MARK: - Debug
    func printPendingNotifications() {
        center.getPendingNotificationRequests { requests in
            print("📬 Pending Notifications (\(requests.count)):")
            for request in requests {
                print("  - \(request.identifier): \(request.content.title)")
            }
        }
    }
}

// MARK: - Notification Categories & Actions
extension NotificationManager {
    func registerNotificationCategories() {
        // Streak reminder actions
        let practiceNowAction = UNNotificationAction(
            identifier: "PRACTICE_NOW",
            title: "Practice Now 🎵",
            options: [.foreground]
        )

        let remindLaterAction = UNNotificationAction(
            identifier: "REMIND_LATER",
            title: "Remind in 1 Hour",
            options: []
        )

        let streakReminderCategory = UNNotificationCategory(
            identifier: "STREAK_REMINDER",
            actions: [practiceNowAction, remindLaterAction],
            intentIdentifiers: [],
            options: []
        )

        // Streak danger actions
        let saveStreakAction = UNNotificationAction(
            identifier: "SAVE_STREAK",
            title: "Save My Streak! 🆘",
            options: [.foreground]
        )

        let streakDangerCategory = UNNotificationCategory(
            identifier: "STREAK_DANGER",
            actions: [saveStreakAction],
            intentIdentifiers: [],
            options: []
        )

        // Milestone category
        let celebrateAction = UNNotificationAction(
            identifier: "CELEBRATE",
            title: "Keep Going! 🎉",
            options: [.foreground]
        )

        let milestoneCategory = UNNotificationCategory(
            identifier: "STREAK_MILESTONE",
            actions: [celebrateAction],
            intentIdentifiers: [],
            options: []
        )

        center.setNotificationCategories([
            streakReminderCategory,
            streakDangerCategory,
            milestoneCategory
        ])
    }
}

// MARK: - Integration Helper
extension NotificationManager {
    /// Call this when user completes any practice session
    func onPracticeCompleted(currentStreak: Int, isNewMilestone: Bool) {
        // Cancel danger notifications - user practiced!
        cancelStreakDangerNotifications()

        // Cancel come back notification
        cancelComeBackNotification()

        // Schedule come back for if they go inactive
        scheduleComeBackNotification()

        // Check for milestone
        if isNewMilestone {
            sendStreakMilestoneNotification(streak: currentStreak)
        }

        // Clear badge
        clearBadge()
    }

    /// Call this at app launch
    func onAppLaunch(currentStreak: Int, hasPracticedToday: Bool, lastPracticeDate: Date?) {
        Task {
            // Check and request authorization if needed
            if !isAuthorized {
                _ = await requestAuthorization()
            }

            // Register categories
            registerNotificationCategories()

            // Schedule daily reminders
            scheduleDailyReminders()

            // Schedule streak danger notifications if not practiced today
            scheduleStreakDangerNotifications(currentStreak: currentStreak, hasPracticedToday: hasPracticedToday)

            // Check if streak was lost
            if let lastPractice = lastPracticeDate {
                let calendar = Calendar.current
                let daysSinceLastPractice = calendar.dateComponents([.day], from: lastPractice, to: Date()).day ?? 0

                if daysSinceLastPractice > 1 && currentStreak == 0 {
                    // Streak was lost
                    sendStreakLostNotification(previousStreak: daysSinceLastPractice)
                }
            }
        }
    }
}
