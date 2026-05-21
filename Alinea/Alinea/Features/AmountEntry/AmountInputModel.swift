//
//  AmountInputModel.swift
//  Alinea
//
//  Created by Abraham Duran on 20/5/26.
//
//  Pure value-type holding every input rule for the amount-entry screen.
//  Free of SwiftUI so the rules are unit-testable in isolation.
//

import Foundation

public struct AmountInputModel: Equatable, Sendable {

    /// Maximum decimal places allowed past the dot (per Ryan, May 20).
    public static let maxDecimalPlaces = 2

    /// Raw entry buffer — digits, an optional `.`, up to 2 fractional digits.
    /// Never contains a leading zero (except the lone `"0."` form).
    public private(set) var enteredText: String = ""

    public init() {}

    // MARK: Derived

    public var isEmpty: Bool { enteredText.isEmpty }
    public var isDecimalDisabled: Bool { enteredText.contains(".") }

    /// Review CTA is enabled only when a positive amount has been entered.
    public var canReview: Bool {
        guard !enteredText.isEmpty else { return false }
        return (Decimal(string: enteredText) ?? 0) > 0
    }

    // MARK: Intents

    public mutating func append(digit: Int) {
        precondition((0...9).contains(digit), "digit must be 0-9")

        if enteredText.isEmpty {
            // Suppress a leading zero so the display stays `$0` rather than `$00`.
            guard digit != 0 else { return }
            enteredText = String(digit)
            return
        }

        if let dotIndex = enteredText.firstIndex(of: ".") {
            let afterDot = enteredText.distance(from: dotIndex, to: enteredText.endIndex) - 1
            guard afterDot < Self.maxDecimalPlaces else { return }
            enteredText.append(String(digit))
            return
        }

        if enteredText == "0" {
            // Replace the lone zero with the new digit.
            enteredText = String(digit)
        } else {
            enteredText.append(String(digit))
        }
    }

    public mutating func appendDecimal() {
        guard !enteredText.contains(".") else { return }
        enteredText.append(enteredText.isEmpty ? "0." : ".")
    }

    public mutating func backspace() {
        guard !enteredText.isEmpty else { return }
        enteredText.removeLast()
    }

    /// Quick-amount chip selection. Whole-dollar amounts only.
    public mutating func set(amount: Int) {
        precondition(amount >= 0, "amount must be non-negative")
        enteredText = String(amount)
    }
}
