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

                QuickAmountCTA(
                    showChips: vm.showChips,
                    canReview: vm.canReview,
                    onChipTap: { vm.tap(quickAmount: $0) },
                    onReview: {
                        // Submit action — not part of this take-home.
                    }
                )
                .padding(.horizontal, 24)
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

}

#Preview {
    AmountEntryView()
}
