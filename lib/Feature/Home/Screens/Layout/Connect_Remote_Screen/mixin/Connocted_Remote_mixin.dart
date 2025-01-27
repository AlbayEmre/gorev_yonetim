import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorev_yonetim/Feature/Home/Screens/Layout/Connect_Remote_Screen/Connect_Remote_Screen.dart';
import 'package:gorev_yonetim/Global/Constant/SaveUser.dart';
import 'package:gorev_yonetim/Global/Extensions/Project_Extensions.dart';
import 'package:gorev_yonetim/production/Models/User/User_Model.dart';
import 'package:gorev_yonetim/production/Models/User_Data/Task_Data_Model.dart';
import 'package:gorev_yonetim/production/Provider/Auth/Auth_Home_State.dart';
import 'package:gorev_yonetim/production/Provider/Task/Fetch_Remote_Task/Fetch_Remote_Home.dart';
import 'package:gorev_yonetim/production/init/language/locale_keys.g.dart';

mixin ConnectedRemoteMixin on State<ConnectRemoteScreen> {
  late TextEditingController passwordController;
  late Future<List<TaskDataModel>?> tasksFuture;
  late Key futureBuilderKey;
  UserModel? userModel;
  late bool istaskActive;

  @override
  void initState() {
    super.initState();

    passwordController = TextEditingController();
    userModel = SaveUser().userModel;
    futureBuilderKey = UniqueKey();
    if (userModel != null) {
      tasksFuture =
          context.FetchTask_Provider.fetchActiveTask(userId: userModel!.id ?? "", username: userModel!.Username);
    } else {
      tasksFuture = Future.value([]);
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  void openDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(LocaleKeys.alert_dialog_write_remote_task_password.tr()),
          content: TextField(
            maxLength: 6,
            controller: passwordController,
            decoration: InputDecoration(labelText: LocaleKeys.general_button_enter_password.tr()),
          ),
          actions: [
            TextButton(
              child: Text(LocaleKeys.general_button_okay.tr()),
              onPressed: () async {
                if (userModel != null && passwordController.text.length == 6) {
                  await context.FetchTask_Provider.savetaskFromActiveTask(
                      password: passwordController.text, userId: userModel!.id ?? "");
                  Navigator.pop(dialogContext);
                  passwordController.text = "";
                  setState(
                    () {
                      futureBuilderKey = UniqueKey(); // Refresh the FutureBuilder
                      tasksFuture = context.FetchTask_Provider.fetchActiveTask(
                          userId: userModel!.id ?? "", username: userModel!.Username);
                    },
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
