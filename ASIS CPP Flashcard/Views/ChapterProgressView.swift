import SwiftUI

struct ChapterProgressView: View {
    let chapter: Chapter
    let chapterIndex: Int
    @ObservedObject var chapterStore: ChapterStore
    
    var body: some View {
        List {
            Section(header: Text("Overall Progress").foregroundColor(Color("4A6572"))) {
                HStack {
                    Text("Mastered")
                        .foregroundColor(Color("4A6572"))
                    Spacer()
                    Text("\(Int(chapter.progressPercentage))%")
                        .foregroundColor(Color("5D7B89"))
                }
                
                ProgressView(value: chapter.progressPercentage, total: 100)
                    .tint(Color("5D7B89"))
            }
            
            Section(header: Text("Cards Status").foregroundColor(Color("4A6572"))) {
                ForEach(chapter.flashcards.indices, id: \.self) { index in
                    let card = chapter.flashcards[index]
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Card \(index + 1)")
                                .font(.headline)
                                .foregroundColor(Color("4A6572"))
                            Text(card.question)
                                .font(.subheadline)
                                .foregroundColor(Color("6B8C9A"))
                                .lineLimit(2)
                        }
                        
                        Spacer()
                        
                        Image(systemName: card.isMastered ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(card.isMastered ? Color("81C784") : Color("B0BEC5"))
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .background(Color("E3F2FD"))
        .navigationTitle("Chapter Progress")
        .navigationBarTitleDisplayMode(.inline)
    }
} 