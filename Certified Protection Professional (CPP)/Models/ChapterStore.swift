import Foundation
import SwiftUI

class ChapterStore: ObservableObject {
    static let appVersion = "1.0.0"
    static let legalDisclaimer = """
        This app is an unofficial study aid for the Certified Protection Professional (CPP) certification. 
        CPP® is a registered certification mark. All content is intended for self-study purposes only.
        """
    
    static let attribution = """
        Content is based on publicly available Certified Protection Professional (CPP) certification materials. 
        This is a study aid created by independent developers to help certification candidates.
        """
    
    // App information
    static let appName = "Certified Protection Professional (CPP)"
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
} 