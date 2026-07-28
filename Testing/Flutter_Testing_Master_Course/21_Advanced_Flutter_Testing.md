# Module 21: Advanced Flutter Testing

---

## Module Overview

This module covers advanced, less commonly taught testing topics that mature Flutter teams eventually need: performance testing and profiling, testing platform channels and native plugin interactions, testing animations, accessibility testing in depth, testing localization, and contract testing at API boundaries.

---

## Learning Objectives

- Profile and test app performance using Flutter DevTools and `integration_test` tracing.
- Test code that interacts with platform channels/native plugins.
- Test animations deterministically without relying on real elapsed time.
- Perform deeper accessibility testing beyond Module 03's introduction.
- Test localization (l10n) correctness.
- Understand contract testing as a strategy for API boundary confidence.

---

## Prerequisites

- Modules 01–20

---

## Theory

### Performance Testing and Profiling

Beyond functional correctness, production Flutter apps need to render at 60/120fps and manage memory responsibly. Flutter DevTools provides:
- **Performance view**: frame rendering timeline, identifying jank (frames taking >16ms at 60fps).
- **Memory view**: heap snapshots, leak detection.
- **CPU profiler**: identifying expensive synchronous work blocking the UI thread.

For automated, repeatable performance testing, `integration_test`'s `traceAction` (introduced in Module 14) captures timeline data during a real user interaction:

```dart
final timelineSummary = await binding.traceAction(() async {
  await tester.fling(find.byType(ListView), const Offset(0, -500), 3000);
  await tester.pumpAndSettle();
}, reportKey: 'list_scroll_performance');
```

This produces frame-timing statistics that can be tracked over time in CI to catch performance regressions — the same "track trends, not just a static pass/fail" philosophy from Module 16's coverage discussion.

### Testing Platform Channels

Flutter communicates with native (iOS/Android) code via platform channels. Testing code that uses a platform channel directly is problematic — real native code can't run in the Dart test environment. The solution is to mock the channel itself.

```dart
const channel = MethodChannel('com.myapp/battery');

TestWidgetsFlutterBinding.ensureInitialized();

setUp(() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (call) async {
    if (call.method == 'getBatteryLevel') {
      return 85;
    }
    throw PlatformException(code: 'UNAVAILABLE');
  });
});

tearDown(() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, null);
});
```

Just as with any other external dependency (Module 07), the better long-term architecture wraps the platform channel behind your own abstraction (`BatteryService`), so most of your codebase mocks that abstraction with `mocktail` and never touches `MethodChannel` mocking directly — reserving this lower-level technique for the wrapper's own tests.

### Testing Animations Deterministically

Real animations run over real time, which is incompatible with fast, deterministic tests. `flutter_test`'s fake clock (introduced conceptually in Module 08) lets you advance time explicitly:

```dart
testWidgets('fade animation completes and reveals content', (tester) async {
  await tester.pumpWidget(const MaterialApp(home: FadeInWidget()));

  expect(find.byType(Opacity), findsOneWidget);

  await tester.pump(); // start animation
  await tester.pump(const Duration(milliseconds: 150)); // halfway
  // could assert intermediate opacity here if exposed

  await tester.pump(const Duration(milliseconds: 150)); // complete
  await tester.pumpAndSettle();

  expect(find.text('Loaded Content'), findsOneWidget);
});
```

Never use `Future.delayed` combined with real `await Future.delayed(...)` inside a widget test to "wait for" an animation — this makes tests slow and occasionally flaky. Always advance Flutter's fake clock explicitly with `pump(duration)`.

### Deep Accessibility Testing

Module 03 introduced the concept; here we go further. Flutter's `flutter_test` provides a full accessibility guideline-checking API:

```dart
testWidgets('screen meets accessibility guidelines', (tester) async {
  await tester.pumpWidget(const MyApp());
  final handle = tester.ensureSemantics();

  await expectLater(tester, meetsGuideline(textContrastGuideline));
  await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

  handle.dispose();
});
```

These four guidelines check, respectively: sufficient text/background color contrast, minimum Android touch target size (48x48dp), minimum iOS touch target size (44x44pt), and that every tappable widget has a semantic label for screen readers. Running these across your app's key screens catches accessibility regressions automatically, rather than relying solely on manual audits.

### Testing Localization (l10n)

Apps supporting multiple languages need tests confirming the correct locale's strings render, and that layouts don't break with longer translated text (a common real bug — German and Finnish strings are often 30-40% longer than English).

```dart
testWidgets('renders French greeting when locale is fr', (tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      locale: Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: GreetingScreen(),
    ),
  );
  await tester.pumpAndSettle();

  expect(find.text('Bonjour'), findsOneWidget);
});
```

Golden tests (Module 15) are particularly valuable for catching localization-induced layout overflow, since they catch *visual* breakage that a text-presence assertion alone would miss.

### Contract Testing

Module 12 tested your API client against manually-crafted mock responses — but what if the *real* backend's contract has drifted from what your mocks assume? **Contract testing** (e.g., using the Pact framework, or shared OpenAPI schema validation) verifies that your mocked assumptions and the real backend's actual behavior stay in sync, typically by having both the frontend and backend teams run tests against a shared, versioned contract definition.

```text
┌─────────────┐     publishes      ┌─────────────────┐     verified against    ┌─────────────┐
│ Flutter App  │───────────────────►│  Shared Contract │◄────────────────────────│  Backend API │
│ (consumer)   │   expectations      │   (Pact file)    │      real behavior       │  (provider)  │
└─────────────┘                     └─────────────────┘                          └─────────────┘
```

This is typically an organization-level testing investment (requiring coordination with backend teams) rather than something an individual Flutter developer sets up alone, but understanding the concept helps you recognize *why* mocked API tests (Module 12) alone aren't a complete substitute for integration confidence at scale.

---

## Flutter Perspective

These advanced topics represent the difference between a Flutter app that merely "passes its tests" and one that is genuinely production-hardened: performant under real usage, accessible to all users, correctly localized, resilient to native platform quirks, and protected against backend contract drift. Not every project needs all of these from day one — but a senior Flutter engineer should recognize when a project has grown to the point where they matter.

---

## Diagrams

### Advanced Testing Topics Map

```text
Performance        → DevTools + integration_test traceAction
Platform Channels  → mock MethodChannel, wrap in abstraction
Animations         → advance fake clock via pump(duration), never real delays
Accessibility       → meetsGuideline() checks (contrast, tap targets, labels)
Localization         → locale-specific widget tests + golden tests for layout breakage
Contract Testing    → Pact/shared schema, organization-level investment
```

---

## Code Examples

### Wrapping a Platform Channel Behind an Abstraction

```dart
// lib/services/battery_service.dart
abstract class BatteryService {
  Future<int> getBatteryLevel();
}

class NativeBatteryService implements BatteryService {
  static const _channel = MethodChannel('com.myapp/battery');

  @override
  Future<int> getBatteryLevel() async {
    final level = await _channel.invokeMethod<int>('getBatteryLevel');
    return level ?? -1;
  }
}
```

```dart
// test/services/native_battery_service_test.dart — the ONLY place channel mocking is needed
void main() {
  const channel = MethodChannel('com.myapp/battery');
  late NativeBatteryService service;

  setUp(() {
    service = NativeBatteryService();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'getBatteryLevel') return 85;
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('returns battery level from platform channel', () async {
    expect(await service.getBatteryLevel(), 85);
  });
}
```

Everywhere else in the app, `BatteryService` is mocked with plain `mocktail`, exactly as in Module 07 — the platform channel complexity is fully contained in one file.

---

## Step-by-Step Explanation

1. For performance: wrap the critical interaction in `traceAction()` during an integration test and track results over time.
2. For platform channels: wrap the channel in your own abstraction; mock the channel only inside that abstraction's own test file.
3. For animations: always use `pump(duration)` to advance the fake clock deterministically — never real `Future.delayed`.
4. For accessibility: add `meetsGuideline()` checks to widget tests for key screens as part of routine widget testing.
5. For localization: write locale-specific widget tests and pair them with golden tests to catch layout overflow from longer translated strings.
6. For contract testing: evaluate whether your team's scale and backend-drift risk justify the organizational investment.

---

## Best Practices

- Contain platform-channel mocking to the thin wrapper class's own tests; mock the wrapper abstraction everywhere else.
- Never use real elapsed time (`Future.delayed`) to wait for animations in tests — always advance the fake clock explicitly.
- Bake accessibility guideline checks into your normal widget test suite, not a separate rarely-run audit.
- Pair localization tests with golden tests specifically to catch layout breakage from text length differences.

---

## Common Mistakes

- Mocking `MethodChannel` directly throughout the codebase instead of behind a single abstraction, spreading low-level test complexity everywhere.
- Using real `await Future.delayed()` in widget tests, making the suite slow and occasionally flaky.
- Treating accessibility testing as a one-time audit rather than an ongoing, automated part of the widget test suite.
- Assuming English-only text-presence tests are sufficient for localization, missing layout overflow bugs in longer languages.

---

## Interview Questions

1. Why should platform channel mocking be contained to a single wrapper class's tests rather than spread throughout the codebase?
2. How do you test a Flutter animation without relying on real elapsed time?
3. What four accessibility guidelines does `flutter_test` provide built-in checks for?
4. Why are golden tests particularly valuable for catching localization bugs?
5. What problem does contract testing solve that mocked API tests (Module 12) alone cannot?

---

## Exercises

1. Wrap a hypothetical native `Vibration` platform channel behind a `VibrationService` abstraction, and write the channel-mocking test for just that wrapper.
2. Write a widget test that advances a fake clock through a 500ms slide-in animation in 3 discrete `pump()` steps.
3. Add all four `meetsGuideline()` checks to an existing widget test for a screen of your choice.

---

## Mini Project

Take the `CatalogScreen` from Module 20's mini project. Add: an accessibility test suite (all four guidelines), a localization test confirming correct rendering in at least 2 locales, and a golden test confirming layout doesn't break with a long, translated product name.

---

## Assignment

Pick one advanced topic from this module (performance, platform channels, animations, accessibility, localization, or contract testing) that's most relevant to a project you're working on. Write a short technical proposal (half a page) for how your team would adopt it, including one concrete code example.

---

## Summary

- Advanced Flutter testing extends beyond correctness into performance, native integration, animation determinism, accessibility, localization, and API contract confidence.
- Platform channel testing should be isolated behind a thin abstraction wrapper, mocked normally everywhere else.
- Animations must be tested using the fake clock (`pump(duration)`), never real elapsed time.
- Accessibility guideline checks (`meetsGuideline`) should be a routine part of widget testing, not a separate audit.
- Contract testing addresses a real gap that mocked API tests alone cannot close, at an organizational investment level.

---

## Revision Notes

- Performance: DevTools + `traceAction`, track trends over time
- Platform channels: mock only inside the thin wrapper's own test
- Animations: `pump(duration)`, never real delays
- Accessibility: `meetsGuideline` (contrast, Android/iOS tap targets, labels)
- Localization: locale-specific tests + golden tests for overflow
- Contract testing: Pact/shared schema, organization-level

---

## Next Module

Continue with **22_Capstone_Project.md**.
