import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:gorev_yonetim/Feature/Home/Screens/Forget_Pasword_Screen.dart';
import 'package:gorev_yonetim/Feature/Home/Screens/Register_Screen.dart';
import 'package:gorev_yonetim/Feature/Home/Widgets/Mixin/Login_Screen_Mixin.dart';
import 'package:gorev_yonetim/Feature/Landing_Screen.dart';
import 'package:gorev_yonetim/Global/Constant/Custom_Snack_bar.dart';
import 'package:gorev_yonetim/Global/Constant/SaveUser.dart';
import 'package:gorev_yonetim/main.dart';
import 'package:gorev_yonetim/production/init/language/locale_keys.g.dart';

import '../../../../Global/Extensions/Project_Extensions.dart';
import '../../../../Global/Widgets/Register_Button.dart';
import 'package:gorev_yonetim/production/Models/User/User_Model.dart';
import 'package:kartal/kartal.dart';

import '../../../../Global/Constant/Project_String.dart';
import '../../../../Global/Constant/Text_Style.dart';
import '../../../../Global/Widgets/Cutom_TextFormField.dart';

part "../Widgets/Login_Part.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with LoginScreenMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _LoginAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: context.padding.onlyTopMedium,
          child: Padding(
            padding: context.padding.horizontalMedium,
            child: Center(
              child: Column(
                children: [
                  if (isPhone) ...[
                    CustomTextFormField(
                        keyboardType: TextInputType.phone,
                        labelText: LocaleKeys.text_field_phone,
                        suffixIchon: Icons.phone,
                        obscureText: false,
                        obscureChar: "*",
                        controller: phoneController,
                        maxlengt: null,
                        autofocus: false)
                  ] else ...[
                    Padding(
                      padding: context.padding.verticalMedium,
                      child: CustomTextFormField(
                        keyboardType: TextInputType.emailAddress,
                        suffixIchon: Icons.email_outlined,
                        labelText: LocaleKeys.text_field_e_mail_field.tr(),
                        obscureText: false,
                        obscureChar: '*',
                        controller: e_mailController,
                        maxlengt: null,
                        autofocus: false,
                      ),
                    ),
                    CustomTextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      suffixIchon: Icons.password,
                      labelText: LocaleKeys.text_field_password_field.tr(),
                      obscureText: isVizible,
                      obscureChar: '*',
                      controller: passwordController,
                      maxlengt: 8,
                      autofocus: false,
                      buildCounter: (context, {required currentLength, required isFocused, required maxLength}) {
                        return AnimatedContainer(
                          color: const Color.fromARGB(255, 190, 228, 246),
                          duration: Duration(seconds: 2),
                          height: 10,
                          width: 80 - (10 * currentLength.toDouble()),
                        );
                      },
                      paswordVizible: IconButton(
                          onPressed: () {
                            ChangeVizible();
                          },
                          icon: isVizible ? vizible : notVizible),
                    ),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(LocaleKeys.label_login_phone_text_choice.tr()), //"Login with Phone"
                      Checkbox(
                        checkColor: Colors.blue,
                        activeColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                        value: isPhone,
                        onChanged: (value) {
                          isPhone = value!;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  LoginButton(
                    e_mail: e_mailController,
                    password: passwordController,
                    text: LocaleKeys.general_button_register_go_to_login.tr(),
                    onPressed: () {
                      if (isPhone) {
                        context.auth_Provider.register_with_phone(phoneController.text, null); //!Somethink went wrong
                      } else {
                        context.auth_Provider.login_With_Email(e_mailController.text, passwordController.text).then(
                          (value) {
                            if (value != null) {
                              context.Connectivity_Provider.addNewActiveUser(SaveUser().userModel!);
                              SaveUser().updateUserModel(value);

                              navigatorKey.currentState?.pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => LandingScreen()),
                                (Route<dynamic> route) => false,
                              );
                            }
                          },
                        );
                      }
                    },
                  ),
                  Padding(
                    padding: context.padding.onlyTopMedium,
                    child: Container(
                      width: context.sizeOf.width * 0.7,
                      height: context.sizeOf.width * 0.15,
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(0, 5),
                            blurRadius: 5,
                            blurStyle: BlurStyle.outer,
                          )
                        ],
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(20),
                          right: Radius.circular(20),
                        ),
                        color: Colors.white,
                      ),
                      child: Sing_In_With_Google(),
                    ),
                  ),
                  Padding(
                    padding: context.padding.onlyTopHigh,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LocaleKeys.general_dialog_entry_pages_Dont_have_an_account.tr(), //"Don't have an account?"
                          style: context.themeOf.textTheme.bodyMedium?.copyWith(color: Colors.black),
                        ),
                        InkWell(
                          onTap: () {
                            navigatorKey.currentState?.pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => RegisterScreen()),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: Text(
                            LocaleKeys.general_button_login_go_to_register.tr(),
                            style: context.themeOf.textTheme.bodyMedium?.copyWith(
                              color: Colors.lightBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: context.padding.onlyTopMedium,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(LocaleKeys.general_dialog_entry_pages_I_forgot_my_password
                            .tr()), //"I forgot my password.  "
                        InkWell(
                          onTap: () {
                            navigatorKey.currentState?.pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => ForgetPaswordScreen()),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: Text(
                            LocaleKeys.general_button_login_go_to_save_Password.tr(),
                            style: context.themeOf.textTheme.bodyMedium?.copyWith(
                              color: Colors.lightBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
