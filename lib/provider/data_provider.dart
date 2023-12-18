import 'package:askenzo_admin_panel/api/api.dart';
import 'package:askenzo_admin_panel/models/discovery.dart';
import 'package:askenzo_admin_panel/models/experience.dart';
import 'package:askenzo_admin_panel/models/popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
// EXPERIENCE
/// The `ExperienceNotifier` class is a state notifier that fetches experience data and updates its
/// state accordingly.

class ExperienceNotifier extends StateNotifier<List<UpdateExperienceModel>> {
  ExperienceNotifier() : super([]);

  Future<List<UpdateExperienceModel>?> fetchData(
    ScaffoldMessengerState scaffoldMessenger,
  ) async {
    final experiences = await getExperienceList(scaffoldMessenger, 0, 200);
    if (experiences != null) {
      state = experiences;
      return state;
    } else {
      state = [];
      return experiences;
    }
  }
}

final experienceProvider =
    StateNotifierProvider<ExperienceNotifier, List<UpdateExperienceModel>>(
        (ref) {
  return ExperienceNotifier();
});

// DISCOVERY
/// The `DiscoveryNotifier` class is a state notifier that fetches and updates a list of
/// `UpdateDiscoveryModel` objects.

class DiscoveryNotifier extends StateNotifier<List<UpdateDiscoveryModel>> {
  DiscoveryNotifier() : super([]);

  Future<List<UpdateDiscoveryModel>?> fetchData(
    ScaffoldMessengerState scaffoldMessenger,
  ) async {
    final discoveries = await getDiscoveryList(scaffoldMessenger, 0, 200);
    if (discoveries != null) {
      state = discoveries;
      return state;
    } else {
      state = [];
      return discoveries;
    }
  }
}

final discoveryProvider =
    StateNotifierProvider<DiscoveryNotifier, List<UpdateDiscoveryModel>>((ref) {
  return DiscoveryNotifier();
});

// POPUP
/// The `PopupNotifier` class is a state notifier that fetches a list of update popups and updates its
/// state accordingly.

class PopupNotifier extends StateNotifier<List<UpdatePopupModel>> {
  PopupNotifier() : super([]);

  Future<List<UpdatePopupModel>?> fetchData(
    ScaffoldMessengerState scaffoldMessenger,
  ) async {
    final popups = await getPopupList(scaffoldMessenger, 0, 200);
    if (popups != null) {
      state = popups;
      return state;
    } else {
      state = [];
      return popups;
    }
  }
}
/// The code `final popupProvider = StateNotifierProvider<PopupNotifier, List<UpdatePopupModel>>((ref) {
/// return PopupNotifier(); });` is creating a provider called `popupProvider` using the
/// `StateNotifierProvider` class from the `flutter_riverpod` package.

final popupProvider =
    StateNotifierProvider<PopupNotifier, List<UpdatePopupModel>>((ref) {
  return PopupNotifier();
});

// CONNECTIVITY
/// The `ConnectivityNotifier` class is a state notifier that checks the device's connectivity and
/// updates its state accordingly.

class ConnectivityNotifier extends StateNotifier<bool> {
  ConnectivityNotifier() : super(false);

  void checkConnectivity() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      state = false;
    } else {
      state = true;
    }
  }
}
/// The code `final connectivityProvider = StateNotifierProvider<ConnectivityNotifier, bool>((ref) {
/// return ConnectivityNotifier(); });` is creating a provider called `connectivityProvider` using the
/// `StateNotifierProvider` class from the `flutter_riverpod` package.

final connectivityProvider =
    StateNotifierProvider<ConnectivityNotifier, bool>((ref) {
  return ConnectivityNotifier();
});
