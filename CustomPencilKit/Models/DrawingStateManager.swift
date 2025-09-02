import SwiftUI
import PencilKit
import Combine

@Observable
class DrawingStateManager {
    private(set) var undoManager = UndoManager()
    private var drawingHistory: [PKDrawing] = []
    private var toolConfigurations: [String: CustomDrawingTool] = [:]
    private let maxHistorySize = 50

    var canvasView = PKCanvasView()
    var currentTool = CustomDrawingTool()
    var isUsingPencil = false

    // Performance monitoring
    private var strokeCount = 0
    private var lastPerformanceCheck = Date()

    init() {
        setupCanvasOptimizations()
        loadSavedConfigurations()
    }

    private func setupCanvasOptimizations() {
        canvasView.drawingGestureRecognizer.isEnabled = true
        canvasView.contentInsetAdjustmentBehavior = .never

        if let metalLayer = canvasView.layer as? CAMetalLayer {
            metalLayer.presentsWithTransaction = false
            metalLayer.framebufferOnly = true
        }
    }

    func captureDrawingState() {
        let currentDrawing = canvasView.drawing

        if drawingHistory.count >= maxHistorySize {
            drawingHistory.removeFirst()
        }

        drawingHistory.append(currentDrawing)

        undoManager.registerUndo(withTarget: self) { target in
            target.restoreDrawing(at: self.drawingHistory.count - 1)
        }
    }

    private func restoreDrawing(at index: Int) {
        guard index >= 0 && index < drawingHistory.count else { return }
        canvasView.drawing = drawingHistory[index]
    }

    func saveToolConfiguration(name: String) {
        toolConfigurations[name] = currentTool
        persistConfigurations()
    }

    func loadToolConfiguration(name: String) {
        if let config = toolConfigurations[name] {
            currentTool = config
        }
    }

    private func persistConfigurations() {
        if let encoded = try? JSONEncoder().encode(toolConfigurations) {
            UserDefaults.standard.set(encoded, forKey: "CustomToolConfigurations")
        }
    }

    private func loadSavedConfigurations() {
        if let data = UserDefaults.standard.data(forKey: "CustomToolConfigurations"),
           let decoded = try? JSONDecoder().decode([String: CustomDrawingTool].self, from: data) {
            toolConfigurations = decoded
        }
    }

    func checkPerformance() {
        let now = Date()
        let timeElapsed = now.timeIntervalSince(lastPerformanceCheck)

        if timeElapsed > 1.0 {
            let strokesPerSecond = Double(strokeCount) / timeElapsed

            if strokesPerSecond < 30 {
                optimizeForPerformance()
            }

            strokeCount = 0
            lastPerformanceCheck = now
        }
    }

    private func optimizeForPerformance() {
        canvasView.drawing = canvasView.drawing.transformed(using: CGAffineTransform(scaleX: 0.5, y: 0.5))
        canvasView.drawing = canvasView.drawing.transformed(using: CGAffineTransform(scaleX: 2.0, y: 2.0))
    }
}
