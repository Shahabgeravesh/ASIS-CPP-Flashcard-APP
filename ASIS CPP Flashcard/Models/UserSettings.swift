import SwiftUI

class UserSettings: ObservableObject {
    static let shared = UserSettings()
    
    @AppStorage("isDarkMode") var isDarkMode = false {
        didSet {
            applyTheme()
        }
    }
    
    private init() {
        applyTheme()
    }
    
    private func applyTheme() {
        // Set the window's user interface style
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
            }
        }
    }
} 