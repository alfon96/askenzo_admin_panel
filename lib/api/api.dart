import 'dart:convert';
import 'package:askenzo_admin_panel/api/api_exceptions.dart';
import 'package:askenzo_admin_panel/data/constant_data.dart';
import 'package:askenzo_admin_panel/exceptions/exceptions.dart';
import 'package:askenzo_admin_panel/models/discovery.dart';
import 'package:askenzo_admin_panel/models/experience.dart';
import 'package:askenzo_admin_panel/models/popup.dart';
import 'package:askenzo_admin_panel/shared_functions/shared_functions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
/// The `headers` variable is a `Map` that contains the headers to be sent with HTTP requests. It
/// includes the following headers:
/// The above code is creating a map called "headers" with key-value pairs. These headers are commonly
/// used in HTTP requests to provide additional information about the request. In this case, the headers
/// include the "accept" header with a value of "application/json", the "Content-Type" header with a
/// value of "application/json", and the "Authorization" header with a value of "Bearer" followed by the
/// value of the "kAuthentication.jwt" variable.

Map<String, String> headers = {
  'accept': 'application/json',
  'Content-Type': 'application/json',
  'Authorization': 'Bearer ${kAuthentication.jwt}',
};

Map<String, String> getFileHeaders() {
  return {
    'accept': 'application/json',
    'Content-Type': 'multipart/form-data',
    'Authorization': 'Bearer ${kAuthentication.jwt}',
  };
}
/// The function `updateHeader()` updates the headers with the necessary information for making
/// authenticated API requests.

void updateHeader() {
  headers = {
    'accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${kAuthentication.jwt}',
  };
}

Future<bool> createExperience(
  ScaffoldMessengerState scaffoldMessenger,
  ExperienceModel experience,
) async {
  try {
    final response = await http.post(
      Uri.parse(ConstantData.apiCreateExperienceURL),
      headers: headers,
      body: experience.toJsonString(),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      exceptionHandler(response.statusCode, scaffoldMessenger);
      return false;
    }
  } catch (e) {
    throw Exception('Failed request');
  }
}
/// The `adminLogin` function is responsible for logging in an admin user by making an API request with
/// the provided username and password.
/// 
/// Args:
///   scaffoldMessenger (ScaffoldMessengerState): The `scaffoldMessenger` parameter is an instance of
/// `ScaffoldMessengerState`, which is used to show snack bars and other notifications within the app's
/// scaffold. It is used to display error messages or alternative messages to the user.
///   username (String): The username of the admin trying to log in.
///   password (String): The password parameter is a string that represents the user's password for the
/// admin login.
///   alternativeMessage (String): The `alternativeMessage` parameter is an optional parameter that
/// allows you to provide a custom error message to be displayed in case of a failed login attempt. If
/// this parameter is not provided, the function will call the `exceptionHandler` function to display
/// the default error message based on the response status code.
/// 
/// Returns:
///   The function `adminLogin` returns a `Future<bool?>`.

Future<bool?> adminLogin(
    ScaffoldMessengerState scaffoldMessenger, String username, String password,
    {String? alternativeMessage}) {
  return handleApiErrors<bool>(() async {
    String url =
        '${ConstantData.apiAdminLoginURL}?username=$username&password=$password';
    final response = await http.post(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode((utf8.decode(response.bodyBytes)));
      String? token = responseData['access_token'];
      if (token != null) {
        kAuthentication.jwt = token;
        updateHeader();
        return true;
      }
      return false;
    } else {
      if (alternativeMessage == null) {
        exceptionHandler(response.statusCode, scaffoldMessenger);
      } else {
        showCustomSnackBar(scaffoldMessenger, alternativeMessage);
      }
      return false;
    }
  }, scaffoldMessenger);
}
/// The function `getExperience` retrieves an experience from an API endpoint and returns it as an
/// `UpdateExperienceModel` object, or throws an exception if the request fails.
/// 
/// Args:
///   scaffoldMessenger (ScaffoldMessengerState): The `scaffoldMessenger` parameter is an instance of
/// `ScaffoldMessengerState`, which is used to show snackbars or modal dialogs to display messages or
/// notifications to the user. It is typically obtained by calling `ScaffoldMessenger.of(context)`
/// within a widget's build method.
///   id (int): The `id` parameter is an integer that represents the ID of the experience you want to
/// retrieve. It is used to construct the URL for the API request.
/// 
/// Returns:
///   a `Future` object that resolves to an `UpdateExperienceModel` or `null`.

Future<UpdateExperienceModel?> getExperience(
    ScaffoldMessengerState scaffoldMessenger, int id) async {
  try {
    String url = '${ConstantData.apiGetExperienceURL}?id=$id';

    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData =
          jsonDecode((utf8.decode(response.bodyBytes)))['result'];
      return toUpdateExperienceModel(responseData);
    } else {
      exceptionHandler(response.statusCode, scaffoldMessenger);
      return null;
    }
  } catch (e) {
    throw Exception('Failed request');
  }
}

Future<List<UpdateExperienceModel>?> getExperienceList(
    ScaffoldMessengerState scaffoldMessenger, int cursor, int limit) async {
  try {
    String url =
        '${ConstantData.apiGetExperienceListURL}?cursor=$cursor&limit=$limit';

    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<UpdateExperienceModel> result = [];
      dynamic responseData =
          jsonDecode((utf8.decode(response.bodyBytes)))['items'];
      for (Map<String, dynamic> item in responseData) {
        result.add(toUpdateExperienceModel(item));
      }
      return result;
    } else {
      exceptionHandler(response.statusCode, scaffoldMessenger);
      return null;
    }
  } catch (e) {
    throw Exception('Failed request');
  }
}
/// The function `updateExperience` sends a PATCH request to update an experience and returns a boolean
/// indicating whether the update was successful or not.
/// 
/// Args:
///   scaffoldMessenger (ScaffoldMessengerState): The `scaffoldMessenger` parameter is an instance of
/// `ScaffoldMessengerState` which is used to show snackbars or modal bottom sheets within a `Scaffold`
/// widget. It allows you to display messages or notifications to the user.
///   experience (UpdateExperienceModel): The "experience" parameter is an instance of the
/// "UpdateExperienceModel" class. It contains the data that needs to be updated for a particular
/// experience.
/// 
/// Returns:
///   a `Future<bool>`.

Future<bool> updateExperience(
  ScaffoldMessengerState scaffoldMessenger,
  UpdateExperienceModel experience,
) async {
  try {
    final response = await http.patch(
      Uri.parse(
          '${ConstantData.apiUpdateExperienceURL}?experience_id=${experience.id}'),
      headers: headers,
      body: experience.toJsonString(),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      exceptionHandler(response.statusCode, scaffoldMessenger);
      return false;
    }
  } catch (e) {
    throw Exception('Failed request');
  }
}
/// The function `deleteExperience` sends a DELETE request to a specified URL with an experience ID, and
/// returns true if the request is successful, otherwise it handles the exception and returns false.
/// 
/// Args:
///   scaffoldMessenger (ScaffoldMessengerState): The `scaffoldMessenger` parameter is an instance of
/// `ScaffoldMessengerState` which is used to show snackbar messages or modal dialogs in a Flutter
/// application. It is typically obtained by calling `ScaffoldMessenger.of(context)` where `context` is
/// the current build context.
///   id (int): The `id` parameter is an integer that represents the unique identifier of the experience
/// that needs to be deleted.
/// 
/// Returns:
///   a `Future<bool>`.

Future<bool> deleteExperience(
    ScaffoldMessengerState scaffoldMessenger, int id) async {
  try {
    final response = await http.delete(
      Uri.parse('${ConstantData.apDeleteExperienceURL}?experience_id=$id'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      exceptionHandler(response.statusCode, scaffoldMessenger);
      return false;
    }
  } catch (e) {
    throw Exception('Failed request');
  }
}

// DISCOVERY
/// The function `createDiscovery` sends a POST request to a specified API endpoint to create a new
/// discovery, and returns a boolean value indicating whether the request was successful or not.
/// 
/// Args:
///   scaffoldMessenger (ScaffoldMessengerState): The `scaffoldMessenger` parameter is an instance of
/// `ScaffoldMessengerState`, which is used to show snackbars or modal bottom sheets within a `Scaffold`
/// widget. It allows you to display messages or notifications to the user.
///   discovery (DiscoveryModel): The `discovery` parameter is an instance of the `DiscoveryModel`
/// class. It contains the data that needs to be sent to the server in the request body.
/// 
/// Returns:
///   a `Future<bool>`.
/// The function `createDiscovery` sends a POST request to a specified API endpoint to create a new
/// discovery, and returns a boolean value indicating whether the request was successful or not.
/// 
/// Args:
///   scaffoldMessenger (ScaffoldMessengerState): The `scaffoldMessenger` parameter is an instance of
/// `ScaffoldMessengerState`, which is used to show snackbars or modal bottom sheets within a `Scaffold`
/// widget. It allows you to display messages or notifications to the user.
///   discovery (DiscoveryModel): The `discovery` parameter is an instance of the `DiscoveryModel`
/// class. It contains the data that needs to be sent to the server in the request body.
/// 
/// Returns:
///   a `Future<bool>`.

Future<bool> createDiscovery(
  ScaffoldMessengerState scaffoldMessenger,
  DiscoveryModel discovery,
) async {
  try {
    final response = await http.post(
      Uri.parse(ConstantData.apiCreateDiscoveryURL),
      headers: headers,
      body: discovery.toJsonString(),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      exceptionHandler(response.statusCode, scaffoldMessenger);
      return false;
    }
  } catch (e) {
    throw Exception('Failed request');
  }
}

Future<UpdateDiscoveryModel?> getDiscovery(
    ScaffoldMessengerState scaffoldMessenger, int id) async {
  try {
    String url = '${ConstantData.apiGetDiscoveryURL}?id=$id';

    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData =
          jsonDecode((utf8.decode(response.bodyBytes)))['result'];
      return toUpdateDiscoveryModel(responseData);
    } else {
      exceptionHandler(response.statusCode, scaffoldMessenger);
      return null;
    }
  } catch (e) {
    throw Exception('Failed request');
  }
}
/// The function `getDiscoveryList` makes an HTTP GET request to retrieve a list of discovery items and
/// returns a list of `UpdateDiscoveryModel` objects.
/// 
/// Args:
///   scaffoldMessenger (ScaffoldMessengerState): The `scaffoldMessenger` parameter is an instance of
/// `ScaffoldMessengerState` which is used to show snackbars or modal dialogs to display messages or
/// errors to the user.
///   cursor (int): The cursor parameter is used to specify the starting point of the data to be
/// fetched. It helps in pagination by indicating the position from where the next set of data should be
/// retrieved.
///   limit (int): The `limit` parameter is used to specify the maximum number of items to be returned
/// in the discovery list. It determines the number of items that will be fetched from the API in a
/// single request.
/// 
/// Returns:
///   a `Future<List<UpdateDiscoveryModel>?>`.

Future<List<UpdateDiscoveryModel>?> getDiscoveryList(
    ScaffoldMessengerState scaffoldMessenger, int cursor, int limit) async {
  try {
    String url =
        '${ConstantData.apiGetDiscoveryListURL}?cursor=$cursor&limit=$limit&category=1&all=true';

    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<UpdateDiscoveryModel> result = [];
      dynamic responseData =
          jsonDecode((utf8.decode(response.bodyBytes)))['items'];
      for (Map<String, dynamic> item in responseData) {
        result.add(toUpdateDiscoveryModel(item));
      }
      return result;
    } else {
      exceptionHandler(response.statusCode, scaffoldMessenger);
      return null;
    }
  } catch (e) {
    throw Exception('Failed request');
  }
}
/// The function `updateDiscovery` sends a PATCH request to update a discovery using the provided
/// `discovery` model, and returns a boolean indicating whether the update was successful or not.
/// 
/// Args:
///   scaffoldMessenger (ScaffoldMessengerState): The `scaffoldMessenger` parameter is an instance of
/// `ScaffoldMessengerState` which is used to show snackbars or modal bottom sheets within a `Scaffold`
/// widget. It is typically used to display error messages or notifications to the user.
///   discovery (UpdateDiscoveryModel): The "discovery" parameter is an instance of the
/// "UpdateDiscoveryModel" class. It contains the data that needs to be updated for a discovery.
/// 
/// Returns:
///   a `Future<bool>`.

Future<bool> updateDiscovery(
  ScaffoldMessengerState scaffoldMessenger,
  UpdateDiscoveryModel discovery,
) async {
  try {
    final response = await http.patch(
      Uri.parse(
          '${ConstantData.apiUpdateDiscoveryURL}?discovery_id=${discovery.id}'),
      headers: headers,
      body: discovery.toJsonString(),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      exceptionHandler(response.statusCode, scaffoldMessenger);
      return false;
    }
  } catch (e) {
    throw Exception('Failed request');
  }
}
/// The function `deleteDiscovery` sends a DELETE request to a specified URL with a discovery ID, and
/// returns true if the request is successful, otherwise it handles the exception and returns false.
/// 
/// Args:
///   scaffoldMessenger (ScaffoldMessengerState): The `scaffoldMessenger` parameter is an instance of
/// `ScaffoldMessengerState` which is used to show snackbars or modal dialogs to display messages or
/// errors to the user.
///   id (int): The id parameter is an integer that represents the unique identifier of the discovery
/// that needs to be deleted.
/// 
/// Returns:
///   a `Future<bool>`.

Future<bool> deleteDiscovery(
    ScaffoldMessengerState scaffoldMessenger, int id) async {
  try {
    final response = await http.delete(
      Uri.parse('${ConstantData.apDeleteDiscoveryURL}?discovery_id=$id'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      exceptionHandler(response.statusCode, scaffoldMessenger);
      return false;
    }
  } catch (e) {
    throw Exception('Failed request');
  }
}

// POP UP messages
/// The above code is defining a function called `createPopup` in Dart. This function takes two
/// parameters: `scaffoldMessenger` of type `ScaffoldMessengerState` and `popup` of type `PopupModel`.

Future<bool> createPopup(
  ScaffoldMessengerState scaffoldMessenger,
  PopupModel popup,
) async {
  try {
    final response = await http.post(
      Uri.parse(ConstantData.apiCreatePopupURL),
      headers: headers,
      body: popup.toJsonString(),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      exceptionHandler(response.statusCode, scaffoldMessenger);
      return false;
    }
  } catch (e) {
    throw Exception('Failed request');
  }
}
/// The function `getPopup` retrieves a popup model from an API endpoint and returns it as a `Future`.
/// 
/// Args:
///   scaffoldMessenger (ScaffoldMessengerState): The `scaffoldMessenger` parameter is an instance of
/// `ScaffoldMessengerState` which is used to show snackbars or modal bottom sheets in the app. It is
/// typically obtained by calling `ScaffoldMessenger.of(context)`.
///   id (int): The `id` parameter is an integer value that represents the unique identifier of the
/// popup that you want to retrieve.
/// 
/// Returns:
///   a `Future` object that resolves to an `UpdatePopupModel` or `null`.

Future<UpdatePopupModel?> getPopup(
    ScaffoldMessengerState scaffoldMessenger, int id) async {
  try {
    String url = '${ConstantData.apiGetPopupURL}?id=$id';

    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData =
          jsonDecode((utf8.decode(response.bodyBytes)))['result'];
      return toUpdatePopupModel(responseData);
    } else {
      exceptionHandler(response.statusCode, scaffoldMessenger);
      return null;
    }
  } catch (e) {
    throw Exception('Failed request');
  }
}
/// The function `getPopupList` retrieves a list of update popups from an API endpoint and returns it as
/// a list of `UpdatePopupModel` objects.
/// 
/// Args:
///   scaffoldMessenger (ScaffoldMessengerState): The `scaffoldMessenger` parameter is an instance of
/// `ScaffoldMessengerState` which is used to show snackbars or modal dialogs to display messages or
/// notifications to the user. It is typically obtained by calling `ScaffoldMessenger.of(context)` where
/// `context` is the current build context.
///   cursor (int): The cursor parameter is used to specify the starting point of the data to be
/// fetched. It helps in pagination by indicating the position from where the next set of data should be
/// retrieved.
///   limit (int): The `limit` parameter is used to specify the maximum number of items to be returned
/// in the response. It determines the number of items that will be fetched from the API in a single
/// request.
/// 
/// Returns:
///   a `Future<List<UpdatePopupModel>?>`.

Future<List<UpdatePopupModel>?> getPopupList(
    ScaffoldMessengerState scaffoldMessenger, int cursor, int limit) async {
  try {
    String url =
        '${ConstantData.apiGetPopupListURL}?cursor=$cursor&limit=$limit';

    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<UpdatePopupModel> result = [];
      dynamic responseData =
          jsonDecode((utf8.decode(response.bodyBytes)))['items'];
      for (Map<String, dynamic> item in responseData) {
        result.add(toUpdatePopupModel(item));
      }
      return result;
    } else {
      exceptionHandler(response.statusCode, scaffoldMessenger);
      return null;
    }
  } catch (e) {
    throw Exception('Failed request');
  }
}
/// The above code is defining a function called `updatePopup` in Dart. This function takes two
/// parameters: `scaffoldMessenger` of type `ScaffoldMessengerState` and `popup` of type
/// `UpdatePopupModel`.

Future<bool> updatePopup(
  ScaffoldMessengerState scaffoldMessenger,
  UpdatePopupModel popup,
) async {
  try {
    final response = await http.patch(
      Uri.parse('${ConstantData.apiUpdatePopupURL}?popup_id=${popup.id}'),
      headers: headers,
      body: popup.toJsonString(),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      exceptionHandler(response.statusCode, scaffoldMessenger);
      return false;
    }
  } catch (e) {
    throw Exception('Failed request');
  }
}
/// The `deletePopup` function sends a DELETE request to a specified URL with a given popup ID and
/// returns a boolean indicating whether the request was successful or not.
/// 
/// Args:
///   scaffoldMessenger (ScaffoldMessengerState): The `scaffoldMessenger` parameter is an instance of
/// `ScaffoldMessengerState`, which is used to show snackbars and other notifications to the user. It is
/// typically obtained by calling `ScaffoldMessenger.of(context)` in a widget's build method.
///   id (int): The id parameter is an integer that represents the unique identifier of the popup that
/// needs to be deleted.
/// 
/// Returns:
///   a `Future<bool>`.

Future<bool> deletePopup(
    ScaffoldMessengerState scaffoldMessenger, int id) async {
  try {
    final response = await http.delete(
      Uri.parse('${ConstantData.apDeletePopupURL}?popup_id=$id'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      exceptionHandler(response.statusCode, scaffoldMessenger);
      return false;
    }
  } catch (e) {
    throw Exception('Failed request');
  }
}
