import 'package:flutter/material.dart';

double globalScreenWidth = 0;
double globalScreenHeight = 0;

class ConstantData {
  static const String basePath = String.fromEnvironment(
    'SERVER',
    defaultValue: 'NotAValidUrl',
  );
  static const String username = 'askenzo_admin';
  static const String password = 'askenzo_admin123';
  static const String apiAdminLoginURL = '$basePath/admin/login';
  static const String pathsDelimiter = ';';
  // COLORS
  static const Color colorePrimario = Color.fromARGB(255, 37, 69, 90);
  static const Color coloreExperiencePage = Color(0xFFD1603D);
  static const Color coloreDiscoveryPage = Color(0xFFDDB967);
  static const Color colorePopUpPage = Color(0xFF78C0E0);
  // PAGE LAYOUT
  static const double marginHorizontal = 300.0;
  static const double marginVertical = 50.0;
  static const double spacingHeight = 15.0;
  // STYLE CUSTOM ELEVATED BUTTON
  static const String fontFamilyBody = 'PoppinsBlack';
  // IMAGE UPLOAD ROUTES
  static const String apiPostImage = '$basePath/images/new';
  static const String apiUpdateImage = '$basePath/images/update';
  static const String apiDeleteImage = '$basePath/images/delete';
  static const String apiPostListOfImage = '$basePath/images/new_list';
  static const String apiDeleteListOfImage = '$basePath/images/delete_list';
  // EXPERIENCE ROUTES
  static const String apiCreateExperienceURL = '$basePath/experiences/new';
  static const String apiUpdateExperienceURL = '$basePath/experiences/update';
  static const String apiGetExperienceURL = '$basePath/experiences/single';
  static const String apiGetExperienceListURL = '$basePath/experiences/list';
  static const String apDeleteExperienceURL = '$basePath/experiences/delete';
  // DISCOVERY ROUTES
  static const String apiCreateDiscoveryURL = '$basePath/discoveries/new';
  static const String apiUpdateDiscoveryURL = '$basePath/discoveries/update';
  static const String apiGetDiscoveryURL = '$basePath/discoveries/single';
  static const String apiGetDiscoveryListURL = '$basePath/discoveries/list';
  static const String apDeleteDiscoveryURL = '$basePath/discoveries/delete';
  // POPUP ROUTES
  static const String apiCreatePopupURL = '$basePath/popup/new';
  static const String apiUpdatePopupURL = '$basePath/popup/update';
  static const String apiGetPopupURL = '$basePath/popup/single';
  static const String apiGetPopupListURL = '$basePath/popup/list';
  static const String apDeletePopupURL = '$basePath/popup/delete';
  // WEBAPP ROUTES
  // Home
  static const String home = '/';
  // Login //
  static const String loginAdmin = '/login_admin';
  // Discovery //
  static const String discoveryHome = '/home_discovery';
  static const String discoveryCreate = '/create_discovery';
  static const String discoveryUpdate = '/update_discovery';
  // Experience //
  static const String experienceHome = '/home_experience';
  static const String experienceCreate = '/create_experience';
  static const String experienceUpdate = '/update_experience';
  // Popup //
  static const String popupHome = '/home_popup';
  static const String popupCreate = '/create_popup';
  static const String popupUpdate = '/update_popup';

  // Parametri schermata
  static const double paddingVerticalSubmit = 10;
  static const double paddingHorizontalSubmit = 60;
  static const double imgBoxSize = 150;
  static const double sizeOffset = 100;
  static const double zoomSize = 4;
  static const double widthDropArea = 500;
  static const double heightDropArea = 80;
  static const double sizeDeleteContainer =
      (imgBoxSize * 1.414 - imgBoxSize) / (2 * 1.414);
}

enum TypeApp { experience, discovery, popup }

int contextColor = 0;
/// The code snippet is defining several maps that associate certain values with specific keys:

Map<int, Color> mapSnackbarColors = {
  0: ConstantData.colorePrimario,
  1: ConstantData.coloreExperiencePage,
  2: ConstantData.coloreDiscoveryPage,
  3: ConstantData.colorePopUpPage,
};
Map<String, int> statesMap = {'active': 1, 'inactive': 2};
Map<String, int> difficultyMap = {'easy': 1, 'medium': 2, 'hard': 3};
Map<String, int> currencyMap = {'\$': 1, '€': 2};
/// The `discoveryKindsMap` is a map that associates different kinds of discoveries with their
/// corresponding integer values. Each key-value pair in the map represents a kind of discovery and its
/// associated integer value. For example, the key `'video'` is associated with the value `1`, the key
/// `'food'` is associated with the value `2`, and so on. This map can be used to easily map a kind of
/// discovery to its corresponding integer value or vice versa.

Map<String, int> discoveryKindsMap = {
  'video': 1,
  'food': 2,
  'monuments': 3,
  'hotels': 4
};
/// The class "Authentication" represents an authentication object with a JWT token.

class Authentication {
  String? jwt;

  Authentication({this.jwt});
}

Authentication kAuthentication = Authentication();
