import Foundation

// MARK: - Exercise Type
enum ExerciseCategory: String, CaseIterable, Identifiable, Codable {
    case notes = "Single Notes"
    case chords = "Chords"
    case intervals = "Intervals"
    case scales = "Scales & Modes"
    case melodicDictation = "Melodic Dictation"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .notes: return "music.note"
        case .chords: return "pianokeys"
        case .intervals: return "arrow.up.arrow.down"
        case .scales: return "music.quarternote.3"
        case .melodicDictation: return "waveform.and.mic"
        }
    }

    var description: String {
        switch self {
        case .notes: return "Master individual pitch recognition"
        case .chords: return "Identify chord qualities and progressions"
        case .intervals: return "Learn the distance between any two notes"
        case .scales: return "Recognize scales and their characteristic sounds"
        case .melodicDictation: return "Transcribe melodies by ear"
        }
    }

    var color: String {
        switch self {
        case .notes: return "6366F1"
        case .chords: return "8B5CF6"
        case .intervals: return "EC4899"
        case .scales: return "14B8A6"
        case .melodicDictation: return "F59E0B"
        }
    }
}

// MARK: - Difficulty
enum Difficulty: Int, CaseIterable, Identifiable, Codable {
    case beginner = 1
    case intermediate = 2
    case advanced = 3
    case expert = 4
    case master = 5

    var id: Int { rawValue }

    var name: String {
        switch self {
        case .beginner: return "Beginner"
        case .intermediate: return "Intermediate"
        case .advanced: return "Advanced"
        case .expert: return "Expert"
        case .master: return "Master"
        }
    }

    var xpMultiplier: Double {
        switch self {
        case .beginner: return 1.0
        case .intermediate: return 1.5
        case .advanced: return 2.0
        case .expert: return 2.5
        case .master: return 3.0
        }
    }
}

// MARK: - Exercise Session
struct ExerciseSession: Identifiable, Codable {
    let id: UUID
    let category: ExerciseCategory
    let difficulty: Difficulty
    let startTime: Date
    var endTime: Date?
    var questions: [Question]
    var currentQuestionIndex: Int

    init(category: ExerciseCategory, difficulty: Difficulty, questionCount: Int = 20) {
        self.id = UUID()
        self.category = category
        self.difficulty = difficulty
        self.startTime = Date()
        self.questions = []
        self.currentQuestionIndex = 0

        // Generate questions based on category
        self.questions = generateQuestions(count: questionCount)
    }

    var isComplete: Bool {
        currentQuestionIndex >= questions.count
    }

    var currentQuestion: Question? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }

    var correctCount: Int {
        questions.filter { $0.isCorrect == true }.count
    }

    var accuracy: Double {
        let answered = questions.filter { $0.isCorrect != nil }.count
        guard answered > 0 else { return 0 }
        return Double(correctCount) / Double(answered)
    }

    var totalXP: Int {
        let baseXP = questions.reduce(0) { total, question in
            total + (question.isCorrect == true ? question.xpValue : 0)
        }
        return Int(Double(baseXP) * difficulty.xpMultiplier)
    }

    var duration: TimeInterval {
        guard let end = endTime else { return Date().timeIntervalSince(startTime) }
        return end.timeIntervalSince(startTime)
    }

    var starRating: Int {
        switch accuracy {
        case 0.9...1.0: return 3
        case 0.7..<0.9: return 2
        case 0.5..<0.7: return 1
        default: return 0
        }
    }

    private func generateQuestions(count: Int) -> [Question] {
        (0..<count).map { index in
            switch category {
            case .notes:
                return Question.noteQuestion(difficulty: difficulty, questionNumber: index + 1)
            case .chords:
                return Question.chordQuestion(difficulty: difficulty, questionNumber: index + 1)
            case .intervals:
                return Question.intervalQuestion(difficulty: difficulty, questionNumber: index + 1)
            case .scales:
                return Question.scaleQuestion(difficulty: difficulty, questionNumber: index + 1)
            case .melodicDictation:
                return Question.noteQuestion(difficulty: difficulty, questionNumber: index + 1)
            }
        }
    }

    mutating func answerCurrent(_ answer: String) -> Bool {
        guard currentQuestionIndex < questions.count else { return false }
        let isCorrect = questions[currentQuestionIndex].answer(answer)
        currentQuestionIndex += 1

        if isComplete {
            endTime = Date()
        }

        return isCorrect
    }
}

// MARK: - Question
struct Question: Identifiable, Codable {
    let id: UUID
    let questionNumber: Int
    let prompt: String
    let correctAnswer: String
    let options: [String]
    let xpValue: Int
    var selectedAnswer: String?
    var answeredAt: Date?

    var isCorrect: Bool? {
        guard selectedAnswer != nil else { return nil }
        return selectedAnswer == correctAnswer
    }

    var responseTime: TimeInterval? {
        guard let answered = answeredAt else { return nil }
        return answered.timeIntervalSinceNow * -1
    }

    mutating func answer(_ answer: String) -> Bool {
        selectedAnswer = answer
        answeredAt = Date()
        return answer == correctAnswer
    }

    // MARK: - Question Generators

    static func noteQuestion(difficulty: Difficulty, questionNumber: Int) -> Question {
        let includeAccidentals = difficulty.rawValue >= 2
        let octaveRange: ClosedRange<Int> = difficulty.rawValue >= 3 ? 2...6 : 3...5

        let correctNote = Note.random(octaveRange: octaveRange, includeAccidentals: includeAccidentals)

        let optionCount = difficulty.rawValue >= 3 ? 7 : (difficulty.rawValue >= 2 ? 5 : 4)
        var options = [correctNote.pitchClass.name]

        let availablePitches = includeAccidentals ? PitchClass.allCases : PitchClass.naturals
        while options.count < optionCount {
            let randomPitch = availablePitches.randomElement()!
            if !options.contains(randomPitch.name) {
                options.append(randomPitch.name)
            }
        }

        return Question(
            id: UUID(),
            questionNumber: questionNumber,
            prompt: "What note is this?",
            correctAnswer: correctNote.pitchClass.name,
            options: options.shuffled(),
            xpValue: 10 + (difficulty.rawValue * 5)
        )
    }

    static func chordQuestion(difficulty: Difficulty, questionNumber: Int) -> Question {
        let availableQualities = ChordQuality.forDifficulty(difficulty.rawValue + 1)
        let correctChord = Chord.random(qualities: availableQualities)

        var options = [correctChord.quality.rawValue]
        while options.count < min(4, availableQualities.count) {
            let randomQuality = availableQualities.randomElement()!
            if !options.contains(randomQuality.rawValue) {
                options.append(randomQuality.rawValue)
            }
        }

        return Question(
            id: UUID(),
            questionNumber: questionNumber,
            prompt: "What type of chord is this?",
            correctAnswer: correctChord.quality.rawValue,
            options: options.shuffled(),
            xpValue: 15 + (difficulty.rawValue * 5)
        )
    }

    static func intervalQuestion(difficulty: Difficulty, questionNumber: Int) -> Question {
        let availableIntervals: [Interval]
        switch difficulty {
        case .beginner:
            availableIntervals = [.majorSecond, .majorThird, .perfectFourth, .perfectFifth, .octave]
        case .intermediate:
            availableIntervals = [.majorSecond, .minorThird, .majorThird, .perfectFourth, .perfectFifth, .minorSixth, .majorSixth, .octave]
        default:
            availableIntervals = Interval.allCases.filter { $0 != .unison }
        }

        let correctInterval = availableIntervals.randomElement()!

        var options = [correctInterval.name]
        while options.count < min(4, availableIntervals.count) {
            let randomInterval = availableIntervals.randomElement()!
            if !options.contains(randomInterval.name) {
                options.append(randomInterval.name)
            }
        }

        return Question(
            id: UUID(),
            questionNumber: questionNumber,
            prompt: "What interval is this?",
            correctAnswer: correctInterval.name,
            options: options.shuffled(),
            xpValue: 15 + (difficulty.rawValue * 5)
        )
    }

    static func scaleQuestion(difficulty: Difficulty, questionNumber: Int) -> Question {
        let scales = ["Major", "Natural Minor", "Harmonic Minor", "Melodic Minor", "Dorian", "Mixolydian"]
        let availableScales = Array(scales.prefix(2 + difficulty.rawValue))
        let correctScale = availableScales.randomElement()!

        var options = [correctScale]
        while options.count < min(4, availableScales.count) {
            let randomScale = availableScales.randomElement()!
            if !options.contains(randomScale) {
                options.append(randomScale)
            }
        }

        return Question(
            id: UUID(),
            questionNumber: questionNumber,
            prompt: "What scale is this?",
            correctAnswer: correctScale,
            options: options.shuffled(),
            xpValue: 20 + (difficulty.rawValue * 5)
        )
    }
}

// MARK: - Session Result
struct SessionResult: Identifiable, Codable {
    let id: UUID
    let session: ExerciseSession
    let date: Date
    let xpEarned: Int
    let newAchievements: [Achievement]
    let streakBonus: Int
    let isPerfect: Bool

    init(session: ExerciseSession, newAchievements: [Achievement] = [], streakBonus: Int = 0) {
        self.id = UUID()
        self.session = session
        self.date = Date()
        self.xpEarned = session.totalXP + streakBonus
        self.newAchievements = newAchievements
        self.streakBonus = streakBonus
        self.isPerfect = session.accuracy == 1.0
    }
}
