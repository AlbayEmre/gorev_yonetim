// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:gorev_yonetim/Global/Constant/Custom_Snack_bar.dart';
import 'package:gorev_yonetim/production/init/language/locale_keys.g.dart';
import 'package:kartal/kartal.dart';
import 'package:uuid/uuid.dart';

import 'package:gorev_yonetim/Feature/Home/Screens/Layout/AddTask_Screen/mixin/AddTask_mixin.dart';

import 'package:gorev_yonetim/production/Models/User_Data/Task_Data_Model.dart';
import 'package:gorev_yonetim/production/Provider/Auth/Auth_Home_State.dart';
import 'package:gorev_yonetim/production/Provider/Firebase/Laoding_Home_State.dart';
import 'package:gorev_yonetim/production/State/Auth_State.dart';
import 'package:gorev_yonetim/production/State/FireLoding_State.dart';
import 'package:gorev_yonetim/root.dart';

import '../../../../../../Global/Extensions/Project_Extensions.dart';
import '../../../../../../Global/Widgets/Cutom_TextFormField.dart';

import '../../../../../../Global/Widgets/Register_Button.dart';

part 'widgets/Add_Task_Part.dart';

// ignore: must_be_immutable
class AddTask extends StatefulWidget {
  TaskDataModel? currentTask;
  bool isUpdate;
  AddTask({
    Key? key,
    this.currentTask,
    this.isUpdate = false,
  }) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> with AddtaskMixin {
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
                  page: 1,
                ),
              ),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.transparent,
        title: Text(
          LocaleKeys.home_create_new_task.tr(),
          style: TextStyle(
            fontFamily: GoogleFonts.acme().fontFamily,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          BlocBuilder<FirebaseLaoding, FirelodingState>(
            builder: (context, state) {
              if (state.fire_issave) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: const Color.fromARGB(255, 1, 41, 74).withOpacity(0.2),
                      width: double.infinity,
                      height: 100,
                      child: Center(
                        child: SpinKitThreeInOut(
                          itemBuilder: (BuildContext context, int index) {
                            return DecoratedBox(
                              decoration: BoxDecoration(
                                shape: index.isEven ? BoxShape.circle : BoxShape.rectangle,
                                color: index.isEven ? Colors.lightBlue.withOpacity(0.8) : Colors.black.withOpacity(0.1),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
                ;
              }
              return SizedBox.shrink();
            },
          ),
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: context.padding.horizontalMedium,
                child: Column(
                  children: [
                    Padding(
                      padding: context.padding.onlyTopLow,
                      child: Padding(
                        padding: context.padding.horizontalHigh,
                        child: CustomTextFormField(
                          labelText: LocaleKeys.text_field_title.tr(),
                          obscureText: false,
                          obscureChar: "*",
                          controller: titleConteoller,
                          maxlengt: null,
                          autofocus: false,
                        ),
                      ),
                    ),
                    Description_TextFiled(taskTextConteoller: taskTextConteoller),
                    Padding(
                      padding: context.padding.onlyTopMedium,
                      child: Text(
                        LocaleKeys.general_dialog_Create_new_task_add_image.tr(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          height: 150,
                          width: context.sizeOf.width * 0.7,
                          color: Colors.grey.withOpacity(0.2),
                          child: PageView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: imageUrl?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      color: Colors.blue,
                                      width: 100,
                                      height: 150,
                                      child: Image.network(
                                        imageUrl?[index] ?? "",
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            customBottomSheet(context);
                          },
                          icon: Icon(Icons.add_a_photo),
                        )
                      ],
                    ),

                    ///
                    Padding(
                      padding: context.padding.onlyTopMedium,
                      child: Row(
                        children: [
                          Container(
                            height: 150,
                            width: context.sizeOf.width * 0.7,
                            color: Colors.grey.withOpacity(0.2),
                            child: PageView(
                              scrollDirection: Axis.vertical,
                              children: [
                                ListView.builder(
                                  itemCount: soundUrl?.length,
                                  itemBuilder: (context, index) {
                                    bool isPlaying = isPlayingMap[index] ?? false;
                                    return ListTile(
                                      title: Text(LocaleKeys.general_dialog_Connected_Task_Audio.tr() + '$index'),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                                            onPressed: () {
                                              if (isPlaying) {
                                                pauseAudio(index);
                                              } else {
                                                playAudio(soundUrl?[index] ?? "", index);
                                              }
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              deleteSound(index);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: context.padding.onlyLeftLow,
                            child: GestureDetector(
                              onLongPress: () async {
                                changeLongPress();
                                await startRecording();
                              },
                              onLongPressEnd: (details) async {
                                changeLongPress();
                                await stopRecording();
                              },
                              child: isLongPress
                                  ? Icon(
                                      Icons.surround_sound,
                                      size: 40,
                                      color: Colors.green,
                                    )
                                  : Icon(
                                      Icons.surround_sound,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: context.padding.onlyTopLow,
                      child: SizedBox(
                        height: 70,
                        child: Padding(
                          padding: context.padding.horizontalHigh,
                          child: CustomTextFormField(
                            keyboardType: TextInputType.number,
                            labelText: LocaleKeys.text_field_Task_password.tr(),
                            obscureText: false,
                            obscureChar: "*",
                            controller: passwordConteoller,
                            maxlengt: 6,
                            autofocus: false,
                          ),
                        ),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(LocaleKeys.general_dialog_Create_new_task_deadline.tr() + ":"),
                        IconButton(
                          onPressed: () {
                            selectDate(context);
                            setState(() {});
                          },
                          icon: Icon(
                            size: 30,
                            Icons.calendar_month_outlined,
                            color: deadLine == null ? Colors.red : Colors.green,
                          ),
                        ),
                        if (deadLine != null) ...[
                          Text(
                            deadLine!.year.toString() +
                                "-" +
                                deadLine!.month.toString() +
                                "-" +
                                deadLine!.day.toString(),
                          )
                        ]
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(LocaleKeys.general_dialog_Create_new_task_important_level.tr() + ":"),
                        Slider(
                          thumbColor: Colors.lightBlue,
                          activeColor: Colors.green,
                          value: importtentLevel,
                          onChanged: (value) {
                            importtentLevel = value;
                            setState(() {});
                          },
                        ),
                        Text((importtentLevel * 3).toStringAsFixed(1)),
                      ],
                    ),

                    BlocBuilder<AuthHomeState, AuthState>(
                      builder: (context, state) {
                        return Padding(
                          padding: context.padding.horizontalHigh,
                          child: LoginButton(
                            text: LocaleKeys.general_button_save.tr(),
                            onPressed: () async {
                              String taskUid = Uuid().v4();
                              if (widget.isUpdate) {
                                await context.Task_Provicer.Upgrade_Task_from_firestore(
                                    title: titleConteoller.text,
                                    taskText: taskTextConteoller.text,
                                    taskUid: widget.currentTask?.taskId ?? "",
                                    taskPassword: passwordConteoller.text,
                                    TaskImages_URLs: imageUrl ?? [],
                                    TaskSound_URLs: soundUrl ?? [],
                                    deadLine: deadLine,
                                    importantLevel: (importtentLevel * 3));

                                ProjectSnackBar.showSnackbar(
                                    context,
                                    LocaleKeys.general_dialog_snackbar_text_add_task_Success.tr(),
                                    LocaleKeys.general_dialog_snackbar_text_add_task_Upgrade_Success.tr());
                              } else {
                                await context.Task_Provicer.Save_Task_from_firestore(
                                    taskUid: taskUid,
                                    title: titleConteoller.text,
                                    taskText: taskTextConteoller.text,
                                    taskPassword: passwordConteoller.text,
                                    TaskImages_URLs: imageUrl ?? [],
                                    TaskSound_URLs: soundUrl ?? [],
                                    AllAddedUsersUid: [state.userModel.Username],
                                    deadLine: deadLine,
                                    importantLevel: (importtentLevel * 3));
                                context.auth_Provider.add_task_into_user(
                                    userUid: state.userModel.id ?? "", taskUid: taskUid); //Kulşanıcının görevleri

                                ProjectSnackBar.showSnackbar(
                                  context,
                                  LocaleKeys.general_dialog_snackbar_text_add_task_Success.tr(),
                                  LocaleKeys.general_dialog_snackbar_text_add_task_Save_Success.tr(),
                                );
                              }

                              // ignore: use_build_context_synchronously

                              print(context.auth_Provider.userModel.Username);
                              //    context.FireLoading_Provider.Save_isLoding_IsLoading();
                              //                              context.FireLoading_Provider.Save_isLoding_IsLoading();
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
        ],
      ),
    );
  }
}
