//
//  NumberPadKey.swift
//  Alinea
//
//  Created by Abraham Duran on 20/5/26.
//

import Foundation

public enum NumberPadKey: Hashable, Sendable {
    case digit(Int)
    case decimal
    case backspace
}
