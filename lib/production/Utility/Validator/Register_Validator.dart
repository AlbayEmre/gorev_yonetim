import 'package:flutter/material.dart';

@immutable
class RegisterValidator {
  RegisterValidator._();

  static String? nameValid(String? value) {
    String name = value ?? "";
    if (name.length <= 3) {
      return "Name length cannot be less than 3";
    }
    return null;
  }

  static String? emailValid(String? value) {
    bool _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value ?? "");

    if (!_emailRegex) {
      return "Please enter valid email address";
    }

    return null;
  }

  static String? paswordValid(String? value) {
    var length = value?.length ?? 0;

    if (length < 4) {
      return "Password longer than 4 characters";
    }
    return null;
  }

  static String? phoneValid(String? value) {
    var length = value?.length ?? 0;

    if (length < 11 && value![0] != "0") {
      return "Please enter your phone number correctly";
    }
  }
}
