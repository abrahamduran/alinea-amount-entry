//
//  AlineaApp.swift
//  Alinea
//
//  Created by Abraham Duran on 20/5/26.
//

import DesignSystem
import SwiftUI

@main
struct AlineaApp: App {
    init() {
        FontRegistration.registerOnce()
    }

    var body: some Scene {
        WindowGroup {
            AmountEntryView()
        }
    }
}
