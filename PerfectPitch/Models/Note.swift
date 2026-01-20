import Foundation

// MARK: - Pitch Class
enum PitchClass: Int, CaseIterable, Codable, Identifiable {
    case C = 0
    case CSharp = 1
    case D = 2
    case DSharp = 3
    case E = 4
    case F = 5
    case FSharp = 6
    case G = 7
    case GSharp = 8
    case A = 9
    case ASharp = 10
    case B = 11

    var id: Int { rawValue }

    var name: String {
        switch self {
        case .C: return "C"
        case .CSharp: return "C#"
        case .D: return "D"
        case .DSharp: return "D#"
        case .E: return "E"
        case .F: return "F"
        case .FSharp: return "F#"
        case .G: return "G"
        case .GSharp: return "G#"
        case .A: return "A"
        case .ASharp: return "A#"
        case .B: return "B"
        }
    }

    var flatName: String {
        switch self {
        case .C: return "C"
        case .CSharp: return "Db"
        case .D: return "D"
        case .DSharp: return "Eb"
        case .E: return "E"
        case .F: return "F"
        case .FSharp: return "Gb"
        case .G: return "G"
        case .GSharp: return "Ab"
        case .A: return "A"
        case .ASharp: return "Bb"
        case .B: return "B"
        }
    }

    var isNatural: Bool {
        switch self {
        case .C, .D, .E, .F, .G, .A, .B:
            return true
        default:
            return false
        }
    }

    static var naturals: [PitchClass] {
        [.C, .D, .E, .F, .G, .A, .B]
    }

    static var sharpsAndFlats: [PitchClass] {
        [.CSharp, .DSharp, .FSharp, .GSharp, .ASharp]
    }
}

// MARK: - Note
struct Note: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    let pitchClass: PitchClass
    let octave: Int

    init(pitchClass: PitchClass, octave: Int) {
        self.id = UUID()
        self.pitchClass = pitchClass
        self.octave = octave
    }

    init(midiNumber: Int) {
        self.id = UUID()
        self.pitchClass = PitchClass(rawValue: midiNumber % 12) ?? .C
        self.octave = (midiNumber / 12) - 1
    }

    var midiNumber: Int {
        (octave + 1) * 12 + pitchClass.rawValue
    }

    var frequency: Double {
        440.0 * pow(2.0, Double(midiNumber - 69) / 12.0)
    }

    var displayName: String {
        "\(pitchClass.name)\(octave)"
    }

    var fullName: String {
        "\(pitchClass.name)\(octave) (\(Int(frequency))Hz)"
    }

    static func random(
        octaveRange: ClosedRange<Int> = 3...5,
        includeAccidentals: Bool = true
    ) -> Note {
        let pitchClasses = includeAccidentals ? PitchClass.allCases : PitchClass.naturals
        let pitchClass = pitchClasses.randomElement()!
        let octave = Int.random(in: octaveRange)
        return Note(pitchClass: pitchClass, octave: octave)
    }

    static func randomSet(
        count: Int,
        octaveRange: ClosedRange<Int> = 3...5,
        includeAccidentals: Bool = true,
        excluding: Note? = nil
    ) -> [Note] {
        var notes: [Note] = []
        while notes.count < count {
            let note = Note.random(octaveRange: octaveRange, includeAccidentals: includeAccidentals)
            if note != excluding && !notes.contains(where: { $0.pitchClass == note.pitchClass }) {
                notes.append(note)
            }
        }
        return notes.shuffled()
    }
}

// MARK: - Interval
enum Interval: Int, CaseIterable, Codable, Identifiable {
    case unison = 0
    case minorSecond = 1
    case majorSecond = 2
    case minorThird = 3
    case majorThird = 4
    case perfectFourth = 5
    case tritone = 6
    case perfectFifth = 7
    case minorSixth = 8
    case majorSixth = 9
    case minorSeventh = 10
    case majorSeventh = 11
    case octave = 12

    var id: Int { rawValue }

    var name: String {
        switch self {
        case .unison: return "Unison"
        case .minorSecond: return "Minor 2nd"
        case .majorSecond: return "Major 2nd"
        case .minorThird: return "Minor 3rd"
        case .majorThird: return "Major 3rd"
        case .perfectFourth: return "Perfect 4th"
        case .tritone: return "Tritone"
        case .perfectFifth: return "Perfect 5th"
        case .minorSixth: return "Minor 6th"
        case .majorSixth: return "Major 6th"
        case .minorSeventh: return "Minor 7th"
        case .majorSeventh: return "Major 7th"
        case .octave: return "Octave"
        }
    }

    var shortName: String {
        switch self {
        case .unison: return "P1"
        case .minorSecond: return "m2"
        case .majorSecond: return "M2"
        case .minorThird: return "m3"
        case .majorThird: return "M3"
        case .perfectFourth: return "P4"
        case .tritone: return "TT"
        case .perfectFifth: return "P5"
        case .minorSixth: return "m6"
        case .majorSixth: return "M6"
        case .minorSeventh: return "m7"
        case .majorSeventh: return "M7"
        case .octave: return "P8"
        }
    }

    var songExample: String {
        switch self {
        case .unison: return "Same note"
        case .minorSecond: return "Jaws Theme"
        case .majorSecond: return "Happy Birthday"
        case .minorThird: return "Greensleeves"
        case .majorThird: return "Oh When The Saints"
        case .perfectFourth: return "Here Comes the Bride"
        case .tritone: return "The Simpsons"
        case .perfectFifth: return "Star Wars"
        case .minorSixth: return "The Entertainer"
        case .majorSixth: return "NBC Chime"
        case .minorSeventh: return "Star Trek Theme"
        case .majorSeventh: return "Take On Me"
        case .octave: return "Somewhere Over the Rainbow"
        }
    }
}
