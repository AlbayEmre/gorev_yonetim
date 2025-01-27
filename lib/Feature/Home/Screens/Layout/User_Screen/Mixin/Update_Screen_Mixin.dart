import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gorev_yonetim/Feature/Home/Screens/Layout/User_Screen/Update_User.dart';
import 'package:image_picker/image_picker.dart';

mixin UpdateScreenMixin on State<UpdateUser> {
  late TextEditingController nameController;
  @override
  void initState() {
    nameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  File? image;
  String? olduserImage;

  ImagePicker picker = ImagePicker();

  Future ImageCatch(ImageSource source) async {
    XFile? ImageSource = await picker.pickImage(source: source);

    setState(() {
      image = File(ImageSource!.path);
    });
  }
}
