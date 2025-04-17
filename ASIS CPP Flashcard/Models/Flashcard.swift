import Foundation

struct Flashcard: Identifiable, Codable {
    let id = UUID()
    let question: String
    let answer: String
    var isReviewed: Bool = false
    var isMastered: Bool = false
    var lastReviewDate: Date?
    var attemptCount: Int = 0
    var isFavorite: Bool = false
    
    // Required for Codable when we have a stored property with a default value
    enum CodingKeys: String, CodingKey {
        case id, question, answer, isReviewed, isMastered, lastReviewDate, attemptCount, isFavorite
    }
} 