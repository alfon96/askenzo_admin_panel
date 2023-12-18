import 'package:askenzo_admin_panel/provider/navigation_provider.dart';
import 'package:askenzo_admin_panel/widgets/login_popup.dart';
import 'package:flutter/material.dart';
/// The function returns a list of custom actions for an app bar in Dart, including a refresh button and
/// a login button.
/// 
/// Args:
///   refresh (Function): The `refresh` parameter is a function that takes a `ScaffoldMessenger` as an
/// argument and is called when the refresh button is pressed. It is used to refresh the content of the
/// page.
///   navigationNotifier (NavigationNotifier): The `navigationNotifier` parameter is an instance of the
/// `NavigationNotifier` class. It is used to notify the app about navigation events, such as changing
/// the current page or navigating to a different screen.
///   page (String): The `page` parameter is a string that represents the current page or screen in the
/// application.
///   context (BuildContext): The `context` parameter is the current build context of the widget tree.
/// It is typically used to access the theme, media query, and other properties of the current widget's
/// context.
/// 
/// Returns:
///   The function `customActionsAppBar` returns a list of `Widget` objects.

List<Widget> customActionsAppBar(Function refresh,
    NavigationNotifier navigationNotifier, String page, BuildContext context) {
  return <Widget>[
    IconButton(
      onPressed: () => refresh(ScaffoldMessenger.of(context)),
      icon: const Icon(Icons.refresh),
    ),
    IconButton(
        icon: const Icon(Icons.person),
        onPressed: () async => await showLoginDialog(context)),
  ];
}
