import Foundation

struct Chapter: Identifiable, Codable {
    let id = UUID()
    let title: String
    let number: Int
    var flashcards: [Flashcard]
    
    var progressPercentage: Double {
        let masteredCount = flashcards.filter { $0.isMastered }.count
        return Double(masteredCount) / Double(flashcards.count) * 100
    }
    
    // Required for Codable when we have a stored property with a default value
    enum CodingKeys: String, CodingKey {
        case id, title, number, flashcards
    }
} 