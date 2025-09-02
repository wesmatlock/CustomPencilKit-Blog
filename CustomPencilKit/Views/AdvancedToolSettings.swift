import SwiftUI

struct AdvancedToolSettings: View {
    @Bindable var tool: CustomDrawingTool
    @State private var selectedTexture: String = "texture_pencil"
    @State private var pressureCurve: [CGPoint] = []
    @Environment(\.dismiss) private var dismiss

    let availableTextures = [
        "texture_pencil": "Pencil",
        "texture_chalk": "Chalk",
        "texture_watercolor": "Watercolor",
        "texture_oil": "Oil Paint",
        "texture_spray": "Spray Paint"
    ]

    let blendModes: [(CGBlendMode, String)] = [
        (.normal, "Normal"),
        (.multiply, "Multiply"),
        (.screen, "Screen"),
        (.overlay, "Overlay"),
        (.softLight, "Soft Light"),
        (.hardLight, "Hard Light")
    ]

    var body: some View {
        NavigationView {
            Form {
                Section("Pressure Sensitivity") {
                    VStack(alignment: .leading) {
                        Text("Pressure Response Curve")
                            .font(.caption)

                        PressureCurveEditor(
                            curve: $pressureCurve,
                            onChange: { curve in
                                applyPressureCurve(curve)
                            }
                        )
                        .frame(height: 150)

                        HStack {
                            Text("Min Pressure")
                            Slider(value: .constant(0.1), in: 0...1)
                        }

                        HStack {
                            Text("Max Pressure")
                            Slider(value: .constant(1.0), in: 0...1)
                        }
                    }
                }

                Section("Texture") {
                    Picker("Brush Texture", selection: $selectedTexture) {
                        ForEach(availableTextures.keys.sorted(), id: \.self) { key in
                            HStack {
                                Image(systemName: "square.fill")
                                    .frame(width: 30, height: 30)
                                Text(availableTextures[key] ?? "")
                            }
                            .tag(key)
                        }
                    }
                    .onChange(of: selectedTexture) { _, newValue in
                        tool.texture = newValue
                    }
                }

                Section("Blend Mode") {
                    Picker("Blend Mode", selection: $tool.blendMode) {
                        ForEach(blendModes, id: \.0.rawValue) { mode, name in
                            Text(name).tag(mode)
                        }
                    }
                }

                Section("Tilt Settings") {
                    Toggle("Enable Tilt", isOn: .constant(true))

                    VStack(alignment: .leading) {
                        Text("Tilt Angle: \(Int(tool.tilt * 180 / .pi))°")
                        Slider(value: $tool.tilt, in: 0...(.pi/2))
                    }

                    Toggle("Tilt affects width", isOn: .constant(true))
                    Toggle("Tilt affects opacity", isOn: .constant(false))
                }

                Section("Stabilization") {
                    Toggle("Smooth Strokes", isOn: .constant(true))

                    VStack(alignment: .leading) {
                        Text("Smoothing Level")
                        Slider(value: .constant(0.5), in: 0...1)
                    }

                    Toggle("Predictive Stroke", isOn: .constant(false))
                }
            }
            .navigationTitle("Advanced Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func applyPressureCurve(_ curve: [CGPoint]) {
        // Apply the custom pressure curve to the tool
    }
}
