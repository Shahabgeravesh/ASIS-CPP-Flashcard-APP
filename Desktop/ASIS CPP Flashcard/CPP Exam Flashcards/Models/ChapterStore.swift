import Foundation
import SwiftUI

class ChapterStore: ObservableObject {
    static let appVersion = "1.0.0"
    static let legalDisclaimer = """
        This app is an unofficial study aid for the Certified Protection Professional (CPP) certification. 
        CPP® is a registered certification mark. All content is intended for self-study purposes only.
        """
    
    static let attribution = """
        Content is based on publicly available CPP certification materials. 
        This is a study aid created by independent developers to help certification candidates.
        """
    
    // Update app information
    static let supportEmail = "support@yourdomain.com"
    static let privacyPolicyURL = "https://yourdomain.com/privacy"
    static let termsOfUseURL = "https://yourdomain.com/terms"
    
    static let dataPrivacyInfo = """
        This app stores all data locally on your device. 
        No personal information is collected or transmitted.
        """
    
    @Published var chapters: [Chapter]
    private let saveKey = "ChapterProgress"
    
    init() {
        self.chapters = ChapterStore.defaultChapters()
        loadProgress()
    }
    
    // Would you like me to continue with the rest of the file, including:
    // 1. All the chapter data
    // 2. Progress tracking methods
    // 3. Data persistence methods
    // 4. Design constants
} 