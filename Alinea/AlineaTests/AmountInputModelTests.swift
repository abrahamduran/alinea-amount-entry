//
//  AmountInputModelTests.swift
//  AlineaTests
//
//  Created by Abraham Duran on 20/5/26.
//

import Testing
@testable import Alinea

@Suite("AmountInputModel")
struct AmountInputModelTests {

    // MARK: Empty state

    @Test func emptyStateIsEmpty() {
        let model = AmountInputModel()
        #expect(model.isEmpty)
        #expect(model.enteredText == "")
        #expect(!model.canReview)
        #expect(!model.isDecimalDisabled)
    }

    @Test func zeroIsSuppressedWhenEmpty() {
        var model = AmountInputModel()
        model.append(digit: 0)
        #expect(model.enteredText == "")
        #expect(model.isEmpty)
    }

    @Test func nonZeroDigitReplacesEmpty() {
        var model = AmountInputModel()
        model.append(digit: 5)
        #expect(model.enteredText == "5")
        #expect(!model.isEmpty)
    }

    // MARK: Lone-zero replacement

    @Test func loneZeroIsReplacedByNonZeroDigit() {
        var model = AmountInputModel()
        // The only path to a lone "0" without a dot: type ".", then backspace.
        model.appendDecimal()          // "0."
        model.backspace()              // "0"
        model.append(digit: 5)         // should replace, not become "05"
        #expect(model.enteredText == "5")
    }

    // MARK: Decimal handling

    @Test func decimalAtStartProducesZeroPoint() {
        var model = AmountInputModel()
        model.appendDecimal()
        #expect(model.enteredText == "0.")
        #expect(model.isDecimalDisabled)
    }

    @Test func secondDecimalIsBlocked() {
        var model = AmountInputModel()
        model.append(digit: 5)
        model.appendDecimal()
        model.appendDecimal()
        #expect(model.enteredText == "5.")
    }

    @Test func maxTwoDecimalPlaces() {
        var model = AmountInputModel()
        model.append(digit: 5)
        model.appendDecimal()
        model.append(digit: 1)
        model.append(digit: 2)
        model.append(digit: 3) // should be rejected
        #expect(model.enteredText == "5.12")
    }

    @Test func decimalDisabledWhenAlreadyPresent() {
        var model = AmountInputModel()
        #expect(!model.isDecimalDisabled)
        model.appendDecimal()
        #expect(model.isDecimalDisabled)
    }

    // MARK: Backspace

    @Test func backspaceOnEmptyIsNoOp() {
        var model = AmountInputModel()
        model.backspace()
        #expect(model.enteredText == "")
    }

    @Test func backspaceDisabledMatchesEmptiness() {
        var model = AmountInputModel()
        #expect(model.isBackspaceDisabled)
        model.append(digit: 5)
        #expect(!model.isBackspaceDisabled)
        model.backspace()
        #expect(model.isBackspaceDisabled)
    }

    @Test func backspaceRemovesLastChar() {
        var model = AmountInputModel()
        model.append(digit: 1)
        model.append(digit: 2)
        model.appendDecimal()
        model.append(digit: 5)
        model.backspace()
        #expect(model.enteredText == "12.")
        model.backspace()
        #expect(model.enteredText == "12")
        #expect(!model.isDecimalDisabled)
    }

    // MARK: Quick amounts

    @Test func quickAmountReplacesInput() {
        var model = AmountInputModel()
        model.append(digit: 7)
        model.append(digit: 7)
        model.set(amount: 2000)
        #expect(model.enteredText == "2000")
    }

    // MARK: Review gating

    @Test func canReviewOnlyWithPositiveAmount() {
        var model = AmountInputModel()
        #expect(!model.canReview)

        model.appendDecimal()      // "0."
        #expect(!model.canReview)

        model.append(digit: 0)     // "0.0"
        #expect(!model.canReview)

        model.append(digit: 1)     // "0.01"
        #expect(model.canReview)
    }
}
