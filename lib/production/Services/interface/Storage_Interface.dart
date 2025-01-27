import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

abstract class StorageInterface {
  final FirebaseStorage storage;

  StorageInterface(this.storage);

  Future<String?> save_to_Storage(File file);
}
