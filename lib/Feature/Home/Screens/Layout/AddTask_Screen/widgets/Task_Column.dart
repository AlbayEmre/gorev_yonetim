import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gorev_yonetim/Feature/Home/Screens/Layout/AddTask_Screen/Add_Task.dart';
import 'package:gorev_yonetim/Feature/Home/Screens/Layout/AddTask_Screen/widgets/Add_First_Task_Screen.dart';
import 'package:gorev_yonetim/Global/Constant/Custom_Snack_bar.dart';
import 'package:gorev_yonetim/Global/Extensions/Project_Extensions.dart';
import 'package:gorev_yonetim/production/Models/User_Data/Task_Data_Model.dart';
import 'package:gorev_yonetim/production/Provider/Task/Data/Task_Home_State.dart';
import 'package:gorev_yonetim/production/State/Task_State.dart';
import 'package:gorev_yonetim/production/init/language/locale_keys.g.dart';
import 'package:gorev_yonetim/root.dart';
import 'package:kartal/kartal.dart';

class Task_Column extends StatefulWidget {
  Task_Column({
    super.key,
  });

  @override
  State<Task_Column> createState() => _Task_ColumnState();
}

class _Task_ColumnState extends State<Task_Column> {
  TextEditingController filterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<TaskHomeState, TaskStatee>(
          builder: (context, state) {
            if (state.TaskData.isNotEmpty) {
              return Padding(
                padding: context.padding.horizontalMedium,
                child: SizedBox(
                  height: 50,
                  child: TextField(
                    onChanged: (value) {
                      context.Task_Provicer.filter_task_with_name(
                          allTask: state.TaskData, filter_String: value); // TaskHomeState'de filterTasks metodunu çağır
                    },
                    controller: filterController,
                    decoration: InputDecoration(
                      hintText: LocaleKeys.label_search_something.tr(), //!,
                      suffix: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () {
                                filterController.text = "";
                                setState(() {});
                              },
                              icon: Icon(Icons.clear)),
                        ],
                      ),
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),
        Expanded(
          child: BlocBuilder<TaskHomeState, TaskStatee>(
            builder: (context, state) {
              var tasks = filterController.text.isNotEmpty ? state.filterData : state.TaskData;
              if (state.TaskData.isNotEmpty) {
                return ListView.builder(
                  itemCount: tasks?.length ?? 0,
                  itemBuilder: (context, index) {
                    var task = tasks?[index];
                    return Stack(
                      children: [
                        Card(
                          color: task!.isDone ? Colors.grey[500] : Color.fromARGB(255, 223, 223, 223),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddTask(
                                    currentTask: task,
                                    isUpdate: true,
                                  ),
                                ),
                              );
                            },
                            title: Text(task?.title ?? "Unnamed Task"),
                            subtitle: Text(LocaleKeys.label_created.tr() +
                                " :  ${task?.date?.year}-${task?.date?.month}-${task?.date?.day}"),
                            trailing: SizedBox(
                              width: 100,
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.image),
                                  Text(task?.taskImages?.length.toString() ?? '0'),
                                  Icon(Icons.headphones),
                                  Text(task?.taskSound?.length.toString() ?? '0'),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: -4,
                          top: -8,
                          child: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // onay diyalogunu göster
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(LocaleKeys.general_button_okay.tr()),
                                    content: Text(LocaleKeys.alert_dialog_Are_you_sure_you_want_to_clear_this_quest
                                        .tr()), //'Are you sure you want to clear this quest?'
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text(LocaleKeys.general_button_no.tr()),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text(LocaleKeys.general_button_yes.tr()),
                                        onPressed: () {
                                          context.Task_Provicer.delete_This_Task(taskId: task?.taskId ?? "");

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Root(
                                                page: 2,
                                              ),
                                            ),
                                          );
                                          ProjectSnackBar.showSnackbar(
                                            context,
                                            LocaleKeys.general_dialog_snackbar_text_register_successful.tr(),
                                            LocaleKeys.alert_dialog_Deletion_successful.tr(),
                                          );

                                          Navigator.of(context).pop(); // Dialog'u kapat
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        LocaleKeys.general_dialog_My_Tasks_Add_task_label_text.tr(),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: context.padding.low,
                        child: Text(
                          LocaleKeys.general_dialog_My_Tasks_Add_a_text_here_bold.tr(),
                          style: context.themeOf.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: context.padding.onlyTopMedium,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AddTask()),
                            );
                          },
                          child: Image.asset(
                            "assets/TaskImages/add.png",
                            scale: 6,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
