import 'package:askenzo_admin_panel/models/discovery.dart';
import 'package:askenzo_admin_panel/models/experience.dart';

/// The InitialDataForm class represents a form with initial data and provides a method to check for
/// differences with another instance of the class.
class InitialDataForm {
/// The ConstantData class contains various constant values used in the application, such as URLs,
/// colors, page layout parameters, and routes.
  InitialDataForm({
    required this.id,
    required this.title,
    required this.description,
    required this.imgPreviewPath,
    required this.imgPaths,
  });

  int id;
  String title;
  String description;
  String imgPreviewPath;
  String imgPaths;

  bool checkDifferences(InitialDataForm other) {
    return id != other.id ||
        title != other.title ||
        description != other.description ||
        imgPreviewPath != other.imgPreviewPath ||
        imgPaths != other.imgPaths;
  }
}
/// The `ExperienceDataForm` class is a subclass of `InitialDataForm` that represents a form for
/// collecting data related to an experience, including its price, duration, state, difficulty, and
/// currency.

class ExperienceDataForm extends InitialDataForm {
  ExperienceDataForm({
    required int id,
    required String title,
    required String description,
    required String imgPreviewPath,
    required String imgPaths,
    required this.price,
    required this.duration,
    required this.stateId,
    required this.difficultyId,
    required this.currency,
  }) : super(
          id: id,
          title: title,
          description: description,
          imgPreviewPath: imgPreviewPath,
          imgPaths: imgPaths,
        );

  String price;
  int currency;
  String duration;
  int stateId;
  int difficultyId;

  @override
  bool checkDifferences(InitialDataForm other) {
    if (other is ExperienceDataForm) {
      return super.checkDifferences(other) ||
          price != other.price ||
          duration != other.duration ||
          stateId != other.stateId ||
          difficultyId != other.difficultyId ||
          currency != other.currency;
    }
    return super.checkDifferences(other);
  }

  ExperienceModel toExperienceModel() {
    return ExperienceModel(
      title: title,
      description: description,
      difficultyId: difficultyId,
      price: {'default': double.parse(price)},
      duration: duration,
      imgPreviewPath: imgPreviewPath,
      imgPaths: imgPaths.split(';'),
      stateId: stateId,
    );
  }

  UpdateExperienceModel toUpdateExperienceModel() {
    return UpdateExperienceModel(
      title: title,
      description: description,
      difficultyId: difficultyId,
      price: {'default': double.parse(price)},
      duration: duration,
      imgPreviewPath: imgPreviewPath,
      imgPaths: imgPaths.split(';'),
      stateId: stateId,
      id: id,
    );
  }
}
/// The `DiscoveryDataForm` class is a subclass of `InitialDataForm` that represents a form for
/// collecting data related to a discovery, including information such as title, description, images,
/// videos, location, and state.

class DiscoveryDataForm extends InitialDataForm {
  DiscoveryDataForm({
    required int id,
    required String title,
    required String description,
    required String imgPreviewPath,
    required String imgPaths,
    required this.kindId,
    required this.longitude,
    required this.latitude,
    required this.address,
    required this.stateId,
    required this.videoPath,
  }) : super(
          id: id,
          title: title,
          description: description,
          imgPreviewPath: imgPreviewPath,
          imgPaths: imgPaths,
        );

  int kindId;
  double longitude;
  double latitude;
  String address;
  String videoPath;
  int stateId;

  @override
  bool checkDifferences(InitialDataForm other) {
    if (other is DiscoveryDataForm) {
      return super.checkDifferences(other) ||
          kindId != other.kindId ||
          longitude != other.longitude ||
          latitude != other.latitude ||
          address != other.address ||
          stateId != other.stateId;
    }
    return super.checkDifferences(other);
  }

  DiscoveryModel toDiscoveryModel() {
    return DiscoveryModel(
      title: title,
      description: description,
      imgPreviewPath: imgPreviewPath,
      imgPaths: imgPaths.split(';'),
      videoPaths: [], // Provide the appropriate value here
      kindId: kindId,
      longitude: longitude,
      latitude: latitude,
      address: address,
      stateId: stateId,
    );
  }

  UpdateDiscoveryModel toUpdateDiscoveryModel() {
    return UpdateDiscoveryModel(
      id: id,
      title: title,
      description: description,
      imgPreviewPath: imgPreviewPath,
      imgPaths: imgPaths.split(';'),
      videoPaths: [], // Provide the appropriate value here
      kindId: kindId,
      longitude: longitude,
      latitude: latitude,
      address: address,
      stateId: stateId,
    );
  }
}
