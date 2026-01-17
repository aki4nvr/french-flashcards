import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    var iconColor: Color = .blue

    var body: some View {
        CardView {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(iconColor)
                    .frame(width: 40)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(value)
                        .font(.title3)
                        .fontWeight(.bold)
                }

                Spacer()
            }
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        StatCard(title: "Total Words", value: "42", icon: "book.fill", iconColor: .blue)
        StatCard(title: "Sessions", value: "15", icon: "chart.bar.fill", iconColor: .green)
        StatCard(title: "Last Score", value: "85%", icon: "star.fill", iconColor: .orange)
    }
    .padding()
}
