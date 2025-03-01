import Foundation

struct AppMetadata {
    static let appName = "ASIS CPP Flashcards"
    static let appDescription = "Study flashcards for ASIS CPP certification exam preparation"
    
    static let features = [
        "Practice with professionally curated flashcards",
        "Track your progress across chapters",
        "Study at your own pace",
        "Mark cards for review",
        "Dark mode support"
    ]
    
    static let privacyFeatures = [
        "No account required",
        "All data stored locally",
        "No internet connection needed",
        "No data collection",
        "Complete privacy"
    ]
    
    static let developerInfo = """
        Developed by [Your Name/Company]
        For support: [Your Support Email]
        """
    
    static func generatePrivacyPolicy() -> String {
        """
        Privacy Policy for ASIS CPP Flashcards
        
        1. Data Collection
        This app does not collect any personal information.
        All study progress is stored locally on your device.
        
        2. Data Usage
        Your study progress is used only within the app to track your learning.
        
        3. Data Storage
        All data is stored locally on your device.
        No data is transmitted to external servers.
        
        4. Third-Party Access
        No data is shared with third parties.
        
        5. Contact
        For privacy concerns, contact: [Your Privacy Email]
        """
    }
    
    static func generateTermsOfUse() -> String {
        """
        Terms of Use for ASIS CPP Flashcards
        
        1. Acceptance of Terms
        By using this app, you agree to these terms.
        
        2. App Purpose
        This is an unofficial study aid for ASIS CPP exam preparation.
        
        3. Intellectual Property
        ASIS CPP® is a registered trademark of ASIS International.
        This app is not affiliated with ASIS International.
        
        4. Disclaimer
        This app does not guarantee exam success.
        Use as a supplementary study aid only.
        
        5. Updates
        Terms may be updated. Check regularly for changes.
        
        6. Contact
        For questions: [Your Support Email]
        """
    }
} 