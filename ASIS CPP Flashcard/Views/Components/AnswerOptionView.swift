import SwiftUI

struct AnswerOptionView: View {
    let text: String
    let isSelected: Bool
    
    var body: some View {
        HStack {
            Text(text)
                .font(.body)
                .foregroundColor(Color("4A6572"))
                .multilineTextAlignment(.leading)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color("4FC3F7"), Color("81D4FA")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    isSelected ?
                    LinearGradient(
                        colors: [
                            Color("4FC3F7").opacity(0.1),
                            Color("81D4FA").opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ) :
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.9),
                            Color("F5F5F5")
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(
                    isSelected ?
                    LinearGradient(
                        colors: [
                            Color("4FC3F7").opacity(0.5),
                            Color("81D4FA").opacity(0.5)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ) :
                    LinearGradient(
                        colors: [
                            Color("4FC3F7").opacity(0.1),
                            Color("81D4FA").opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: isSelected ? 2 : 1
                )
        )
    }
} 