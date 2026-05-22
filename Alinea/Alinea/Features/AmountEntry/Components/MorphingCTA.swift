//
//  MorphingCTA.swift
//  Alinea
//
//  Created by Abraham Duran on 22/5/26.
//
//  Single view that morphs between a quick-amount chip and the Review
//  button. `@Animatable` interpolates `progress` 0→1 and re-evaluates
//  `body` per frame, so fill, foreground, padding, and label opacities
//  all share one spring. One identity throughout — avoids the
//  two-view crossfade you get from `matchedGeometryEffect` when the
//  endpoints differ in text, color, and typography.
//

import DesignSystem
import SwiftUI

@Animatable
public struct MorphingCTA: View {

    /// 0 = chip configuration (dark fill, white text, `chipLabel`)
    /// 1 = Review configuration (white fill, dark text, `buttonLabel`)
    public var progress: Double

    @AnimatableIgnored public var chipLabel: String
    @AnimatableIgnored public var buttonLabel: String
    /// Stable identity driver for the a11y label and tap routing —
    /// decoupled from `progress` so VoiceOver doesn't flip mid-morph.
    @AnimatableIgnored public var isReview: Bool
    @AnimatableIgnored public var canReview: Bool
    @AnimatableIgnored public var onChipTap: () -> Void
    @AnimatableIgnored public var onReview: () -> Void

    public init(
        progress: Double,
        chipLabel: String = "$2,000",
        buttonLabel: String = "Review",
        isReview: Bool,
        canReview: Bool,
        onChipTap: @escaping () -> Void,
        onReview: @escaping () -> Void
    ) {
        self.progress = progress
        self.chipLabel = chipLabel
        self.buttonLabel = buttonLabel
        self.isReview = isReview
        self.canReview = canReview
        self.onChipTap = onChipTap
        self.onReview = onReview
    }

    public var body: some View {
        let p = max(0, min(1, progress))
        let fill = Color.Background.chip.mix(with: .white, by: p)
        let fg   = Color.Text.primary.mix(with: Color.Text.inverse, by: p)

        // 12 → 14 keeps each rest state at its native height (~44 / 50).
        let vPad: CGFloat = 12 + 2 * p

        // Chip out twice as fast as Review in — avoids a muddy 50/50 frame.
        let chipLabelOpacity   = 1 - min(1, p * 2)
        let reviewLabelOpacity = max(0, p * 2 - 1)

        Button(action: handleTap) {
            ZStack {
                Text(chipLabel)
                    .typography(.chipLabel)
                    .opacity(chipLabelOpacity)
                Text(buttonLabel)
                    .typography(.buttonLabel)
                    .opacity(reviewLabelOpacity)
            }
            .foregroundStyle(fg)
            .fixedSize(horizontal: true, vertical: false)
            .padding(.horizontal, 24)
            .padding(.vertical, vPad)
            .frame(maxWidth: .infinity)
            .glassEffect(.regular, in: .capsule)
            .background(fill, in: .capsule)
            .contentShape(.capsule)
        }
        .buttonStyle(.plain)
        .disabled(isReview && !canReview)
        .accessibilityLabel(isReview ? buttonLabel : "Quick amount \(chipLabel)")
    }

    private func handleTap() {
        if isReview { onReview() } else { onChipTap() }
    }
}

#Preview("Idle stops") {
    VStack(spacing: 20) {
        MorphingCTA(progress: 0,    isReview: false, canReview: true, onChipTap: {}, onReview: {})
        MorphingCTA(progress: 0.25, isReview: false, canReview: true, onChipTap: {}, onReview: {})
        MorphingCTA(progress: 0.5,  isReview: false, canReview: true, onChipTap: {}, onReview: {})
        MorphingCTA(progress: 0.75, isReview: true,  canReview: true, onChipTap: {}, onReview: {})
        MorphingCTA(progress: 1,    isReview: true,  canReview: true, onChipTap: {}, onReview: {})
    }
    .padding(40)
    .background(Color.Background.screen)
}

#Preview("Animated toggle") {
    @Previewable @State var on = false

    return VStack(spacing: 32) {
        Spacer()

        MorphingCTA(
            progress: on ? 1 : 0,
            isReview: on,
            canReview: true,
            onChipTap: { on = true },
            onReview: { on = false }
        )
        .animation(.spring(response: 0.45, dampingFraction: 0.82).speed(0.8), value: on)
        .padding(.horizontal, 24)

        Spacer()

        Button("Toggle") { on.toggle() }
            .padding(.bottom, 24)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.Background.screen)
}
