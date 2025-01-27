import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:gorev_yonetim/Feature/Home/Screens/Login_Screen.dart';
import 'package:gorev_yonetim/Feature/Home/Widgets/Mixin/Forget_Password_Mixin.dart';
import 'package:gorev_yonetim/Global/Constant/Custom_Snack_bar.dart';
import 'package:gorev_yonetim/main.dart';
import 'package:gorev_yonetim/production/init/language/locale_keys.g.dart';
import '../../../../Global/Constant/Text_Style.dart';
import '../../../../Global/Extensions/Project_Extensions.dart';
import '../../../../Global/Widgets/Cutom_TextFormField.dart';
import '../../../../Global/Widgets/Register_Button.dart';
import 'package:gorev_yonetim/production/Utility/Validator/Register_Validator.dart';
import 'package:kartal/kartal.dart';

class ForgetPaswordScreen extends StatefulWidget {
  const ForgetPaswordScreen({super.key});

  @override
  State<ForgetPaswordScreen> createState() => _ForgetPaswordScreenState();
}

class _ForgetPaswordScreenState extends State<ForgetPaswordScreen> with ForgetPasswordMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            navigatorKey.currentState?.pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (Route<dynamic> route) => false,
            );
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        iconTheme: const IconThemeData.fallback().copyWith(
          color: Colors.black,
        ),
        title: Text(
          LocaleKeys.general_button_Recover_password.tr(),
          style: context.themeOf.textTheme.titleLarge?.copyWith(
            fontFamily: TextStylee.fontFamilypacifico,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: context.padding.horizontalMedium,
          child: Center(
            child: Column(
              children: [
                Image.asset(
                  "assets/User/forget.png",
                  scale: 2,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      LocaleKeys.general_dialog_entry_pages_forget_screen_dark_title.tr(), //"Forgot Your Password?"
                      style: context.themeOf.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      LocaleKeys.general_dialog_entry_pages_forget_screen_text.tr(),
                    ), //"Enter your email address and we will send you instructions to reset your password."
                  ],
                ),
                Padding(
                  padding: context.padding.onlyTopMedium,
                  child: SizedBox(
                    child: CustomTextFormField(
                      suffixIchon: Icons.mail,
                      validator: (value) => RegisterValidator.emailValid(value),
                      labelText: LocaleKeys.text_field_e_mail_field.tr(),
                      autofocus: false,
                      obscureText: false,
                      obscureChar: '*',
                      controller: forgetPassword_for_Email,
                      maxlengt: null,
                    ),
                  ),
                ),
                Padding(
                  padding: context.padding.onlyTopMedium,
                  child: SizedBox(
                    height: context.sizeOf.height * 0.07,
                    child: LoginButton(
                      text: LocaleKeys.general_button_Recover_password.tr(),
                      onPressed: () {
                        context.auth_Provider.forget_Password(forgetPassword_for_Email.text).then(
                          (value) {
                            if (value) {
                              ProjectSnackBar.showSnackbar(
                                  context,
                                  LocaleKeys.general_dialog_snackbar_text_forget_password_Email.tr(),
                                  LocaleKeys.general_dialog_snackbar_text_forget_password_Check_your_email.tr());
                            }
                          },
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
