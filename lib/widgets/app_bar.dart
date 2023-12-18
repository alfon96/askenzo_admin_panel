import 'package:askenzo_admin_panel/data/constant_data.dart';
import 'package:askenzo_admin_panel/provider/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The `CustomAppBar` class is a custom implementation of the `AppBar` widget in Flutter, with
/// additional features such as a customizable background color, actions, and a back button with
/// optional callback function.
class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.bckgColor,
    this.actions,
    this.popFun,
  });
  final String title;
  final Color? bckgColor;
  final Function? popFun;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigationNotifier = ref.read(navigationProvider.notifier);

    return AppBar(
      centerTitle: true,
      actions: actions ?? [],
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),
        textAlign: TextAlign.center,
      ),
      backgroundColor: bckgColor ?? mapSnackbarColors[contextColor],
      leadingWidth: 120,
      leading: Row(
        children: [
          const SizedBox(width: 5),
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          const SizedBox(width: 5),
          if (Navigator.canPop(context))
            IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  navigationNotifier.pop();

                  if (popFun != null) {
                    popFun!();
                  }
                }),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
