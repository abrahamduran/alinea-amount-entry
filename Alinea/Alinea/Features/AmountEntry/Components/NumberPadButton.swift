//
//  NumberPadButton.swift
//  Alinea
//
//  Created by Abraham Duran on 20/5/26.
//

import DesignSystem
import SwiftUI

public struct NumberPadButton: View {

    public let key: NumberPadKey
    public let isDisabled: Bool
    public let action: () -> Void

    @State private var holdTask: Task<Void, Never>?

    public init(key: NumberPadKey, isDisabled: Bool = false, action: @escaping () -> Void) {
        self.key = key
        self.isDisabled = isDisabled
        self.action = action
    }

    public var body: some View {
        switch key {
        case .backspace:
            backspaceContent
        default:
            tapButton
        }
    }

    // MARK: Regular tap (digits and decimal)

    private var tapButton: some View {
        Button(action: action) {
            label
                .typography(.keypadDigit)
                .foregroundStyle(.textPrimary)
                .frame(maxWidth: .infinity, minHeight: 56)
                .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.35 : 1)
        .animation(.easeInOut(duration: 0.15), value: isDisabled)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityAddTraits(.isKeyboardKey)
    }

    // MARK: Hold-to-repeat (backspace)
    //
    // First tap fires immediately on touch-down (responsive feel),
    // then a 400ms hold threshold starts a repeat at ~14 Hz. Using a
    // DragGesture(minimumDistance: 0) rather than a Button so we own
    // the press/release lifecycle and can cancel the loop cleanly.

    private var backspaceContent: some View {
        label
            .typography(.keypadDigit)
            .foregroundStyle(.textPrimary)
            .frame(maxWidth: .infinity, minHeight: 56)
            .contentShape(.rect)
            .opacity(isDisabled ? 0.35 : 1)
            .animation(.easeInOut(duration: 0.15), value: isDisabled)
            .gesture(holdGesture)
            .accessibilityElement()
            .accessibilityLabel(accessibilityLabel)
            .accessibilityAddTraits([.isButton, .isKeyboardKey])
            .accessibilityAction { action() }
    }

    private var holdGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { _ in
                guard !isDisabled, holdTask == nil else { return }
                action()
                holdTask = Task { @MainActor in
                    try? await Task.sleep(for: .milliseconds(400))
                    guard !Task.isCancelled else { return }
                    while !Task.isCancelled {
                        action()
                        try? await Task.sleep(for: .milliseconds(70))
                    }
                }
            }
            .onEnded { _ in
                holdTask?.cancel()
                holdTask = nil
            }
    }

    // MARK: Label + a11y

    @ViewBuilder
    private var label: some View {
        switch key {
        case .digit(let d):
            Text(String(d))
        case .decimal:
            Text(".")
        case .backspace:
            Image(systemName: "delete.left.fill")
                .imageScale(.small)
        }
    }

    private var accessibilityLabel: String {
        switch key {
        case .digit(let d): "Digit \(d)"
        case .decimal:      "Decimal point"
        case .backspace:    "Backspace"
        }
    }
}

#Preview {
    VStack {
        NumberPadButton(key: .digit(5)) {}
        NumberPadButton(key: .decimal, isDisabled: true) {}
        NumberPadButton(key: .backspace) {}
    }
    .padding(40)
    .background(Color.Background.screen)
}
