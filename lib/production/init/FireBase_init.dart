import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

@immutable
class FirebaseInit {
  FirebaseInit._();

  static Future FireInitFunction() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }
}

enum PlatfomEnum {
  android,
  ios,
  wep,
}
