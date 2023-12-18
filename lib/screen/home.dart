import 'package:askenzo_admin_panel/data/constant_data.dart';
import 'package:askenzo_admin_panel/provider/data_provider.dart';
import 'package:askenzo_admin_panel/provider/navigation_provider.dart';
import 'package:askenzo_admin_panel/widgets/app_bar.dart';
import 'package:askenzo_admin_panel/widgets/custom_drawer.dart';
import 'package:askenzo_admin_panel/widgets/custom_elevated_button.dart';
import 'package:askenzo_admin_panel/widgets/custom_waiting_widget.dart';
import 'package:askenzo_admin_panel/widgets/login_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ButtonName { experience, discovery, popup }
/// The `HomePage` class is a stateful widget that extends `ConsumerStatefulWidget` in Dart.

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}
/// The `_HomePageState` class represents the state of the `HomePage` widget and contains logic for
/// handling button clicks and displaying loading indicators.

class _HomePageState extends ConsumerState<HomePage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final navigationNotifier = ref.read(navigationProvider.notifier);
    ScaffoldMessengerState scaffold = ScaffoldMessenger.of(context);

    void btnFuns(ButtonName btn) async {
      setState(() {
        isLoading = true;
      });
      if (btn == ButtonName.experience) {
        if (await ref.read(experienceProvider.notifier).fetchData(scaffold) !=
            null) {
          navigationNotifier.push(ConstantData.experienceHome);
        }
      } else if (btn == ButtonName.discovery) {
        if (await ref.read(discoveryProvider.notifier).fetchData(scaffold) !=
            null) {
          navigationNotifier.push(ConstantData.discoveryHome);
        }
      } else {
        if (btn == ButtonName.popup) {
          if (await ref.read(popupProvider.notifier).fetchData(scaffold) !=
              null) {
            navigationNotifier.push(ConstantData.popupHome);
          }
        }
      }
      setState(() {
        isLoading = false;
      });
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Admin Panel',
        bckgColor: ConstantData.colorePrimario,
        actions: [
          IconButton(
              icon: const Icon(Icons.person),
              onPressed: () async => await showLoginDialog(context)),
        ],
      ),
      drawer: const CustomDrawer(),
      body: CustomWaitingWidget(
        isWaiting: isLoading,
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(
                horizontal: ConstantData.marginHorizontal,
                vertical: ConstantData.marginVertical),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomElevatedButton(
                    bkgColor: ConstantData.coloreExperiencePage,
                    paddingVertical: 20,
                    fun: () async => btnFuns(ButtonName.experience),
                    title: 'Esperienze',
                    ctxColor: 1,
                  ),
                  const SizedBox(height: 30),
                  CustomElevatedButton(
                    bkgColor: ConstantData.coloreDiscoveryPage,
                    paddingVertical: 20,
                    fun: () async => btnFuns(ButtonName.discovery),
                    title: 'Discovery',
                    ctxColor: 2,
                  ),
                  const SizedBox(height: 30),
                  CustomElevatedButton(
                    bkgColor: ConstantData.colorePopUpPage,
                    paddingVertical: 20,
                    fun: () async => btnFuns(ButtonName.popup),
                    title: 'Popup',
                    ctxColor: 3,
                  ),
                  // const SizedBox(height: 30),
                  // ElevatedButton(
                  //     onPressed: () {}, child: const Text('Disattiva Utente')),
                  // const SizedBox(height: 30),
                  // ElevatedButton(
                  //     onPressed: () {}, child: const Text('Disattiva Contenuto')),
                ]),
          ),
        ),
      ),
    );
  }
}
