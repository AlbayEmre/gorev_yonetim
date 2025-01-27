import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gorev_yonetim/Feature/Home/Screens/Layout/User_Screen/Settings.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gorev_yonetim/production/init/product_Localization.dart';
import 'package:gorev_yonetim/production/constant/enums/locales.dart';

// SettingsMixin tanımı
mixin SettingsMixin on State<SettingsScreen> {
  Box<dynamic> box = Hive.box('language');
  bool isEnglish = true; // Varsayılan dil İngilizce

  @override
  void initState() {
    super.initState();
    loadLocale();
  }

  void loadLocale() {
    var storedLocale = box.get('language', defaultValue: Locales.en.toString());
    isEnglish = storedLocale == Locales.en.toString();
    setState(() {});
  }
}
