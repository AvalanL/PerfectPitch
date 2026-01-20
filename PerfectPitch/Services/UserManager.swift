import Foundation
import Combine

// MARK: - User Manager
@MainActor
class UserManager: ObservableObject {
    @Published var currentUser: User
    @Published var dailyChallenge: DailyChallenge?
    @Published var recentSessions: [ExerciseSession] = []

    private let userDefaultsKey = "currentUser"
    private let dailyChallengeKey = "dailyChallenge"
    private let sessionsKey = "recentSessions"

    init() {
        // Load user from storage or create default
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let user = try? JSONDecoder().decode(User.self, from: data) {
            self.currentUser = user
        } else {
            self.currentUser = User(name: "Musician")
        }

        // Load or generate daily challenge
        loadDailyChallenge()

        // Load recent sessions
        loadRecentSessions()
    }

    // MARK: - User Management

    func updateUser(_ user: User) {
        currentUser = user
        saveUser()
    }

    func updateSettings(_ settings: UserSettings) {
        currentUser.settings = settings
        saveUser()
    }

    private func saveUser() {
        if let data = try? JSONEncoder().encode(currentUser) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }

    // MARK: - Stats Management

    func recordSession(_ session: ExerciseSession) {
        // Update stats
        currentUser.stats.totalSessions += 1
        currentUser.stats.totalCorrect += session.correctCount
        currentUser.stats.totalQuestions += session.questions.count
        currentUser.stats.totalXP += session.totalXP
        currentUser.stats.totalPracticeTime += session.duration
        currentUser.stats.updateStreak()

        // Update category-specific stats
        switch session.category {
        case .notes:
            currentUser.stats.noteStats.totalCorrect += session.correctCount
            currentUser.stats.noteStats.totalQuestions += session.questions.count
            currentUser.stats.noteStats.sessionsCompleted += 1
        case .chords:
            currentUser.stats.chordStats.totalCorrect += session.correctCount
            currentUser.stats.chordStats.totalQuestions += session.questions.count
            currentUser.stats.chordStats.sessionsCompleted += 1
        case .intervals:
            currentUser.stats.intervalStats.totalCorrect += session.correctCount
            currentUser.stats.intervalStats.totalQuestions += session.questions.count
            currentUser.stats.intervalStats.sessionsCompleted += 1
        case .scales, .melodicDictation:
            currentUser.stats.scaleStats.totalCorrect += session.correctCount
            currentUser.stats.scaleStats.totalQuestions += session.questions.count
            currentUser.stats.scaleStats.sessionsCompleted += 1
        }

        // Check for achievements
        checkAchievements(after: session)

        // Save session to history
        recentSessions.insert(session, at: 0)
        if recentSessions.count > 50 {
            recentSessions = Array(recentSessions.prefix(50))
        }
        saveRecentSessions()

        currentUser.lastActiveAt = Date()
        saveUser()
    }

    func addXP(_ amount: Int) {
        let previousLevel = currentUser.level
        currentUser.stats.totalXP += amount
        saveUser()

        // Check for level up
        if currentUser.level > previousLevel {
            // Could trigger level up notification/animation
            NotificationCenter.default.post(name: .userLeveledUp, object: currentUser.level)
        }
    }

    // MARK: - Achievements

    private func checkAchievements(after session: ExerciseSession) {
        var newAchievements: [Achievement] = []

        for (index, achievement) in currentUser.achievements.enumerated() {
            var updated = achievement

            switch achievement.id {
            case "first_steps":
                updated.updateProgress(currentUser.stats.totalSessions)
            case "week_warrior", "month_master", "year_of_the_ear":
                updated.updateProgress(currentUser.stats.currentStreak)
            case "dedicated_10", "committed_50", "obsessed_100":
                updated.updateProgress(currentUser.stats.totalSessions)
            case "note_novice", "note_expert":
                updated.updateProgress(currentUser.stats.noteStats.totalCorrect)
            case "chord_champion":
                updated.updateProgress(currentUser.stats.chordStats.totalCorrect)
            case "perfect_session":
                if session.accuracy == 1.0 {
                    updated.updateProgress(1)
                }
            case "level_10", "level_25", "level_50":
                updated.updateProgress(currentUser.level)
            case "night_owl":
                let hour = Calendar.current.component(.hour, from: Date())
                if hour >= 0 && hour < 5 {
                    updated.updateProgress(1)
                }
            case "early_bird":
                let hour = Calendar.current.component(.hour, from: Date())
                if hour >= 4 && hour < 6 {
                    updated.updateProgress(1)
                }
            default:
                break
            }

            if updated.isUnlocked && !achievement.isUnlocked {
                newAchievements.append(updated)
            }

            currentUser.achievements[index] = updated
        }

        if !newAchievements.isEmpty {
            NotificationCenter.default.post(name: .newAchievementsUnlocked, object: newAchievements)
        }
    }

    func initializeAchievements() {
        if currentUser.achievements.isEmpty {
            currentUser.achievements = Achievement.all
            saveUser()
        }
    }

    // MARK: - Daily Challenge

    private func loadDailyChallenge() {
        if let data = UserDefaults.standard.data(forKey: dailyChallengeKey),
           let challenge = try? JSONDecoder().decode(DailyChallenge.self, from: data) {
            // Check if it's still today's challenge
            if Calendar.current.isDateInToday(challenge.date) {
                dailyChallenge = challenge
                return
            }
        }

        // Generate new daily challenge
        dailyChallenge = DailyChallenge.generateDaily()
        saveDailyChallenge()
    }

    func updateDailyChallenge(_ challenge: DailyChallenge) {
        dailyChallenge = challenge
        saveDailyChallenge()
    }

    private func saveDailyChallenge() {
        if let data = try? JSONEncoder().encode(dailyChallenge) {
            UserDefaults.standard.set(data, forKey: dailyChallengeKey)
        }
    }

    // MARK: - Session History

    private func loadRecentSessions() {
        if let data = UserDefaults.standard.data(forKey: sessionsKey),
           let sessions = try? JSONDecoder().decode([ExerciseSession].self, from: data) {
            recentSessions = sessions
        }
    }

    private func saveRecentSessions() {
        if let data = try? JSONEncoder().encode(recentSessions) {
            UserDefaults.standard.set(data, forKey: sessionsKey)
        }
    }

    // MARK: - Greeting

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            return "Good morning"
        case 12..<17:
            return "Good afternoon"
        case 17..<21:
            return "Good evening"
        default:
            return "Good night"
        }
    }

    var greetingIcon: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            return "sun.max.fill"
        case 12..<17:
            return "sun.min.fill"
        case 17..<21:
            return "sunset.fill"
        default:
            return "moon.stars.fill"
        }
    }

    // MARK: - Streak & Practice Tracking

    /// Check if user has practiced today
    var hasPracticedToday: Bool {
        guard let lastPractice = currentUser.stats.lastPracticeDate else { return false }
        return Calendar.current.isDateInToday(lastPractice)
    }

    /// Time remaining until midnight (streak deadline)
    var timeUntilMidnight: TimeInterval {
        let calendar = Calendar.current
        let now = Date()
        guard let midnight = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: calendar.date(byAdding: .day, value: 1, to: now)!) else { return 0 }
        return midnight.timeIntervalSince(now)
    }

    /// Formatted time until midnight
    var formattedTimeUntilMidnight: String {
        let total = Int(timeUntilMidnight)
        let hours = total / 3600
        let minutes = (total % 3600) / 60

        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }

    /// Check if streak is in danger (less than 2 hours until midnight and hasn't practiced)
    var isStreakInDanger: Bool {
        return !hasPracticedToday && timeUntilMidnight < 7200 && currentUser.stats.currentStreak > 0
    }

    /// Record session and notify notification manager
    func recordSessionWithNotifications(_ session: ExerciseSession) {
        let previousStreak = currentUser.stats.currentStreak
        recordSession(session)
        let newStreak = currentUser.stats.currentStreak

        // Notify the notification manager
        let isNewMilestone = NotificationManager.Messages.milestoneMessages.keys.contains(newStreak)

        Task { @MainActor in
            NotificationManager.shared.onPracticeCompleted(
                currentStreak: newStreak,
                isNewMilestone: isNewMilestone && newStreak > previousStreak
            )
        }
    }
}

// MARK: - Notifications
extension Notification.Name {
    static let userLeveledUp = Notification.Name("userLeveledUp")
    static let newAchievementsUnlocked = Notification.Name("newAchievementsUnlocked")
}
