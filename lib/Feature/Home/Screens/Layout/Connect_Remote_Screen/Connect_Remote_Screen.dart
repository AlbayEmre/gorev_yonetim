import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gorev_yonetim/Feature/Home/Screens/Layout/Connect_Remote_Screen/Widgets/NoData_Widget.dart';
import 'package:gorev_yonetim/Feature/Home/Screens/Layout/Connect_Remote_Screen/Widgets/Task_Information.dart';

import 'package:gorev_yonetim/Feature/Home/Screens/Layout/Connect_Remote_Screen/mixin/Connocted_Remote_mixin.dart';
import 'package:gorev_yonetim/Global/Constant/Custom_Snack_bar.dart';
import 'package:gorev_yonetim/Global/Constant/Project_Images.dart';
import 'package:gorev_yonetim/Global/Constant/Text_Style.dart';
import 'package:gorev_yonetim/Global/Extensions/Project_Extensions.dart';
import 'package:gorev_yonetim/Global/Widgets/NoUser_Screen.dart';
import 'package:gorev_yonetim/production/Models/User_Data/Task_Data_Model.dart';
import 'package:gorev_yonetim/production/Provider/Task/Fetch_Remote_Task/Fetch_Remote_Home.dart';
import 'package:gorev_yonetim/production/State/Fetch_Remote_State.dart';
import 'package:gorev_yonetim/production/init/language/locale_keys.g.dart';

class ConnectRemoteScreen extends StatefulWidget {
  ConnectRemoteScreen({Key? key}) : super(key: key);

  @override
  _ConnectRemoteScreenState createState() => _ConnectRemoteScreenState();
}

class _ConnectRemoteScreenState extends State<ConnectRemoteScreen> with ConnectedRemoteMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () async {
                openDialog();
              },
              child: Icon(
                Icons.connect_without_contact_outlined,
              ),
            ),
          ),
        ],
        title: Text(
          LocaleKeys.home_page3_title.tr(),
          style: context.themeOf.textTheme.titleLarge?.copyWith(
            fontFamily: TextStylee.fontFamilypacifico,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<List<TaskDataModel>?>(
        key: futureBuilderKey,
        future: tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return NouserScreen();
          } else if (snapshot.data?.isEmpty ?? true) {
            return NodataWidget();
          } else {
            return BlocSelector<FetchRemoteHome, FetchRemoteState, List<TaskDataModel>>(
              selector: (state) {
                return state.activeTaskData;
              },
              builder: (context, state) {
                return ListView.builder(
                  itemCount: state.length,
                  itemBuilder: (context, index) {
                    //  TaskDataModel task = snapshot.data![index];
                    return Card(
                      shadowColor: Colors.black,
                      color: Colors.grey[100],
                      child: Column(
                        children: [
                          Text(LocaleKeys.general_dialog_Create_new_task_Owner_of_the_task.tr() +
                              " : ${state[index].AllAddedUsersUid?[0]}"),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                if (!state[index].date!.isAfter(state[index].deadLine ?? DateTime.now())) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => TaskInformation(data: state[index])),
                                  );
                                  context.FetchTask_Provider.ViewRecently(data: state[index]);
                                } else {
                                  ProjectSnackBar.showSnackbar(context,
                                      LocaleKeys.general_dialog_snackbar_text_Filtered_tasks_Task_expired.tr(), " ");
                                }
                              },
                              child: Card(
                                color: state[index].date!.isAfter(state[index].deadLine ?? DateTime.now())
                                    ? Colors.red
                                    : !state[index].isDone
                                        ? Colors.green.withOpacity(0.2)
                                        : Colors.grey.withOpacity(0.2),
                                child: ListTile(
                                  title: Text(state[index].title ?? "Unnamed Task"),
                                  subtitle: Text(LocaleKeys.general_dialog_Create_new_task_deadline.tr() +
                                      ": ${state[index].taskText ?? 'No deadline'}"),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
