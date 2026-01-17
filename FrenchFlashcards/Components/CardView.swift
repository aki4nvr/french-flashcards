import SwiftUI

struct CardView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    CardView {
        VStack(alignment: .leading) {
            Text("Sample Card")
                .font(.headline)
            Text("This is some content inside the card")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    .padding()
}
