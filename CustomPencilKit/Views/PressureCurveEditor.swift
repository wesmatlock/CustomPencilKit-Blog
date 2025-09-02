import SwiftUI

struct PressureCurveEditor: View {
    @Binding var curve: [CGPoint]
    let onChange: ([CGPoint]) -> Void

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Grid background
                Path { path in
                    let gridSize: CGFloat = 20
                    let rows = Int(geometry.size.height / gridSize)
                    let cols = Int(geometry.size.width / gridSize)

                    for row in 0...rows {
                        path.move(to: CGPoint(x: 0, y: CGFloat(row) * gridSize))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: CGFloat(row) * gridSize))
                    }

                    for col in 0...cols {
                        path.move(to: CGPoint(x: CGFloat(col) * gridSize, y: 0))
                        path.addLine(to: CGPoint(x: CGFloat(col) * gridSize, y: geometry.size.height))
                    }
                }
                .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)

                // Pressure curve
                Path { path in
                    if curve.isEmpty {
                        path.move(to: CGPoint(x: 0, y: geometry.size.height))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: 0))
                    } else {
                        path.move(to: curve[0])
                        for point in curve.dropFirst() {
                            path.addLine(to: point)
                        }
                    }
                }
                .stroke(Color.accentColor, lineWidth: 2)

                // Control points
                ForEach(curve.indices, id: \.self) { index in
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 12, height: 12)
                        .position(curve[index])
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    curve[index] = value.location
                                    onChange(curve)
                                }
                        )
                }
            }
            .background(Color.gray.opacity(0.05))
            .cornerRadius(8)
            .onAppear {
                if curve.isEmpty {
                    curve = [
                        CGPoint(x: 0, y: geometry.size.height),
                        CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2),
                        CGPoint(x: geometry.size.width, y: 0)
                    ]
                }
            }
        }
    }
}
