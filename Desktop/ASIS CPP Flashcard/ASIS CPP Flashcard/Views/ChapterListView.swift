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
                        VStack(alignment: .leading, spacing: 16) {
                            // Chapter title and number
                            HStack(alignment: .center) {
                                Text("Chapter \(chapter.number)")
                                    .font(AppTheme.captionFont)
                                    .foregroundColor(AppTheme.secondary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(AppTheme.secondary.opacity(0.1))
                                    .cornerRadius(8)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(AppTheme.secondary)
                                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                            }
                            
                            Text(chapter.title)
                                .font(AppTheme.headlineFont)
                                .foregroundColor(.primary)
                                .lineLimit(2)
                            
                            // Progress section
                            VStack(alignment: .leading, spacing: 12) {
                                ProgressView(value: chapter.progressPercentage, total: 100)
                                    .tint(AppTheme.success)
                                    .scaleEffect(x: 1, y: 1.5, anchor: .center)
                                
                                HStack {
                                    HStack(spacing: 4) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(AppTheme.success)
                                        Text("\(max(0, min(100, Int(chapter.progressPercentage))))%")
                                            .font(AppTheme.captionFont)
                                            .foregroundColor(AppTheme.success)
                                    }
                                    
                                    Spacer()
                                    
                                    HStack(spacing: 4) {
                                        Image(systemName: "cards.fill")
                                            .foregroundColor(AppTheme.secondary)
                                        Text("\(chapter.flashcards.filter { !$0.isMastered }.count)/\(chapter.flashcards.count)")
                                            .font(AppTheme.captionFont)
                                            .foregroundColor(AppTheme.secondary)
                                    }
                                }
                            }
                        }
                        .padding(AppTheme.cardPadding)
                        .background(AppTheme.cardBackground)
                        .cornerRadius(AppTheme.cardCornerRadius)
                        .shadow(color: AppTheme.cardShadow, radius: 8, x: 0, y: 2)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
        .navigationTitle("Chapters")
        .navigationBarTitleDisplayMode(.large)
    }
} 
