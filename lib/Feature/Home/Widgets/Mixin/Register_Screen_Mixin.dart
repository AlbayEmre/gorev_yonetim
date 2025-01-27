import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import '../../Screens/Register_Screen.dart';

mixin RegisterScreenMixin on State<RegisterScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController PhoneController;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  bool isVizible = false;
  bool isPhone = false;
  bool fire_Loading = false;

  ImagePicker picker = ImagePicker();
  File? image;

  void change_fire_Loading() {
    fire_Loading = !fire_Loading;
    setState(() {});
  }

  Future ImageCatch(ImageSource source) async {
    XFile? ImageSource = await picker.pickImage(source: source);

    setState(() {
      image = File(ImageSource!.path);
    });
  }

  Icon notVizible = Icon(
    Icons.visibility,
    color: Colors.amber,
  );
  Icon vizible = Icon(
    Icons.visibility_off,
    color: Colors.grey[600],
  );

  void ChangeVizible() {
    isVizible = !isVizible;
    setState(() {});
  }

  @override
  void initState() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    PhoneController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    PhoneController.dispose();
    super.dispose();
  }
}
