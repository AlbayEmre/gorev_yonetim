import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

abstract class TaskStorageInterface {
  /// This interfase stored for [image] adn [sound]  with [FirebaseStorage];
  final FirebaseStorage storage;

  TaskStorageInterface(this.storage);

  Future<String?> saveImage_or_Sound_to_Storage(File file, String refString);
}
