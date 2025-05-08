import SwiftUI

struct ChapterProgressView: View {
    let chapter: Chapter
    let chapterIndex: Int
    @ObservedObject var chapterStore: ChapterStore
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        List {
            Section(header: Text("Overall Progress").foregroundStyle(Color(.label))) {
                HStack {
                    Text("Mastered")
                        .foregroundStyle(Color(.label))
                    Spacer()
                    Text("\(Int(chapter.progressPercentage))%")
                        .foregroundStyle(Color(.secondaryLabel))
                }
                
                ProgressView(value: chapter.progressPercentage, total: 100)
                    .tint(Color(.systemBlue))
            }
            
            Section(header: Text("Cards Status").foregroundStyle(Color(.label))) {
                ForEach(chapter.flashcards.indices, id: \.self) { index in
                    let card = chapter.flashcards[index]
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Card \(index + 1)")
                                .font(.headline)
                                .foregroundStyle(Color(.label))
                            Text(card.question)
                                .font(.subheadline)
                                .foregroundStyle(Color(.secondaryLabel))
                                .lineLimit(2)
                        }
                        
                        Spacer()
                        
                        Image(systemName: card.isMastered ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(card.isMastered ? Color(.systemGreen) : Color(.secondaryLabel))
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .background(Color(.systemBackground))
        .navigationTitle("Chapter Progress")
        .navigationBarTitleDisplayMode(.inline)
    }
} 