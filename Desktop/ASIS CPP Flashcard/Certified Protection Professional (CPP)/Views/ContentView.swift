.navigationTitle("CPP Exam Prep") 

struct ContentView: View {
    @StateObject private var chapterStore = ChapterStore()
    @StateObject private var themeManager = ThemeManager()
    
    var body: some View {
        TabView {
            NavigationView {
                DashboardView(chapterStore: chapterStore)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Label("Dashboard", systemImage: "chart.bar.fill")
            }
            
            NavigationView {
                ChapterListView(chapterStore: chapterStore)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Label("Chapters", systemImage: "book.fill")
            }
            
            NavigationView {
                SettingsView(chapterStore: chapterStore)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
        .onAppear {
            themeManager.applyTheme()
        }
    }
} 