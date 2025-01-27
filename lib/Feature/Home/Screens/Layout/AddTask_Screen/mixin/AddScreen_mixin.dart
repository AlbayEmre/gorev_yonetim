import 'package:flutter/material.dart';
import 'package:gorev_yonetim/Feature/Home/Screens/Layout/AddTask_Screen/Add_Screen.dart';

mixin AddscreenMixin on State<AddScreen> {
  late TextEditingController filterController;

  @override
  void initState() {
    filterController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    filterController.dispose();

    super.dispose();
  }
}
