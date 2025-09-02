import SwiftUI

struct ToolButton: View {
    let toolType: ToolType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: iconName)
                    .font(.title2)
                Text(toolType.rawValue)
                    .font(.caption)
            }
            .frame(width: 60, height: 60)
            .background(isSelected ? Color.accentColor.opacity(0.2) : Color.clear)
            .cornerRadius(8)
        }
    }

    var iconName: String {
        switch toolType {
        case .pen: return "pencil.tip"
        case .pencil: return "pencil"
        case .marker: return "highlighter"
        case .highlighter: return "pencil.tip.crop.circle"
        case .eraser: return "eraser"
        case .blurEraser: return "drop.circle"
        case .pixelateEraser: return "square.grid.3x3"
        case .customBrush: return "paintbrush"
        }
    }
}
