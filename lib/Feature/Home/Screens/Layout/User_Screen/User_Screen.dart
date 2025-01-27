import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gorev_yonetim/Feature/Home/Screens/Layout/User_Screen/Settings.dart';
import 'package:gorev_yonetim/Feature/Home/Screens/Login_Screen.dart';
import 'package:gorev_yonetim/Global/Constant/Project_Images.dart';
import 'package:gorev_yonetim/Global/Constant/SaveUser.dart';
import 'package:gorev_yonetim/Global/Constant/Text_Style.dart';
import 'package:gorev_yonetim/production/Models/User_Data/Task_Data_Model.dart';
import 'package:gorev_yonetim/production/Provider/Task/Data/Task_Home_State.dart';
import 'package:gorev_yonetim/production/Provider/Task/Fetch_Remote_Task/Fetch_Remote_Home.dart';
import 'package:gorev_yonetim/production/State/Fetch_Remote_State.dart';
import 'package:gorev_yonetim/production/State/Task_State.dart';
import 'package:gorev_yonetim/production/init/language/locale_keys.g.dart';

import '../../../../../../Global/Extensions/Project_Extensions.dart';
import 'package:gorev_yonetim/production/Models/User/User_Model.dart';
import 'package:gorev_yonetim/production/Provider/Auth/Auth_Home_State.dart';
import 'package:gorev_yonetim/production/State/Auth_State.dart';
import 'package:kartal/kartal.dart';

class UserScreen extends StatefulWidget {
  UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
            icon: Icon(Icons.settings),
          ),
        ],
        title: Text(
          LocaleKeys.home_page4_title.tr(),
          style: context.themeOf.textTheme.titleLarge?.copyWith(
            fontFamily: TextStylee.fontFamilypacifico,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          BlocSelector<AuthHomeState, AuthState, UserModel>(
            selector: (state) {
              return state.userModel;
            },
            builder: (context, state) {
              return Column(
                children: [
                  Padding(
                    padding: context.padding.onlyTopMedium,
                    child: Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        maxRadius: 50,
                        backgroundImage: state.ProfilePhoto != null
                            ? NetworkImage(state.ProfilePhoto!)
                            : AssetImage(ProjectImages.defaultUser),
                      ),
                    ),
                  ),
                  Padding(
                    padding: context.padding.onlyTopLow,
                    child: Text(
                      LocaleKeys.general_dialog_Profile_Welcome_text.tr(),
                      style: context.themeOf.textTheme.bodyLarge
                          ?.copyWith(fontStyle: FontStyle.italic, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: context.padding.onlyTopLow,
                    child: Text(
                      state.Username ?? "",
                      style: context.themeOf.textTheme.bodyLarge
                          ?.copyWith(fontStyle: FontStyle.italic, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: context.padding.verticalLow,
                    child: Text(
                      state.e_mail ?? "",
                      style: context.themeOf.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          //WRAP WİTH BLOC
          Padding(
            padding: context.padding.onlyTopMedium,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocBuilder<AuthHomeState, AuthState>(
                      builder: (context, state) {
                        return Stack(
                          children: [
                            Card(
                              color: Colors.blue[100],
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(color: Colors.blue.withOpacity(0.4), blurRadius: 10),
                                  ],
                                ),
                                width: 125,
                                height: 125,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        LocaleKeys.general_dialog_Profile_All_room_text.tr(),
                                        textAlign: TextAlign.center,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.key),
                                          Text(":${state.userModel.users_tasks?.length ?? 0}"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Scaffold(
                                        body: Center(
                                          child: LinearProgressIndicator(),
                                        ),
                                        appBar: AppBar(
                                          leading: IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: Icon(Icons.arrow_back),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Image.asset(
                                  ProjectImages.premTask,
                                  scale: 15,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    BlocSelector<FetchRemoteHome, FetchRemoteState, List<TaskDataModel>>(
                      selector: (state) {
                        return state.activeTaskData;
                      },
                      builder: (context, state) {
                        return Card(
                          color: Colors.yellow[100],
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(color: Colors.pink.withOpacity(0.4), blurRadius: 10),
                              ],
                            ),
                            width: 125,
                            height: 125,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(LocaleKeys.general_dialog_Profile_Active_Tasks.tr()),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.task),
                                      Text(":" + state.length.toString()),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocBuilder<FetchRemoteHome, FetchRemoteState>(
                      builder: (context, state) {
                        return Card(
                          color: Colors.purple[100],
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(color: Colors.pink.withOpacity(0.4), blurRadius: 10),
                              ],
                            ),
                            width: 125,
                            height: 125,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(LocaleKeys.general_dialog_home_view_recently.tr(), textAlign: TextAlign.center),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.saved_search_sharp),
                                      Text(
                                        ":${state.View_recently.length}",
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    BlocBuilder<FetchRemoteHome, FetchRemoteState>(
                      builder: (context, state) {
                        return Card(
                          color: Colors.green[100],
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(color: Colors.green.withOpacity(0.4), blurRadius: 10),
                              ],
                            ),
                            width: 125,
                            height: 125,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(LocaleKeys.general_dialog_Profile_complated_text.tr()),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.task_alt),
                                      Text(":${state.isDoneList.length ?? 0}"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: context.padding.verticalMedium,
                  child: SizedBox(
                    width: 150,
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith(
                          (state) {
                            if (state.contains(WidgetState.pressed)) {
                              return Colors.red;
                            }
                            return Colors.blueGrey.withOpacity(0.1);
                          },
                        ),
                      ),
                      onPressed: () {
                        context.auth_Provider.singOut();
                        context.Connectivity_Provider.deleteActiveUserFromListAndReturnUpdatedList(
                            SaveUser().userModel!);
                        print("silindi");
                        context.Connectivity_Provider.deleteActiveUserFromListAndReturnUpdatedList(
                            SaveUser().userModel ?? UserModel());

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      label: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout,
                            size: 20,
                          ),
                          Text(
                            LocaleKeys.general_button_Log_out.tr(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
