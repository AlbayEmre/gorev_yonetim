import 'package:gorev_yonetim/production/Models/User/User_Model.dart';

class SaveUser {
  ///  Save [UserModel] with [LazySingleton]
  static final SaveUser _singleton = SaveUser._internal();
  factory SaveUser() => _singleton;
  SaveUser._internal();

  UserModel? oldUserModel;

  void updateUserModel(UserModel? userModel) {
    oldUserModel = userModel;
  }

  UserModel? get userModel => oldUserModel;
}
