//
//  NumberPad.swift
//  Alinea
//
//  Created by Abraham Duran on 20/5/26.
//

import DesignSystem
import SwiftUI

public struct NumberPad: View {

    public let isDecimalDisabled: Bool
    public let isBackspaceDisabled: Bool
    public let isDigitDisabled: Bool
    public let onTap: (NumberPadKey) -> Void

    public init(
        isDecimalDisabled: Bool,
        isBackspaceDisabled: Bool,
        isDigitDisabled: Bool = false,
        onTap: @escaping (NumberPadKey) -> Void
    ) {
        self.isDecimalDisabled = isDecimalDisabled
        self.isBackspaceDisabled = isBackspaceDisabled
        self.isDigitDisabled = isDigitDisabled
        self.onTap = onTap
    }

    public var body: some View {
        Grid(horizontalSpacing: 24, verticalSpacing: 12) {
            ForEach(rows, id: \.self) { row in
                GridRow {
                    ForEach(row, id: \.self) { key in
                        NumberPadButton(
                            key: key,
                            isDisabled: isDisabled(key),
                            action: { onTap(key) }
                        )
                    }
                }
            }
        }
    }

    private func isDisabled(_ key: NumberPadKey) -> Bool {
        switch key {
        case .decimal:   isDecimalDisabled
        case .backspace: isBackspaceDisabled
        case .digit:     isDigitDisabled
        }
    }

    private let rows: [[NumberPadKey]] = [
        [.digit(1), .digit(2), .digit(3)],
        [.digit(4), .digit(5), .digit(6)],
        [.digit(7), .digit(8), .digit(9)],
        [.decimal, .digit(0), .backspace],
    ]
}

#Preview {
    NumberPad(isDecimalDisabled: false, isBackspaceDisabled: true) { _ in }
        .padding(.horizontal, 40)
        .padding(.vertical, 40)
        .background(Color.Background.screen)
}
