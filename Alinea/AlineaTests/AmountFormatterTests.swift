//
//  AmountFormatterTests.swift
//  AlineaTests
//
//  Created by Abraham Duran on 20/5/26.
//

import Testing
@testable import Alinea

@Suite("AmountFormatter")
struct AmountFormatterTests {

    @Test func emptyReturnsEmpty() {
        // The View renders the "$0" placeholder; the formatter
        // only formats real input.
        #expect(AmountFormatter.format("") == "")
    }

    @Test func loneZeroShowsZero() {
        #expect(AmountFormatter.format("0") == "$0")
    }

    @Test func groupsThousands() {
        #expect(AmountFormatter.format("2000") == "$2,000")
        #expect(AmountFormatter.format("1234567") == "$1,234,567")
    }

    @Test func preservesUpToTwoDecimals() {
        #expect(AmountFormatter.format("2000.5") == "$2,000.5")
        #expect(AmountFormatter.format("2000.12") == "$2,000.12")
    }

    @Test func preservesTrailingDot() {
        #expect(AmountFormatter.format("2000.") == "$2,000.")
    }

    @Test func preservesTrailingZeroAfterDot() {
        // "2000.10" must NOT collapse to "$2,000.1" — the user typed
        // the trailing zero intentionally.
        #expect(AmountFormatter.format("2000.10") == "$2,000.10")
    }
}
