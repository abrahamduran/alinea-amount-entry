//
//  Typography.swift
//  DesignSystem
//
//  Created by Abraham Duran on 20/5/26.
//

import SwiftUI

public enum Typography: String, CaseIterable, Sendable {
    case displayAmount
    case titleMedium
    case buttonLabel
    case chipLabel
    case keypadDigit
    case badge

    public var fontSize: CGFloat {
        switch self {
        case .displayAmount: 100
        case .titleMedium:   24
        case .buttonLabel:   21
        case .chipLabel:     17
        case .keypadDigit:   37
        case .badge:         12
        }
    }

    public var tracking: CGFloat {
        switch self {
        case .displayAmount: -2.0
        case .titleMedium:   -0.72
        case .buttonLabel:   -0.64
        case .chipLabel:     -0.17
        case .keypadDigit:   -1.1
        case .badge:         0
        }
    }

    public var textCase: SwiftUI.Text.Case? {
        switch self {
        case .badge: .uppercase
        default:     nil
        }
    }

    public var textStyle: Font.TextStyle {
        switch self {
        case .displayAmount: .largeTitle
        case .titleMedium:   .title2
        case .buttonLabel:   .headline
        case .chipLabel:     .callout
        case .keypadDigit:   .title
        case .badge:         .caption
        }
    }

    public var font: Font {
        switch self {
        case .displayAmount:
            .custom("GTFlexa-CnMd", size: fontSize, relativeTo: textStyle).leading(.tight)
        case .titleMedium, .buttonLabel:
            .custom("GTFlexa-CnMd", size: fontSize, relativeTo: textStyle)
        case .chipLabel, .badge:
            .custom("InstrumentSansSemiCondensed-Medium", size: fontSize, relativeTo: textStyle)
        case .keypadDigit:
            .system(size: fontSize, weight: .medium).width(.condensed)
        }
    }
}
