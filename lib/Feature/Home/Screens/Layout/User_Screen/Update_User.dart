import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gorev_yonetim/Feature/Home/Screens/Layout/User_Screen/Mixin/Update_Screen_Mixin.dart';
import 'package:gorev_yonetim/Feature/Home/Screens/Layout/User_Screen/Settings.dart';
import 'package:gorev_yonetim/Global/Constant/Custom_Snack_bar.dart';
import 'package:gorev_yonetim/Global/Constant/Project_Images.dart';
import 'package:gorev_yonetim/production/init/language/locale_keys.g.dart';
import '../../../../../../Global/Constant/Text_Style.dart';
import '../../../../../../Global/Extensions/Project_Extensions.dart';
import '../../../../../../Global/Widgets/Cutom_TextFormField.dart';
import '../../../../../../Global/Widgets/Register_Button.dart';

import 'package:gorev_yonetim/production/Provider/Auth/Auth_Home_State.dart';
import 'package:gorev_yonetim/production/State/Auth_State.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kartal/kartal.dart';

class UpdateUser extends StatefulWidget {
  UpdateUser({super.key});

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> with UpdateScreenMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
            // Get.to(() => SettingsScreen());
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
          LocaleKeys.home_Update_information.tr(),
          style: context.themeOf.textTheme.titleLarge?.copyWith(
            fontFamily: TextStylee.fontFamilyaBeeZee,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: context.padding.horizontalMedium,
            child: Column(
              children: [
                Stack(
                  children: [
                    BlocBuilder<AuthHomeState, AuthState>(
                      builder: (context, state) {
                        if (state.userModel.ProfilePhoto != null) {
                          olduserImage = state.userModel.ProfilePhoto;
                        }
                        return Container(
                          color: Colors.transparent,
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: image != null
                                ? Image.file(
                                    image!, // Dosyadan gelen resim
                                    fit: BoxFit.cover,
                                  )
                                : (state.userModel.ProfilePhoto != null
                                    ? Image.network(
                                        state.userModel.ProfilePhoto ?? "", // State'den gelen kullanıcı resmi
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Image.asset(
                                          ProjectImages.defaultUser, // Hata durumunda varsayılan resim
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Image.asset(
                                        ProjectImages.defaultUser, // Varsayılan kullanıcı resmi
                                        fit: BoxFit.cover,
                                      )),
                          ),
                        );
                      },
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
                                decoration: BoxDecoration(
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
                                        LocaleKeys.general_dialog_image_catch_Camera.tr(), //ÇEVİR
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
                                        LocaleKeys.general_dialog_image_catch_Gallery.tr(), //ÇEVİR
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
                BlocBuilder<AuthHomeState, AuthState>(
                  builder: (context, state) {
                    if (state.userModel.Username != null) {
                      nameController.text = state.userModel.Username!;
                    }
                    return Padding(
                      padding: context.padding.verticalMedium,
                      child: CustomTextFormField(
                        labelText: LocaleKeys.text_field_name_field.tr(),
                        obscureText: false,
                        obscureChar: "*",
                        controller: nameController,
                        maxlengt: null,
                        autofocus: false,
                      ),
                    );
                  },
                ),
                BlocBuilder<AuthHomeState, AuthState>(
                  builder: (context, state) {
                    if (nameController.text.length >= 3) {
                      return Padding(
                        padding: context.padding.horizontalHigh,
                        child: LoginButton(
                          text: LocaleKeys.general_button_save.tr(),
                          onPressed: () {
                            context.auth_Provider
                                .updateProfilePhoto_And_Name(image, state.userModel.id ?? "", nameController.text);

                            ProjectSnackBar.showSnackbar(
                              context,
                              LocaleKeys.general_dialog_snackbar_text_update_user_Success.tr(),
                              LocaleKeys.general_dialog_snackbar_text_update_user_User_Update_Success.tr(),
                            );
                          },
                        ),
                      );
                    }

                    return Padding(
                      padding: context.padding.horizontalHigh,
                      child: LoginButton(
                        text: LocaleKeys.general_button_save.tr(),
                        onPressed: () {
                          ProjectSnackBar.showSnackbar(
                              context,
                              LocaleKeys.general_dialog_snackbar_text_update_user_Failed.tr(),
                              LocaleKeys.general_dialog_snackbar_text_update_user_User_Update_Failed.tr());
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
