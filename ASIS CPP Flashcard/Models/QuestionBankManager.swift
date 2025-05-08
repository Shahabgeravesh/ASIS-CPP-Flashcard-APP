import Foundation

class QuestionBankManager: ObservableObject {
    @Published private(set) var questionBank: [Question]?
    private let jsonFileName = "quiz_questions"
    
    // Root JSON structure
    struct QuizData: Codable {
        let total_questions: Int
        let questions_by_domain: [String: Int]
        let questions: [Question]
    }
    
    struct Question: Codable {
        let number: Int
        let domain: String
        let question: String
        let options: [String: String]
        let correct_answer: String
        let explanation: String
        
        // Extract chapter number from domain (e.g. "Domain 1" -> 1)
        var chapterNumber: Int {
            if let domainNumberStr = domain.split(separator: " ").last,
               let domainNumber = Int(domainNumberStr) {
                return domainNumber
            }
            return 0
        }
        
        func toQuizQuestion() -> QuizQuestionBank.QuizQuestion {
            let sortedOptions = options.sorted { $0.key < $1.key }.map { $0.value }
            let correctIndex = Array(options.keys).sorted().firstIndex(of: correct_answer) ?? 0
            
            return QuizQuestionBank.QuizQuestion(
                id: "\(number)",
                question: question,
                options: sortedOptions,
                correctAnswerIndex: correctIndex,
                explanation: explanation
            )
        }
    }
    
    init() {
        loadQuestions()
        // Debug prints
        print("QuestionBank loaded: \(questionBank != nil)")
        print("Total questions loaded: \(questionBank?.count ?? 0)")
        
        // Group questions by chapter for debugging
        let groupedQuestions = Dictionary(grouping: questionBank ?? [], by: { $0.chapterNumber })
        for (chapter, questions) in groupedQuestions.sorted(by: { $0.key < $1.key }) {
            print("Chapter \(chapter): \(questions.count) questions")
        }
    }
    
    private func loadQuestions() {
        if let url = Bundle.main.url(forResource: jsonFileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let quizData = try JSONDecoder().decode(QuizData.self, from: data)
                questionBank = quizData.questions
            } catch {
                print("Error loading questions: \(error)")
                if let data = try? Data(contentsOf: url),
                   let jsonString = String(data: data, encoding: .utf8)?.prefix(1000) {
                    print("JSON content preview: \(jsonString)...")
                }
            }
        } else {
            print("Could not find \(jsonFileName).json in bundle")
        }
    }
    
    func getQuestionsForChapter(_ chapterNumber: Int) -> [QuizQuestionBank.QuizQuestion] {
        let chapterQuestions = questionBank?
            .filter { $0.chapterNumber == chapterNumber }
            .map { $0.toQuizQuestion() } ?? []
        print("Found \(chapterQuestions.count) questions for chapter \(chapterNumber)")
        return chapterQuestions
    }
    
    func generateQuiz(for chapterNumber: Int, numberOfQuestions: Int = 50) -> QuizSession {
        print("Generating quiz for chapter \(chapterNumber)")
        let allQuestions = getQuestionsForChapter(chapterNumber)
        let numberOfQuestionsToUse = min(numberOfQuestions, allQuestions.count)
        let selectedQuestions = Array(allQuestions.shuffled().prefix(numberOfQuestionsToUse))
        print("Generated quiz with \(selectedQuestions.count) questions")
        return QuizSession(chapterNumber: chapterNumber, questions: selectedQuestions)
    }
}

extension JSONDecoder {
    func decode<T>(_ type: T.Type, from jsonObject: Any) throws -> T where T: Decodable {
        let data = try JSONSerialization.data(withJSONObject: jsonObject)
        return try decode(type, from: data)
    }
} 