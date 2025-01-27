import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gorev_yonetim/Global/Constant/Custom_Snack_bar.dart';
import 'package:gorev_yonetim/Global/Constant/Project_Images.dart';
import 'package:gorev_yonetim/Global/Constant/SaveUser.dart';
import 'package:gorev_yonetim/Global/Extensions/Project_Extensions.dart';
import 'package:gorev_yonetim/production/Models/User/User_Model.dart';
import 'package:gorev_yonetim/production/init/language/locale_keys.g.dart';
import 'package:kartal/kartal.dart';

import '../../production/State/Auth_State.dart';

Future<void> showCustomDialog(BuildContext context, UserModel? userModel) async {
  await showDialog<bool>(
    context: context,
    builder: (BuildContext dialogContext) {
      // dialogContext olarak yeniden adlandırıldı
      return AlertDialog(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        backgroundColor: Colors.lightBlue[50],
        title: Column(
          children: [
            Padding(
              padding: dialogContext.padding.onlyBottomMedium,
              child: Image.asset(
                ProjectImages.waring, // Dikkat: 'waring' yazım hatası düzeltildi 'warning' olarak
                scale: 8,
              ),
            ),
            if (userModel?.ProfilePhoto != null) ...[
              Image.network(
                userModel?.ProfilePhoto ?? '',
                height: 100,
                width: 100,
              ),
            ] else ...[
              Image.asset(
                ProjectImages.defaultUser,
                scale: 8,
              ),
            ]
          ],
        ),
        content: Text(
          LocaleKeys.alert_dialog_do_you_want_to_delete_your_profile.tr(),
          style: dialogContext.themeOf.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(LocaleKeys.general_button_no.tr()),
          ),
          TextButton(
            onPressed: () async {
              if (userModel != null) {
                await context.auth_Provider.deleteUserAuth(useruid: userModel.id ?? "").then((value) async {
                  await context.Task_Provicer.deleteTaskForUserName(UserName: userModel.Username ?? "");

                  ProjectSnackBar.showSnackbar(context, "Successful", "Your profile has been deleted.");
                });
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {}
              } else {}

              //   Navigator.of(dialogContext).pop(true);
            },
            child: Text(LocaleKeys.general_button_yes.tr()),
          ),
        ],
      );
    },
  );
}
