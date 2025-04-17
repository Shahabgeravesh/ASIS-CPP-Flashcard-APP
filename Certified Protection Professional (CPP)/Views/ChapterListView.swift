struct ChapterListView: View {
    @ObservedObject var chapterStore: ChapterStore
    
    var body: some View {
        List {
            ForEach(chapterStore.chapters.indices, id: \.self) { index in
                let chapter = chapterStore.chapters[index]
                NavigationLink(
                    destination: ChapterView(
                        chapter: chapter,
                        chapterIndex: index,
                        chapterStore: chapterStore
                    )
                ) {
                    ChapterRowView(chapter: chapter)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("CPP Exam Prep")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct ChapterRowView: View {
    let chapter: Chapter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Chapter \(chapter.number): \(chapter.title)")
                .font(.headline)
            
            ProgressView(value: chapter.progressPercentage, total: 100)
                .tint(.green)
            
            HStack {
                Text("\(Int(chapter.progressPercentage))% Complete")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(chapter.flashcards.filter { $0.isReviewed }.count)/\(chapter.flashcards.count)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
} 