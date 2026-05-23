//
//  AmountFormatter.swift
//  Alinea
//
//  Created by Abraham Duran on 20/5/26.
//
//  Renders the raw input buffer for display. Custom rather than
//  `Decimal.FormatStyle.currency` so the in-progress shape — a freshly
//  typed `.` or a single decimal digit — survives without being padded
//  to `.00`.
//

import Foundation

public nonisolated enum AmountFormatter {

    /// Formats the raw input buffer for the amount display.
    /// Returns `""` for empty input — the View renders the `$0`
    /// placeholder so this stays purely a formatter, not a synthesizer.
    ///
    ///     ""        → ""
    ///     "0"       → "$0"
    ///     "2000"    → "$2,000"
    ///     "2000."   → "$2,000."
    ///     "2000.5"  → "$2,000.5"
    ///     "2000.12" → "$2,000.12"
    public static func format(_ raw: String) -> String {
        guard !raw.isEmpty else { return "" }

        let parts = raw.split(separator: ".", maxSplits: 1, omittingEmptySubsequences: false)
        let integerString = parts[0].isEmpty ? "0" : String(parts[0])
        let integerDecimal = Decimal(string: integerString) ?? 0
        let groupedInteger = integerDecimal.formatted(.number.grouping(.automatic))

        let decimalPart: String
        if parts.count > 1 {
            decimalPart = "." + String(parts[1])
        } else {
            decimalPart = ""
        }

        return "$" + groupedInteger + decimalPart
    }
}
