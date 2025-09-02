import SwiftUI
import PencilKit

struct ContentView: View {
    @State private var stateManager = DrawingStateManager()
    @State private var showToolPalette = true
    @State private var canvasOffset: CGSize = .zero
    @State private var canvasScale: CGFloat = 1.0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Main Drawing Canvas - NO GESTURES ATTACHED
                CustomDrawingView(
                    canvasView: $stateManager.canvasView,
                    currentTool: $stateManager.currentTool,
                    isUsingPencil: $stateManager.isUsingPencil
                )
                .ignoresSafeArea()
                .scaleEffect(canvasScale)
                .offset(canvasOffset)
                // REMOVED ALL .gesture() modifiers here - this was causing the black screen!

                // Floating Tool Palette
                VStack {
                    HStack {
                        // Menu Button
                        Button(action: {
                            withAnimation {
                                showToolPalette.toggle()
                            }
                        }) {
                            Image(systemName: "paintbrush.pointed")
                                .font(.title2)
                                .frame(width: 44, height: 44)
                                .background(.regularMaterial)
                                .clipShape(Circle())
                        }

                        Spacer()

                        // Add Zoom Controls as buttons instead of gestures
                        HStack(spacing: 8) {
                            // Zoom Out
                            Button(action: {
                                withAnimation(.spring(response: 0.3)) {
                                    canvasScale = max(0.5, canvasScale - 0.25)
                                }
                            }) {
                                Image(systemName: "minus.magnifyingglass")
                                    .font(.title3)
                                    .frame(width: 44, height: 44)
                                    .background(.regularMaterial)
                                    .clipShape(Circle())
                            }

                            // Reset Zoom
                            Button(action: {
                                withAnimation(.spring(response: 0.3)) {
                                    canvasScale = 1.0
                                    canvasOffset = .zero
                                }
                            }) {
                                Text("\(Int(canvasScale * 100))%")
                                    .font(.caption2)
                                    .fontWeight(.medium)
                                    .frame(width: 50, height: 30)
                                    .background(.regularMaterial)
                                    .clipShape(Capsule())
                            }

                            // Zoom In
                            Button(action: {
                                withAnimation(.spring(response: 0.3)) {
                                    canvasScale = min(3.0, canvasScale + 0.25)
                                }
                            }) {
                                Image(systemName: "plus.magnifyingglass")
                                    .font(.title3)
                                    .frame(width: 44, height: 44)
                                    .background(.regularMaterial)
                                    .clipShape(Circle())
                            }
                        }

                        Spacer()

                        // Undo/Redo
                        HStack(spacing: 8) {
                            Button(action: {
                                stateManager.undoManager.undo()
                            }) {
                                Image(systemName: "arrow.uturn.backward")
                                    .font(.title2)
                                    .frame(width: 44, height: 44)
                                    .background(.regularMaterial)
                                    .clipShape(Circle())
                            }
                            .disabled(!stateManager.undoManager.canUndo)

                            Button(action: {
                                stateManager.undoManager.redo()
                            }) {
                                Image(systemName: "arrow.uturn.forward")
                                    .font(.title2)
                                    .frame(width: 44, height: 44)
                                    .background(.regularMaterial)
                                    .clipShape(Circle())
                            }
                            .disabled(!stateManager.undoManager.canRedo)
                        }

                        Spacer()

                        // Clear Canvas
                        Button(action: {
                            stateManager.captureDrawingState()
                            stateManager.canvasView.drawing = PKDrawing()
                        }) {
                            Image(systemName: "trash")
                                .font(.title2)
                                .frame(width: 44, height: 44)
                                .background(.regularMaterial)
                                .clipShape(Circle())
                        }
                    }
                    .padding()

                    Spacer()

                    if showToolPalette {
                        CustomToolPalette(
                            tool: stateManager.currentTool,
                            isUsingPencil: $stateManager.isUsingPencil
                        )
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding()
                    }
                }
            }
        }
        .preferredColorScheme(.light)
    }
}
