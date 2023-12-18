import 'package:askenzo_admin_panel/data/constant_data.dart';
import 'package:askenzo_admin_panel/models/popup.dart';
import 'package:askenzo_admin_panel/provider/data_provider.dart';
import 'package:askenzo_admin_panel/provider/navigation_provider.dart';
import 'package:askenzo_admin_panel/provider/refresh_provider.dart';
import 'package:askenzo_admin_panel/widgets/app_bar.dart';

import 'package:askenzo_admin_panel/widgets/custom_actions.dart';
import 'package:askenzo_admin_panel/widgets/custom_drawer.dart';
import 'package:askenzo_admin_panel/widgets/custom_elevated_button.dart';
import 'package:askenzo_admin_panel/widgets/custom_id_text.dart';
import 'package:askenzo_admin_panel/widgets/custom_waiting_widget.dart';
import 'package:askenzo_admin_panel/widgets/delete_popup.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
/// The class `PopupHome` is a stateful widget that extends `ConsumerStatefulWidget` in Dart.

class PopupHome extends ConsumerStatefulWidget {
  const PopupHome({super.key});

  @override
  ConsumerState<PopupHome> createState() => _PopupHomeState();
}
/// The `_PopupHomeState` class is a stateful widget that displays a list of popups and allows the user
/// to create, edit, and delete popups.

class _PopupHomeState extends ConsumerState<PopupHome> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  void refresh(scaffold) {
    setState(() {
      ref.read(popupProvider.notifier).fetchData(scaffold);
    });
  }

  void toggleLoading(bool value) {
    setState(() {
      isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigationNotifier = ref.read(navigationProvider.notifier);
    ScaffoldMessengerState scaffold = ScaffoldMessenger.of(context);
    ref.watch(refreshProvider);
    return CustomWaitingWidget(
      isWaiting: isLoading,
      child: Scaffold(
        appBar: CustomAppBar(
          bckgColor: ConstantData.colorePopUpPage,
          title: 'Lista Esperienze attuali',
          actions: customActionsAppBar(
              refresh, navigationNotifier, ConstantData.popupCreate, context),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigationNotifier.push(
              ConstantData.popupCreate,
              arguments: () => refresh(ScaffoldMessenger.of(context)),
            );
          },
          backgroundColor: ConstantData.colorePopUpPage,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        ),
        drawer: const CustomDrawer(),
        body: FutureBuilder<List<UpdatePopupModel>?>(
          future: ref.read(popupProvider.notifier).fetchData(scaffold),
          builder: (BuildContext context,
              AsyncSnapshot<List<UpdatePopupModel>?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || snapshot.data == null) {
              return Center(
                child: CustomElevatedButton(
                    bkgColor: ConstantData.colorePopUpPage,
                    alignment: TextAlign.center,
                    fun: () =>
                        navigationNotifier.pushReplacement(ConstantData.home),
                    paddingVertical: 20,
                    title:
                        'Errore richiesta\nClicca qui per tornare alla Home.'),
              );
            } else {
              List<UpdatePopupModel> popups = snapshot.data!;
              final navigationNotifier = ref.read(navigationProvider.notifier);
              return Container(
                margin: const EdgeInsets.symmetric(
                    vertical: ConstantData.marginVertical),
                child: ListView.builder(
                  itemCount: popups.length,
                  itemBuilder: (context, index) {
                    final popup = popups[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: ConstantData.marginHorizontal),
                      child: Card(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          leading: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.black),
                            onPressed: () {
                              navigationNotifier.push(ConstantData.popupUpdate,
                                  arguments: popup);
                            },
                          ),
                          title: CustomIdText(
                            id: '${popup.id}',
                            text: popup.text,
                            icon: const Icon(Icons.textsms_sharp),
                          ),
                          trailing: IconButton(
                            icon:
                                const Icon(Icons.remove, color: Colors.purple),
                            onPressed: () {
                              showDeleteDialog(
                                  popup.id, TypeApp.popup, context);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
