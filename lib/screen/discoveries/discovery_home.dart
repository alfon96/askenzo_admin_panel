import 'package:askenzo_admin_panel/data/constant_data.dart';
import 'package:askenzo_admin_panel/models/discovery.dart';
import 'package:askenzo_admin_panel/provider/data_provider.dart';
import 'package:askenzo_admin_panel/provider/navigation_provider.dart';
import 'package:askenzo_admin_panel/widgets/app_bar.dart';

import 'package:askenzo_admin_panel/widgets/custom_actions.dart';
import 'package:askenzo_admin_panel/widgets/custom_drawer.dart';
import 'package:askenzo_admin_panel/widgets/custom_elevated_button.dart';
import 'package:askenzo_admin_panel/widgets/custom_id_text.dart';
import 'package:askenzo_admin_panel/widgets/custom_waiting_widget.dart';
import 'package:askenzo_admin_panel/widgets/delete_popup.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
/// The `DiscoveryHome` class is a stateful widget that extends `ConsumerStatefulWidget` in Dart.

class DiscoveryHome extends ConsumerStatefulWidget {
  const DiscoveryHome({super.key});

  @override
  ConsumerState<DiscoveryHome> createState() => _DiscoveryHomeState();
}
/// The `_DiscoveryHomeState` class is a stateful widget that displays a list of discovery items and
/// allows the user to create, edit, and delete items.

class _DiscoveryHomeState extends ConsumerState<DiscoveryHome> {
  bool isLoading = false;

  void refresh(
    scaffold,
  ) {
    setState(() {
      ref.read(discoveryProvider.notifier).fetchData(scaffold);
    });
  }

  void toggleLoading(bool value) {
    setState(() {
      isLoading = true;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(DiscoveryHome oldWidget) {
    super.didUpdateWidget(oldWidget);
    ref
        .read(discoveryProvider.notifier)
        .fetchData(ScaffoldMessenger.of(context));
  }

  @override
  Widget build(BuildContext context) {
    final navigationNotifier = ref.read(navigationProvider.notifier);
    ScaffoldMessengerState scaffold = ScaffoldMessenger.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        bckgColor: ConstantData.coloreDiscoveryPage,
        title: 'Lista Discovery attuali',
        actions: customActionsAppBar((scaffold) {
          refresh(scaffold);
        }, navigationNotifier, ConstantData.discoveryCreate, context),
      ),
      drawer: const CustomDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigationNotifier.push(
            ConstantData.discoveryCreate,
            arguments: () => refresh(ScaffoldMessenger.of(context)),
          );
        },
        backgroundColor: ConstantData.coloreDiscoveryPage,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: CustomWaitingWidget(
        isWaiting: isLoading,
        child: FutureBuilder<List<UpdateDiscoveryModel>?>(
          future: ref.read(discoveryProvider.notifier).fetchData(
                scaffold,
              ),
          builder: (BuildContext context,
              AsyncSnapshot<List<UpdateDiscoveryModel>?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || snapshot.data == null) {
              return Center(
                child: CustomElevatedButton(
                    bkgColor: ConstantData.coloreDiscoveryPage,
                    alignment: TextAlign.center,
                    fun: () =>
                        navigationNotifier.pushReplacement(ConstantData.home),
                    paddingVertical: 20,
                    title:
                        'Errore richiesta\nClicca qui per tornare alla Home.'),
              );
            } else {
              List<UpdateDiscoveryModel> discoveries = snapshot.data!;
              final navigationNotifier = ref.read(navigationProvider.notifier);
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 50),
                child: ListView.builder(
                  itemCount: discoveries.length,
                  itemBuilder: (context, index) {
                    final discovery = discoveries[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 200),
                      child: Card(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          leading: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.black),
                            onPressed: () {
                              navigationNotifier.push(
                                ConstantData.discoveryUpdate,
                                arguments: discovery,
                              );
                            },
                          ),
                          title: CustomIdText(
                            id: '${discovery.id}',
                            text: discovery.title,
                            icon: const Icon(Icons.beach_access_outlined),
                          ),
                          trailing: IconButton(
                            icon:
                                const Icon(Icons.remove, color: Colors.purple),
                            onPressed: () {
                              showDeleteDialog(
                                  discovery.id, TypeApp.discovery, context);
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
