//
//  NumberPadButton.swift
//  Alinea
//
//  Created by Abraham Duran on 20/5/26.
//

import DesignSystem
import SwiftUI

public struct NumberPadButton: View {

    public let key: NumberPadKey
    public let isDisabled: Bool
    public let action: () -> Void

    public init(key: NumberPadKey, isDisabled: Bool = false, action: @escaping () -> Void) {
        self.key = key
        self.isDisabled = isDisabled
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            label
                .typography(.keypadDigit)
                .foregroundStyle(.textPrimary)
                .frame(maxWidth: .infinity, minHeight: 56)
                .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.35 : 1)
        .animation(.easeInOut(duration: 0.15), value: isDisabled)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityAddTraits(.isKeyboardKey)
    }

    @ViewBuilder
    private var label: some View {
        switch key {
        case .digit(let d):
            Text(String(d))
        case .decimal:
            Text(".")
        case .backspace:
            Image(systemName: "delete.left.fill")
                .imageScale(.small)
        }
    }

    private var accessibilityLabel: String {
        switch key {
        case .digit(let d): "Digit \(d)"
        case .decimal:      "Decimal point"
        case .backspace:    "Backspace"
        }
    }
}

#Preview {
    VStack {
        NumberPadButton(key: .digit(5)) {}
        NumberPadButton(key: .decimal, isDisabled: true) {}
        NumberPadButton(key: .backspace) {}
    }
    .padding(40)
    .background(Color.Background.screen)
}
