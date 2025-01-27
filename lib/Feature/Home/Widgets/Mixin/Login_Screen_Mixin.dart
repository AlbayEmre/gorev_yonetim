import 'package:flutter/material.dart';

import '../../Screens/Login_Screen.dart';

mixin LoginScreenMixin on State<LoginScreen> {
  late TextEditingController e_mailController;
  late TextEditingController passwordController;
  late TextEditingController phoneController;

  bool isVizible = false;

  bool isPhone = false;
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
    e_mailController = TextEditingController();
    passwordController = TextEditingController();
    phoneController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    e_mailController.dispose();
    passwordController.dispose();
    phoneController.dispose();

    super.dispose();
  }
}
