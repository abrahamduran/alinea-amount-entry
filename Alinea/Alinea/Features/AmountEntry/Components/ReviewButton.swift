//
//  ReviewButton.swift
//  Alinea
//
//  Created by Abraham Duran on 20/5/26.
//
//  White pill CTA. The brand-gradient halo (AllieGlow) is rendered
//  behind it by AmountEntryView, not baked in here — so the button
//  composes cleanly with or without the halo.
//

import DesignSystem
import SwiftUI

public struct ReviewButton: View {

    public let isEnabled: Bool
    public let action: () -> Void

    public init(isEnabled: Bool, action: @escaping () -> Void) {
        self.isEnabled = isEnabled
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text("Review")
                .typography(.buttonLabel)
                .foregroundStyle(.textInverse)
                .fixedSize(horizontal: true, vertical: false)
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity)
                .background(.backgroundButton, in: .capsule)
                .overlay { topHighlight }
                .overlay { upperLeftSpot }
                .shadow(color: .textPrimary.opacity(0.10), radius: 4.73)
                .contentShape(.capsule)
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .accessibilityLabel("Review")
    }

    /// Stationary white reflection along the top edge of the pill —
    /// matches the bright highlight visible on the Figma button. Sits
    /// above the white fill but below the text; clipped to the capsule
    /// so it never bleeds past the rounded edges.
    private var topHighlight: some View {
        Capsule()
            .fill(
                LinearGradient(
                    colors: [
                        .white.opacity(0.95),
                        .white.opacity(0.0),
                    ],
                    startPoint: .top,
                    endPoint: .center
                )
            )
            .blendMode(.plusLighter)
            .allowsHitTesting(false)
    }

    /// Diagonal soft spot anchored top-leading — the second specular
    /// highlight visible on the Figma pill. Radial fade so it reads as
    /// a localized glow rather than a uniform brightening.
    private var upperLeftSpot: some View {
        Capsule()
            .fill(
                RadialGradient(
                    colors: [
                        .white.opacity(0.55),
                        .white.opacity(0.0),
                    ],
                    center: UnitPoint(x: 0.18, y: 0.0),
                    startRadius: 0,
                    endRadius: 90
                )
            )
            .blendMode(.plusLighter)
            .allowsHitTesting(false)
    }
}

#Preview {
    VStack(spacing: 20) {
        ReviewButton(isEnabled: true) {}
        ReviewButton(isEnabled: false) {}
    }
    .frame(width: 345)
    .padding(40)
    .background(.backgroundScreen)
}

#Preview("With AllieGlow") {
    VStack(spacing: 20) {
        ZStack {
            AllieGlow(style: .mesh)

            ReviewButton(isEnabled: true, action: {})
        }
        .frame(height: 50)
        .padding(40)
    }
    .frame(maxHeight: .infinity)
    .background(.backgroundScreen)
}
