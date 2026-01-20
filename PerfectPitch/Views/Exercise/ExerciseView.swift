import SwiftUI

struct ExerciseView: View {
    let category: ExerciseCategory
    let difficulty: Difficulty

    @EnvironmentObject var audioEngine: AudioEngine
    @EnvironmentObject var userManager: UserManager
    @Environment(\.dismiss) var dismiss

    @StateObject private var viewModel: ExerciseViewModel

    init(category: ExerciseCategory, difficulty: Difficulty) {
        self.category = category
        self.difficulty = difficulty
        _viewModel = StateObject(wrappedValue: ExerciseViewModel(category: category, difficulty: difficulty))
    }

    var body: some View {
        ZStack {
            // Rich gradient background
            LinearGradient.ambientGradient
                .ignoresSafeArea()

            if viewModel.showResults {
                SessionResultsView(
                    session: viewModel.session,
                    onDismiss: { dismiss() },
                    onRetry: { viewModel.startNewSession() }
                )
            } else {
                exerciseContent
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.textSecondary)
                        .frame(width: 32, height: 32)
                        .background(Color.backgroundElevated)
                        .clipShape(Circle())
                        .ppShadowSmall()
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: PPSpacing.sm) {
                    Button(action: {}) {
                        Image(systemName: "gearshape")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.textSecondary)
                            .frame(width: 32, height: 32)
                            .background(Color.backgroundElevated)
                            .clipShape(Circle())
                    }

                    Button(action: { viewModel.playCurrentSound(audioEngine: audioEngine) }) {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.primaryPurple)
                            .frame(width: 32, height: 32)
                            .background(Color.primaryPurple.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
            }
        }
        .onAppear {
            // Play sound after a short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                viewModel.playCurrentSound(audioEngine: audioEngine)
            }
        }
    }

    // MARK: - Exercise Content
    private var exerciseContent: some View {
        VStack(spacing: 0) {
            // Progress bar with glow effect
            VStack(spacing: PPSpacing.sm) {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.borderLight)
                            .frame(height: 6)

                        RoundedRectangle(cornerRadius: 4)
                            .fill(LinearGradient.primaryGradient)
                            .frame(width: geo.size.width * viewModel.progress, height: 6)
                            .shadow(color: .primaryPurple.opacity(0.4), radius: 4, x: 0, y: 0)
                    }
                }
                .frame(height: 6)

                HStack {
                    Text("Question \(viewModel.currentQuestionNumber) of \(viewModel.totalQuestions)")
                        .font(PPFont.caption())
                        .foregroundColor(.textSecondary)

                    Spacer()

                    if viewModel.currentStreak > 0 {
                        HStack(spacing: 4) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 12))
                                .foregroundStyle(LinearGradient.streakGradient)
                            Text("\(viewModel.currentStreak)")
                                .font(PPFont.captionSmall())
                                .foregroundColor(.streakOrange)
                        }
                        .padding(.horizontal, PPSpacing.sm)
                        .padding(.vertical, PPSpacing.xs)
                        .background(Color.streakOrange.opacity(0.1))
                        .cornerRadius(PPRadius.full)
                    }
                }
            }
            .padding(.horizontal, PPSpacing.lg)
            .padding(.top, PPSpacing.md)

            Spacer()

            // Play button section
            VStack(spacing: PPSpacing.xl) {
                if let feedback = viewModel.answerFeedback {
                    // Feedback display
                    feedbackView(feedback)
                } else {
                    // Play button
                    PlayButton(isPlaying: audioEngine.isPlaying) {
                        viewModel.playCurrentSound(audioEngine: audioEngine)
                    }

                    Text(viewModel.currentQuestion?.prompt ?? "What do you hear?")
                        .font(PPFont.titleLarge())
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(height: 200)

            Spacer()

            // Answer options
            answerGrid
                .padding(.horizontal, PPSpacing.lg)
                .padding(.bottom, PPSpacing.xxl)

            // Continue button (shown after answering)
            if viewModel.answerFeedback != nil {
                PPButton("Continue", icon: "arrow.right") {
                    viewModel.moveToNextQuestion(audioEngine: audioEngine)
                }
                .padding(.horizontal, PPSpacing.lg)
                .padding(.bottom, PPSpacing.lg)
            }
        }
    }

    // MARK: - Answer Grid
    private var answerGrid: some View {
        let options = viewModel.currentQuestion?.options ?? []
        let columns = options.count <= 4 ?
            [GridItem(.flexible()), GridItem(.flexible())] :
            [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

        return LazyVGrid(columns: columns, spacing: PPSpacing.md) {
            ForEach(options, id: \.self) { option in
                AnswerButton(
                    text: option,
                    state: buttonState(for: option)
                ) {
                    if viewModel.answerFeedback == nil {
                        viewModel.submitAnswer(option)
                    }
                }
            }
        }
    }

    private func buttonState(for option: String) -> AnswerButton.AnswerState {
        guard let feedback = viewModel.answerFeedback else {
            return .normal
        }

        if option == feedback.correctAnswer {
            return .correct
        } else if option == feedback.selectedAnswer && !feedback.isCorrect {
            return .incorrect
        } else {
            return .disabled
        }
    }

    // MARK: - Feedback View
    @ViewBuilder
    private func feedbackView(_ feedback: AnswerFeedback) -> some View {
        VStack(spacing: PPSpacing.lg) {
            if feedback.isCorrect {
                AnimatedCheckmark()

                Text("Correct!")
                    .font(PPFont.titleLarge())
                    .foregroundColor(.success)

                XPGainView(amount: feedback.xpEarned)
            } else {
                AnimatedX()

                Text("Not quite")
                    .font(PPFont.titleLarge())
                    .foregroundColor(.error)

                Text("The answer was \(feedback.correctAnswer)")
                    .font(PPFont.bodyMedium())
                    .foregroundColor(.textSecondary)
            }
        }
    }
}

// MARK: - Answer Feedback
struct AnswerFeedback {
    let isCorrect: Bool
    let correctAnswer: String
    let selectedAnswer: String
    let xpEarned: Int
}

// MARK: - Exercise View Model
@MainActor
class ExerciseViewModel: ObservableObject {
    @Published var session: ExerciseSession
    @Published var answerFeedback: AnswerFeedback?
    @Published var showResults = false
    @Published var currentStreak = 0

    init(category: ExerciseCategory, difficulty: Difficulty) {
        self.session = ExerciseSession(category: category, difficulty: difficulty)
    }

    var currentQuestion: Question? {
        session.currentQuestion
    }

    var currentQuestionNumber: Int {
        session.currentQuestionIndex + 1
    }

    var totalQuestions: Int {
        session.questions.count
    }

    var progress: Double {
        Double(session.currentQuestionIndex) / Double(totalQuestions)
    }

    func playCurrentSound(audioEngine: AudioEngine) {
        guard currentQuestion != nil else { return }

        // Generate appropriate sound based on category
        switch session.category {
        case .notes:
            let note = Note.random()
            audioEngine.playNote(note)
        case .chords:
            let chord = Chord.random()
            audioEngine.playChord(chord)
        case .intervals:
            let note1 = Note(pitchClass: .C, octave: 4)
            let interval = Int.random(in: 1...12)
            let note2 = Note(midiNumber: note1.midiNumber + interval)
            audioEngine.playInterval(from: note1, to: note2)
        default:
            let note = Note.random()
            audioEngine.playNote(note)
        }
    }

    func submitAnswer(_ answer: String) {
        guard let question = currentQuestion else { return }

        let isCorrect = session.answerCurrent(answer)

        if isCorrect {
            currentStreak += 1
        } else {
            currentStreak = 0
        }

        answerFeedback = AnswerFeedback(
            isCorrect: isCorrect,
            correctAnswer: question.correctAnswer,
            selectedAnswer: answer,
            xpEarned: isCorrect ? question.xpValue : 0
        )
    }

    func moveToNextQuestion(audioEngine: AudioEngine) {
        answerFeedback = nil

        if session.isComplete {
            showResults = true
        } else {
            // Play next sound after short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.playCurrentSound(audioEngine: audioEngine)
            }
        }
    }

    func startNewSession() {
        session = ExerciseSession(category: session.category, difficulty: session.difficulty)
        answerFeedback = nil
        showResults = false
        currentStreak = 0
    }
}

// MARK: - Session Results View
struct SessionResultsView: View {
    let session: ExerciseSession
    let onDismiss: () -> Void
    let onRetry: () -> Void

    @State private var showContent = false

    var body: some View {
        ScrollView {
            VStack(spacing: PPSpacing.xxl) {
                // Trophy animation with glow
                ZStack {
                    // Glow effect
                    Circle()
                        .fill(Color.primaryPurple.opacity(0.2))
                        .frame(width: 140, height: 140)
                        .blur(radius: 20)
                        .scaleEffect(showContent ? 1 : 0)

                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.primaryPurple.opacity(0.15), Color.primaryPurple.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                        .scaleEffect(showContent ? 1 : 0)

                    Image(systemName: trophyIcon)
                        .font(.system(size: 50))
                        .foregroundStyle(LinearGradient.primaryGradient)
                        .scaleEffect(showContent ? 1 : 0)
                }
                .padding(.top, PPSpacing.huge)

                // Title
                VStack(spacing: PPSpacing.sm) {
                    Text("Session Complete!")
                        .font(PPFont.displayMedium())
                        .foregroundColor(.textPrimary)
                        .opacity(showContent ? 1 : 0)

                    Text(motivationalMessage)
                        .font(PPFont.bodyLarge())
                        .foregroundColor(.textSecondary)
                        .opacity(showContent ? 1 : 0)
                }

                // Stats card with elevated styling
                VStack(spacing: PPSpacing.lg) {
                        // Score
                        HStack {
                            Text("Score")
                                .font(PPFont.bodyLarge())
                                .foregroundColor(.textSecondary)

                            Spacer()

                            Text("\(session.correctCount) / \(session.questions.count)")
                                .font(PPFont.titleLarge())
                                .foregroundColor(.textPrimary)
                        }

                        Divider()

                        // Accuracy
                        HStack {
                            Text("Accuracy")
                                .font(PPFont.bodyLarge())
                                .foregroundColor(.textSecondary)

                            Spacer()

                            Text("\(Int(session.accuracy * 100))%")
                                .font(PPFont.titleLarge())
                                .foregroundColor(accuracyColor)
                        }

                        Divider()

                        // Stars
                        HStack {
                            Text("Rating")
                                .font(PPFont.bodyLarge())
                                .foregroundColor(.textSecondary)

                            Spacer()

                            HStack(spacing: 4) {
                                ForEach(1...3, id: \.self) { star in
                                    Image(systemName: star <= session.starRating ? "star.fill" : "star")
                                        .foregroundColor(.warning)
                                        .font(.system(size: 20))
                                }
                            }
                        }

                        Divider()

                        // XP Earned
                        HStack {
                            Text("XP Earned")
                                .font(PPFont.bodyLarge())
                                .foregroundColor(.textSecondary)

                            Spacer()

                            Text("+\(session.totalXP)")
                                .font(PPFont.titleLarge())
                                .foregroundColor(.primaryPurple)
                        }

                        Divider()

                        // Time
                        HStack {
                            Text("Time")
                                .font(PPFont.bodyLarge())
                                .foregroundColor(.textSecondary)

                            Spacer()

                            Text(formatDuration(session.duration))
                                .font(PPFont.titleLarge())
                                .foregroundColor(.textPrimary)
                        }
                }
                .padding(PPSpacing.xl)
                .background(
                    RoundedRectangle(cornerRadius: PPRadius.xl)
                        .fill(Color.backgroundElevated)
                        .overlay(
                            RoundedRectangle(cornerRadius: PPRadius.xl)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.primaryPurple.opacity(0.05), Color.clear],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                )
                .ppShadowLarge()
                .padding(.horizontal, PPSpacing.lg)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)

                // Buttons
                VStack(spacing: PPSpacing.md) {
                    PPButton("Practice Again", icon: "arrow.clockwise") {
                        onRetry()
                    }

                    PPButton("Done", style: .secondary) {
                        onDismiss()
                    }
                }
                .padding(.horizontal, PPSpacing.lg)
                .padding(.bottom, PPSpacing.huge)
                .opacity(showContent ? 1 : 0)
            }
        }
        .background(
            LinearGradient.ambientGradient
                .ignoresSafeArea()
        )
        .onAppear {
            withAnimation(.ppSpring.delay(0.2)) {
                showContent = true
            }
        }
    }

    private var trophyIcon: String {
        switch session.starRating {
        case 3: return "trophy.fill"
        case 2: return "medal.fill"
        case 1: return "star.fill"
        default: return "checkmark.circle.fill"
        }
    }

    private var motivationalMessage: String {
        switch session.accuracy {
        case 0.9...1.0: return "Outstanding performance!"
        case 0.75..<0.9: return "Great job!"
        case 0.5..<0.75: return "Good effort, keep practicing!"
        default: return "Every practice makes progress!"
        }
    }

    private var accuracyColor: Color {
        switch session.accuracy {
        case 0.8...1.0: return .success
        case 0.6..<0.8: return .warning
        default: return .error
        }
    }

    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

#Preview {
    NavigationStack {
        ExerciseView(category: .notes, difficulty: .intermediate)
            .environmentObject(AudioEngine())
            .environmentObject(UserManager())
    }
}
