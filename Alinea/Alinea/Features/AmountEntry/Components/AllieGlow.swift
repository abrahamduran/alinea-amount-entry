//
//  AllieGlow.swift
//  Alinea
//
//  Created by Abraham Duran on 20/5/26.
//
//  Breathing, slowly-rotating brand-gradient halo rendered behind the
//  Review pill. Pure SwiftUI via TimelineView(.animation); no Timer,
//  no @State, drains battery only while visible.
//

import DesignSystem
import SwiftUI

public struct AllieGlow: View {

    public var cornerRadius: CGFloat = 25
    public var blurRadius: CGFloat = 32
    public var rotationSpeedDegPerSec: Double = 30
    public var breathSpeedHz: Double = 1.5

    public init(
        cornerRadius: CGFloat = 25,
        blurRadius: CGFloat = 32,
        rotationSpeedDegPerSec: Double = 30,
        breathSpeedHz: Double = 1.5
    ) {
        self.cornerRadius = cornerRadius
        self.blurRadius = blurRadius
        self.rotationSpeedDegPerSec = rotationSpeedDegPerSec
        self.breathSpeedHz = breathSpeedHz
    }

    public var body: some View {
        TimelineView(.animation) { ctx in
            let t = ctx.date.timeIntervalSinceReferenceDate
            let angle = Angle.degrees(
                (t * rotationSpeedDegPerSec).truncatingRemainder(dividingBy: 360)
            )
            let breath = 1.0 + 0.04 * sin(t * breathSpeedHz)
            let opacity = 0.6 + 0.4 * (0.5 + 0.5 * sin(t * breathSpeedHz))

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
                .blur(radius: blurRadius)
                .opacity(opacity)
                .scaleEffect(breath)
        }
        .accessibilityHidden(true)
    }
}

#Preview {
    AllieGlow()
        .frame(width: 345, height: 50)
        .padding(60)
        .background(Color.Background.screen)
}
