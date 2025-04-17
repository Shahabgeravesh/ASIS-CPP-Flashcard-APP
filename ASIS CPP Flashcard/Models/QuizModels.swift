import Foundation

// Update QuizQuestionBank to be an array instead of having chapters
struct QuizQuestionBank {
    struct QuizQuestion: Identifiable, Codable {
        let id: String
        let question: String
        let options: [String]
        let correctAnswerIndex: Int
        let explanation: String
        var selectedAnswerIndex: Int?
        
        enum CodingKeys: String, CodingKey {
            case id, question, options, correctAnswerIndex, explanation
        }
    }
}

// Keep QuizSession the same
struct QuizSession: Identifiable, Codable {
    let id: UUID
    let chapterNumber: Int
    var questions: [QuizQuestionBank.QuizQuestion]
    var score: Int
    var dateTaken: Date
    var completed: Bool
    
    init(chapterNumber: Int, questions: [QuizQuestionBank.QuizQuestion]) {
        self.id = UUID()
        self.chapterNumber = chapterNumber
        self.questions = questions
        self.score = 0
        self.dateTaken = Date()
        self.completed = false
    }
}