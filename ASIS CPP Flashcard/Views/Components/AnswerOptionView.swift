import SwiftUI

struct AnswerOptionView: View {
    let text: String
    let isSelected: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            Text(text)
                .font(.body)
                .foregroundStyle(Color(.label))
                .multilineTextAlignment(.leading)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(Color(.systemBlue))
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    isSelected ?
                    Color(.systemBlue).opacity(0.1) :
                    Color(.systemBackground)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(
                    isSelected ?
                    LinearGradient(
                        colors: [
                            Color(.systemBlue).opacity(0.5),
                            Color(.systemBlue).opacity(0.5)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ) :
                    LinearGradient(
                        colors: [
                            Color(.systemBlue).opacity(0.1),
                            Color(.systemBlue).opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: isSelected ? 2 : 1
                )
        )
    }
} 