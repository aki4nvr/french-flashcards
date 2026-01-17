import SwiftUI

struct ProgressBarView: View {
    let progress: Double // 0.0 to 1.0
    var showPercentage: Bool = true
    var height: CGFloat = 12
    var backgroundColor: Color = Color(.systemGray5)
    var foregroundColor: Color = .green

    var body: some View {
        VStack(spacing: 4) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(backgroundColor)
                        .cornerRadius(height / 2)

                    Rectangle()
                        .fill(foregroundColor)
                        .cornerRadius(height / 2)
                        .frame(width: geometry.size.width * min(max(progress, 0), 1))
                        .animation(.easeInOut(duration: 0.3), value: progress)
                }
            }
            .frame(height: height)

            if showPercentage {
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        ProgressBarView(progress: 0.7)
        ProgressBarView(progress: 0.3, foregroundColor: .orange)
        ProgressBarView(progress: 1.0, foregroundColor: .blue)
    }
    .padding()
}
