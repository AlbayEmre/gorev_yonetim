import 'package:flutter/material.dart';
import 'package:gorev_yonetim/Feature/Home/Screens/Forget_Pasword_Screen.dart';

mixin ForgetPasswordMixin on State<ForgetPaswordScreen> {
  late TextEditingController forgetPassword_for_Email;

  @override
  void initState() {
    forgetPassword_for_Email = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    forgetPassword_for_Email.dispose();
    super.dispose();
  }
}
