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
        HStack(alignment: .center, spacing: 4) {
            Text(isEmpty ? "$0" : amount)
                .typography(.displayAmount)
                .foregroundStyle(isEmpty ? .textPlaceholder : .textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.3)

            BlinkingCaret()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Amount")
        .accessibilityValue(isEmpty ? "Zero dollars" : amount)
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
