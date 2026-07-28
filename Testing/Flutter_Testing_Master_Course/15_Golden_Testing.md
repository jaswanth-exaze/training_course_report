# Module 15: Golden Testing

---

## Module Overview

Golden testing (also called visual regression testing or snapshot testing) verifies that a widget *renders pixel-for-pixel* the same way over time, catching visual regressions that functional widget tests (Module 08) can't detect — a misaligned padding, an incorrect color, a broken layout on a specific screen size. This module covers Flutter's built-in golden testing plus the `golden_toolkit` package for cross-platform consistency.

---

## Learning Objectives

- Understand what golden testing catches that functional widget tests don't.
- Write and update golden tests using `flutter_test`'s built-in `matchesGoldenFile`.
- Use `golden_toolkit` for multi-device, multi-theme golden testing.
- Understand golden file management, platform rendering consistency, and CI considerations.
- Know when golden testing is worth its maintenance cost.

---

## Prerequisites

- Modules 05–08

---

## Theory

### What Golden Testing Catches

Functional widget tests (Module 08) assert on the *structure* of the widget tree — "does this text exist, is this button present." They say nothing about *how it looks*: colors, spacing, alignment, font rendering, overflow.

Golden tests solve this by rendering a widget to an image and comparing it, pixel-for-pixel, against a previously-approved reference image (the "golden" file).

```text
┌────────────┐   render    ┌───────────────┐   compare    ┌──────────────────┐
│   Widget    │───────────►│  Current PNG   │─────────────►│  Golden PNG File  │
│ under test  │             │ (this test run)│  pixel diff  │ (approved, in git)│
└────────────┘             └───────────────┘              └──────────────────┘
```

If the pixels differ beyond a small threshold, the test fails — flagging a visual regression for human review.

### Built-in Golden Testing

```dart
testWidgets('ProfileCard matches golden file', (tester) async {
  await tester.pumpWidget(
    const MaterialApp(home: Scaffold(body: ProfileCard(name: 'Alice'))),
  );

  await expectLater(
    find.byType(ProfileCard),
    matchesGoldenFile('goldens/profile_card.png'),
  );
});
```

The first time this runs, there's no golden file to compare against. You generate it explicitly:

```bash
flutter test --update-goldens
```

This creates/overwrites `goldens/profile_card.png`. From then on, `flutter test` (without `--update-goldens`) compares against it and fails on any pixel difference.

### The Platform Consistency Problem

Text rendering, font hinting, and anti-aliasing differ subtly between operating systems (macOS vs Linux vs Windows). This means golden files generated on a developer's Mac may not match pixel-for-pixel when compared in Linux-based CI — a huge source of golden test flakiness for teams new to the technique.

**Solution**: Generate and compare golden files in the *same environment* every time — almost always this means generating goldens inside Docker/CI (Linux), or explicitly loading a consistent font via `flutter_test`'s font-loading utilities, rather than on individual developer machines.

### `golden_toolkit`

The `golden_toolkit` package (community-maintained, widely adopted) solves several practical golden-testing pain points:
- **Multi-device golden testing**: render the same widget at several screen sizes in one test.
- **Font loading**: ensures consistent font rendering across environments.
- **`screenMatchesGolden`**: simplified API compared to raw `matchesGoldenFile`.

```yaml
dev_dependencies:
  golden_toolkit: ^0.15.0
```

```dart
void main() {
  setUpAll(() async {
    await loadAppFonts(); // ensures consistent font rendering
  });

  testGoldens('ProfileCard renders correctly across devices', (tester) async {
    final builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: [
        Device.phone,
        Device.tabletPortrait,
      ])
      ..addScenario(
        widget: const ProfileCard(name: 'Alice'),
        name: 'default',
      );

    await tester.pumpDeviceBuilder(builder);
    await screenMatchesGolden(tester, 'profile_card_multi_device');
  });
}
```

### Golden File Management in Version Control

Golden PNG files are committed to the repository alongside the code (typically in a `goldens/` or `test/goldens/` directory). This has real implications:
- Repository size grows over time — periodic cleanup of stale goldens matters.
- Pull requests that intentionally change UI must include updated golden files, reviewed visually (many teams use a bot/CI step that posts a visual diff on PRs).
- Golden updates should be a deliberate, reviewed action (`--update-goldens` run locally, diffs eyeballed before committing) — never blindly run in CI to "fix" failing tests.

---

## Flutter Perspective

Golden testing complements, but never replaces, functional widget testing (Module 08). A widget can pass every functional assertion (`findsOneWidget`, correct text) while still looking visually broken (wrong color, broken layout) — and vice versa, a golden test alone won't tell you *why* something is visually different or verify interactive behavior.

A pragmatic Flutter team applies golden testing selectively to:
- Shared/reusable design-system components (buttons, cards, badges) — high reuse means high payoff for catching visual regressions.
- Critical, highly-designed screens (onboarding, marketing screens) where pixel-perfect fidelity matters commercially.

Golden testing is generally **not** applied exhaustively to every screen in an app — the maintenance cost (updating goldens whenever intentional UI changes happen) doesn't pay off for low-risk, rapidly-iterating screens.

---

## Diagrams

### Golden Test Workflow

```text
Write/modify widget
        │
        ▼
flutter test --update-goldens   ── generates new golden PNG
        │
        ▼
Review the golden image diff manually
        │
        ▼
Commit golden PNG + code together
        │
        ▼
flutter test   ── future runs compare against this committed golden
```

---

## Code Examples

### Basic Golden Test

```dart
// test/widgets/badge_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/widgets/badge.dart';

void main() {
  testWidgets('StatusBadge matches golden - success state', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: StatusBadge(status: BadgeStatus.success)),
      ),
    );

    await expectLater(
      find.byType(StatusBadge),
      matchesGoldenFile('goldens/status_badge_success.png'),
    );
  });

  testWidgets('StatusBadge matches golden - error state', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: StatusBadge(status: BadgeStatus.error)),
      ),
    );

    await expectLater(
      find.byType(StatusBadge),
      matchesGoldenFile('goldens/status_badge_error.png'),
    );
  });
}
```

### Multi-Theme Golden Test with `golden_toolkit`

```dart
testGoldens('StatusBadge renders correctly in light and dark themes',
    (tester) async {
  final builder = DeviceBuilder()
    ..addScenario(
      widget: Theme(
        data: ThemeData.light(),
        child: const StatusBadge(status: BadgeStatus.success),
      ),
      name: 'light_theme',
    )
    ..addScenario(
      widget: Theme(
        data: ThemeData.dark(),
        child: const StatusBadge(status: BadgeStatus.success),
      ),
      name: 'dark_theme',
    );

  await tester.pumpDeviceBuilder(builder);
  await screenMatchesGolden(tester, 'status_badge_themes');
});
```

---

## Step-by-Step Explanation

1. Identify a widget worth golden testing (reusable design-system component or critical high-fidelity screen).
2. Write a `testWidgets`/`testGoldens` block rendering the widget in the states/themes/devices that matter.
3. Run with `--update-goldens` to generate the initial reference image(s).
4. Manually review the generated image(s) for correctness before committing.
5. Commit code + golden files together; future CI runs compare automatically.
6. When intentional UI changes occur, regenerate and manually re-review before committing updated goldens.

---

## Best Practices

- Generate and compare golden files in a consistent environment (CI/Docker), not ad hoc on developer machines, to avoid platform rendering flakiness.
- Use `golden_toolkit`'s `loadAppFonts()` to ensure font-rendering consistency.
- Apply golden testing selectively — to design-system components and high-fidelity critical screens, not exhaustively everywhere.
- Treat golden file updates as a reviewed, deliberate action — never auto-regenerate blindly to silence CI failures.

---

## Common Mistakes

- Generating goldens on a local Mac/Windows machine and having them fail in Linux-based CI due to font rendering differences.
- Blindly running `--update-goldens` to "fix" a failing test without visually reviewing whether the change is actually correct.
- Applying golden tests to every single screen, creating an unsustainable maintenance burden for a team that iterates on UI frequently.
- Treating a golden test failure the same as a functional bug — it may simply reflect an *intentional* design change that needs golden regeneration.

---

## Interview Questions

1. What does golden testing catch that functional widget testing does not?
2. Why do golden tests often fail differently across operating systems, and how do teams solve this?
3. What's the recommended workflow when a golden test fails after an intentional UI change?
4. Why shouldn't golden testing be applied to every screen in an app?
5. What problem does `golden_toolkit`'s `loadAppFonts()` solve?

---

## Exercises

1. Write a golden test for a custom `PriceTag` widget showing both a regular and a "discounted" (strikethrough) visual state.
2. Set up `golden_toolkit`'s `DeviceBuilder` to golden-test a widget across phone and tablet sizes in one test.
3. Explain (in writing) what you would do if a teammate's PR includes 40 changed golden files with no description of why.

---

## Mini Project

Build a small design-system `Button` widget with `primary`, `secondary`, and `disabled` visual variants. Write a complete golden test suite covering all three variants, plus light/dark theme variations using `golden_toolkit`.

---

## Assignment

Pick 2–3 reusable UI components from an existing Flutter project (or design new ones: a `Chip`, an `Avatar`, an `Alert` banner). Write golden tests for each covering their meaningful visual states. Document your team's proposed process for reviewing and approving golden file updates in pull requests.

---

## Summary

- Golden testing catches visual regressions that functional widget tests can't — pixel-level comparison against an approved reference image.
- `matchesGoldenFile` is Flutter's built-in mechanism; `golden_toolkit` adds multi-device/theme support and font consistency.
- Golden files must be generated/compared in a consistent environment to avoid cross-platform rendering flakiness.
- Golden testing should be applied selectively, not exhaustively, due to its ongoing maintenance cost.
- Golden file updates should always be a deliberate, visually-reviewed action.

---

## Revision Notes

- Golden test = pixel-level snapshot comparison
- `flutter test --update-goldens` generates/updates reference images
- Generate/compare in consistent (CI/Linux) environment to avoid flakiness
- `golden_toolkit`: multi-device, multi-theme, font consistency
- Apply selectively: design-system components + high-fidelity critical screens

---

## Next Module

Continue with **16_Code_Coverage.md**.
