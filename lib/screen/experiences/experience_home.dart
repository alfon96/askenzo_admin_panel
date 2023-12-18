import 'package:askenzo_admin_panel/data/constant_data.dart';
import 'package:askenzo_admin_panel/models/experience.dart';
import 'package:askenzo_admin_panel/provider/data_provider.dart';
import 'package:askenzo_admin_panel/provider/navigation_provider.dart';
import 'package:askenzo_admin_panel/widgets/app_bar.dart';
import 'package:askenzo_admin_panel/widgets/custom_actions.dart';
import 'package:askenzo_admin_panel/widgets/custom_drawer.dart';
import 'package:askenzo_admin_panel/widgets/custom_elevated_button.dart';
import 'package:askenzo_admin_panel/widgets/custom_id_text.dart';
import 'package:askenzo_admin_panel/widgets/custom_waiting_widget.dart';
import 'package:askenzo_admin_panel/widgets/delete_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
/// The ExperienceHome class is a stateful widget that extends ConsumerStatefulWidget in Dart.

class ExperienceHome extends ConsumerStatefulWidget {
  const ExperienceHome({super.key});

  @override
  ConsumerState<ExperienceHome> createState() => _ExperienceHomeState();
}

/// The `_ExperienceHomeState` class is a stateful widget that displays a list of experiences and allows
/// users to edit and delete them.
/// The `ExperienceEditDetail` class is a stateful widget that allows users to edit experience details.
class _ExperienceHomeState extends ConsumerState<ExperienceHome> {
  List<int> selectedItems = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  void refresh(scaffold) {
    setState(() {
      ref.read(experienceProvider.notifier).fetchData(scaffold);
    });
  }

  void toggleLoading(bool value) {
    setState(() {
      isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    contextColor = 1;
    final navigationNotifier = ref.read(navigationProvider.notifier);
    ScaffoldMessengerState scaffold = ScaffoldMessenger.of(context);
    return CustomWaitingWidget(
      isWaiting: isLoading,
      child: Scaffold(
        appBar: CustomAppBar(
          bckgColor: mapSnackbarColors[contextColor],
          title: 'Lista Esperienze attuali',
          actions: customActionsAppBar(refresh, navigationNotifier,
              ConstantData.experienceCreate, context),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigationNotifier.push(
              ConstantData.experienceCreate,
              arguments: () => refresh(ScaffoldMessenger.of(context)),
            );
          },
          backgroundColor: mapSnackbarColors[contextColor],
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        ),
        drawer: const CustomDrawer(),
        body: FutureBuilder<List<UpdateExperienceModel>?>(
          future: ref.read(experienceProvider.notifier).fetchData(scaffold),
          builder: (BuildContext context,
              AsyncSnapshot<List<UpdateExperienceModel>?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || snapshot.data == null) {
              return Center(
                child: CustomElevatedButton(
                    alignment: TextAlign.center,
                    fun: () =>
                        navigationNotifier.pushReplacement(ConstantData.home),
                    paddingVertical: 20,
                    title:
                        'Errore richiesta\nClicca qui per tornare alla Home.'),
              );
            } else {
              List<UpdateExperienceModel> experiences = snapshot.data!;
              final navigationNotifier = ref.read(navigationProvider.notifier);
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 50),
                child: ListView.builder(
                  itemCount: experiences.length,
                  itemBuilder: (context, index) {
                    final experience = experiences[index];
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
                                  ConstantData.experienceUpdate,
                                  arguments: experience);
                            },
                          ),
                          title: CustomIdText(
                            id: '${experience.id}',
                            text: experience.title,
                            icon: const Icon(Icons.map),
                          ),
                          trailing: IconButton(
                            icon:
                                const Icon(Icons.remove, color: Colors.purple),
                            onPressed: () {
                              showDeleteDialog(
                                  experience.id, TypeApp.experience, context);
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
