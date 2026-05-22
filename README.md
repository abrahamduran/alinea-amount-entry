# Alinea Amount Entry

Take-home for **Alinea Invest** (LATAM Full-Stack iOS Product Engineer):
a single-screen amount-entry UI ported from a Figma design.

Built in SwiftUI for iOS 26.2 / Swift 6 (strict concurrency). No UIKit,
no third-party dependencies.

---

## Build & run

Open `Alinea/Alinea.xcodeproj`, select the `Alinea` scheme, run on an
iOS 26.2 simulator (iPhone 16 Pro or 17 Pro both fine).

```bash
xcodebuild -project Alinea/Alinea.xcodeproj -scheme Alinea \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build

xcodebuild -project Alinea/Alinea.xcodeproj -scheme Alinea \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' test
```

SwiftUI Previews are the primary iteration surface — most components
ship multiple `#Preview` blocks for visual diffing.

---

## Highlights

**The chips → Review morph** (`MorphingCTA` + `QuickAmountCTA`) is the
piece worth opening Xcode for. It's a *single view* whose appearance
is driven by `progress: Double` (0 = chip, 1 = button) using the
iOS 26 `@Animatable` macro. Fill color, foreground color, vertical
padding, and the chip/Review label opacities all interpolate under
one spring, so the morph reads as one capsule transforming rather
than two views crossfading. See [Design notes](#design-notes) for the
trade-off vs `matchedGeometryEffect`.

**The Allie halo** (`AllieGlow`) is a two-layer brand-gradient wash
behind the Review pill. The default `.angular` style is a cheap
rotating conic; the bonus `.mesh` style is a `MeshGradient` whose
edge midpoints and center drift on independent sine phases with
irrational frequency ratios so the wash never repeats cleanly.
Each cell's color cycles through the brand palette via `Color.mix`,
phase-offset so neighbours never sit on the same hue at once.

**`CTAMorph`** is a side-by-side A/B harness — four candidate
transitions including the shipped `morphingView` — kept in the
repo as a reference / playground for the design decision.

---

## Architecture

```
Alinea/
├── Alinea.xcodeproj                       (single Xcode project)
├── Alinea/
│   ├── AlineaApp.swift                    (app entry → AmountEntryView)
│   ├── Assets.xcassets                    (icons only)
│   ├── Features/
│   │   └── AmountEntry/
│   │       ├── AmountEntryView.swift      (screen composition)
│   │       ├── AmountEntryViewModel.swift (@Observable @MainActor)
│   │       ├── AmountInputModel.swift     (pure value type)
│   │       ├── AmountFormatter.swift      (custom — preserves trailing ".")
│   │       └── Components/
│   │           ├── QuickAmountCTA.swift   (production chips ↔ Review row)
│   │           ├── MorphingCTA.swift      (the single-view morph)
│   │           ├── QuickAmountChip.swift
│   │           ├── ReviewButton.swift
│   │           ├── AllieGlow.swift        (angular + mesh halo)
│   │           ├── AmountDisplay.swift
│   │           ├── BlinkingCaret.swift
│   │           ├── NumberPad.swift
│   │           ├── NumberPadButton.swift
│   │           ├── NumberPadKey.swift
│   │           └── CTAMorph.swift         (A/B harness, non-prod)
│   └── FoundationKit/                     (local SPM package)
│       └── Sources/DesignSystem/
│           ├── Colors.swift               (semantic enums; no inline hex)
│           ├── Typography.swift
│           ├── TypographyModifier.swift
│           ├── FontRegistration.swift     (registers GT Flexa, Instrument Sans)
│           ├── Resources/Colors.xcassets  (namespaced, dark-only)
│           └── Components/
│               ├── BackButton.swift
│               └── AutomatedBadge.swift
└── AlineaTests/, AlineaUITests/
```

### Layering

- **`AmountInputModel`** is a pure value type holding the input rules
  (`append(digit:)`, `appendDecimal()`, `backspace()`, plus derived
  `isEmpty` / `canReview` / `isDecimalDisabled`). Tested directly,
  no SwiftUI dependency.
- **`AmountEntryViewModel`** is `@Observable @MainActor`, wraps the
  input model, and bumps `tapCount` to drive the screen-level
  `.sensoryFeedback` haptic.
- **`AmountFormatter`** is hand-rolled (not `Decimal.FormatStyle.currency`)
  because it must preserve in-progress shapes like `$2,000.` (trailing
  dot just typed) or `$2,000.5` (one decimal digit) that
  `FormatStyle.currency` would normalize away.
- **Design system** lives in a local SPM package so colors, fonts,
  typography modifiers, and shared primitives stay decoupled from
  the feature code. Asset catalog uses namespaced folders; every
  color is reached via semantic enums (`Color.Background.screen`,
  `Color.Brand.gradientBlue`, etc.) — no inline hex in feature code.

---

## Behavioral rules

The seven Figma comments — explicit asks from Ryan during the brief:

1. **Chips visible only when empty; Review button only when filled.**
   `QuickAmountCTA` interpolates `progress` from 0 → 1 on the
   `showChips` flip; side chips collapse and the centre morphs.
2. **Review button gradient animates.** `AllieGlow` runs a
   `TimelineView(.animation)`-driven rotation + breathing scale on
   the brand gradient.
3. **Chips → Review transition is the headline differentiator.**
   The single-view morph approach (see [Design notes](#design-notes))
   was chosen specifically to make this read as a transformation
   rather than a crossfade.
4. **Haptics on every keypad tap.** Screen-level `.sensoryFeedback`
   modifier in `AmountEntryView`, triggered by `vm.tapCount`. No
   `UIImpactFeedbackGenerator`.
5. **Caret blinks and sits at end.** `BlinkingCaret` rendered to
   the right of the amount in both empty and filled states.
6. **Decimal key disables when input already contains `.`.**
   `vm.isDecimalDisabled` flows into `NumberPad`.
7. **Amount text scales to fit.** `.minimumScaleFactor(0.3)` on the
   amount label in `AmountDisplay`.

---

## Design notes

### Why a single-view morph instead of `matchedGeometryEffect`

`matchedGeometryEffect` is a *geometry-matching* primitive, not a
morph primitive. When the source and destination differ in content
— here the label changes (`"$2,000"` → `"Review"`), the fill inverts
(dark → white), and the typography style swaps — SwiftUI animates
the matched frame and crossfades the two view bodies through it.
The result reads as two pictures sliding through each other.

`MorphingCTA` is a single `@Animatable` view driven by
`progress: Double`. SwiftUI interpolates `progress` 0 → 1 and
re-evaluates `body` per frame; fill (`Color.mix`), foreground
(`Color.mix`), padding (linear), and label opacities (staggered so
chip-out runs twice as fast as Review-in, avoiding a muddy 50/50
frame) all interpolate under one spring. One identity throughout,
no insertion/removal, no crossfade.

`CTAMorph` keeps three earlier candidates around — `.centerMorph`
(MGE), `.converge` (theatrical collapse), `.swoop` (cinematic
two-beat) — so the decision is reviewable.

### Why iOS 26 specifically

The deployment target was chosen to unlock:

- **`@Animatable` macro** — drives the morph with zero
  `animatableData` boilerplate.
- **Liquid Glass** (`.glassEffect()`, `.buttonStyle(.glass)`) — used
  for the AUTOMATED badge backdrop and the back-chevron container.
- **`Color.mix(with:by:)`** (iOS 18+) — animatable color
  interpolation without manual RGBA decomposition.
- **`MeshGradient`** (iOS 18+) — the bonus halo style.

### Customizing the chip amounts

```swift
QuickAmountCTA(
    amounts: QuickAmounts(leading: 250, center: 1_000, trailing: 5_000),
    showChips: vm.showChips,
    canReview: vm.canReview,
    onChipTap: { vm.tap(quickAmount: $0) },
    onReview: { /* submit */ }
)
```

The `center` slot is the morphing one — tapping it in chip mode
fires `onChipTap(amounts.center)`, and that's the chip that
becomes the Review button. Going beyond three chips would break
the `leading / center / trailing` model and squeeze the slot
widths below the chip's intrinsic text width — a horizontal
carousel with a separate Review CTA would be the right redesign.

---

## Out of scope

Confirmed with Ryan during the brief — these are not evaluated and
have been intentionally left light:

- **Localization.** English only, no String Catalog.
- **Light mode.** Figma is dark-only; no light appearance was designed,
  so none was fabricated.
- **Accessibility.** ~30 min of basic VoiceOver labels (chip,
  back button, Review). No Dynamic Type tuning beyond defaults, no
  Reduce Motion handling. The morph + halo are visual flourishes
  that would need design input to adapt.
- **Networking, persistence, real submit.** The Review action is a no-op.
- **Input limits beyond two decimals.** Max two decimal places
  (`2.00`), minimum `$0.01`, en-US only — per Ryan's correction on
  May 20 (initially said four, narrowed to two).

---

## Tests

- **`AmountInputModelTests`** — unit coverage on the pure value type:
  digit append, decimal append, backspace, leading-zero rules,
  two-decimal cap.
- **`AmountFormatterTests`** — formatter coverage including the
  trailing-dot and partial-decimal in-progress states.
- **`AlineaUITests`** — happy-path UI flow (type an amount → Review
  appears → backspace → chips return).

Snapshot tests were considered but cut in favour of polish time on
the morph and halo.

---

## Acknowledgements

Built solo over four days against the design Figma and Ryan's
written clarifications. SwiftUI animation research drew heavily on
Swift with Majid, Hacking with Swift, The SwiftUI Lab, and Apple's
WWDC 2025 sessions on `@Animatable` and Liquid Glass.
