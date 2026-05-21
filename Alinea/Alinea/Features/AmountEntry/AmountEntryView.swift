//
//  AmountEntryView.swift
//  Alinea
//
//  Created by Abraham Duran on 21/5/26.
//
//  Screen-level composition. Owns the chips → Review matched-geometry
//  morph, the AllieGlow layering, and the single sensoryFeedback
//  trigger that drives haptics for every keypad and chip tap.
//

import DesignSystem
import SwiftUI

public struct AmountEntryView: View {

    @State private var vm = AmountEntryViewModel()
    @Namespace private var morph

    public init() {}

    public var body: some View {
        ZStack {
            Color.Background.screen
                .ignoresSafeArea()

            VStack(spacing: 0) {
                topBar
                    .padding(.horizontal, 18)
                    .padding(.top, 18)

                Spacer(minLength: 0)

                AmountDisplay(amount: vm.displayAmount, isEmpty: vm.isEmpty)
                    .padding(.horizontal, 24)

                Spacer(minLength: 0)

                ctaRow
                    .frame(height: 50)
                    .padding(.bottom, 24)

                NumberPad(
                    isDecimalDisabled: vm.isDecimalDisabled,
                    isBackspaceDisabled: vm.isBackspaceDisabled,
                    onTap: { vm.tap($0) }
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 12)
            }
        }
        .sensoryFeedback(.impact(weight: .light), trigger: vm.tapCount)
    }

    // MARK: Top bar

    private var topBar: some View {
        HStack {
            BackButton {
                // No navigation stack in this take-home; dismiss is a no-op.
            }
            Spacer()
        }
        .overlay {
            AutomatedBadge()
        }
    }

    // MARK: CTA — chips ↔ Review

    @ViewBuilder
    private var ctaRow: some View {
        ZStack {
            if vm.showChips {
                chipsRow
            } else {
                reviewRow
            }
        }
        .animation(.spring(response: 0.45, dampingFraction: 0.82), value: vm.showChips)
    }

    private var chipsRow: some View {
        HStack(spacing: 12) {
            QuickAmountChip(amount: 500) { vm.tap(quickAmount: 500) }
                .transition(.scale(scale: 0.85).combined(with: .opacity))

            QuickAmountChip(amount: 2_000) { vm.tap(quickAmount: 2_000) }
                .matchedGeometryEffect(id: Self.morphID, in: morph)

            QuickAmountChip(amount: 10_000) { vm.tap(quickAmount: 10_000) }
                .transition(.scale(scale: 0.85).combined(with: .opacity))
        }
    }

    private var reviewRow: some View {
        ZStack {
            AllieGlow()
                .frame(width: 345, height: 50)
                .transition(.opacity.combined(with: .scale(scale: 0.85)))

            ReviewButton(isEnabled: vm.canReview) {
                // Submit action — not part of this take-home.
            }
            .matchedGeometryEffect(id: Self.morphID, in: morph)
        }
    }

    private static let morphID = "primaryCTA"
}

#Preview {
    AmountEntryView()
}
