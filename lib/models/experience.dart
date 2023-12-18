import 'dart:convert';

/// The `ExperienceModel` class represents an experience with various properties such as title,
/// description, difficulty level, price, duration, image paths, and state ID.
class ExperienceModel {
  ExperienceModel({
    required this.title,
    required this.description,
    required this.difficultyId,
    required this.price,
    required this.duration,
    required this.imgPreviewPath,
    required this.imgPaths,
    required this.stateId,
  });
  String title;
  String description;
  int difficultyId;
  Map<String, double> price;
  String duration;
  String imgPreviewPath;
  List<String> imgPaths;
  int stateId;

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'difficulty_id': difficultyId,
        'price': price,
        'duration': duration,
        'img_preview_path': imgPreviewPath,
        'img_paths': imgPaths,
        'state_id': stateId,
      };

  String toJsonString() {
    return jsonEncode(toJson());
  }
}
/// The function `toUpdateExperienceModel` takes a `Map` response and returns an instance of
/// `UpdateExperienceModel` with the corresponding values from the response.
/// 
/// Args:
///   response (Map<String, dynamic>): A map containing the response data from an API call.
/// 
/// Returns:
///   an instance of the UpdateExperienceModel class.

UpdateExperienceModel toUpdateExperienceModel(Map<String, dynamic> response) {
  return UpdateExperienceModel(
    id: response['id'],
    title: response['title'],
    description: response['description'],
    difficultyId: response['difficulty_id'],
    price: (response['price'] as Map<String, dynamic>)
        .map((key, value) => MapEntry(key, double.parse(value.toString()))),
    duration: response['duration'],
    imgPreviewPath: response['img_preview_path'],
    imgPaths: List<String>.from(response['img_paths']),
    stateId: response['state_id'],
  );
}

/// The `UpdateExperienceModel` class is a subclass of `ExperienceModel` and represents an updated
/// experience with an additional `id` property.

class UpdateExperienceModel extends ExperienceModel {
  UpdateExperienceModel({
    required String title,
    required String description,
    required int difficultyId,
    required Map<String, double> price,
    required String duration,
    required String imgPreviewPath,
    required List<String> imgPaths,
    required int stateId,
    required this.id,
  }) : super(
          title: title,
          description: description,
          difficultyId: difficultyId,
          price: price,
          duration: duration,
          imgPreviewPath: imgPreviewPath,
          imgPaths: imgPaths,
          stateId: stateId,
        );

  int id;
}





// Use this to have a popup that searches and retrives an experience by id
// IconButton(
//                   onPressed: () async {
//                     UpdateExperienceModel? experience =
//                         await showSearchPopup(context);
//                     if (experience != null) {
//                       setState(() {
//                         experienceId = experience.id;
//                         controllerTitle.text = experience.title;
//                         controllerDescription.text = experience.description;
//                         controllerPrice.text =
//                             '${experience.price.values.first}';
//                         controllerDuration.text = experience.duration;
//                         controllerImgPreviewPath.text =
//                             experience.imgPreviewPath;
//                         controllerImgPaths.text = experience.imgPreviewPath;
//                         choiceStateId = experience.stateId;
//                         choiceDifficulty = experience.difficultyId;
//                         choiceCurrency = retrieveCurrency(experience.price);
//                       });
//                     }
//                   },
//                   icon: const Icon(Icons.search),
//                 ),