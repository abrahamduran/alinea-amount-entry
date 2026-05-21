//
//  BackButton.swift
//  DesignSystem
//
//  Created by Abraham Duran on 20/5/26.
//

import SwiftUI

public struct BackButton: View {
    private let action: () -> Void

    public init(action: @escaping () -> Void) {
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.textPrimary)
                .frame(width: 36, height: 36)
                .glassEffect(.regular, in: .circle)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Back")
    }
}

#Preview {
    BackButton(action: {})
        .padding(40)
        .background(Color.Background.screen)
}
