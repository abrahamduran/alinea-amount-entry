//
//  AllieGlow.swift
//  Alinea
//
//  Created by Abraham Duran on 20/5/26.
//
//  Brand-gradient halo rendered behind the Review pill. Two layers
//  a wide, diffuse outer wash for depth and a tighter inner ring with
//  the rotating gradient both driven by a single TimelineView so
//  they share a clock and pause cleanly when the view leaves screen.
//
//  Two gradient styles ship side-by-side:
//    • `.angular`, conic rotation. Cheap, predictable, ships by default.
//    • `.mesh`, MeshGradient with drifting control points. More
//      organic, more expensive, kept as an opt-in.
//
//  Pure SwiftUI; no Timer, no @State. Battery cost is zero while the
//  view is offscreen because TimelineView stops ticking automatically.
//

import DesignSystem
import SwiftUI

public struct AllieGlow: View {

    public enum Style: Sendable { case angular, mesh }

    public var style: Style
    public var cornerRadius: CGFloat
    public var innerBlur: CGFloat
    public var outerBlur: CGFloat
    public var rotationSpeedDegPerSec: Double
    public var breathSpeedHz: Double

    public init(
        style: Style = .angular,
        cornerRadius: CGFloat = 25,
        innerBlur: CGFloat = 32,
        outerBlur: CGFloat = 56,
        rotationSpeedDegPerSec: Double = 30,
        breathSpeedHz: Double = 1.5
    ) {
        self.style = style
        self.cornerRadius = cornerRadius
        self.innerBlur = innerBlur
        self.outerBlur = outerBlur
        self.rotationSpeedDegPerSec = rotationSpeedDegPerSec
        self.breathSpeedHz = breathSpeedHz
    }

    public var body: some View {
        TimelineView(.animation) { ctx in
            let t = ctx.date.timeIntervalSinceReferenceDate
            let breath = 1.0 + 0.04 * sin(t * breathSpeedHz)
            // 0.8 / 0.2, never fully off, never fully on.
            let opacity = 0.8 + 0.2 * sin(t * breathSpeedHz)

            ZStack {
                // Outer wash, slower counter-rotation, wider blur, lower
                // opacity. Sells depth without competing with the inner ring.
                gradient(at: t, speed: -rotationSpeedDegPerSec * 0.4)
                    .blur(radius: outerBlur)
                    .opacity(opacity * 0.55)
                    .scaleEffect(breath * 1.18)

                // Inner ring, the headline rotation.
                gradient(at: t, speed: rotationSpeedDegPerSec)
                    .blur(radius: innerBlur)
                    .opacity(opacity)
                    .scaleEffect(breath)
            }
        }
        .accessibilityHidden(true)
    }

    // MARK: - Gradient builders

    @ViewBuilder
    private func gradient(at t: TimeInterval, speed: Double) -> some View {
        switch style {
        case .angular:
            let angle = Angle.degrees(
                (t * speed).truncatingRemainder(dividingBy: 360)
            )
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(
                    AngularGradient(
                        colors: [
                            .Brand.gradientStart, .Brand.gradientEnd,
                            .Brand.gradientStart, .Brand.gradientEnd,
                        ],
                        center: .center,
                        angle: angle
                    )
                )

        case .mesh:
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(meshGradient(at: t, speedSign: speed >= 0 ? 1 : -1))
        }
    }

    /// 3×3 MeshGradient whose interior control points drift on
    /// independent sine phases so the wash never repeats cleanly.
    /// Corners stay pinned so the shape remains rectangular.
    private func meshGradient(at t: TimeInterval, speedSign: Double) -> MeshGradient {
        let s = speedSign
        let drift: (Double, Double) -> SIMD2<Float> = { phase, freq in
            let x = 0.5 + 0.18 * sin(t * freq * s + phase)
            let y = 0.5 + 0.18 * cos(t * freq * s + phase * 1.3)
            return SIMD2<Float>(Float(x), Float(y))
        }

        let start: Color = .Brand.gradientStart
        let end: Color = .Brand.gradientEnd

        return MeshGradient(
            width: 3,
            height: 3,
            points: [
                SIMD2(0, 0),   SIMD2(0.5, 0),       SIMD2(1, 0),
                SIMD2(0, 0.5), drift(0.0, 0.45),    SIMD2(1, 0.5),
                SIMD2(0, 1),   SIMD2(0.5, 1),       SIMD2(1, 1),
            ],
            colors: [
                start, end,   start,
                end,   start, end,
                start, end,   start,
            ]
        )
    }
}

#Preview("Angular (default)") {
    AllieGlow(style: .angular)
        .frame(width: 345, height: 50)
        .padding(60)
        .background(Color.Background.screen)
}

#Preview("Mesh (bonus)") {
    AllieGlow(style: .mesh)
        .frame(width: 345, height: 50)
        .padding(60)
        .background(Color.Background.screen)
}
