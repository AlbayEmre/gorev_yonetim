import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gorev_yonetim/Feature/Home/Screens/Login_Screen.dart';
import 'package:gorev_yonetim/Global/Constant/Custom_Snack_bar.dart';
import 'package:gorev_yonetim/Global/Constant/Project_Images.dart';
import 'package:gorev_yonetim/production/init/language/locale_keys.g.dart';

///
///
import '../../../../Global/Constant/Text_Style.dart';
import '../../../../Global/Extensions/Project_Extensions.dart';
import '../../../../Global/Widgets/Cutom_TextFormField.dart';
import 'package:gorev_yonetim/production/Provider/Firebase/Laoding_Home_State.dart';
import 'package:gorev_yonetim/production/State/FireLoding_State.dart';
import 'package:image_picker/image_picker.dart';

import 'package:kartal/kartal.dart';

///
///
///

import '../../../../Global/Widgets/Firebase_Loading_Widget.dart';
import '../../../production/Utility/Validator/Register_Validator.dart';
import '../Widgets/Mixin/Register_Screen_Mixin.dart';

part '../Widgets/Register_part.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with RegisterScreenMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ProjectAppBar(),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            BlocBuilder<FirebaseLaoding, FirelodingState>(
              builder: (context, state) {
                if (state.Fire_isLoading) {
                  return FireBaseLoading_Screen();
                }
                return SizedBox.shrink();
              },
            ),
            Center(
              child: Column(
                children: [
                  Form(
                    key: globalKey,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              color: Colors.transparent,
                              width: context.sizeOf.width * 0.3,
                              height: context.sizeOf.height * 0.2,
                              child: image == null
                                  ? Image.asset(ProjectImages.defaultUser)
                                  : Container(
                                      child:
                                          ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.file(image!)),
                                    ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent, // Arka planı tamamen şeffaf yapar
                                    builder: (context) {
                                      return Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.white, // İçerik için arka plan rengi
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20.0),
                                            topRight: Radius.circular(20.0),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              spreadRadius: 2,
                                              blurRadius: 10,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ListTile(
                                              leading: Icon(Icons.camera_alt, color: Colors.blue),
                                              title: Text(
                                                LocaleKeys.general_dialog_image_catch_Camera.tr(),
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              onTap: () {
                                                ImageCatch(ImageSource.camera); // Sadece File içine kaydet
                                                Navigator.pop(context);
                                              },
                                            ),
                                            Divider(), // İki seçenek arasına ayırıcı ekler
                                            ListTile(
                                              leading: Icon(Icons.photo_album, color: Colors.green),
                                              title: Text(
                                                LocaleKeys.general_dialog_image_catch_Gallery.tr(),
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              onTap: () {
                                                ImageCatch(ImageSource.gallery);
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Icon(
                                  Icons.add_a_photo_outlined,
                                  color: Colors.black.withOpacity(0.3),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: context.padding.onlyTopMedium,
                          child: Padding(
                            padding: context.padding.horizontalMedium,
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: context.padding.onlyBottomNormal,
                                      child: CustomTextFormField(
                                        keyboardType: TextInputType.text,
                                        validator: (value) => RegisterValidator.nameValid(value),
                                        suffixIchon: Icons.person,
                                        labelText: LocaleKeys.text_field_name_field.tr(),
                                        obscureText: false,
                                        obscureChar: '*',
                                        controller: nameController,
                                        maxlengt: null,
                                        autofocus: false,
                                      ),
                                    ),
                                    if (isPhone != true) ...[
                                      Padding(
                                        padding: context.padding.verticalLow,
                                        child: CustomTextFormField(
                                          keyboardType: TextInputType.emailAddress,
                                          validator: (value) => RegisterValidator.emailValid(value),
                                          suffixIchon: Icons.email,

                                          labelText: LocaleKeys.text_field_e_mail_field.tr(),
                                          obscureText: false,
                                          obscureChar: '*',
                                          controller: emailController,
                                          //  maxlengt: 40,
                                          autofocus: false, maxlengt: null,
                                        ),
                                      ),
                                      Padding(
                                        padding: context.padding.verticalNormal,
                                        child: CustomTextFormField(
                                          keyboardType: TextInputType.visiblePassword,
                                          validator: (value) => RegisterValidator.paswordValid(value),
                                          suffixIchon: Icons.password,
                                          labelText: LocaleKeys.text_field_password_field.tr(),
                                          obscureText: isVizible,
                                          obscureChar: '*',
                                          controller: passwordController,
                                          maxlengt: 8,
                                          autofocus: false,
                                          buildCounter: (context,
                                              {required currentLength, required isFocused, required maxLength}) {
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
                                      ),
                                    ] else ...[
                                      Padding(
                                        padding: context.padding.verticalLow,
                                        child: _CustomTextFormField(
                                          keyboardType: TextInputType.phone,
                                          validator: (value) => RegisterValidator.phoneValid(value),
                                          suffixIchon: Icons.phone,

                                          labelText: LocaleKeys.text_field_phone.tr(),
                                          obscureText: false,
                                          obscureChar: '*',
                                          controller: PhoneController,
                                          //  maxlengt: 40,
                                          autofocus: false, maxlengt: null,
                                        ),
                                      ),
                                    ]
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(LocaleKeys.label_register_phone_text_choice.tr()), //Register with Phone:
                                        Checkbox(
                                          checkColor: Colors.blue,
                                          activeColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(3),
                                          ),
                                          value: isPhone,
                                          onChanged: (value) {
                                            isPhone = value!;
                                            setState(() {});
                                          },
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: context.padding.onlyBottomMedium,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(builder: (context) => LoginScreen()),
                                            (Route<dynamic> route) => false,
                                          );
                                        },
                                        child: RichText(
                                          text: TextSpan(
                                            text: "",
                                            style: TextStyle(color: Colors.black),
                                            children: [
                                              TextSpan(
                                                text: LocaleKeys.general_button_register_go_to_login
                                                    .tr(), // "   Sing In..."
                                                style: context.themeOf.textTheme.bodySmall?.copyWith(
                                                  color: Colors.deepOrange,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                _RegisterButton(
                                  globalKeybutton: globalKey,
                                  isphone: isPhone,
                                  phone: PhoneController,
                                  password: passwordController,
                                  email: emailController,
                                  name: nameController,
                                  UserImageFile: image,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
