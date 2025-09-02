import CoreGraphics
import UIKit
import SwiftUI

class CustomBrushEngine {
    private var textureCache: [String: CGImage] = [:]

    func createTexturedStroke(
        points: [CGPoint],
        pressures: [CGFloat],
        tilts: [CGFloat],
        tool: CustomDrawingTool,
        in context: CGContext
    ) {
        guard points.count > 1 else { return }

        context.setBlendMode(tool.blendMode)
        context.setAlpha(tool.opacity)

        if tool.type == .blurEraser {
            applyBlurEffect(to: context, at: points)
            return
        } else if tool.type == .pixelateEraser {
            applyPixelateEffect(to: context, at: points)
            return
        }

        for i in 0..<points.count - 1 {
            let startPoint = points[i]
            let endPoint = points[i + 1]
            let pressure = pressures[safe: i] ?? 1.0
            let tilt = tilts[safe: i] ?? 0.0

            let dynamicWidth = tool.width * pressure

            if tool.type == .customBrush {
                drawTexturedSegment(
                    from: startPoint,
                    to: endPoint,
                    width: dynamicWidth,
                    tilt: tilt,
                    texture: tool.texture,
                    color: UIColor(tool.color),
                    in: context
                )
            } else {
                context.setStrokeColor(UIColor(tool.color).cgColor)
                context.setLineWidth(dynamicWidth)
                context.setLineCap(.round)
                context.setLineJoin(.round)

                context.move(to: startPoint)
                context.addLine(to: endPoint)
                context.strokePath()
            }
        }
    }

    private func drawTexturedSegment(
        from start: CGPoint,
        to end: CGPoint,
        width: CGFloat,
        tilt: CGFloat,
        texture: String?,
        color: UIColor,
        in context: CGContext
    ) {
        let distance = hypot(end.x - start.x, end.y - start.y)
        let steps = max(Int(distance / 2), 1)

        for i in 0...steps {
            let t = CGFloat(i) / CGFloat(steps)
            let point = CGPoint(
                x: start.x + (end.x - start.x) * t,
                y: start.y + (end.y - start.y) * t
            )

            if let textureName = texture,
               let textureImage = loadTexture(named: textureName) {

                let rect = CGRect(
                    x: point.x - width/2,
                    y: point.y - width/2,
                    width: width,
                    height: width
                )

                context.saveGState()
                context.translateBy(x: point.x, y: point.y)
                context.rotate(by: tilt)
                context.translateBy(x: -point.x, y: -point.y)

                context.setBlendMode(.multiply)
                context.draw(textureImage, in: rect)

                context.restoreGState()
            } else {
                context.setFillColor(color.cgColor)
                context.fillEllipse(in: CGRect(
                    x: point.x - width/2,
                    y: point.y - width/2,
                    width: width,
                    height: width
                ))
            }
        }
    }

    private func applyBlurEffect(to context: CGContext, at points: [CGPoint]) {
        guard let _ = CIFilter(name: "CIGaussianBlur") else { return }

        for point in points {
            let blurRadius: CGFloat = 20
            let rect = CGRect(
                x: point.x - blurRadius,
                y: point.y - blurRadius,
                width: blurRadius * 2,
                height: blurRadius * 2
            )

            context.setFillColor(UIColor.white.withAlphaComponent(0.3).cgColor)
            context.fillEllipse(in: rect)
        }
    }

    private func applyPixelateEffect(to context: CGContext, at points: [CGPoint]) {
        let pixelSize: CGFloat = 10

        for point in points {
            let rect = CGRect(
                x: floor(point.x / pixelSize) * pixelSize,
                y: floor(point.y / pixelSize) * pixelSize,
                width: pixelSize,
                height: pixelSize
            )

            context.setFillColor(UIColor.systemGray.cgColor)
            context.fill(rect)
        }
    }

    private func loadTexture(named name: String) -> CGImage? {
        if let cached = textureCache[name] {
            return cached
        }

        guard let image = UIImage(named: name)?.cgImage else { return nil }
        textureCache[name] = image
        return image
    }
}
