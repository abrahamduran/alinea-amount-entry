//
//  AmountEntryViewModel.swift
//  Alinea
//
//  Created by Abraham Duran on 20/5/26.
//

import Foundation
import Observation

@MainActor
@Observable
public final class AmountEntryViewModel {

    private var input = AmountInputModel()

    /// Incremented on every accepted tap. Bind `.sensoryFeedback` to this
    /// so haptics fire once per interaction without leaking UIKit imports.
    public private(set) var tapCount: Int = 0

    public init() {}

    // MARK: Surface state

    /// Formatted amount for the display. `""` when empty — the View renders
    /// the `$0` placeholder so this stays a pure format of real input.
    public var displayAmount: String { AmountFormatter.format(input.enteredText) }

    public var isEmpty: Bool { input.isEmpty }
    public var showChips: Bool { input.isEmpty }
    public var canReview: Bool { input.canReview }
    public var isDecimalDisabled: Bool { input.isDecimalDisabled }
    public var isBackspaceDisabled: Bool { input.isBackspaceDisabled }

    // MARK: Intents

    public func tap(_ key: NumberPadKey) {
        switch key {
        case .digit(let d): input.append(digit: d)
        case .decimal:      input.appendDecimal()
        case .backspace:    input.backspace()
        }
        bumpTap()
    }

    public func tap(quickAmount amount: Int) {
        input.set(amount: amount)
        bumpTap()
    }

    // MARK: Internals

    private func bumpTap() { tapCount &+= 1 }
}
