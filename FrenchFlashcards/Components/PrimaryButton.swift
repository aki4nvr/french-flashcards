import SwiftUI

enum ButtonVariant {
    case primary
    case secondary
    case danger

    var backgroundColor: Color {
        switch self {
        case .primary: return Color.green
        case .secondary: return Color(.systemGray5)
        case .danger: return Color.red
        }
    }

    var foregroundColor: Color {
        switch self {
        case .primary: return .white
        case .secondary: return .primary
        case .danger: return .white
        }
    }
}

struct PrimaryButton: View {
    let title: String
    var variant: ButtonVariant = .primary
    var isLoading: Bool = false
    var isDisabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: variant.foregroundColor))
                        .scaleEffect(0.8)
                }
                Text(title)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(isDisabled ? Color.gray : variant.backgroundColor)
            .foregroundColor(variant.foregroundColor)
            .cornerRadius(12)
        }
        .disabled(isDisabled || isLoading)
    }
}

#Preview {
    VStack(spacing: 16) {
        PrimaryButton(title: "Primary Button", variant: .primary) {}
        PrimaryButton(title: "Secondary Button", variant: .secondary) {}
        PrimaryButton(title: "Danger Button", variant: .danger) {}
        PrimaryButton(title: "Loading...", isLoading: true) {}
        PrimaryButton(title: "Disabled", isDisabled: true) {}
    }
    .padding()
}
