import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../interface/Storage_Interface.dart';

class StorageService extends StorageInterface {
  StorageService(super.storage);

  @override
  Future<String?> save_to_Storage(File file) async {
    String randomName = Uuid().v4();
    Reference ref = storage.ref("userIamges").child(randomName); //İsim ve yolu verdik
    //---------------------file.path
    String? URL;
    await ref.putFile(file).whenComplete(
      () async {
        URL = await ref.getDownloadURL();
      },
    );

    return URL; //Storageye koyduk ve url bu  bu
  }
}
