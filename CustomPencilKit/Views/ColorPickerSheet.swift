import SwiftUI

struct ColorPickerSheet: View {
    @Binding var selectedColor: Color
    @Environment(\.dismiss) private var dismiss

    let presetColors: [Color] = [
        .black, .gray, .red, .orange, .yellow,
        .green, .mint, .teal, .cyan, .blue,
        .indigo, .purple, .pink, .brown
    ]

    var body: some View {
        NavigationView {
            VStack {
                ColorPicker("Custom Color", selection: $selectedColor)
                    .padding()

                Divider()

                Text("Preset Colors")
                    .font(.headline)
                    .padding(.top)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                    ForEach(presetColors, id: \.self) { color in
                        Button(action: {
                            selectedColor = color
                            dismiss()
                        }) {
                            Circle()
                                .fill(color)
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Circle()
                                        .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                                )
                        }
                    }
                }
                .padding()

                Spacer()
            }
            .navigationTitle("Choose Color")
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
}
