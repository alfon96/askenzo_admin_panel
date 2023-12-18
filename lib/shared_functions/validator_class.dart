import 'package:askenzo_admin_panel/widgets/image_item.dart';

/// The above code contains a series of validation functions for different input fields in a Dart
/// application.
/// 
/// Args:
///   title (String): The title of a content.
/// 
/// Returns:
///   The functions are returning a string if there is a validation error, and null if there is no
/// error.
String? _validateTitle(String title) {
  if (title.isEmpty || title.contains(RegExp(r'\d'))) {
    return 'Il titolo non può essere vuoto e non deve contenere numeri.';
  }
  return null;
}

String? _validateDescription(String description) {
  if (description.isEmpty) {
    return 'La descrizione non può essere vuota.';
  }
  return null;
}

String? _validateImgPreviewPath(List<ImageItem> imgPreviewPath) {
  if (imgPreviewPath.isEmpty) {
    return 'Il link dell\'immagine di copertina non può essere nullo.';
  }
  return null;
}

String? _validateImgPaths(List<ImageItem> value) {
  if (value.isEmpty) {
    return 'E\' necessario che ci sia almeno un\'immagine di dettaglio';
  }
  return null;
}

String? _validatePrice(String price) {
  final trimmedPrice = price.trim();

  try {
    double.parse(trimmedPrice);
    return null;
  } catch (e) {
    return 'Inserire un prezzo valido';
  }
}

String? _validateDuration(duration) {
  if (!RegExp(r'^([0-1][0-9]|2[0-3]):([0-5][0-9]):([0-5][0-9])$')
      .hasMatch(duration)) {
    return 'La durata dell\'esperienza deve rispettare il formato hh:mm:ss';
  }
  return null;
}

String? _validateVideoPath(videoPaths, kind) {
  if (videoPaths.isEmpty && kind == 'VIDEO') {
    return 'Il link del video non può essere nullo per un contenuto di tipo VIDEO.';
  }
  return null;
}

String? _validateLatGps(latGps) {
  if (!RegExp(
          r'^(\+|-)?(?:90(?:(?:\.0{1,6})?)|(?:[0-9]|[1-8][0-9])(?:(?:\.[0-9]{1,6})?))$')
      .hasMatch(latGps)) {
    return 'La latitudine inserita non è valida. Essa deve essere compresa tra -90 e 90°';
  }
  return null;
}

String? _validateLonGps(lonGps) {
  if (!RegExp(
          r'^(\+|-)?(?:180(?:(?:\.0{1,6})?)|(?:[0-9]|[1-9][0-9]|1[0-7][0-9])(?:(?:\.[0-9]{1,6})?))$')
      .hasMatch(lonGps)) {
    return 'La longitudine inserita non è valida. Essa deve essere compresa tra -180 e 180°';
  }
  return null;
}

String? _validateAddress(String username) {
  return null;
}

String? _validateUsername(String username) {
  if (username.isEmpty) {
    return 'L\'username non può essere vuoto.';
  }
  return null;
}

String? _validatePassword(String password) {
  if (password.isEmpty) {
    return 'La password non può essere vuota.';
  }
  return null;
}

String? _validateId(String id) {
  if (id.isEmpty) {
    return 'L\'id non può essere nullo.';
  }
  final validCharacters = RegExp(r'^[0-9]+$');
  if (!validCharacters.hasMatch(id)) {
    return 'Il prezzo non può contenere lettere.';
  }
  return null;
}

String? _validatePopupText(String id) {
  return null;
}

/// The code block you provided defines a set of constant functions that can be used for validating
/// different fields in a form. Each function takes a specific input and performs validation checks on
/// it. These functions are then assigned to constant variables for easy access and reuse throughout the
/// codebase.
// LOGIN
const Function validateUsername = _validateUsername;
const Function validatePassword = _validatePassword;

//ID
const Function validateId = _validateId;

// COMMON
const Function validateTitle = _validateTitle;
const Function validateDescription = _validateDescription;
const Function validateImgPreviewPath = _validateImgPreviewPath;
const Function validateImgPaths = _validateImgPaths;

// EXPERIENCE
const Function validatePrice = _validatePrice;
const Function validateDuration = _validateDuration;
// DISCOVERY
const Function validateVideoPath = _validateVideoPath;
const Function validateLatGps = _validateLatGps;
const Function validateLonGps = _validateLonGps;
const Function validateAddress = _validateAddress;
// POPUP
const Function validatePopupText = _validatePopupText;
