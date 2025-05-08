import SwiftUI

struct ChapterListView: View {
    @ObservedObject var chapterStore: ChapterStore
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            LazyVStack(spacing: 16) {
                ForEach(chapterStore.chapters.indices, id: \.self) { index in
                    let chapter = chapterStore.chapters[index]
                    NavigationLink(
                        destination: ChapterView(
                            chapter: chapter,
                            chapterIndex: index,
                            chapterStore: chapterStore
                        )
                    ) {
                        VStack(alignment: .leading, spacing: 12) {
                            // Chapter title and progress button
                            HStack {
                                Text("Chapter \(chapter.number): \(chapter.title)")
                                    .font(.headline)
                                    .lineLimit(2)
                                    .foregroundColor(Color("4A6572"))
                                Spacer()
                            }
                            
                            // Progress section
                            VStack(alignment: .leading, spacing: 8) {
                                ProgressView(value: chapter.progressPercentage, total: 100)
                                    .tint(Color("5D7B89"))
                                
                                HStack {
                                    Text("\(max(0, min(100, Int(chapter.progressPercentage))))% Complete")
                                        .font(.caption)
                                        .foregroundColor(Color("6B8C9A"))
                                    
                                    Spacer()
                                    
                                    Text("\(chapter.flashcards.filter { $0.isReviewed }.count)/\(chapter.flashcards.count) Cards")
                                        .font(.caption)
                                        .foregroundColor(Color("6B8C9A"))
                                }
                            }
                        }
                        .padding()
                        .background(Color("F5F5F5"))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        .contentShape(Rectangle())  // Makes entire card tappable
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
        .background(Color("E3F2FD"))
        .navigationTitle("ASIS CPP Flashcards")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { chapterStore.resetAllProgress() }) {
                    Image(systemName: "arrow.counterclockwise")
                        .foregroundColor(Color("5D7B89"))
                }
            }
        }
    }
} 
