import SwiftUI

struct QuizView: View {
    let chapter: Chapter
    @ObservedObject var chapterStore: ChapterStore
    @State private var quiz: Quiz
    @State private var currentQuestionIndex = 0
    @State private var showingResults = false
    @State private var showingExitAlert = false
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss
    
    init(chapter: Chapter, chapterStore: ChapterStore) {
        self.chapter = chapter
        self.chapterStore = chapterStore
        _quiz = State(initialValue: chapterStore.generateQuiz(for: chapter.number - 1))
    }
    
    var body: some View {
        if showingResults {
            QuizResultView(quiz: quiz, chapter: chapter)
        } else {
            VStack(spacing: 24) {
                // Header with progress
                VStack(spacing: 8) {
                    ProgressView(value: Double(currentQuestionIndex + 1), total: Double(Quiz.questionsPerQuiz))
                        .tint(.accentColor)
                    
                    HStack {
                        Text("Question \(currentQuestionIndex + 1) of \(Quiz.questionsPerQuiz)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("Chapter \(chapter.number)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Question card
                        let question = quiz.questions[currentQuestionIndex]
                        VStack(alignment: .leading, spacing: 16) {
                            Text(question.question)
                                .font(.title3)
                                .fontWeight(.medium)
                                .multilineTextAlignment(.leading)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.secondary.opacity(0.05))
                                .cornerRadius(12)
                        
                            // Answer options
                            VStack(spacing: 12) {
                                ForEach(question.options.indices, id: \.self) { index in
                                    AnswerOptionButton(
                                        text: question.options[index],
                                        index: index,
                                        isSelected: question.selectedAnswer == index,
                                        action: { selectAnswer(index) }
                                    )
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Navigation footer
                HStack(spacing: 20) {
                    if currentQuestionIndex > 0 {
                        NavigationButton(
                            title: "Previous",
                            icon: "chevron.left",
                            action: { currentQuestionIndex -= 1 }
                        )
                    }
                    
                    if currentQuestionIndex < Quiz.questionsPerQuiz - 1 {
                        NavigationButton(
                            title: "Next",
                            icon: "chevron.right",
                            isProminent: true,
                            action: { currentQuestionIndex += 1 }
                        )
                    } else {
                        NavigationButton(
                            title: "Finish Quiz",
                            icon: "checkmark",
                            isProminent: true,
                            action: finishQuiz
                        )
                    }
                }
                .padding()
                .background(
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .edgesIgnoringSafeArea(.bottom)
                )
            }
            .navigationTitle("Chapter Quiz")
            .navigationBarTitleDisplayMode(.inline)
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
                    dismiss()
                }
            } message: {
                Text("Your progress in this quiz will be lost. Are you sure you want to exit?")
            }
        }
    }
    
    private func selectAnswer(_ index: Int) {
        var updatedQuiz = quiz
        updatedQuiz.questions[currentQuestionIndex].selectedAnswer = index
        quiz = updatedQuiz
    }
    
    private func finishQuiz() {
        var updatedQuiz = quiz
        updatedQuiz.score = updatedQuiz.questions.filter { $0.isCorrect }.count
        updatedQuiz.completed = true
        quiz = updatedQuiz
        chapterStore.saveQuiz(quiz)
        showingResults = true
    }
}

// New components for enhanced design
struct AnswerOptionButton: View {
    let text: String
    let index: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Text(String(format: "%c", index + 65)) // Converts 0->A, 1->B, etc.
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