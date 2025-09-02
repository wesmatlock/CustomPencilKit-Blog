import SwiftUI
import PencilKit
import Combine

enum ToolType: String, CaseIterable, Codable {
    case pen = "Pen"
    case pencil = "Pencil"
    case marker = "Marker"
    case highlighter = "Highlighter"
    case eraser = "Eraser"
    case blurEraser = "Blur"
    case pixelateEraser = "Pixelate"
    case customBrush = "Custom"
}

@Observable
class CustomDrawingTool: Codable {
    var type: ToolType = .pen
    var color: Color = .black
    var width: CGFloat = 5.0
    var opacity: CGFloat = 1.0
    var pressure: CGFloat = 1.0
    var tilt: CGFloat = 0.0
    var texture: String? = nil
    var blendMode: CGBlendMode = .normal

    enum CodingKeys: String, CodingKey {
        case type, width, opacity, pressure, tilt, texture
    }

    init() {}

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(ToolType.self, forKey: .type)
        width = try container.decode(CGFloat.self, forKey: .width)
        opacity = try container.decode(CGFloat.self, forKey: .opacity)
        pressure = try container.decode(CGFloat.self, forKey: .pressure)
        tilt = try container.decode(CGFloat.self, forKey: .tilt)
        texture = try container.decodeIfPresent(String.self, forKey: .texture)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(width, forKey: .width)
        try container.encode(opacity, forKey: .opacity)
        try container.encode(pressure, forKey: .pressure)
        try container.encode(tilt, forKey: .tilt)
        try container.encodeIfPresent(texture, forKey: .texture)
    }

    var pkTool: PKTool {
        switch type {
        case .pen:
            return PKInkingTool(.pen, color: UIColor(color), width: width)
        case .pencil:
            return PKInkingTool(.pencil, color: UIColor(color), width: width)
        case .marker:
            return PKInkingTool(.marker, color: UIColor(color), width: width)
        case .highlighter:
            // FIX: Simulate highlighter with marker + transparency
            // since .highlighter doesn't exist in PKInkingTool.InkType
            let highlighterColor = UIColor(color).withAlphaComponent(0.5)
            return PKInkingTool(.marker, color: highlighterColor, width: width * 2)
        case .eraser:
            return PKEraserTool(.bitmap)
        case .blurEraser, .pixelateEraser:
            return PKEraserTool(.vector)
        case .customBrush:
            return createCustomTool()
        }
    }

    private func createCustomTool() -> PKTool {
        let ink = PKInk(.pen, color: UIColor(color))
        // FIX: Added 'ink:' argument label
        return PKInkingTool(ink: ink, width: width)
    }
}
