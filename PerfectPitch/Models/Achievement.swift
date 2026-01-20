import Foundation

// MARK: - Achievement
struct Achievement: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let category: Category
    let requirement: Int
    var progress: Int
    var unlockedAt: Date?

    var isUnlocked: Bool {
        unlockedAt != nil
    }

    var progressPercentage: Double {
        min(1.0, Double(progress) / Double(requirement))
    }

    enum Category: String, Codable, CaseIterable {
        case consistency = "Consistency"
        case skill = "Skill"
        case speed = "Speed"
        case special = "Special"

        var icon: String {
            switch self {
            case .consistency: return "flame.fill"
            case .skill: return "star.fill"
            case .speed: return "bolt.fill"
            case .special: return "sparkles"
            }
        }
    }

    mutating func updateProgress(_ newProgress: Int) {
        progress = newProgress
        if progress >= requirement && unlockedAt == nil {
            unlockedAt = Date()
        }
    }

    // MARK: - All Achievements
    static let all: [Achievement] = [
        // Consistency
        Achievement(
            id: "first_steps",
            title: "First Steps",
            description: "Complete your first exercise",
            icon: "figure.walk",
            category: .consistency,
            requirement: 1,
            progress: 0
        ),
        Achievement(
            id: "week_warrior",
            title: "Week Warrior",
            description: "Maintain a 7-day streak",
            icon: "flame.fill",
            category: .consistency,
            requirement: 7,
            progress: 0
        ),
        Achievement(
            id: "month_master",
            title: "Month Master",
            description: "Maintain a 30-day streak",
            icon: "flame.circle.fill",
            category: .consistency,
            requirement: 30,
            progress: 0
        ),
        Achievement(
            id: "year_of_the_ear",
            title: "Year of the Ear",
            description: "Maintain a 365-day streak",
            icon: "crown.fill",
            category: .consistency,
            requirement: 365,
            progress: 0
        ),
        Achievement(
            id: "dedicated_10",
            title: "Dedicated",
            description: "Complete 10 training sessions",
            icon: "checkmark.circle.fill",
            category: .consistency,
            requirement: 10,
            progress: 0
        ),
        Achievement(
            id: "committed_50",
            title: "Committed",
            description: "Complete 50 training sessions",
            icon: "checkmark.seal.fill",
            category: .consistency,
            requirement: 50,
            progress: 0
        ),
        Achievement(
            id: "obsessed_100",
            title: "Obsessed",
            description: "Complete 100 training sessions",
            icon: "star.circle.fill",
            category: .consistency,
            requirement: 100,
            progress: 0
        ),

        // Skill
        Achievement(
            id: "note_novice",
            title: "Note Novice",
            description: "Identify 100 notes correctly",
            icon: "music.note",
            category: .skill,
            requirement: 100,
            progress: 0
        ),
        Achievement(
            id: "note_expert",
            title: "Note Expert",
            description: "Identify 1,000 notes correctly",
            icon: "music.note.list",
            category: .skill,
            requirement: 1000,
            progress: 0
        ),
        Achievement(
            id: "chord_champion",
            title: "Chord Champion",
            description: "Identify 500 chords correctly",
            icon: "pianokeys",
            category: .skill,
            requirement: 500,
            progress: 0
        ),
        Achievement(
            id: "interval_intuition",
            title: "Interval Intuition",
            description: "Get 50 intervals correct in a row",
            icon: "arrow.up.arrow.down",
            category: .skill,
            requirement: 50,
            progress: 0
        ),
        Achievement(
            id: "perfect_session",
            title: "Perfectionist",
            description: "Complete a session with 100% accuracy",
            icon: "checkmark.diamond.fill",
            category: .skill,
            requirement: 1,
            progress: 0
        ),
        Achievement(
            id: "accuracy_master",
            title: "Accuracy Master",
            description: "Achieve 95% accuracy in advanced mode",
            icon: "target",
            category: .skill,
            requirement: 1,
            progress: 0
        ),

        // Speed
        Achievement(
            id: "quick_ear",
            title: "Quick Ear",
            description: "Answer 10 questions in under 20 seconds",
            icon: "hare.fill",
            category: .speed,
            requirement: 1,
            progress: 0
        ),
        Achievement(
            id: "lightning_reflexes",
            title: "Lightning Reflexes",
            description: "Answer correctly in under 1 second",
            icon: "bolt.fill",
            category: .speed,
            requirement: 1,
            progress: 0
        ),
        Achievement(
            id: "speed_demon",
            title: "Speed Demon",
            description: "Complete a session in under 2 minutes",
            icon: "timer",
            category: .speed,
            requirement: 1,
            progress: 0
        ),

        // Special
        Achievement(
            id: "night_owl",
            title: "Night Owl",
            description: "Practice after midnight",
            icon: "moon.stars.fill",
            category: .special,
            requirement: 1,
            progress: 0
        ),
        Achievement(
            id: "early_bird",
            title: "Early Bird",
            description: "Practice before 6 AM",
            icon: "sunrise.fill",
            category: .special,
            requirement: 1,
            progress: 0
        ),
        Achievement(
            id: "level_10",
            title: "Rising Star",
            description: "Reach level 10",
            icon: "star.fill",
            category: .special,
            requirement: 10,
            progress: 0
        ),
        Achievement(
            id: "level_25",
            title: "Skilled Listener",
            description: "Reach level 25",
            icon: "star.leadinghalf.filled",
            category: .special,
            requirement: 25,
            progress: 0
        ),
        Achievement(
            id: "level_50",
            title: "Golden Ear",
            description: "Reach level 50",
            icon: "ear.fill",
            category: .special,
            requirement: 50,
            progress: 0
        ),
        Achievement(
            id: "all_chord_types",
            title: "Chord Collector",
            description: "Successfully identify all chord types",
            icon: "rectangle.stack.fill",
            category: .special,
            requirement: 12,
            progress: 0
        )
    ]
}

// MARK: - Daily Challenge
struct DailyChallenge: Identifiable, Codable {
    let id: UUID
    let date: Date
    let exercises: [ChallengeExercise]
    var completed: Bool
    var score: Int
    var totalPossible: Int

    struct ChallengeExercise: Codable {
        let type: ExerciseType
        let questionCount: Int
        var completed: Bool
        var correctCount: Int
    }

    enum ExerciseType: String, Codable {
        case notes = "Notes"
        case chords = "Chords"
        case intervals = "Intervals"
        case scales = "Scales"

        var icon: String {
            switch self {
            case .notes: return "music.note"
            case .chords: return "pianokeys"
            case .intervals: return "arrow.up.arrow.down"
            case .scales: return "music.quarternote.3"
            }
        }
    }

    var progress: Double {
        let completedCount = exercises.filter { $0.completed }.count
        return Double(completedCount) / Double(exercises.count)
    }

    static func generateDaily() -> DailyChallenge {
        let exerciseTypes: [ExerciseType] = [.notes, .chords, .intervals].shuffled()
        let exercises = exerciseTypes.prefix(3).map { type in
            ChallengeExercise(type: type, questionCount: 10, completed: false, correctCount: 0)
        }

        return DailyChallenge(
            id: UUID(),
            date: Date(),
            exercises: Array(exercises),
            completed: false,
            score: 0,
            totalPossible: exercises.reduce(0) { $0 + $1.questionCount }
        )
    }
}
