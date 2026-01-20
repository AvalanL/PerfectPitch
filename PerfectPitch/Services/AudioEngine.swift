import Foundation
import AVFoundation
import Combine

// MARK: - Audio Engine
@MainActor
class AudioEngine: ObservableObject {
    @Published var isPlaying = false
    @Published var currentNote: Note?
    @Published var currentChord: Chord?

    private var audioEngine: AVAudioEngine?
    private var playerNode: AVAudioPlayerNode?
    private var mixerNode: AVAudioMixerNode?

    private var toneGenerators: [ToneGenerator] = []
    private let sampleRate: Double = 44100.0

    init() {
        setupAudioSession()
        setupAudioEngine()
    }

    // MARK: - Setup

    private func setupAudioSession() {
        #if os(iOS)
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try session.setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
        #endif
    }

    private func setupAudioEngine() {
        audioEngine = AVAudioEngine()

        guard let engine = audioEngine else { return }

        mixerNode = engine.mainMixerNode
        playerNode = AVAudioPlayerNode()

        if let player = playerNode {
            engine.attach(player)
            engine.connect(player, to: engine.mainMixerNode, format: nil)
        }

        do {
            try engine.start()
        } catch {
            print("Failed to start audio engine: \(error)")
        }
    }

    // MARK: - Playback

    func playNote(_ note: Note, duration: TimeInterval = 1.0, instrument: UserSettings.Instrument = .piano) {
        stopAllSounds()
        currentNote = note
        isPlaying = true

        switch instrument {
        case .sineWave:
            playSineWave(frequency: note.frequency, duration: duration)
        default:
            playPianoNote(note: note, duration: duration)
        }

        Task { @MainActor in
            try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
            self.isPlaying = false
        }
    }

    func playChord(_ chord: Chord, duration: TimeInterval = 1.5, instrument: UserSettings.Instrument = .piano) {
        stopAllSounds()
        currentChord = chord
        isPlaying = true

        switch instrument {
        case .sineWave:
            for frequency in chord.frequencies {
                playSineWave(frequency: frequency, duration: duration, volume: 0.3)
            }
        default:
            playPianoChord(chord: chord, duration: duration)
        }

        Task { @MainActor in
            try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
            self.isPlaying = false
        }
    }

    func playInterval(from note1: Note, to note2: Note, melodic: Bool = true, duration: TimeInterval = 0.8) {
        stopAllSounds()
        isPlaying = true

        if melodic {
            playSineWave(frequency: note1.frequency, duration: duration)
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: UInt64((duration + 0.1) * 1_000_000_000))
                self.playSineWave(frequency: note2.frequency, duration: duration)
                try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
                self.isPlaying = false
            }
        } else {
            playSineWave(frequency: note1.frequency, duration: duration, volume: 0.5)
            playSineWave(frequency: note2.frequency, duration: duration, volume: 0.5)
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
                self.isPlaying = false
            }
        }
    }

    func playScale(_ notes: [Note], duration: TimeInterval = 0.4) {
        stopAllSounds()
        isPlaying = true

        Task { @MainActor in
            for note in notes {
                self.playSineWave(frequency: note.frequency, duration: duration * 0.9)
                try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
            }
            self.isPlaying = false
        }
    }

    func stopAllSounds() {
        for generator in toneGenerators {
            generator.stop()
        }
        toneGenerators.removeAll()
        playerNode?.stop()
        isPlaying = false
    }

    // MARK: - Sound Generation

    private func playSineWave(frequency: Double, duration: TimeInterval, volume: Float = 0.5) {
        let generator = ToneGenerator(
            frequency: frequency,
            sampleRate: sampleRate,
            volume: volume
        )
        toneGenerators.append(generator)
        generator.play(duration: duration)
    }

    private func playPianoNote(note: Note, duration: TimeInterval) {
        let generator = ToneGenerator(
            frequency: note.frequency,
            sampleRate: sampleRate,
            volume: 0.6,
            attackTime: 0.01,
            decayTime: 0.1,
            sustainLevel: 0.7,
            releaseTime: 0.3
        )
        toneGenerators.append(generator)
        generator.play(duration: duration)
    }

    private func playPianoChord(chord: Chord, duration: TimeInterval) {
        for (index, note) in chord.notes.enumerated() {
            let generator = ToneGenerator(
                frequency: note.frequency,
                sampleRate: sampleRate,
                volume: 0.4 - (Float(index) * 0.05),
                attackTime: 0.01,
                decayTime: 0.15,
                sustainLevel: 0.6,
                releaseTime: 0.4
            )
            toneGenerators.append(generator)
            generator.play(duration: duration)
        }
    }
}

// MARK: - Tone Generator
class ToneGenerator {
    private let frequency: Double
    private let sampleRate: Double
    private var audioPlayer: AVAudioPlayer?

    let volume: Float
    let attackTime: Double
    let decayTime: Double
    let sustainLevel: Float
    let releaseTime: Double

    init(
        frequency: Double,
        sampleRate: Double = 44100.0,
        volume: Float = 0.5,
        attackTime: Double = 0.01,
        decayTime: Double = 0.05,
        sustainLevel: Float = 0.8,
        releaseTime: Double = 0.1
    ) {
        self.frequency = frequency
        self.sampleRate = sampleRate
        self.volume = volume
        self.attackTime = attackTime
        self.decayTime = decayTime
        self.sustainLevel = sustainLevel
        self.releaseTime = releaseTime
    }

    func play(duration: TimeInterval) {
        let audioData = generateToneData(duration: duration)

        do {
            let data = samplesToWAVData(samples: audioData)
            audioPlayer = try AVAudioPlayer(data: data, fileTypeHint: AVFileType.wav.rawValue)
            audioPlayer?.volume = volume
            audioPlayer?.play()
        } catch {
            print("Error playing tone: \(error)")
        }
    }

    func stop() {
        audioPlayer?.stop()
        audioPlayer = nil
    }

    private func generateToneData(duration: TimeInterval) -> [Float] {
        let sampleCount = Int(duration * sampleRate)
        var samples: [Float] = []

        let attackSamples = max(1, Int(attackTime * sampleRate))
        let decaySamples = max(1, Int(decayTime * sampleRate))
        let releaseSamples = max(1, Int(releaseTime * sampleRate))
        let sustainSamples = max(0, sampleCount - attackSamples - decaySamples - releaseSamples)

        for i in 0..<sampleCount {
            let time = Double(i) / sampleRate
            let sineValue = Float(sin(2.0 * .pi * frequency * time))

            // Add harmonics for richer sound
            let harmonic2 = Float(sin(4.0 * .pi * frequency * time)) * 0.5
            let harmonic3 = Float(sin(6.0 * .pi * frequency * time)) * 0.25

            var sample = (sineValue + harmonic2 + harmonic3) / 1.75

            // Apply ADSR envelope
            let envelope: Float
            if i < attackSamples {
                envelope = Float(i) / Float(attackSamples)
            } else if i < attackSamples + decaySamples {
                let decayProgress = Float(i - attackSamples) / Float(decaySamples)
                envelope = 1.0 - (decayProgress * (1.0 - sustainLevel))
            } else if i < attackSamples + decaySamples + sustainSamples {
                envelope = sustainLevel
            } else {
                let releaseProgress = Float(i - attackSamples - decaySamples - sustainSamples) / Float(max(1, releaseSamples))
                envelope = sustainLevel * (1.0 - min(1.0, releaseProgress))
            }

            sample *= envelope * volume
            samples.append(sample)
        }

        return samples
    }

    private func samplesToWAVData(samples: [Float]) -> Data {
        var data = Data()

        // WAV parameters
        let channels: UInt16 = 1
        let bitsPerSample: UInt16 = 16
        let byteRate = UInt32(sampleRate) * UInt32(channels) * UInt32(bitsPerSample / 8)
        let blockAlign = channels * (bitsPerSample / 8)
        let dataSize = UInt32(samples.count * Int(blockAlign))
        let fileSize = 36 + dataSize

        // RIFF header
        data.append(contentsOf: "RIFF".utf8)
        data.append(contentsOf: withUnsafeBytes(of: fileSize.littleEndian) { Array($0) })
        data.append(contentsOf: "WAVE".utf8)

        // fmt chunk
        data.append(contentsOf: "fmt ".utf8)
        data.append(contentsOf: withUnsafeBytes(of: UInt32(16).littleEndian) { Array($0) })
        data.append(contentsOf: withUnsafeBytes(of: UInt16(1).littleEndian) { Array($0) }) // PCM
        data.append(contentsOf: withUnsafeBytes(of: channels.littleEndian) { Array($0) })
        data.append(contentsOf: withUnsafeBytes(of: UInt32(sampleRate).littleEndian) { Array($0) })
        data.append(contentsOf: withUnsafeBytes(of: byteRate.littleEndian) { Array($0) })
        data.append(contentsOf: withUnsafeBytes(of: blockAlign.littleEndian) { Array($0) })
        data.append(contentsOf: withUnsafeBytes(of: bitsPerSample.littleEndian) { Array($0) })

        // data chunk
        data.append(contentsOf: "data".utf8)
        data.append(contentsOf: withUnsafeBytes(of: dataSize.littleEndian) { Array($0) })

        // Audio samples - convert Float to Int16
        for sample in samples {
            let clampedSample = max(-1.0, min(1.0, sample))
            let intSample = Int16(clampedSample * Float(Int16.max))
            data.append(contentsOf: withUnsafeBytes(of: intSample.littleEndian) { Array($0) })
        }

        return data
    }
}
