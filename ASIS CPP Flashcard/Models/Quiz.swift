import Foundation

struct Quiz: Identifiable, Codable {
    var id: UUID
    let chapterNumber: Int
    var questions: [QuizQuestion]
    var score: Int
    var dateTaken: Date
    var completed: Bool
    
    static let questionsPerQuiz = 50
    
    init(chapterNumber: Int, questions: [QuizQuestion]) {
        self.id = UUID()
        self.chapterNumber = chapterNumber
        self.questions = questions
        self.score = 0
        self.dateTaken = Date()
        self.completed = false
    }
}

struct QuizQuestion: Identifiable, Codable {
    var id: UUID
    let question: String
    let options: [String]
    let correctAnswer: Int
    var selectedAnswer: Int?
    
    var isCorrect: Bool {
        selectedAnswer == correctAnswer
    }
    
    init(question: String, options: [String], correctAnswer: Int) {
        self.id = UUID()
        self.question = question
        self.options = options
        self.correctAnswer = correctAnswer
        self.selectedAnswer = nil
    }
} 