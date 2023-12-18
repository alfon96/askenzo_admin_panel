import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>();
List<String> routeNames = [];
/// The `NavigationState` class represents the state of a navigation system, including the current route
/// and optional arguments.

class NavigationState {
  String currentRoute;
  Object? arguments;
  NavigationState(this.currentRoute, this.arguments);
}
/// The `NavigationNotifier` class is a state notifier that manages navigation within an app using a
/// `navigatorKey` and provides methods for pushing, replacing, and popping routes.

class NavigationNotifier extends StateNotifier<NavigationState> {
  final GlobalKey<NavigatorState> navigatorKey;

  NavigationNotifier()
      : navigatorKey = GlobalKey<NavigatorState>(),
        super(NavigationState('/', null));
  void push(String routeName, {Object? arguments}) {
    if (state.currentRoute == routeName && state.arguments == arguments) return;

    state = NavigationState(routeName, arguments);

    navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
    // Information to be stored
    routeNames.add(routeName);
    globalNavigatorKey = navigatorKey;
  }

  void pushReplacement(String routeName, {Object? arguments}) {
    state = NavigationState(routeName, arguments);

    navigatorKey.currentState!
        .pushReplacementNamed(routeName, arguments: arguments);

    // Information to be stored
    routeNames = [];
    routeNames.add(routeName);
    globalNavigatorKey = navigatorKey;
  }

  void pop({Object? result, Function? fun}) {
    navigatorKey.currentState!.pop(result);
    state = NavigationState('', null);

    if (fun != null) {
      fun();
    }
    // Information to be stored
    if (routeNames.isNotEmpty) {
      routeNames.removeLast();
    }
    globalNavigatorKey = navigatorKey;
  }
}

/// The code `final navigationProvider = StateNotifierProvider<NavigationNotifier,
/// NavigationState>((ref) => NavigationNotifier());` is creating a provider called `navigationProvider`
/// using the `StateNotifierProvider` class from the `flutter_riverpod` package.
final navigationProvider =
    StateNotifierProvider<NavigationNotifier, NavigationState>(
        (ref) => NavigationNotifier());
