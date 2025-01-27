import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:gorev_yonetim/Feature/Home/Screens/Layout/Connect_Remote_Screen/Connect_Remote_Screen.dart';
import 'package:gorev_yonetim/Global/Constant/Project_Images.dart';
import 'package:gorev_yonetim/Global/Extensions/Project_Extensions.dart';
import 'package:gorev_yonetim/Global/Widgets/Cutom_TextFormField.dart';
import 'package:gorev_yonetim/production/Models/User_Data/Task_Data_Model.dart';
import 'package:gorev_yonetim/production/init/language/locale_keys.g.dart';
import 'package:gorev_yonetim/root.dart';
import 'package:kartal/kartal.dart';

// ignore: must_be_immutable
class TaskInformation extends StatefulWidget {
  TaskDataModel? data;
  TaskInformation({super.key, this.data});

  @override
  State<TaskInformation> createState() => _TaskInformationState();
}

class _TaskInformationState extends State<TaskInformation> {
  late bool isdonde;
  Map<int, bool> isPlayingMap = {};
  final AudioPlayer audioPlayer = AudioPlayer();
  int? currentIndex;
  Future<void> playAudio(String url, int index) async {
    try {
      await audioPlayer.stop(); // Diğer tüm sesleri durdur
      currentIndex = index; // Şu an oynatılan ses dosyasının index'ini sakla
      await audioPlayer.play(UrlSource(url));
      isPlayingMap[index] = true; // Bu ses dosyasının oynatıldığını belirle
      setState(() {});
    } catch (e) {
      print('Ses dosyası çalınırken bir hata oluştu: $e');
    }
  }

  Future<void> pauseAudio(int index) async {
    try {
      await audioPlayer.pause();
      isPlayingMap[index] = false;
      setState(() {});
    } catch (e) {
      print('Ses dosyası durdurulurken bir hata oluştu: $e');
    }
  }

  @override
  void initState() {
    isdonde = widget.data!.isDone;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    controller.text = widget.data?.title ?? "Title";
    TextEditingController descriptioncontroller = TextEditingController();
    descriptioncontroller.text = widget.data?.taskText ?? "Task description";

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(LocaleKeys.home_Task_Information.tr()),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: context.padding.horizontalLow,
        child: Center(
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Padding(
                      padding: context.padding.horizontalHigh,
                      child: CustomTextFormField(
                        isOnlyRead: true,
                        obscureText: false,
                        obscureChar: '*',
                        controller: controller,
                        maxlengt: null,
                        autofocus: false,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: context.padding.verticalLow,
                      child: Padding(
                        padding: context.padding.onlyTopLow,
                        child: CustomTextFormField(
                          isOnlyRead: true,
                          obscureText: false,
                          obscureChar: '*',
                          controller: descriptioncontroller,
                          maxlengt: null,
                          autofocus: false,
                          textAlign: TextAlign.center,
                          minlines: 4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.data?.taskImages != null) ...[
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.data?.taskImages?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: context.padding.low,
                        child: Image.network(
                          widget.data?.taskImages?[index] ?? "",
                          scale: 10,
                        ),
                      );
                    },
                  ),
                ),
              ],
              if (widget.data?.taskSound != null) ...[
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.data?.taskSound?.length, //  ,
                    itemBuilder: (context, index) {
                      bool isPlaying = isPlayingMap[index] ?? false;
                      return Padding(
                        padding: context.padding.low,
                        child: Container(
                          width: 80,
                          color: Colors.green.withOpacity(0.2),
                          child: Center(
                            child: IconButton(
                              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                              onPressed: () {
                                if (isPlaying) {
                                  pauseAudio(index);
                                } else {
                                  playAudio(widget.data?.taskSound?[index] ?? "", index);
                                }
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
              Column(
                children: [
                  Row(
                    children: [
                      Text(LocaleKeys.general_dialog_Task_Information_screen_this_task_complated.tr()),
                      Checkbox(
                        checkColor: Colors.blue,
                        activeColor: Colors.grey[200],
                        value: isdonde,
                        onChanged: (value) {
                          setState(() {});
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(LocaleKeys.general_button_okay).tr(),
                                content: Text(LocaleKeys.text_field_are_you_sure).tr(),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text(LocaleKeys.general_button_no).tr(),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text(LocaleKeys.general_button_yes).tr(),
                                    onPressed: () {
                                      isdonde = value ?? false;
                                      // Evet'e basıldığında yeni değeri kabul et
                                      context.Task_Provicer.Update_isDone_State(
                                          isDone: value ?? false, taskId: widget.data?.taskId ?? "");
                                      setState(() {});
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        LocaleKeys.general_dialog_Create_new_task_deadline.tr() +
                            " : ${widget.data?.deadLine?.year.toString()}-${widget.data?.deadLine?.month.toString()}-${widget.data?.deadLine?.day.toString()}",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (widget.data?.taskImages == null && widget.data?.taskSound == null) ...[
                Spacer(
                  flex: 3,
                )
              ] else if (widget.data?.taskImages == null || widget.data?.taskSound == null) ...[
                Spacer(
                  flex: 2,
                )
              ] else ...[
                Spacer(
                  flex: 1,
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
