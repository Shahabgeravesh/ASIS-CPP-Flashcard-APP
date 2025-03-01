import Foundation

struct StudyStats: Codable {
    var totalCardsReviewed: Int
    var studyStreak: Int
    var lastStudyDate: Date?
    var timeSpentStudying: TimeInterval
    
    static let saveKey = "StudyStats"
    
    static func load() -> StudyStats {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let stats = try? JSONDecoder().decode(StudyStats.self, from: data) {
            return stats
        }
        return StudyStats(totalCardsReviewed: 0, studyStreak: 0, lastStudyDate: nil, timeSpentStudying: 0)
    }
    
    func save() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: StudyStats.saveKey)
        }
    }
} 