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
                .shadow(color: .textPrimary.opacity(0.10), radius: 4.73)
                .contentShape(.capsule)
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .accessibilityLabel("Review")
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
