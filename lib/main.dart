import 'package:askenzo_admin_panel/data/constant_data.dart';
import 'package:askenzo_admin_panel/models/discovery.dart';
import 'package:askenzo_admin_panel/models/experience.dart';
import 'package:askenzo_admin_panel/models/popup.dart';
import 'package:askenzo_admin_panel/provider/navigation_provider.dart';
import 'package:askenzo_admin_panel/screen/discoveries/discovery_create.dart';
import 'package:askenzo_admin_panel/screen/discoveries/discovery_edit_detail.dart';
import 'package:askenzo_admin_panel/screen/discoveries/discovery_home.dart';
import 'package:askenzo_admin_panel/screen/experiences/experience_create.dart';
import 'package:askenzo_admin_panel/screen/experiences/experience_edit_detail.dart';
import 'package:askenzo_admin_panel/screen/experiences/experience_home.dart';
import 'package:askenzo_admin_panel/screen/home.dart';
import 'package:askenzo_admin_panel/screen/login/login.dart';
import 'package:askenzo_admin_panel/screen/popup/popup_create.dart';
import 'package:askenzo_admin_panel/screen/popup/popup_edit.dart';
import 'package:askenzo_admin_panel/screen/popup/popup_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The `main` function in Dart initializes the app and sets up the routes for different pages.

void main() {
  runApp(const ProviderScope(child: App()));
}

/// The `App` class is a Dart class that represents the main application widget and defines the routes
/// for different pages in the application.

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigationNotifier = ref.read(navigationProvider.notifier);
    globalScreenWidth = MediaQuery.of(context).size.width;
    globalScreenHeight = MediaQuery.of(context).size.height;

    globalNavigatorKey = navigationNotifier.navigatorKey;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        // Login
        ConstantData.loginAdmin: (context) => const LoginPage(),

        // Experience
        ConstantData.experienceHome: (context) => const ExperienceHome(),
        ConstantData.experienceCreate: (context) => const ExperienceCreate(),
        ConstantData.experienceUpdate: (context) => ExperienceEditDetail(
              experience: ModalRoute.of(context)!.settings.arguments
                  as UpdateExperienceModel,
            ),
        // Discovery
        ConstantData.discoveryHome: (context) => const DiscoveryHome(),
        ConstantData.discoveryCreate: (context) => const DiscoveryCreate(),
        ConstantData.discoveryUpdate: (context) => DiscoveryEditDetail(
              discovery: ModalRoute.of(context)!.settings.arguments
                  as UpdateDiscoveryModel,
            ),
        // Popup
        ConstantData.popupHome: (context) => const PopupHome(),
        ConstantData.popupCreate: (context) => const PopupCreate(),
        ConstantData.popupUpdate: (context) => PopupEdit(
              popup: ModalRoute.of(context)!.settings.arguments
                  as UpdatePopupModel,
            ),
      },
      navigatorKey: navigationNotifier.navigatorKey,
    );
  }
}
