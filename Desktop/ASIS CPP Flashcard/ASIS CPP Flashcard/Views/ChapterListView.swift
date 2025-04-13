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
                                Spacer()
                            }
                            
                            // Progress section
                            VStack(alignment: .leading, spacing: 8) {
                                ProgressView(value: chapter.progressPercentage, total: 100)
                                    .tint(.green)
                                
                                HStack {
                                    Text("\(max(0, min(100, Int(chapter.progressPercentage))))% Complete")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    Spacer()
                                    
                                    Text("\(chapter.flashcards.filter { $0.isReviewed }.count)/\(chapter.flashcards.count) Cards")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        .contentShape(Rectangle())  // Makes entire card tappable
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
        .navigationTitle("ASIS CPP Flashcards")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { chapterStore.resetAllProgress() }) {
                    Image(systemName: "arrow.counterclockwise")
                }
                
            }
        }
    }
} 
