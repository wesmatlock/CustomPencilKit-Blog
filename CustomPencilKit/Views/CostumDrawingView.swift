import SwiftUI
import PencilKit

struct CustomDrawingView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    @Binding var currentTool: CustomDrawingTool
    @Binding var isUsingPencil: Bool

    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.delegate = context.coordinator
        canvasView.drawingPolicy = .anyInput
        canvasView.backgroundColor = .systemBackground
        canvasView.isOpaque = true
        canvasView.alwaysBounceVertical = false
        canvasView.alwaysBounceHorizontal = false

        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        uiView.tool = currentTool.pkTool
        uiView.isUserInteractionEnabled = true
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: CustomDrawingView

        init(_ parent: CustomDrawingView) {
            self.parent = parent
        }

        func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
            // Detect input type - simplified version
            parent.isUsingPencil = canvasView.tool is PKInkingTool
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            // Track changes for undo/redo
        }
    }
}
