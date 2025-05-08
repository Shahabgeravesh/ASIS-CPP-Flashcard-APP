import SwiftUI

struct QuizResultView: View {
    let quizSession: QuizSession
    let chapter: Chapter
    @Environment(\.dismiss) private var dismiss
    
    var percentageScore: Double {
        Double(quizSession.score) / Double(quizSession.questions.count) * 100
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
                        Text("\(quizSession.score)")
                            .font(.system(size: 50, weight: .bold))
                        Text("out of \(quizSession.questions.count)")
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
                QuestionReviewSection(questions: quizSession.questions)
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
    let questions: [QuizQuestionBank.QuizQuestion]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Question Review")
                .font(.headline)
                .foregroundStyle(Color(.label))
                .padding(.top)
            
            ForEach(questions.indices, id: \.self) { index in
                let question = questions[index]
                VStack(alignment: .leading, spacing: 8) {
                    Text("Question \(index + 1)")
                        .font(.subheadline)
                        .foregroundStyle(Color(.secondaryLabel))
                    
                    Text(question.question)
                        .font(.body)
                        .foregroundStyle(Color(.label))
                    
                    if let selected = question.selectedAnswerIndex {
                        HStack {
                            Text("Your answer: ")
                                .foregroundStyle(Color(.label))
                            Text(question.options[selected])
                                .foregroundStyle(selected == question.correctAnswerIndex ? Color(.systemGreen) : Color(.systemRed))
                        }
                        
                        if selected != question.correctAnswerIndex {
                            HStack {
                                Text("Correct answer: ")
                                    .foregroundStyle(Color(.label))
                                Text(question.options[question.correctAnswerIndex])
                                    .foregroundStyle(Color(.systemGreen))
                            }
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
        }
    }
} 