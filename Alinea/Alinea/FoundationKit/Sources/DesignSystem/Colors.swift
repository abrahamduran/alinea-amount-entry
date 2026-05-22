//
//  Colors.swift
//  DesignSystem
//
//  Created by Abraham Duran on 20/5/26.
//

import SwiftUI

// MARK: - Semantic Color System

/// Semantic color system for the Alinea amount-entry screen.
///
/// ## Usage
/// ```
/// Text("$0").foregroundStyle(.textPlaceholder)
/// RoundedRectangle(cornerRadius: 22).fill(.backgroundChip)
/// ```
public extension Color {
    // MARK: Background

    /// Background colors for surfaces.
    enum Background {
        /// App screen background (#18161F).
        public static let screen = Color(.Background.screen)

        /// Quick-amount chip fill (#23212C at 75% opacity).
        public static let chip = Color(.Background.chip)
        /// Review button (solid white).
        public static let button = Color(.Background.button)
    }

    // MARK: Text

    /// Text colors for the amount display, chips, buttons, and badge.
    enum Text {
        /// Primary text (white).
        public static let primary = Color(.Text.primary)

        /// Faded placeholder in the empty state (40% white).
        public static let placeholder = Color(.Text.primary).opacity(0.04)

        /// Dark text on the white Review button (#22212D).
        public static let inverse = Color(.Text.inverse)
    }

    // MARK: Brand

    /// Brand-gradient stops used by the Review button halo and AUTOMATED badge stroke.
    enum Brand {
        /// Magenta (#B24DCC) — `main/brand`.
        public static let gradientStart = Color(.Brand.gradientStart)

        /// Iris (#8955F9) — `strategies/st01`.
        public static let gradientEnd = Color(.Brand.gradientEnd)

        /// Blue (#2073DF) — `strategies/st03`.
        public static let gradientBlue = Color(.Brand.gradientBlue)

        /// Yellow (#FFEE59) — `main/accent`.
        public static let gradientAccent = Color(.Brand.gradientAccent)
    }
}

// MARK: - ShapeStyle Shorthand

/// Flat `ShapeStyle` shorthand so call sites can use leading-dot syntax
/// in SwiftUI modifiers that take a `ShapeStyle`.
///
/// ## Usage
/// ```
/// Circle().fill(.brandGradientStart)
/// Text("Review").foregroundStyle(.textInverse)
/// ```
public extension ShapeStyle where Self == Color {
    // MARK: Background
    static var backgroundScreen: Color { Color.Background.screen }
    static var backgroundChip: Color { Color.Background.chip }
    static var backgroundButton: Color { Color.Background.button }

    // MARK: Text
    static var textPrimary: Color { Color.Text.primary }
    static var textPlaceholder: Color { Color.Text.placeholder }
    static var textInverse: Color { Color.Text.inverse }

    // MARK: Brand
    static var brandGradientStart: Color { Color.Brand.gradientStart }
    static var brandGradientEnd: Color { Color.Brand.gradientEnd }
    static var brandGradientBlue: Color { Color.Brand.gradientBlue }
    static var brandGradientAccent: Color { Color.Brand.gradientAccent }
}

// MARK: - Brand Gradient

/// Ready-to-use brand gradient (purple → iris, leading → trailing).
///
/// ## Usage
/// ```
/// RoundedRectangle(cornerRadius: 25).fill(.brandGradient)
/// ```
public extension ShapeStyle where Self == LinearGradient {
    static var brandGradient: LinearGradient {
        LinearGradient(
            colors: [.Brand.gradientStart, .Brand.gradientEnd],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}
