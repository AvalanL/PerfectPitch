import Foundation

// MARK: - Chord Quality
enum ChordQuality: String, CaseIterable, Codable, Identifiable {
    case major = "Major"
    case minor = "Minor"
    case diminished = "Diminished"
    case augmented = "Augmented"
    case major7 = "Major 7th"
    case minor7 = "Minor 7th"
    case dominant7 = "Dominant 7th"
    case diminished7 = "Diminished 7th"
    case halfDiminished7 = "Half-Dim 7th"
    case minorMajor7 = "Minor-Major 7th"
    case suspended2 = "Suspended 2nd"
    case suspended4 = "Suspended 4th"

    var id: String { rawValue }

    var abbreviation: String {
        switch self {
        case .major: return "maj"
        case .minor: return "min"
        case .diminished: return "dim"
        case .augmented: return "aug"
        case .major7: return "maj7"
        case .minor7: return "min7"
        case .dominant7: return "7"
        case .diminished7: return "dim7"
        case .halfDiminished7: return "m7b5"
        case .minorMajor7: return "mM7"
        case .suspended2: return "sus2"
        case .suspended4: return "sus4"
        }
    }

    var intervals: [Int] {
        switch self {
        case .major: return [0, 4, 7]
        case .minor: return [0, 3, 7]
        case .diminished: return [0, 3, 6]
        case .augmented: return [0, 4, 8]
        case .major7: return [0, 4, 7, 11]
        case .minor7: return [0, 3, 7, 10]
        case .dominant7: return [0, 4, 7, 10]
        case .diminished7: return [0, 3, 6, 9]
        case .halfDiminished7: return [0, 3, 6, 10]
        case .minorMajor7: return [0, 3, 7, 11]
        case .suspended2: return [0, 2, 7]
        case .suspended4: return [0, 5, 7]
        }
    }

    var description: String {
        switch self {
        case .major: return "Bright and happy"
        case .minor: return "Sad and emotional"
        case .diminished: return "Tense and unstable"
        case .augmented: return "Dreamy and unresolved"
        case .major7: return "Jazzy and sophisticated"
        case .minor7: return "Smooth and mellow"
        case .dominant7: return "Bluesy with tension"
        case .diminished7: return "Dramatic and suspenseful"
        case .halfDiminished7: return "Melancholic jazz"
        case .minorMajor7: return "Mysterious and complex"
        case .suspended2: return "Open and airy"
        case .suspended4: return "Anticipating resolution"
        }
    }

    var difficulty: Int {
        switch self {
        case .major, .minor: return 1
        case .diminished, .augmented: return 2
        case .major7, .minor7, .dominant7: return 3
        case .diminished7, .halfDiminished7: return 4
        case .minorMajor7, .suspended2, .suspended4: return 5
        }
    }

    static func forDifficulty(_ level: Int) -> [ChordQuality] {
        allCases.filter { $0.difficulty <= level }
    }
}

// MARK: - Chord
struct Chord: Identifiable, Codable, Equatable {
    let id: UUID
    let root: PitchClass
    let quality: ChordQuality
    let octave: Int

    init(root: PitchClass, quality: ChordQuality, octave: Int = 4) {
        self.id = UUID()
        self.root = root
        self.quality = quality
        self.octave = octave
    }

    var displayName: String {
        "\(root.name) \(quality.rawValue)"
    }

    var shortName: String {
        "\(root.name)\(quality.abbreviation)"
    }

    var notes: [Note] {
        quality.intervals.map { interval in
            let midiBase = (octave + 1) * 12 + root.rawValue
            return Note(midiNumber: midiBase + interval)
        }
    }

    var frequencies: [Double] {
        notes.map { $0.frequency }
    }

    static func random(
        qualities: [ChordQuality]? = nil,
        octave: Int = 4
    ) -> Chord {
        let availableQualities = qualities ?? ChordQuality.allCases
        let quality = availableQualities.randomElement()!
        let root = PitchClass.allCases.randomElement()!
        return Chord(root: root, quality: quality, octave: octave)
    }

    static func randomSet(
        count: Int,
        qualities: [ChordQuality]? = nil,
        excluding: Chord? = nil
    ) -> [Chord] {
        var chords: [Chord] = []
        let availableQualities = qualities ?? ChordQuality.allCases

        while chords.count < count {
            let chord = Chord.random(qualities: availableQualities)
            if chord.quality != excluding?.quality && !chords.contains(where: { $0.quality == chord.quality }) {
                chords.append(chord)
            }
        }
        return chords.shuffled()
    }
}

// MARK: - Chord Progression
struct ChordProgression: Identifiable, Codable {
    let id: UUID
    let name: String
    let numerals: [String]
    let chords: [Chord]
    let genre: Genre

    enum Genre: String, Codable, CaseIterable {
        case pop = "Pop"
        case jazz = "Jazz"
        case blues = "Blues"
        case classical = "Classical"
        case rock = "Rock"
    }

    static let commonProgressions: [ChordProgression] = [
        ChordProgression(
            id: UUID(),
            name: "I-V-vi-IV",
            numerals: ["I", "V", "vi", "IV"],
            chords: [
                Chord(root: .C, quality: .major),
                Chord(root: .G, quality: .major),
                Chord(root: .A, quality: .minor),
                Chord(root: .F, quality: .major)
            ],
            genre: .pop
        ),
        ChordProgression(
            id: UUID(),
            name: "ii-V-I",
            numerals: ["ii", "V", "I"],
            chords: [
                Chord(root: .D, quality: .minor7),
                Chord(root: .G, quality: .dominant7),
                Chord(root: .C, quality: .major7)
            ],
            genre: .jazz
        ),
        ChordProgression(
            id: UUID(),
            name: "12-Bar Blues",
            numerals: ["I", "I", "I", "I", "IV", "IV", "I", "I", "V", "IV", "I", "V"],
            chords: [
                Chord(root: .C, quality: .dominant7),
                Chord(root: .C, quality: .dominant7),
                Chord(root: .C, quality: .dominant7),
                Chord(root: .C, quality: .dominant7),
                Chord(root: .F, quality: .dominant7),
                Chord(root: .F, quality: .dominant7),
                Chord(root: .C, quality: .dominant7),
                Chord(root: .C, quality: .dominant7),
                Chord(root: .G, quality: .dominant7),
                Chord(root: .F, quality: .dominant7),
                Chord(root: .C, quality: .dominant7),
                Chord(root: .G, quality: .dominant7)
            ],
            genre: .blues
        )
    ]
}
