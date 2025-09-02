# CustomPencilKit 🎨

> **Ditch Apple's tool picker. Build your own.**

A complete SwiftUI implementation showing how to create a custom drawing interface for PencilKit, because sometimes the default `PKToolPicker` just doesn't cut it.

![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![iOS](https://img.shields.io/badge/iOS-17.0%2B-blue.svg)
![iPadOS](https://img.shields.io/badge/iPadOS-17.0%2B-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## The Problem

You're building a drawing app with PencilKit. Apple's `PKToolPicker` works, but:
- It looks like every other PencilKit app
- You can't match your app's design language
- The customization options are basically nil
- You want features that don't exist

## The Solution

Hide the default picker. Build your own. Take control of the experience while keeping PencilKit's excellent drawing engine.

## What This Does

### ✅ Actually Works
- **Custom tool palette** - Your design, your rules
- **Pencil vs Touch detection** - Visual feedback for input mode
- **Simulated brushes** - Highlighter, fountain pen, watercolor effects
- **No gesture conflicts** - Solved the black screen issue
- **State persistence** - Drawings and tools save automatically
- **Zoom without breaking** - Buttons instead of gestures
- **Clean architecture** - SwiftUI + iOS 17's `@Observable`

### ⚠️ PencilKit Limitations (Not Our Fault)
- **No custom textures** - Apple doesn't expose the drawing pipeline
- **No pressure curves** - PencilKit handles this internally
- **No blur/pixelate erasers** - Limited to bitmap and vector
- **No real-time filters** - Would need Metal or Core Graphics

## Quick Start

```bash
git clone https://github.com/yourusername/CustomPencilKit.git
cd CustomPencilKit
open CustomPencilKit.xcodeproj
```

Build and run on your iPad. That's it.

## The Code Structure

```
CustomPencilKit/
├── Models/
│   ├── ToolType.swift           # Tool definitions
│   ├── CustomDrawingTool.swift   # Tool → PKTool conversion
│   └── DrawingStateManager.swift # State and undo/redo
├── Views/
│   ├── CustomDrawingView.swift   # PKCanvasView wrapper
│   ├── CustomToolPalette.swift   # The custom UI
│   ├── InputModeIndicator.swift  # Pencil vs Touch indicator
│   └── ColorPickerSheet.swift    # Color selection
└── ContentView.swift             # Main app view
```

## Key Learnings

### 🔥 The Gesture Conflict Issue

**DON'T** do this - it causes a black screen when drawing:
```swift
CustomDrawingView()
    .gesture(MagnificationGesture())  // ❌ Breaks drawing!
    .gesture(DragGesture())           // ❌ This too!
```

**DO** this instead:
```swift
// Use buttons for zoom
Button("-") { scale = max(0.5, scale - 0.25) }
Button("+") { scale = min(3.0, scale + 0.25) }
```

### 🎭 Simulating Advanced Brushes

PencilKit only has pen, pencil, and marker. But we can fake it:

```swift
case .highlighter:
    // Transparent marker = highlighter
    let color = UIColor(color).withAlphaComponent(0.3)
    return PKInkingTool(.marker, color: color, width: width * 3)
    
case .fountain:
    // Thin pen = fountain pen
    return PKInkingTool(.pen, color: UIColor(color), width: width * 0.7)
```

### 📱 Detecting Pencil vs Touch

Override `touchesBegan` in a PKCanvasView subclass:

```swift
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    if let touch = touches.first {
        isPencil = touch.type == .pencil
    }
}
```

## Requirements

- **Xcode 15.0+** - For iOS 17 and `@Observable`
- **iOS/iPadOS 17.0+** - Modern SwiftUI features
- **iPad recommended** - Works on iPhone but designed for iPad
- **Apple Pencil** - Optional but recommended for full experience

## Usage

1. **Run the app** - Opens with pen tool selected
2. **Choose tools** - Tap any tool in the palette
3. **Adjust properties** - Color, width, opacity sliders
4. **Zoom** - Use the +/- buttons (not gestures!)
5. **Switch input** - Automatically detects Pencil vs finger

## Customization Ideas

Want to make it yours? Try these:

- **Floating palette** - Make it draggable
- **Radial menu** - Long-press for tool wheel
- **Gesture shortcuts** - Two-finger tap to undo
- **Tool presets** - Save favorite configurations
- **Themes** - Dark mode, color schemes

## Known Issues

1. **Simulator** - Pencil detection always shows "Touch" (no pencil in simulator)
2. **Fountain pen** - Effect is subtle, might need more dramatic values
3. **Performance** - Large canvases may lag with many strokes

## Blog Post

Read the full technical breakdown: [Customizing PencilKit: Going Past Apple's Tool Picker]([https://yourblog.com/pencilkit-custom](https://medium.com/@wesleymatlock/customizing-pencilkit-going-past-apples-tool-picker-b82eca7bfbe2))

## Contributing

Found a way to make PencilKit do something it "can't"? Open a PR! We're all fighting the same constraints here.

## License

MIT - Use it, modify it, ship it.

## Acknowledgments

- James, whose production app inspired this journey
- Apple, for PencilKit (even with its limitations)
- Everyone who's hit these same walls and shared solutions

---

**Built with frustration and determination in SwiftUI.**

If this saved you from the black screen of death, star the repo. ⭐
