import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gorev_yonetim/production/Models/User/User_Model.dart';

class TaskDataModel {
  String taskId;
  String taskPassword;
  DateTime? date = DateTime.now(); //creation time
  DateTime? deadLine;
  String? title;
  String? taskText;
  List<String?>? taskImages;
  List<String?>? taskSound;
  double? importantLevel; //0-5    not important-most important

  bool isDone = false; //--> For new task

  List<String?>? AllAddedUsersUid;

  TaskDataModel({
    required this.taskPassword,
    required this.taskId,
    this.date,
    this.deadLine,
    this.importantLevel,
    this.isDone = false,
    this.taskImages,
    this.taskSound,
    this.taskText,
    this.title,
    this.AllAddedUsersUid,
  });

  factory TaskDataModel.fromJson(Map<String, dynamic> json) {
    return TaskDataModel(
      taskPassword: json["taskPassword"],
      taskId: json["taskId"],
      date: (json["date"] as Timestamp?)?.toDate() ?? DateTime.now(),
      deadLine: (json["deadLine"] as Timestamp?)?.toDate(),
      title: json["title"],
      taskText: json["taskText"],
      taskImages: List<String?>.from(json["taskImages"] ?? []),
      taskSound: List<String?>.from(json["taskSound"] ?? []),
      importantLevel: json["importantLevel"],
      isDone: json["isDone"] ?? false,
      AllAddedUsersUid: List<String?>.from(json["AllAddedUsersUdi"] ?? []),
    );
  }

  factory TaskDataModel.fromdoc(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var data = snapshot.data();
    if (data == null) throw Exception();
    return TaskDataModel.fromJson(data);
  }

  Map<String, dynamic> toJson() {
    return {
      "taskId": taskId,
      "taskPassword": taskPassword,
      "date": date?.toUtc().millisecondsSinceEpoch, // Firestore için DateTime'ı Epoch'a çevirme
      "deadLine": deadLine?.toUtc().millisecondsSinceEpoch,
      "title": title,
      "taskText": taskText,
      "taskImages": taskImages?.where((image) => image != null).toList() ?? [],
      "taskSound": taskSound?.where((sound) => sound != null).toList() ?? [],
      "importantLevel": importantLevel,
      "isDone": isDone,
      "AllAddedUsersUid": AllAddedUsersUid?.where((uid) => uid != null).toList() ?? [],
    };
  }
}
