import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:gorev_yonetim/Feature/Home/Screens/Layout/Home_Screen/Home.dart';
import '../../../../../../Global/Constant/Project_Images.dart';

mixin HomeMixin on State<Home> {
  late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;
  List<String> swiper_String = [ProjectImages.swiper1, ProjectImages.swiper2, ProjectImages.swiper3];
}
