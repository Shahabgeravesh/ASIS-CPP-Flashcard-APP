import SwiftUI

struct QuizResultView: View {
    let quiz: Quiz
    let chapter: Chapter
    @Environment(\.dismiss) private var dismiss
    
    var percentageScore: Double {
        Double(quiz.score) / Double(Quiz.questionsPerQuiz) * 100
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Score circle
                ZStack {
                    Circle()
                        .stroke(Color.secondary.opacity(0.2), lineWidth: 20)
                        .frame(width: 200, height: 200)
                    
                    Circle()
                        .trim(from: 0, to: percentageScore / 100)
                        .stroke(scoreColor, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                        .frame(width: 200, height: 200)
                        .rotationEffect(.degrees(-90))
                    
                    VStack {
                        Text("\(quiz.score)")
                            .font(.system(size: 50, weight: .bold))
                        Text("out of \(Quiz.questionsPerQuiz)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                
                // Performance summary
                VStack(spacing: 16) {
                    Text(performanceMessage)
                        .font(.title2)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                    
                    Text("\(Int(percentageScore))%")
                        .font(.title)
                        .foregroundColor(scoreColor)
                }
                
                // Question review
                QuestionReviewSection(questions: quiz.questions)
                
                // Add exit button at the bottom
                Button(action: { dismiss() }) {
                    HStack(spacing: 8) {
                        Image(systemName: "xmark.circle.fill")
                        Text("Exit Quiz")
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.red.opacity(0.1))
                    .foregroundColor(.red)
                    .cornerRadius(10)
                }
                .padding(.top, 20)
            }
            .padding()
        }
        .navigationTitle("Quiz Results")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "xmark.circle.fill")
                        Text("Exit")
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
    
    private var scoreColor: Color {
        switch percentageScore {
        case 90...100: return .green
        case 70..<90: return .blue
        case 50..<70: return .orange
        default: return .red
        }
    }
    
    private var performanceMessage: String {
        switch percentageScore {
        case 90...100: return "Excellent! You've mastered this chapter!"
        case 70..<90: return "Good job! You're on the right track."
        case 50..<70: return "Keep practicing! You're getting there."
        default: return "More review needed. Don't give up!"
        }
    }
}

struct QuestionReviewSection: View {
    let questions: [QuizQuestion]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Question Review")
                .font(.headline)
                .padding(.top)
            
            ForEach(questions.indices, id: \.self) { index in
                let question = questions[index]
                VStack(alignment: .leading, spacing: 8) {
                    Text("Question \(index + 1)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(question.question)
                        .font(.body)
                    
                    if let selected = question.selectedAnswer {
                        HStack {
                            Text("Your answer: ")
                            Text(question.options[selected])
                                .foregroundColor(question.isCorrect ? .green : .red)
                        }
                        
                        if !question.isCorrect {
                            HStack {
                                Text("Correct answer: ")
                                Text(question.options[question.correctAnswer])
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(10)
            }
        }
    }
} 