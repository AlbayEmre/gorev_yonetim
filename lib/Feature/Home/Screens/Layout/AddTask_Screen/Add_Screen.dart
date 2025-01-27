import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gorev_yonetim/Feature/Home/Screens/Layout/AddTask_Screen/Add_Task.dart';
import 'package:gorev_yonetim/Feature/Home/Screens/Layout/AddTask_Screen/mixin/AddScreen_mixin.dart';
import 'package:gorev_yonetim/Feature/Home/Screens/Layout/AddTask_Screen/widgets/Friends_Screen.dart';
import 'package:gorev_yonetim/Feature/Home/Screens/Layout/AddTask_Screen/widgets/Task_Column.dart';
import 'package:gorev_yonetim/Global/Constant/SaveUser.dart';
import 'package:gorev_yonetim/Global/Constant/Text_Style.dart';
import 'package:gorev_yonetim/Global/Extensions/Project_Extensions.dart';
import 'package:gorev_yonetim/Global/Widgets/NoUser_Screen.dart';
import 'package:gorev_yonetim/production/Models/User_Data/Task_Data_Model.dart';
import 'package:gorev_yonetim/production/Provider/Auth/Auth_Home_State.dart';
import 'package:gorev_yonetim/production/State/Auth_State.dart';
import 'package:gorev_yonetim/production/init/language/locale_keys.g.dart';
import 'package:kartal/kartal.dart';

class AddScreen extends StatefulWidget {
  AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> with AddscreenMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        onPressed: () async {
          await context.auth_Provider.fetchFriends(userUid: SaveUser().userModel?.id ?? "");

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FriendsScreen()),
          );
        },
        child: Icon(
          Icons.person_pin_rounded,
          color: Colors.black,
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: context.padding.normal,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddTask()),
                );
              },
              child: Image.asset(
                "assets/TaskImages/add.png",
                scale: 8,
              ),
            ),
          ),
        ],
        title: Text(
          LocaleKeys.home_page2_title.tr(),
          style: context.themeOf.textTheme.titleLarge?.copyWith(
            fontFamily: TextStylee.fontFamilypacifico,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<AuthHomeState, AuthState>(
        builder: (context, state) {
          if (state.userModel.Username == null || state.userModel.users_tasks == null) {
            return NouserScreen();
          } else {
            return FutureBuilder<List<TaskDataModel>?>(
              future: context.Task_Provicer.getFireStrire_All_Data(
                  uid: state.userModel.Username!, allUsertask: state.userModel.users_tasks!),
              builder: (context, builder) {
                if (builder.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: LinearProgressIndicator(),
                  );
                } else if (builder.hasError) {
                  return Center(
                    child: Text("An error occurred."),
                  );
                } else if (builder.hasData) {
                  return Task_Column();
                } else {
                  return Center(
                    child: Text("Something went wrong"),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
