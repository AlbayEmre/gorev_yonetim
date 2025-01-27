import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorev_yonetim/Feature/Home/Screens/Layout/User_Screen/Mixin/Settings_mixin.dart';

import 'package:gorev_yonetim/Feature/Home/Screens/Layout/User_Screen/Update_User.dart';
import 'package:gorev_yonetim/Global/Constant/SaveUser.dart';
import 'package:gorev_yonetim/Global/Widgets/Cutom_Alert.dart';
import 'package:gorev_yonetim/production/Provider/Auth/Auth_Home_State.dart';
import 'package:gorev_yonetim/production/Provider/distribution/Text_Theme_Home.dart';
import 'package:gorev_yonetim/production/State/Auth_State.dart';
import 'package:gorev_yonetim/production/State/Text_Theme_Sate.dart';
import 'package:gorev_yonetim/production/constant/enums/locales.dart';
import 'package:gorev_yonetim/production/init/language/locale_keys.g.dart';
import 'package:gorev_yonetim/production/init/product_Localization.dart';
import '../../../../../../Global/Constant/Text_Style.dart';
import '../../../../../../Global/Extensions/Project_Extensions.dart';
import 'package:gorev_yonetim/production/Models/User/User_Model.dart';
import 'package:gorev_yonetim/root.dart';
import 'package:kartal/kartal.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SettingsMixin {
  double value1 = 0;
  bool swithvalue = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Root(
                        page: 3,
                      )),
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
          LocaleKeys.home_Settings.tr(),
          style: context.themeOf.textTheme.titleLarge?.copyWith(
            fontFamily: TextStylee.fontFamilyaBeeZee,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Card(
                shadowColor: Colors.black,
                surfaceTintColor: Colors.red,
                color: Colors.white,
                child: ListTile(
                  title: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(LocaleKeys.general_dialog_Settings_Update_User_Information).tr(),
                          IconButton(
                            iconSize: 30,
                            color: Colors.black,
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => UpdateUser()),
                                (Route<dynamic> route) => false,
                              );
                            },
                            icon: Icon(
                              Icons.person_4,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Card(
                shadowColor: Colors.black,
                color: Colors.blueGrey.shade100,
                child: ListTile(
                  title: Padding(
                    padding: context.padding.onlyBottomNormal,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(LocaleKeys.general_dialog_Settings_Change_Language).tr(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Tr",
                                style: context.themeOf.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Switch(
                                activeColor: Colors.lightBlue,
                                value: isEnglish, // isEnglish ile doğrudan senkronize olacak
                                onChanged: (bool value) {
                                  setState(() {
                                    isEnglish = value; // Güncel değeri ayarla
                                    Locales selectedLocale =
                                        value ? Locales.en : Locales.tr; // Ters mantık hatası düzeltildi
                                    box.put('language', selectedLocale.toString()); // Hive'a kaydet
                                    ProductLocalization.updateLanguage(
                                        context: context, value: selectedLocale); // Lokalizasyonu güncelle
                                  });
                                },
                              ),
                              Text(
                                "En",
                                style: context.themeOf.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(backgroundColor: WidgetStateProperty.resolveWith((state) {
                return state.contains(WidgetState.pressed) ? Colors.purple : Colors.red[200];
              })),
              onPressed: () async {
                if (mounted) {
                  UserModel? userModel = SaveUser().userModel;
                  if (userModel != null) {
                    print(userModel.id);
                    await showCustomDialog(context, userModel);
                  } else {
                    throw Exception("USER MODEL NULL");
                  }
                }
              },
              child: Text(
                LocaleKeys.general_button_delete_profile.tr(),
                style: context.themeOf.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Spacer(
              flex: 5,
            ),
          ],
        ),
      ),
    );
  }
}
