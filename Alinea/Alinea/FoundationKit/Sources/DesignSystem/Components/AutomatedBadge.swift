//
//  AutomatedBadge.swift
//  DesignSystem
//
//  Created by Abraham Duran on 20/5/26.
//

import SwiftUI

public struct AutomatedBadge: View {
    public init() {}

    public var body: some View {
        Image(.automated)
            .resizable()
            .scaledToFit()
            .frame(height: 20)
            .accessibilityLabel("Automated")
    }
}

#Preview {
    AutomatedBadge()
        .padding(40)
        .background(Color.Background.screen)
}
