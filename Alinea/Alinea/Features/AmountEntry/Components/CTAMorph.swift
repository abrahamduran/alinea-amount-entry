//
//  CTAMorph.swift
//  Alinea
//
//  Created by Abraham Duran on 21/5/26.
//
//  All variants share:
//   • Same spring (response 0.45, dampingFraction 0.82) for a single
//     choreography signature across the screen.
//   • Same Namespace so matched-geometry IDs remain consistent.
//   • Same AllieGlow layered behind ReviewButton.
//

import DesignSystem
import SwiftUI

public enum CTAMorphStyle: String, CaseIterable, Identifiable, Sendable {
    /// Center chip ($2,000) matched-geometry-morphs into Review.
    /// Side chips scale + fade. Cleanest, least visual noise.
    case centerMorph

    /// All three chips converge toward center while scaling down;
    /// Review blooms from a smaller scale at the same time.
    /// More theatrical, reads as "options collapsing into a decision."
    case converge

    /// Chips fade and drop a few points; Review slides up from below
    /// with the glow blooming behind it. Two-beat, most cinematic.
    case swoop

    /// Single-view morph: the middle slot is a `MorphingCTA` whose
    /// `progress: Double` drives every channel (width, fill, foreground,
    /// label opacity, padding) under one spring. Side chips collapse their
    /// width to zero so the HStack reflow grows the middle naturally.
    case morphingView

    public var id: String { rawValue }
}

public struct CTAMorph: View {

    public let style: CTAMorphStyle
    public let showChips: Bool
    public let canReview: Bool
    public let onChipTap: (Int) -> Void
    public let onReview: () -> Void

    @Namespace private var morph
    private static let morphID = "primaryCTA"

    public init(
        style: CTAMorphStyle,
        showChips: Bool,
        canReview: Bool,
        onChipTap: @escaping (Int) -> Void,
        onReview: @escaping () -> Void
    ) {
        self.style = style
        self.showChips = showChips
        self.canReview = canReview
        self.onChipTap = onChipTap
        self.onReview = onReview
    }

    public var body: some View {
        Group {
            if style == .morphingView {
                morphingRow
            } else {
                ZStack {
                    if showChips {
                        chips
                    } else {
                        review
                    }
                }
            }
        }
        .frame(height: 50, alignment: .center)
        .animation(spring.speed(0.6), value: showChips)
    }

    // Delegates to the shipped `QuickAmountCTA` so the harness A/Bs
    // against production, not a copy.
    private var morphingRow: some View {
        QuickAmountCTA(
            showChips: showChips,
            canReview: canReview,
            onChipTap: onChipTap,
            onReview: onReview
        )
    }

    private var spring: Animation {
        .spring(response: 0.45, dampingFraction: 0.82)
    }

    // MARK: - Chips

    @ViewBuilder
    private var chips: some View {
        switch style {
        case .centerMorph:
            // Equal-width slots so the middle chip's geometric center
            // lands exactly at parent center — otherwise asymmetric
            // text widths ($500 vs $10,000) shift the HStack and the
            // return morph reads as "chip appears from the right."
            HStack(spacing: 12) {
                chip(500)
                    .frame(maxWidth: .infinity)
                    .transition(sideTransition)
                chip(2_000)
                    .frame(maxWidth: .infinity)
                    .matchedGeometryEffect(id: Self.morphID, in: morph)
                chip(10_000)
                    .frame(maxWidth: .infinity)
                    .transition(sideTransition)
            }

        case .converge:
            HStack(spacing: 12) {
                chip(500).transition(convergeTransition(from: .leading))
                chip(2_000).transition(convergeTransition(from: .center))
                chip(10_000).transition(convergeTransition(from: .trailing))
            }

        case .swoop:
            HStack(spacing: 12) {
                chip(500)
                chip(2_000)
                chip(10_000)
            }
            .transition(.move(edge: .top).combined(with: .opacity))

        case .morphingView:
            // Handled by `morphingRow`, never reached here.
            EmptyView()
        }
    }

    private func chip(_ amount: Int) -> some View {
        QuickAmountChip(amount: amount) { onChipTap(amount) }
    }

    private var sideTransition: AnyTransition {
        .scale(scale: 0.5).combined(with: .opacity)
    }

    /// Collapse each chip toward the screen's horizontal center.
    /// Side chips travel further than the middle one.
    private func convergeTransition(from origin: HorizontalEdge) -> AnyTransition {
        let dx: CGFloat
        switch origin {
        case .leading:  dx = 80
        case .trailing: dx = -80
        case .center:   dx = 0
        }
        return .asymmetric(
            insertion: .offset(x: dx).combined(with: .opacity).combined(with: .scale(scale: 0.6)),
            removal:   .offset(x: dx).combined(with: .opacity).combined(with: .scale(scale: 0.6))
        )
    }

    private enum HorizontalEdge { case leading, center, trailing }

    // MARK: - Review

    @ViewBuilder
    private var review: some View {
        switch style {
        case .centerMorph:
            reviewLayered
                .matchedGeometryEffect(id: Self.morphID, in: morph)

        case .converge:
            reviewLayered
                .transition(.scale(scale: 0.7).combined(with: .opacity))

        case .swoop:
            reviewLayered
                .transition(.move(edge: .bottom).combined(with: .opacity))

        case .morphingView:
            // Handled by `morphingRow`, never reached here.
            EmptyView()
        }
    }

    private var reviewLayered: some View {
        ZStack {
            AllieGlow(style: .mesh)

            ReviewButton(isEnabled: canReview, action: onReview)
        }
    }
}

// MARK: - Preview harness

/// Auto-toggles `showChips` every 1.6s so you can watch each variant
/// loop forwards and backwards. Use the segmented control to compare.
#Preview("All variants") {
    @Previewable @State var style: CTAMorphStyle = .centerMorph
    @Previewable @State var showChips: Bool = true

    return VStack(spacing: 32) {
        Picker("Style", selection: $style) {
            ForEach(CTAMorphStyle.allCases) { s in
                Text(s.rawValue).tag(s)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)

        Spacer()

        CTAMorph(
            style: style,
            showChips: showChips,
            canReview: true,
            onChipTap: { _ in },
            onReview: {}
        )
        .padding(.horizontal, 24)

        Spacer()

        Button(showChips ? "Tap chip → Review" : "Backspace → Chips") {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.82).speed(0.6)) {
                showChips.toggle()
            }
        }
        .padding(.bottom, 24)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.Background.screen)
}
