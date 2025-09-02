import SwiftUI

struct InputModeIndicator: View {
    let isUsingPencil: Bool

    var body: some View {
        HStack {
            Image(systemName: isUsingPencil ? "applepencil" : "hand.draw")
                .font(.caption)
            Text(isUsingPencil ? "Apple Pencil" : "Touch")
                .font(.caption)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(isUsingPencil ? Color.blue.opacity(0.2) : Color.orange.opacity(0.2))
        .cornerRadius(12)
        .animation(.easeInOut(duration: 0.3), value: isUsingPencil)
    }
}
