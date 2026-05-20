//
//  ContentView.swift
//  Alinea
//
//  Created by Abraham Duran on 20/5/26.
//

import DesignSystem
import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.Background.screen
                .ignoresSafeArea()

            VStack(spacing: 32) {
                Text("AUTOMATED")
                    .typography(.badge)
                    .foregroundStyle(.textPrimary)

                Text("$2,000")
                    .typography(.displayAmount)
                    .foregroundStyle(.textPrimary)

                Text("$500")
                    .typography(.chipLabel)
                    .foregroundStyle(.textPrimary)
                    .frame(width: 96, height: 44)
                    .background(.backgroundChip, in: .capsule)

                Text("Review")
                    .typography(.buttonLabel)
                    .foregroundStyle(.textInverse)
                    .frame(width: 345, height: 50)
                    .background(.backgroundButton, in: .capsule)

                Capsule()
                    .fill(.brandGradient)
                    .frame(width: 345, height: 8)
            }
        }
    }
}

#Preview {
    ContentView()
}
