import SwiftUI

struct CustomToolPalette: View {
    @Bindable var tool: CustomDrawingTool
    @State private var showColorPicker = false
    @State private var showAdvancedSettings = false
    @Binding var isUsingPencil: Bool

    var body: some View {
        VStack(spacing: 12) {
            InputModeIndicator(isUsingPencil: isUsingPencil)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(ToolType.allCases, id: \.self) { toolType in
                        ToolButton(
                            toolType: toolType,
                            isSelected: tool.type == toolType,
                            action: { tool.type = toolType }
                        )
                    }
                }
                .padding(.horizontal)
            }

            Divider()

            HStack(spacing: 16) {
                Button(action: { showColorPicker.toggle() }) {
                    Circle()
                        .fill(tool.color)
                        .frame(width: 32, height: 32)
                        .overlay(Circle().stroke(Color.primary.opacity(0.2), lineWidth: 1))
                }

                VStack {
                    Text("Size: \(Int(tool.width))pt")
                        .font(.caption)
                    Slider(value: $tool.width, in: 1...50)
                        .frame(width: 120)
                }

                VStack {
                    Text("Opacity: \(Int(tool.opacity * 100))%")
                        .font(.caption)
                    Slider(value: $tool.opacity, in: 0...1)
                        .frame(width: 120)
                }

                Button(action: { showAdvancedSettings.toggle() }) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.title2)
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 12)
        .background(.regularMaterial)
        .cornerRadius(16)
        .shadow(radius: 8)
        .sheet(isPresented: $showColorPicker) {
            ColorPickerSheet(selectedColor: $tool.color)
        }
        .sheet(isPresented: $showAdvancedSettings) {
            AdvancedToolSettings(tool: tool)
        }
    }
}
