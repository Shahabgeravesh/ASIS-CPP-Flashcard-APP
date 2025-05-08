import SwiftUI

struct ChapterListView: View {
    @ObservedObject var chapterStore: ChapterStore
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            LazyVStack(spacing: 24) {
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
                            // Chapter title and progress button
                            HStack(alignment: .center) {
                                Text("Chapter \(chapter.number): \(chapter.title)")
                                    .font(.system(size: 22, weight: .bold, design: .rounded))
                                    .lineLimit(2)
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [
                                                colorScheme == .dark ? Color("4FC3F7") : Color("4A6572"),
                                                colorScheme == .dark ? Color("81D4FA") : Color("5D7B89")
                                            ],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .minimumScaleFactor(0.8)
                                Spacer()
                            }
                            .frame(minHeight: 44)
                            
                            // Progress section
                            VStack(alignment: .leading, spacing: 16) {
                                // Progress view
                                ProgressView(value: chapter.progressPercentage, total: 100)
                                    .tint(colorScheme == .dark ? Color("4FC3F7") : Color("4FC3F7"))
                                    .scaleEffect(x: 1, y: 1.5, anchor: .center)
                                
                                HStack(alignment: .center) {
                                    Text("\(max(0, min(100, Int(chapter.progressPercentage))))% Complete")
                                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                                        .foregroundColor(colorScheme == .dark ? Color("4FC3F7") : Color("4A6572"))
                                    
                                    Spacer()
                                    
                                    Text("\(chapter.flashcards.filter { $0.isReviewed }.count)/\(chapter.flashcards.count) Cards")
                                        .font(.system(size: 15, weight: .medium, design: .rounded))
                                        .foregroundColor(colorScheme == .dark ? Color("81D4FA") : Color("6B8C9A"))
                                }
                                .frame(minHeight: 44)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(colorScheme == .dark ? Color("1A1A1A") : Color("F5F5F5"))
                                .shadow(
                                    color: colorScheme == .dark ? Color.black.opacity(0.3) : Color.black.opacity(0.08),
                                    radius: 8,
                                    x: 0,
                                    y: 4
                                )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            colorScheme == .dark ? Color("4FC3F7").opacity(0.3) : Color("4FC3F7").opacity(0.3),
                                            colorScheme == .dark ? Color("81D4FA").opacity(0.1) : Color("81D4FA").opacity(0.1)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
        }
        .background(
            LinearGradient(
                colors: [
                    colorScheme == .dark ? Color("1A1A1A") : Color("E3F2FD"),
                    colorScheme == .dark ? Color("2A2A2A") : Color("BBDEFB")
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationTitle("ASIS CPP Flashcards")
        .navigationBarTitleDisplayMode(.large)
    }
} 
