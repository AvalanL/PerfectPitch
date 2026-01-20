import Foundation

// MARK: - User
struct User: Identifiable, Codable {
    let id: UUID
    var name: String
    var email: String?
    var avatarURL: URL?
    var stats: UserStats
    var settings: UserSettings
    var achievements: [Achievement]
    var createdAt: Date
    var lastActiveAt: Date

    init(
        id: UUID = UUID(),
        name: String,
        email: String? = nil,
        avatarURL: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.avatarURL = avatarURL
        self.stats = UserStats()
        self.settings = UserSettings()
        self.achievements = []
        self.createdAt = Date()
        self.lastActiveAt = Date()
    }

    var level: Int {
        LevelSystem.level(for: stats.totalXP)
    }

    var levelProgress: Double {
        LevelSystem.progress(for: stats.totalXP)
    }

    var xpForNextLevel: Int {
        LevelSystem.xpForNextLevel(currentXP: stats.totalXP)
    }

    var levelTitle: String {
        LevelSystem.title(for: level)
    }
}

// MARK: - User Stats
struct UserStats: Codable {
    var totalXP: Int = 0
    var totalSessions: Int = 0
    var totalCorrect: Int = 0
    var totalQuestions: Int = 0
    var currentStreak: Int = 0
    var longestStreak: Int = 0
    var lastPracticeDate: Date?
    var totalPracticeTime: TimeInterval = 0

    // Skill-specific stats
    var noteStats: SkillStats = SkillStats()
    var chordStats: SkillStats = SkillStats()
    var intervalStats: SkillStats = SkillStats()
    var scaleStats: SkillStats = SkillStats()

    var overallAccuracy: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(totalCorrect) / Double(totalQuestions)
    }

    var formattedPracticeTime: String {
        let hours = Int(totalPracticeTime) / 3600
        let minutes = (Int(totalPracticeTime) % 3600) / 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
    }

    mutating func updateStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        if let lastDate = lastPracticeDate {
            let lastDay = calendar.startOfDay(for: lastDate)
            let daysDifference = calendar.dateComponents([.day], from: lastDay, to: today).day ?? 0

            if daysDifference == 1 {
                currentStreak += 1
            } else if daysDifference > 1 {
                currentStreak = 1
            }
        } else {
            currentStreak = 1
        }

        longestStreak = max(longestStreak, currentStreak)
        lastPracticeDate = Date()
    }
}

// MARK: - Skill Stats
struct SkillStats: Codable {
    var totalCorrect: Int = 0
    var totalQuestions: Int = 0
    var bestStreak: Int = 0
    var averageResponseTime: TimeInterval = 0
    var sessionsCompleted: Int = 0

    var accuracy: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(totalCorrect) / Double(totalQuestions)
    }

    var skillLevel: Int {
        switch accuracy {
        case 0..<0.4: return 1
        case 0.4..<0.6: return 2
        case 0.6..<0.75: return 3
        case 0.75..<0.9: return 4
        default: return 5
        }
    }

    var skillLevelName: String {
        switch skillLevel {
        case 1: return "Beginner"
        case 2: return "Novice"
        case 3: return "Intermediate"
        case 4: return "Advanced"
        default: return "Expert"
        }
    }
}

// MARK: - User Settings
struct UserSettings: Codable, Equatable {
    var instrument: Instrument = .piano
    var questionsPerSession: Int = 20
    var showNoteNames: Bool = true
    var includeAccidentals: Bool = true
    var octaveRange: ClosedRange<Int> = 3...5
    var autoPlayNext: Bool = false
    var dailyReminderEnabled: Bool = true
    var dailyReminderTime: Date = Calendar.current.date(from: DateComponents(hour: 9, minute: 0)) ?? Date()
    var hapticFeedbackEnabled: Bool = true
    var soundEffectsEnabled: Bool = true

    enum Instrument: String, Codable, CaseIterable, Equatable {
        case piano = "Piano"
        case sineWave = "Sine Wave"
        case guitar = "Guitar"
        case violin = "Violin"
        case synth = "Synth"
        case organ = "Organ"

        var iconName: String {
            switch self {
            case .piano: return "pianokeys"
            case .sineWave: return "waveform"
            case .guitar: return "guitars"
            case .violin: return "music.note"
            case .synth: return "waveform.path"
            case .organ: return "music.quarternote.3"
            }
        }
    }

    // Custom Codable for ClosedRange
    enum CodingKeys: String, CodingKey {
        case instrument, questionsPerSession, showNoteNames, includeAccidentals
        case octaveRangeLower, octaveRangeUpper, autoPlayNext
        case dailyReminderEnabled, dailyReminderTime
        case hapticFeedbackEnabled, soundEffectsEnabled
    }

    init() {}

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        instrument = try container.decode(Instrument.self, forKey: .instrument)
        questionsPerSession = try container.decode(Int.self, forKey: .questionsPerSession)
        showNoteNames = try container.decode(Bool.self, forKey: .showNoteNames)
        includeAccidentals = try container.decode(Bool.self, forKey: .includeAccidentals)
        let lower = try container.decode(Int.self, forKey: .octaveRangeLower)
        let upper = try container.decode(Int.self, forKey: .octaveRangeUpper)
        octaveRange = lower...upper
        autoPlayNext = try container.decode(Bool.self, forKey: .autoPlayNext)
        dailyReminderEnabled = try container.decode(Bool.self, forKey: .dailyReminderEnabled)
        dailyReminderTime = try container.decode(Date.self, forKey: .dailyReminderTime)
        hapticFeedbackEnabled = try container.decode(Bool.self, forKey: .hapticFeedbackEnabled)
        soundEffectsEnabled = try container.decode(Bool.self, forKey: .soundEffectsEnabled)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(instrument, forKey: .instrument)
        try container.encode(questionsPerSession, forKey: .questionsPerSession)
        try container.encode(showNoteNames, forKey: .showNoteNames)
        try container.encode(includeAccidentals, forKey: .includeAccidentals)
        try container.encode(octaveRange.lowerBound, forKey: .octaveRangeLower)
        try container.encode(octaveRange.upperBound, forKey: .octaveRangeUpper)
        try container.encode(autoPlayNext, forKey: .autoPlayNext)
        try container.encode(dailyReminderEnabled, forKey: .dailyReminderEnabled)
        try container.encode(dailyReminderTime, forKey: .dailyReminderTime)
        try container.encode(hapticFeedbackEnabled, forKey: .hapticFeedbackEnabled)
        try container.encode(soundEffectsEnabled, forKey: .soundEffectsEnabled)
    }
}

// MARK: - Level System
struct LevelSystem {
    static let xpPerLevel: [Int] = {
        var levels: [Int] = [0]
        for level in 1...100 {
            let xp = Int(pow(Double(level), 2.0) * 100)
            levels.append(levels.last! + xp)
        }
        return levels
    }()

    static func level(for xp: Int) -> Int {
        for (index, threshold) in xpPerLevel.enumerated() {
            if xp < threshold {
                return max(1, index)
            }
        }
        return 100
    }

    static func progress(for xp: Int) -> Double {
        let currentLevel = level(for: xp)
        guard currentLevel < 100 else { return 1.0 }

        let currentLevelXP = xpPerLevel[currentLevel - 1]
        let nextLevelXP = xpPerLevel[currentLevel]
        let xpInLevel = xp - currentLevelXP
        let xpRequired = nextLevelXP - currentLevelXP

        return Double(xpInLevel) / Double(xpRequired)
    }

    static func xpForNextLevel(currentXP: Int) -> Int {
        let currentLevel = level(for: currentXP)
        guard currentLevel < 100 else { return 0 }
        return xpPerLevel[currentLevel] - currentXP
    }

    static func title(for level: Int) -> String {
        switch level {
        case 1...10: return "Beginner"
        case 11...25: return "Intermediate"
        case 26...50: return "Advanced"
        case 51...75: return "Expert"
        case 76...99: return "Master"
        default: return "Grandmaster"
        }
    }
}
