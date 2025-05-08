import SwiftUI

struct ChapterProgressView: View {
    let chapter: Chapter
    let chapterIndex: Int
    @ObservedObject var chapterStore: ChapterStore
    
    var body: some View {
        List {
            Section(header: Text("Overall Progress")) {
                HStack {
                    Text("Mastered")
                    Spacer()
                    Text("\(Int(chapter.progressPercentage))%")
                        .foregroundColor(.green)
                }
                
                ProgressView(value: chapter.progressPercentage, total: 100)
                    .tint(.green)
            }
            
            Section(header: Text("Cards Status")) {
                ForEach(chapter.flashcards.indices, id: \.self) { index in
                    let card = chapter.flashcards[index]
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Card \(index + 1)")
                                .font(.headline)
                            Text(card.question)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                        }
                        
                        Spacer()
                        
                        Image(systemName: card.isMastered ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(card.isMastered ? .green : .gray)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Chapter Progress")
        .navigationBarTitleDisplayMode(.inline)
    }
} 