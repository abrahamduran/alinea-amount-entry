//
//  AllieGlow.swift
//  Alinea
//
//  Created by Abraham Duran on 20/5/26.
//
//  Brand-gradient halo behind the Review pill. Two stacked layers — a
//  wide outer wash and a tighter inner ring — both driven by a single
//  `TimelineView` so they share a clock and pause when offscreen.
//
//  Styles: `.angular` (conic rotation, cheap, default) and `.mesh`
//  (MeshGradient with drifting control points, opt-in).
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
        innerBlur: CGFloat = 18,
        outerBlur: CGFloat = 36,
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
                            .Brand.gradientStart,   // magenta
                            .Brand.gradientEnd,     // iris
                            .Brand.gradientBlue,    // blue
                            .Brand.gradientAccent,  // yellow
                            .Brand.gradientStart,   // close the loop
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

    /// 3×3 MeshGradient whose edge midpoints AND center drift on
    /// independent sine phases — irrational frequency ratios so the
    /// wash never repeats cleanly. Corners stay pinned so the shape
    /// remains rectangular.
    private func meshGradient(at t: TimeInterval, speedSign: Double) -> MeshGradient {
        let s = speedSign

        // Drift a point around a base anchor by `amp` units. Phase and
        // frequency are picked per call so each point follows its own
        // orbit — the rationals avoid resonance, so no global cycle.
        let drift: (Double, Double, Double, Double, Double) -> SIMD2<Float> = {
            baseX, baseY, amp, phase, freq in
            let x = baseX + amp * sin(t * freq * s + phase)
            let y = baseY + amp * cos(t * freq * s + phase * 1.37)
            return SIMD2<Float>(Float(x), Float(y))
        }

        let palette: [Color] = [
            .Brand.gradientStart,    // magenta
            .Brand.gradientEnd,      // iris
            .Brand.gradientBlue,     // blue
            .Brand.gradientAccent,   // yellow
        ]

        // Pick a continuously-shifting color for each cell. `phase`
        // offsets the cell's position in the palette so neighboring
        // cells never sit on the same color simultaneously.
        let cycleSpeed = 0.18
        let color: (Double) -> Color = { phase in
            let progress = (t * cycleSpeed * s + phase)
                .truncatingRemainder(dividingBy: Double(palette.count))
            let normalized = progress < 0 ? progress + Double(palette.count) : progress
            let i = Int(normalized) % palette.count
            let next = (i + 1) % palette.count
            let blend = normalized - Double(i)
            return palette[i].mix(with: palette[next], by: blend)
        }

        return MeshGradient(
            width: 3,
            height: 3,
            points: [
                SIMD2(0, 0),
                drift(0.5, 0.0, 0.12, 0.0,  0.31),       // top edge
                SIMD2(1, 0),

                drift(0.0, 0.5, 0.10, 1.7,  0.27),       // left edge
                drift(0.5, 0.5, 0.20, 0.0,  0.45),       // center (biggest swing)
                drift(1.0, 0.5, 0.10, 3.4,  0.23),       // right edge

                SIMD2(0, 1),
                drift(0.5, 1.0, 0.12, 5.1,  0.37),       // bottom edge
                SIMD2(1, 1),
            ],
            colors: [
                color(0.0), color(0.5), color(1.0),
                color(1.5), color(2.0), color(2.5),
                color(3.0), color(3.5), color(0.25),
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
