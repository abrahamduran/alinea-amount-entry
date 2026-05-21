//
//  QuickAmountChip.swift
//  Alinea
//
//  Created by Abraham Duran on 20/5/26.
//

import DesignSystem
import SwiftUI

public struct QuickAmountChip: View {

    public let amount: Int
    public let action: () -> Void

    public init(amount: Int, action: @escaping () -> Void) {
        self.amount = amount
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(label)
                .typography(.chipLabel)
                .foregroundStyle(.textPrimary)
                .frame(width: 96, height: 44)
                .background(.backgroundChip, in: .capsule)
                .contentShape(.capsule)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Quick amount \(label)")
    }

    private var label: String {
        "$" + amount.formatted(.number)
    }
}

#Preview {
    HStack(spacing: 12) {
        QuickAmountChip(amount: 500) {}
        QuickAmountChip(amount: 2_000) {}
        QuickAmountChip(amount: 10_000) {}
    }
    .padding(40)
    .background(.backgroundScreen)
}
