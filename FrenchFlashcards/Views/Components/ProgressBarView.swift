import SwiftUI

struct ProgressBarView: View {
    let value: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.gray.opacity(0.2))
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.green)
                    .frame(width: geometry.size.width * max(0, min(1, value)))
            }
        }
        .frame(height: 12)
    }
}

#Preview {
    ProgressBarView(value: 0.65)
        .padding()
}
