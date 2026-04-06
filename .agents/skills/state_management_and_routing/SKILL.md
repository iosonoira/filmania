---
name: State Management and Routing
description: Best practices for managing Riverpod state and GoRouter paths in Filmania.
---

# State Management and Routing Guidelines

Filmania heavily relies on Riverpod (`@riverpod` code generation) for reactivity and GoRouter for structural navigation. Support the redirect logic properly.

## 1. Riverpod Best Practices
- **No Direct Service Calls in UI:** NEVER call a repository or Supabase directly from an `onPressed` callback.
- **AsyncValue.guard:** Always wrap asynchronous actions inside `AsyncValue.guard()` in your `AsyncNotifier` to automatically catch errors and shift states to `AsyncError`.
- **Side Effects:** For side effects (e.g. SnackBars, Toast messages), use `ref.listen` inside the widget's `build` method rather than handling it within the provider. Sample:
  ```dart
  ref.listen(featureProvider, (prev, next) {
    if (next is AsyncError) {
      ScaffoldMessenger.of(context).showSnackBar(...);
    }
  });
  ```

## 2. GoRouter Routing
- The router (`AppRouter`) is tightly coupled to the application's auth state via a `RefreshListenable`.
- Always use `context.go('/target_path')` to perform routing.
- Keep the hardcoded string paths centrally managed inside `AppRoutes` abstraction in `lib/core/router/app_router.dart`.
- The main application operates under a `StatefulShellRoute`. When adding a new primary section, be sure to add it as a new `StatefulShellBranch` rather than a standard top-level route.
