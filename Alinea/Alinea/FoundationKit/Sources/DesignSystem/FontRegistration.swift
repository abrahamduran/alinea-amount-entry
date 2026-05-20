//
//  FontRegistration.swift
//  DesignSystem
//
//  Created by Abraham Duran on 20/5/26.
//

import CoreText
import Foundation

public enum FontRegistration {
    public static func registerOnce() { _ = once }

    private static let once: Void = {
        let names = [
            "GTFlexa-CnMd",
            "InstrumentSansSemiCondensed-Medium",
        ]
        for name in names {
            let url = Bundle.module.url(forResource: name, withExtension: "otf")
                ?? Bundle.module.url(forResource: name, withExtension: "ttf")
            guard let url else { continue }
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }()
}
