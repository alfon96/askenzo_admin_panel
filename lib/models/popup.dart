import 'dart:convert';
/// The `PopupModel` class represents a popup with a text property and provides methods to convert it to
/// JSON format.

class PopupModel {
  PopupModel({
    required this.text,
  });
  String text;

  Map<String, dynamic> toJson() => {
        'text': text,
      };

  String toJsonString() {
    return jsonEncode(toJson());
  }
}
/// The function `toUpdatePopupModel` converts a `Map` response into an `UpdatePopupModel` object.
/// 
/// Args:
///   response (Map<String, dynamic>): A map containing key-value pairs where the keys are strings and
/// the values can be of any type.
/// 
/// Returns:
///   an instance of the UpdatePopupModel class.

UpdatePopupModel toUpdatePopupModel(Map<String, dynamic> response) {
  return UpdatePopupModel(
    id: response['id'],
    text: response['text'],
  );
}

/// The `UpdatePopupModel` class is a subclass of `PopupModel` that includes an additional `id`
/// property.
class UpdatePopupModel extends PopupModel {
  UpdatePopupModel({
    required String text,
    required this.id,
  }) : super(
          text: text,
        );

  int id;
}
