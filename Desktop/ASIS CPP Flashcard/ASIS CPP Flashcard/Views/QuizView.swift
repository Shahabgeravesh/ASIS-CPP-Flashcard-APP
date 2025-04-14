import SwiftUI

struct QuizView: View {
    let chapter: Chapter
    @ObservedObject var chapterStore: ChapterStore
    @State private var quizSession: QuizSession
    @State private var currentQuestionIndex = 0
    @State private var showingResults = false
    @State private var showingExitAlert = false
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss
    @State private var showFeedback = false
    @State private var isCorrect = false
    
    init(chapter: Chapter, chapterStore: ChapterStore) {
        self.chapter = chapter
        self.chapterStore = chapterStore
        print("Initializing quiz for chapter \(chapter.number)")
        print("Total questions loaded: \(chapterStore.questionBankManager.questionBank?.count ?? 0)")
        _quizSession = State(initialValue: chapterStore.questionBankManager.generateQuiz(for: chapter.number))
    }
    
    private var progress: Double {
        let current = Double(currentQuestionIndex + 1)
        let total = Double(quizSession.questions.count)
        return min(max(current / total, 0), 1) // Ensure progress is between 0 and 1
    }
    
    var body: some View {
        if quizSession.questions.isEmpty {
            // Show message if no questions are loaded
            VStack {
                Text("No questions available for this chapter")
                    .font(.headline)
                Text("Please check the question bank configuration")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // Add debug button
                Button(action: {
                    print("Debug Info:")
                    print("Chapter number: \(chapter.number)")
                    print("Quiz session questions: \(quizSession.questions.count)")
                    print("Available questions: \(chapterStore.questionBankManager.getQuestionsForChapter(chapter.number).count)")
                    
                    if let questions = chapterStore.questionBankManager.questionBank {
                        print("Total questions in bank: \(questions.count)")
                        
                        // Group questions by chapter for debugging
                        let groupedQuestions = Dictionary(grouping: questions, by: { $0.chapterNumber })
                        for (chapterNum, chapterQuestions) in groupedQuestions.sorted(by: { $0.key < $1.key }) {
                            print("Chapter \(chapterNum): \(chapterQuestions.count) questions")
                        }
                    }
                }) {
                    Text("Debug Question Bank")
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showingExitAlert = true }) {
                        HStack(spacing: 4) {
                            Image(systemName: "xmark.circle.fill")
                            Text("Exit")
                        }
                        .foregroundColor(.red)
                    }
                }
            }
        } else if showingResults {
            QuizResultView(quizSession: quizSession, chapter: chapter)
        } else {
            VStack(spacing: 24) {
                // Updated Progress indicator
                ProgressView(value: progress)
                    .padding(.horizontal)
                
                Text("Question \(currentQuestionIndex + 1) of \(quizSession.questions.count)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // Add safety check for questions array
                if !quizSession.questions.isEmpty && currentQuestionIndex < quizSession.questions.count {
                    let question = quizSession.questions[currentQuestionIndex]
                    
                    // Question
                    Text(question.question)
                        .font(.title3)
                        .padding()
                        .multilineTextAlignment(.leading)
                    
                    // Answer options
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(0..<question.options.count, id: \.self) { index in
                            Button(action: {
                                selectAnswer(index)
                            }) {
                                HStack {
                                    Text("\(["A", "B", "C", "D"][index]). \(question.options[index])")
                                        .foregroundColor(.primary)
                                        .multilineTextAlignment(.leading)
                                    
                                    Spacer()
                                    
                                    if showFeedback && question.selectedAnswerIndex == index {
                                        Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                            .foregroundColor(isCorrect ? .green : .red)
                                    }
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(question.selectedAnswerIndex == index ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                            )
                            .disabled(showFeedback)
                        }
                        
                        if showFeedback {
                            VStack(alignment: .leading, spacing: 10) {
                                Text(isCorrect ? "Correct!" : "Wrong! The correct answer is \(["A", "B", "C", "D"][question.correctAnswerIndex]).")
                                    .font(.headline)
                                    .foregroundColor(isCorrect ? .green : .red)
                                    .padding(.top)
                                
                                Text("Explanation: \(question.explanation)")
                                    .font(.subheadline)
                                    .padding(.top, 5)
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
                            .padding(.vertical)
                        }
                    }
                } else {
                    // Fallback view if no questions are available
                    Text("No questions available")
                        .font(.title2)
                        .foregroundColor(.secondary)
                        .padding()
                }
                
                Spacer()
                
                // Navigation buttons with safety checks
                HStack {
                    if currentQuestionIndex > 0 {
                        NavigationButton(
                            title: "Previous",
                            icon: "chevron.left",
                            action: { 
                                withAnimation {
                                    currentQuestionIndex = max(currentQuestionIndex - 1, 0)
                                    // Update feedback state based on whether the previous question was answered
                                    if let question = getCurrentQuestion() {
                                        showFeedback = question.selectedAnswerIndex != nil
                                        if showFeedback {
                                            isCorrect = question.selectedAnswerIndex == question.correctAnswerIndex
                                        }
                                    }
                                }
                            }
                        )
                    }
                    
                    Spacer()
                    
                    if currentQuestionIndex < quizSession.questions.count - 1 {
                        NavigationButton(
                            title: "Next",
                            icon: "chevron.right",
                            isProminent: true,
                            action: { 
                                moveToNextQuestion()
                            }
                        )
                        .disabled(getCurrentQuestion()?.selectedAnswerIndex == nil)
                    } else {
                        NavigationButton(
                            title: "Finish",
                            icon: "checkmark",
                            isProminent: true,
                            action: finishQuiz
                        )
                        .disabled(getCurrentQuestion()?.selectedAnswerIndex == nil)
                    }
                }
                .padding()
            }
            .padding()
            .navigationTitle("Chapter \(chapter.number) Quiz")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showingExitAlert = true }) {
                        HStack(spacing: 4) {
                            Image(systemName: "xmark.circle.fill")
                            Text("Exit")
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .alert("Exit Quiz?", isPresented: $showingExitAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Exit", role: .destructive) {
                    presentationMode.wrappedValue.dismiss()
                }
            } message: {
                Text("Your progress in this quiz will be lost. Are you sure you want to exit?")
            }
        }
    }
    
    private func selectAnswer(_ index: Int) {
        guard currentQuestionIndex < quizSession.questions.count else { return }
        
        var updatedQuizSession = quizSession
        updatedQuizSession.questions[currentQuestionIndex].selectedAnswerIndex = index
        quizSession = updatedQuizSession
        
        // Check if answer is correct and update accordingly
        isCorrect = (index == quizSession.questions[currentQuestionIndex].correctAnswerIndex)
        
        // Update score if correct
        if isCorrect {
            quizSession.score += 1
        }
        
        // Show feedback
        showFeedback = true
    }
    
    private func moveToNextQuestion() {
        // Only proceed if an answer has been selected
        guard let currentQuestion = getCurrentQuestion(),
              currentQuestion.selectedAnswerIndex != nil else {
            return
        }
        
        showFeedback = false
        if currentQuestionIndex < quizSession.questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            quizSession.completed = true
            showingResults = true
        }
    }
    
    private func getCurrentQuestion() -> QuizQuestionBank.QuizQuestion? {
        guard !quizSession.questions.isEmpty && currentQuestionIndex < quizSession.questions.count else {
            return nil
        }
        return quizSession.questions[currentQuestionIndex]
    }
    
    private func finishQuiz() {
        var updatedQuizSession = quizSession
        updatedQuizSession.score = updatedQuizSession.questions.filter { 
            $0.selectedAnswerIndex == $0.correctAnswerIndex 
        }.count
        updatedQuizSession.completed = true
        quizSession = updatedQuizSession
        
        withAnimation {
            chapterStore.saveQuiz(quizSession)
            showingResults = true
        }
    }
}

// Renamed from AnswerOptionButton to AnswerOptionView
struct AnswerOptionView: View {
    let text: String
    let index: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Text(String(format: "%c", index + 65))
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : .accentColor)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(isSelected ? Color.accentColor : Color.accentColor.opacity(0.1))
                    )
                
                Text(text)
                    .font(.body)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.accentColor)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.accentColor.opacity(0.1) : Color.secondary.opacity(0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct NavigationButton: View {
    let title: String
    let icon: String
    var isProminent: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if !isProminent {
                    Image(systemName: icon)
                }
                Text(title)
                if isProminent {
                    Image(systemName: icon)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(isProminent ? Color.accentColor : Color.secondary.opacity(0.1))
            .foregroundColor(isProminent ? .white : .primary)
            .cornerRadius(10)
        }
    }
}