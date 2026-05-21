//
//  BlinkingCaret.swift
//  Alinea
//
//  Created by Abraham Duran on 20/5/26.
//
//  Pure-SwiftUI blinking caret. Uses TimelineView(.periodic) so the
//  blink runs on the SwiftUI run loop without a Timer or @State.
//

import DesignSystem
import SwiftUI

public struct BlinkingCaret: View {

    public var width: CGFloat = 3
    public var height: CGFloat = 106
    public var period: TimeInterval = 0.5

    public init(width: CGFloat = 3, height: CGFloat = 106, period: TimeInterval = 0.5) {
        self.width = width
        self.height = height
        self.period = period
    }

    public var body: some View {
        TimelineView(.periodic(from: .now, by: period)) { ctx in
            let phase = Int(ctx.date.timeIntervalSinceReferenceDate / period) % 2
            Rectangle()
                .fill(.textPrimary)
                .frame(width: width, height: height)
                .opacity(phase == 0 ? 1 : 0)
                .animation(.easeInOut(duration: 0.15), value: phase)
        }
        .accessibilityHidden(true)
    }
}

#Preview {
    BlinkingCaret()
        .padding(40)
        .background(Color.Background.screen)
}
