//
//  TypographyModifier.swift
//  DesignSystem
//
//  Created by Abraham Duran on 20/5/26.
//

import SwiftUI

public struct TypographyModifier: ViewModifier {
    public let style: Typography

    public init(style: Typography) {
        self.style = style
    }

    public func body(content: Content) -> some View {
        content
            .font(style.font)
            .tracking(style.tracking)
            .textCase(style.textCase)
    }
}

public extension View {
    func typography(_ style: Typography) -> some View {
        modifier(TypographyModifier(style: style))
    }
}
