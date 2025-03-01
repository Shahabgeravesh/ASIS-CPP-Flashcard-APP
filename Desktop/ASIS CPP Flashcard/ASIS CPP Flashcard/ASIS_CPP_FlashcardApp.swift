//
//  ASIS_CPP_FlashcardApp.swift
//  ASIS CPP Flashcard
//
//  Created by Shahab Geravesh on 1/22/25.
//

import SwiftUI

@main
struct ASIS_CPP_FlashcardApp: App {
    @StateObject private var settings = UserSettings.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(settings.isDarkMode ? .dark : .light)
                .navigationViewStyle(.stack)
        }
    }
}
