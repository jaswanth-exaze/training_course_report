# Module 20: Real Project Testing

---

## Module Overview

This module synthesizes everything from Modules 01–19 into a single, realistic worked example: testing a complete feature — a "Product Catalog with Cart" — from the domain layer down to the UI, exactly as you would on a real production Flutter team. Instead of introducing new concepts, this module is about **integration of prior knowledge** into one coherent, end-to-end workflow.

---

## Learning Objectives

- Apply the full testing stack (unit, mocking, BLoC, repository, API, widget, navigation, golden, integration) to one cohesive feature.
- Practice deciding *which* testing technique to apply to *which* layer, under realistic time constraints.
- Practice structuring a feature's tests following Module 17's test architecture principles.
- Build a complete, professional-quality test suite for a non-trivial feature end-to-end.

---

## Prerequisites

- Modules 01–19 (this module assumes and exercises everything prior)

---

## Theory

### The Feature: Product Catalog with Cart

We'll build and test a small but realistic feature:
- Browse a list of products (fetched from an API, cached locally).
- View product details.
- Add/remove items from a cart (in-memory, managed via Cubit).
- See a running cart total with tax calculation.

This feature touches every architectural layer covered in this course:

```text
lib/features/catalog/
├── data/
│   ├── datasources/
│   │   ├── product_remote_datasource.dart   (Module 12)
│   │   └── product_local_datasource.dart    (Module 13)
│   ├── models/product_dto.dart              (Module 06)
│   └── repositories/product_repository_impl.dart (Module 11)
├── domain/
│   ├── entities/product.dart                (Module 06)
│   ├── repositories/product_repository.dart (Module 07 - abstraction)
│   └── usecases/calculate_cart_total_usecase.dart (Module 06)
├── presentation/
│   ├── cubit/
│   │   ├── catalog_cubit.dart               (Module 10)
│   │   └── cart_cubit.dart                  (Module 10)
│   └── screens/
│       ├── catalog_screen.dart              (Module 08, 09)
│       └── cart_screen.dart                 (Module 08, 15)
```

### Applying the Test Pyramid to This Feature

Recall Module 02's pyramid — here's how it maps onto this specific feature's actual test count, illustrating the shape in practice rather than the abstract:

```text
                ▲
               / \
              /E2E \        1-2 tests: "browse → add to cart → checkout" journey
             /-------\
            /Widget    \    ~15-20 tests: CatalogScreen, CartScreen, ProductCard states
           /   Tests    \
          /---------------\
         /   Unit Tests    \ ~30-40 tests: models, use case, repository, data sources, cubits
        /____________________\
```

### Layer-by-Layer Test Plan

**1. Domain entity (`Product`) — Module 06**
- `fromJson`/`toJson`/`copyWith`/equality tests.

**2. Use case (`CalculateCartTotalUseCase`) — Modules 04, 06**
- EP + BVA on quantities and tax rates; empty cart edge case.

**3. Remote data source — Module 12**
- Mock `Dio`; test 200/404/500/timeout/malformed-response branches.

**4. Local data source — Module 13**
- `SharedPreferences.setMockInitialValues`; test cache write/read/staleness.

**5. Repository — Module 11**
- Mock both data sources; test remote-first/cache-fallback decision table.

**6. `CatalogCubit` — Modules 07, 10**
- Mock the repository; `blocTest` for loading/loaded/error state sequences.

**7. `CartCubit` — Module 10**
- Pure state logic (no external dependency); test add/remove/quantity-update/total-recalculation sequences.

**8. `CatalogScreen` widget — Modules 08, 09**
- Mock `CatalogCubit`; test loading/empty/error/loaded states render correctly; test tapping a product navigates to details (Module 09).

**9. `CartScreen` widget + golden — Modules 08, 15**
- Mock `CartCubit`; test empty-cart state, item list rendering, total display; golden test for the cart summary card's visual states (empty, with discount applied).

**10. Full user journey — Module 14**
- One `integration_test`: browse catalog → view details → add to cart → view cart total, using an injected fake repository.

### Realistic Prioritization Under Time Constraints

In a real sprint, you rarely have unlimited time to write every conceivable test. Applying Module 02's defect-clustering and Module 16's risk-weighted coverage principles, a sensible priority order for this feature would be:

1. `CalculateCartTotalUseCase` and `CartCubit` — highest business risk (money calculations, easy to get wrong).
2. Repository remote-first/cache-fallback logic — coordination bugs are costly and easy to introduce.
3. `CatalogCubit` state sequences.
4. Widget tests for both screens' major states.
5. One end-to-end integration test for the critical journey.
6. Golden tests — valuable but lowest priority if time is constrained, since they protect visual polish rather than correctness.

---

## Flutter Perspective

This module is deliberately less about new Flutter APIs and more about **professional judgment** — the skill of deciding, under real constraints, which tests earn their cost and which don't. This is exactly the skill senior Flutter engineers are expected to exercise daily, and it's the actual goal of the entire course up to this point: not memorizing `bloc_test` syntax, but knowing *when and why* to reach for it.

---

## Diagrams

### Feature Test Suite Composition

```text
Domain Entity Tests        ████ (fast, cheap, foundational)
Use Case Tests              █████ (business-critical, high priority)
Data Source Tests (x2)      ███████ (isolate external dependencies)
Repository Tests            █████ (coordination logic)
Cubit Tests (x2)            ███████ (highest-leverage layer)
Widget Tests (x2 screens)   ██████████ (user-visible behavior)
Golden Tests                ███ (visual polish, lower priority)
Integration Test            █ (one critical journey)
```

---

## Code Examples

### `CartCubit` — Pure State Logic (No Mocking Needed)

```dart
// lib/features/catalog/presentation/cubit/cart_cubit.dart
class CartState {
  final Map<String, int> quantities; // productId -> quantity
  final List<Product> products;
  const CartState({this.quantities = const {}, this.products = const []});

  double get total => products.fold(
      0.0, (sum, p) => sum + (p.price * (quantities[p.id] ?? 0)));

  CartState copyWith({Map<String, int>? quantities, List<Product>? products}) =>
      CartState(
        quantities: quantities ?? this.quantities,
        products: products ?? this.products,
      );
}

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addProduct(Product product) {
    final updatedProducts = state.products.any((p) => p.id == product.id)
        ? state.products
        : [...state.products, product];
    final updatedQuantities = Map<String, int>.from(state.quantities);
    updatedQuantities[product.id] = (updatedQuantities[product.id] ?? 0) + 1;

    emit(state.copyWith(products: updatedProducts, quantities: updatedQuantities));
  }

  void removeProduct(String productId) {
    final updatedQuantities = Map<String, int>.from(state.quantities)
      ..remove(productId);
    final updatedProducts =
        state.products.where((p) => p.id != productId).toList();

    emit(state.copyWith(products: updatedProducts, quantities: updatedQuantities));
  }
}
```

```dart
// test/features/catalog/presentation/cubit/cart_cubit_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../fixtures/product_fixtures.dart';

void main() {
  group('CartCubit', () {
    test('initial state is empty cart', () {
      expect(CartCubit().state.products, isEmpty);
      expect(CartCubit().state.total, 0.0);
    });

    blocTest<CartCubit, CartState>(
      'addProduct adds a new product with quantity 1',
      build: () => CartCubit(),
      act: (cubit) => cubit.addProduct(buildProduct(id: '1', price: 10.0)),
      verify: (cubit) {
        expect(cubit.state.products.length, 1);
        expect(cubit.state.quantities['1'], 1);
        expect(cubit.state.total, 10.0);
      },
    );

    blocTest<CartCubit, CartState>(
      'adding the same product twice increments quantity, not duplicates',
      build: () => CartCubit(),
      act: (cubit) {
        final product = buildProduct(id: '1', price: 10.0);
        cubit.addProduct(product);
        cubit.addProduct(product);
      },
      verify: (cubit) {
        expect(cubit.state.products.length, 1);
        expect(cubit.state.quantities['1'], 2);
        expect(cubit.state.total, 20.0);
      },
    );

    blocTest<CartCubit, CartState>(
      'removeProduct removes product and its quantity entry',
      build: () => CartCubit(),
      act: (cubit) {
        final product = buildProduct(id: '1', price: 10.0);
        cubit.addProduct(product);
        cubit.removeProduct('1');
      },
      verify: (cubit) {
        expect(cubit.state.products, isEmpty);
        expect(cubit.state.total, 0.0);
      },
    );
  });
}
```

### Integration Test: The Critical Journey

```dart
// integration_test/catalog_to_cart_flow_test.dart
testWidgets('user can browse catalog and add a product to cart',
    (tester) async {
  serviceLocator.registerSingleton<ProductRepository>(FakeProductRepository());

  app.main();
  await tester.pumpAndSettle();

  expect(find.text('Wireless Mouse'), findsOneWidget);

  await tester.tap(find.text('Wireless Mouse'));
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('add_to_cart_button')));
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('cart_icon')));
  await tester.pumpAndSettle();

  expect(find.text('Wireless Mouse'), findsOneWidget);
  expect(find.text('\$29.99'), findsOneWidget);
});
```

---

## Step-by-Step Explanation

1. Break the feature down by architectural layer (entity, use case, data sources, repository, cubits, widgets, navigation, one integration journey).
2. Apply the specific technique from the relevant earlier module to each layer.
3. Prioritize business-critical/high-risk layers (money calculations, coordination logic) first under time constraints.
4. Structure the resulting tests following Module 17's fixtures/helpers/mocks architecture.
5. Add exactly one focused integration test for the feature's critical end-to-end journey — not more.
6. Add golden tests last, only for genuinely reusable or high-fidelity visual components.

---

## Best Practices

- Plan the test suite layer-by-layer before writing any tests, using the feature's architecture as your checklist.
- Prioritize ruthlessly under real time constraints — money/business logic first, visual polish last.
- Keep the integration test count for a single feature to just 1-2 focused journeys, per Module 14's pyramid discipline.
- Reuse fixtures/helpers across all layers of the same feature (Module 17) to avoid duplicated setup.

---

## Common Mistakes

- Writing integration tests for functionality already covered by faster unit/widget tests, duplicating effort without added confidence.
- Skipping business-logic tests (cart total calculation) in favor of easier-to-write widget tests, inverting the correct priority order.
- Not reusing fixtures across the feature's many test files, leading to duplicated `Product` construction logic everywhere.
- Treating this kind of full-feature test suite as "extra" work rather than part of the feature's actual definition of done (Module 01).

---

## Interview Questions

1. Walk through how you would plan a test suite for a new feature, layer by layer, from domain entity to integration test.
2. Under time pressure, which layers of a typical Flutter feature deserve testing priority, and why?
3. Why is it appropriate for a `CartCubit` in this example to have no mocked dependencies, unlike `CatalogCubit`?
4. How many integration tests would you write for a single feature like this, and why not more?
5. How does test architecture (Module 17) reduce the effort of building this kind of full-feature test suite?

---

## Mini Project

Fully implement and test the "Product Catalog with Cart" feature described in this module, following the complete layer-by-layer test plan given: entity, use case, both data sources, repository, both cubits, both screens' widget tests, one golden test, and one integration test.

---

## Assignment

Pick a real feature from your own portfolio or a course project (something with at least a data layer, business logic, and UI). Apply this module's layer-by-layer planning process explicitly: write out the test plan first (which layers, which techniques, in what priority order), then implement it. Submit both the plan and the resulting test suite.

---

## Summary

- Real-world Flutter features require coordinating every testing technique from this course across multiple architectural layers.
- The Test Pyramid's shape should be visible in the actual test count per layer for any well-tested feature.
- Under real time constraints, prioritize business-critical logic (money, coordination) before UI polish and before integration tests.
- Test architecture (fixtures, helpers, centralized mocks) pays for itself immediately once you're testing a full feature, not just isolated examples.
- This kind of full-feature test suite is not "extra" — it is the professional definition of a feature being "done."

---

## Revision Notes

- Plan tests layer-by-layer, matching each layer to its module's technique
- Priority under time pressure: business logic > coordination > widgets > integration > golden
- Pyramid shape should be visible in real test counts, not just theory
- Reuse fixtures/helpers across the whole feature

---

## Next Module

Continue with **21_Advanced_Flutter_Testing.md**.
