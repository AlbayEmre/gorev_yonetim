import 'package:flutter/material.dart';

@immutable
final class ProjectImages {
  ProjectImages._();

  ///[path] for image
  static String swiper_path = "assets/Swiper/";
  static String button_path = "assets/Button/";
  static String Task_Images_path = "assets/TaskImages/";
  static String AlertImage = "assets/Alert/";
  static String UserImage = "assets/User/";

  ///[image] for swiper
  static String swiper1 = "${swiper_path}1.png";
  static String swiper2 = "${swiper_path}2.png";
  static String swiper3 = "${swiper_path}3.png";

  ///[image] for button
  static String low = "${button_path}1.png";
  static String medium = "${button_path}2.png";
  static String hight = "${button_path}3.png";

  ///[image] for task
  static String addTask = "${Task_Images_path}add.png";
  static String premTask = "${Task_Images_path}prem.png";

  ///[image] for alert
  static String waring = "${AlertImage}warning.png";
  static String NoUser = "${AlertImage}nouser.png";

  ///[image] for User
  static String defaultUser = "${UserImage}user.png";
}
