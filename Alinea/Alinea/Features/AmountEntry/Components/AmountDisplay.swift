//
//  AmountDisplay.swift
//  Alinea
//
//  Created by Abraham Duran on 20/5/26.
//

import DesignSystem
import SwiftUI

public struct AmountDisplay: View {

    public let amount: String
    public let isEmpty: Bool

    public init(amount: String, isEmpty: Bool) {
        self.amount = amount
        self.isEmpty = isEmpty
    }

    public var body: some View {
        ZStack {
            if isEmpty {
                placeholder
                    .transition(.opacity.combined(with: .scale(scale: 1.04)))
            }
            HStack(alignment: .center, spacing: 4) {
                Text(amount)
                    .typography(.displayAmount)
                    .foregroundStyle(.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
                    .contentTransition(.numericText())

                BlinkingCaret()
            }
        }
        .animation(.smooth(duration: 0.25), value: isEmpty)
        .animation(.snappy(duration: 0.2), value: amount)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Amount")
        .accessibilityValue(isEmpty ? "Zero dollars" : amount)
    }

    private var placeholder: some View {
        Text("$0")
            .typography(.displayAmount)
            .foregroundStyle(.textPlaceholder)
    }
}

#Preview("Empty") {
    AmountDisplay(amount: "", isEmpty: true)
        .padding(40)
        .background(Color.Background.screen)
}

#Preview("Filled") {
    AmountDisplay(amount: "$2,000.12", isEmpty: false)
        .padding(40)
        .background(Color.Background.screen)
}
