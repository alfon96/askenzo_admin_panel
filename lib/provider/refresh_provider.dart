import 'package:flutter_riverpod/flutter_riverpod.dart';
/// The RefreshNotifier class is a state notifier that toggles between true and false.

class RefreshNotifier extends StateNotifier<bool> {
  RefreshNotifier() : super(false);

  void toggle() {
    state = !state;
  }
}
/// The code is creating a `StateNotifierProvider` called `refreshProvider`.

final refreshProvider = StateNotifierProvider<RefreshNotifier, bool>((ref) {
  return RefreshNotifier();
});
