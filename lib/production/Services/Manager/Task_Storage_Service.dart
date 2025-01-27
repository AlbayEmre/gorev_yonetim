import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gorev_yonetim/production/Services/interface/Task_Storage_Interface.dart';
import 'package:uuid/uuid.dart';

class TaskStorageService extends TaskStorageInterface {
  TaskStorageService(super.storage);

  @override
  Future<String?> saveImage_or_Sound_to_Storage(File file, String refString) async {
    String randomUuid = Uuid().v4();

    Reference ref = storage.ref(refString).child(randomUuid);

    String? URL;
    await ref.putFile(file).whenComplete(
      () async {
        URL = await ref.getDownloadURL();
      },
    );

    return URL;
  }
}
