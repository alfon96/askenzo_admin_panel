import 'package:askenzo_admin_panel/data/constant_data.dart';
import 'package:askenzo_admin_panel/provider/data_provider.dart';
import 'package:askenzo_admin_panel/provider/navigation_provider.dart';
import 'package:askenzo_admin_panel/widgets/custom_drawer_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The `CustomDrawer` class is a widget that represents a custom drawer with buttons for navigating to
/// different pages in an app.
const double containerHeight = 150;

enum ButtonName { home, experience, discovery, popup }

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigationNotifier = ref.read(navigationProvider.notifier);
    ScaffoldMessengerState scaffold = ScaffoldMessenger.of(context);

    void btnFuns(ButtonName btn) async {
      navigationNotifier.pop();
      if (btn == ButtonName.experience) {
        contextColor = 1;
        if (await ref.read(experienceProvider.notifier).fetchData(scaffold) !=
            null) {
          navigationNotifier.push(ConstantData.experienceHome);
        }
      } else if (btn == ButtonName.discovery) {
        contextColor = 2;
        if (await ref.read(discoveryProvider.notifier).fetchData(scaffold) !=
            null) {
          navigationNotifier.push(ConstantData.discoveryHome);
        }
      } else if (btn == ButtonName.popup) {
        contextColor = 3;
        if (await ref.read(popupProvider.notifier).fetchData(scaffold) !=
            null) {
          navigationNotifier.push(ConstantData.popupHome);
        }
      } else {
        navigationNotifier.push(ConstantData.home);
        contextColor = 0;
      }
    }

    return Drawer(
      backgroundColor: const Color.fromARGB(0, 255, 255, 255),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomDrawerButton(
              backgroundColor: ConstantData.colorePrimario,
              containerHeight: containerHeight,
              fun: () async => btnFuns(ButtonName.home),
              buttonText: 'Home'),
          CustomDrawerButton(
              backgroundColor: ConstantData.coloreExperiencePage,
              containerHeight: containerHeight,
              fun: () async => btnFuns(ButtonName.experience),
              buttonText: 'Esperienze'),
          CustomDrawerButton(
              backgroundColor: ConstantData.coloreDiscoveryPage,
              containerHeight: containerHeight,
              fun: () => btnFuns(ButtonName.discovery),
              buttonText: 'Discovery'),
          CustomDrawerButton(
              backgroundColor: ConstantData.colorePopUpPage,
              containerHeight: containerHeight,
              fun: () async => btnFuns(ButtonName.popup),
              buttonText: 'Popup'),
        ],
      ),
    );
  }
}
