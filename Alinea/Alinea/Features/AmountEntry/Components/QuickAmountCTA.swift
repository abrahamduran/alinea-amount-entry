//
//  QuickAmountCTA.swift
//  Alinea
//
//  Created by Abraham Duran on 22/5/26.
//
//  The production chips ↔ Review CTA row. Three equal-width slots; the
//  middle is a `MorphingCTA` driven by `progress` (showChips → 0,
//  !showChips → 1). Side slots collapse to zero width as progress
//  advances. One spring drives every channel.
//

import DesignSystem
import SwiftUI

// MARK: - QuickAmounts

/// The three quick-amount values in the CTA row. `center` is the
/// morphing slot — the one that becomes the Review button.
public struct QuickAmounts: Sendable, Equatable {
    public let leading: Int
    public let center: Int
    public let trailing: Int

    public init(leading: Int, center: Int, trailing: Int) {
        self.leading = leading
        self.center = center
        self.trailing = trailing
    }

    public static let `default` = QuickAmounts(leading: 500, center: 2_000, trailing: 10_000)
}

// MARK: - QuickAmountCTA

public struct QuickAmountCTA: View {

    public let amounts: QuickAmounts
    public let showChips: Bool
    public let canReview: Bool
    public let onChipTap: (Int) -> Void
    public let onReview: () -> Void

    public init(
        amounts: QuickAmounts = .default,
        showChips: Bool,
        canReview: Bool,
        onChipTap: @escaping (Int) -> Void,
        onReview: @escaping () -> Void
    ) {
        self.amounts = amounts
        self.showChips = showChips
        self.canReview = canReview
        self.onChipTap = onChipTap
        self.onReview = onReview
    }

    public var body: some View {
        morphingLayout
            .frame(height: 50, alignment: .center)
            .animation(Self.spring, value: showChips)
    }

    private static let spring: Animation =
        .spring(response: 0.45, dampingFraction: 0.82).speed(0.8)

    // MARK: Morphing layout

    private var morphingLayout: some View {
        GeometryReader { geo in
            let fullWidth   = geo.size.width
            let spacing: Double = 12
            let chipSlot    = max(0, (fullWidth - spacing * 2) / 3)
            let progress: Double = showChips ? 0 : 1
            let middleWidth = chipSlot + (fullWidth - chipSlot) * progress
            let sideWidth   = chipSlot * (1 - progress)

            ZStack {
                AllieGlow(style: .mesh)
                    .frame(width: middleWidth, height: 50)
                    .opacity(progress)
                    .accessibilityHidden(true)

                HStack(spacing: spacing) {
                    sideChip(amounts.leading, width: sideWidth, progress: progress)

                    MorphingCTA(
                        progress: progress,
                        chipLabel: format(amounts.center),
                        isReview: !showChips,
                        canReview: canReview,
                        onChipTap: { onChipTap(amounts.center) },
                        onReview: onReview
                    )
                    .frame(width: middleWidth)

                    sideChip(amounts.trailing, width: sideWidth, progress: progress)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }

    private func sideChip(_ amount: Int, width: Double, progress: Double) -> some View {
        QuickAmountChip(amount: amount) { onChipTap(amount) }
            .frame(width: width)
            .opacity(1 - progress)
            .clipped()
            .allowsHitTesting(showChips)
            .accessibilityHidden(!showChips)
    }

    private func format(_ amount: Int) -> String {
        "$" + amount.formatted(.number)
    }
}

// MARK: - Preview

#Preview("Toggle") {
    @Previewable @State var showChips = true

    return VStack(spacing: 24) {
        Spacer()

        QuickAmountCTA(
            showChips: showChips,
            canReview: true,
            onChipTap: { _ in showChips = false },
            onReview: { showChips = true }
        )
        .padding(.horizontal, 24)

        Spacer()

        Button(showChips ? "Tap chip → Review" : "Backspace → Chips") {
            showChips.toggle()
        }
        .padding(.bottom, 24)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.Background.screen)
}

#Preview("Custom amounts") {
    @Previewable @State var showChips = true

    return VStack(spacing: 24) {
        Spacer()

        QuickAmountCTA(
            amounts: QuickAmounts(leading: 250, center: 1_000, trailing: 5_000),
            showChips: showChips,
            canReview: true,
            onChipTap: { _ in showChips = false },
            onReview: { showChips = true }
        )
        .padding(.horizontal, 24)

        Spacer()

        Button("Toggle") { showChips.toggle() }
            .padding(.bottom, 24)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.Background.screen)
}
