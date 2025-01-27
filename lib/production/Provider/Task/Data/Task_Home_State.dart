import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gorev_yonetim/production/Models/User/User_Model.dart';
import 'package:gorev_yonetim/production/Models/User_Data/Task_Data_Model.dart';
import 'package:gorev_yonetim/production/Provider/Task/Data/Task_Home_interface.dart';
import 'package:gorev_yonetim/production/Services/Manager/Task_Service.dart';
import 'package:gorev_yonetim/production/Services/Manager/Task_Storage_Service.dart';
import 'package:gorev_yonetim/production/State/Task_State.dart';
import 'package:uuid/uuid.dart';

class TaskHomeState extends Cubit<TaskStatee> implements TaskHomeInterface {
  TaskHomeState() : super(TaskStatee(TaskData: [])); //firs value

  TaskService taskService = TaskService(FirebaseFirestore.instance, FirebaseStorage.instance);

  TaskStorageService task_Storage = TaskStorageService(FirebaseStorage.instance);
  @override // TODO: implement Add_New_Imge_State
  Future? Add_New_Imge_State({required String image, required String taskId}) async {
    try {
      await taskService.Add_New_Imge(image: image, taskId: taskId);
    } on FirebaseException catch (e) {
      throw FirebaseException(plugin: "ADD NEW İMAGE ERROR:${e.toString()}");
    }
  }

  @override // TODO: implement Add_New_Sound_State
  Future? Add_New_Sound_State({required String sound, required String taskId}) async {
    try {
      await taskService.Add_New_Sound(sound: sound, taskId: taskId);
    } on FirebaseException catch (e) {
      throw FirebaseException(plugin: "ADD NEW SOUND ERROR:${e.toString()}");
    }
  }

  @override // TODO: implement Add_New_User_State
  Future? Add_New_User_State({required UserModel user, required String taskId}) async {
    try {
      await taskService.Add_New_User(user: user, taskId: taskId);
    } on FirebaseException catch (e) {
      throw FirebaseException(plugin: "ADD NEW USER ERROR:${e.toString()}");
    }
  }

  @override // TODO: implement Update_AllAddedUsers_State
  Future? Update_AllAddedUsers_State({required List<String>? AllAddedUsersUid, required String taskId}) async {
    try {
      await taskService.Update_AllAddedUsers(AllAddedUsersUid: AllAddedUsersUid, taskId: taskId);
    } on FirebaseException catch (e) {
      throw FirebaseException(plugin: "ADD NEW USER ERROR:${e.toString()}");
    }
  }

  @override // TODO: implement Update_DeadLine_State
  Future? Update_DeadLine_State({required DateTime deadline, required String taskId}) async {
    try {
      await taskService.Update_DeadLine(deadline: deadline, taskId: taskId);
    } on FirebaseException catch (e) {
      throw FirebaseException(plugin: "ADD NEW DEADLINE ERROR:${e.toString()}");
    }
  }

  @override // TODO: implement Update_TaskImages_URLs_State
  Future? Update_TaskImages_URLs_State({required List<String?> TaskImages_URLs, required String taskId}) async {
    try {
      await taskService.Update_TaskImages_URLs(TaskImages_URLs: TaskImages_URLs, taskId: taskId);
    } on FirebaseException catch (e) {
      throw FirebaseException(plugin: "ADD NEW TaskImages_URLs ERROR:${e.toString()}");
    }
  }

  @override
  Future? Update_TaskSound_URLs_State({required List<String?> TaskSound_URLs, required String taskId}) async {
    try {
      await taskService.Update_TaskSound_URLs(TaskSound_URLs: TaskSound_URLs, taskId: taskId);
    } on FirebaseException catch (e) {
      throw FirebaseException(plugin: "ADD NEW TaskSound_URLs ERROR:${e.toString()}");
    }
  }

  @override // TODO: implement Update_isDone_State
  Future? Update_isDone_State({required bool isDone, required String taskId}) async {
    try {
      await taskService.Update_isDone(isDone: isDone, taskId: taskId);
    } on FirebaseException catch (e) {
      throw FirebaseException(plugin: "ADD NEW isDone ERROR:${e.toString()}");
    }
  }

  @override // TODO: implement Update_taskText_State
  Future? Update_taskText_State({required String taskText, required String taskId}) async {
    try {
      await taskService.Update_taskText(taskText: taskText, taskId: taskId);
    } on FirebaseException catch (e) {
      throw FirebaseException(plugin: "ADD NEW taskText ERROR:${e.toString()}");
    }
  }

  @override // TODO: implement Update_title_State
  Future Update_title_State({required String title, required String taskId}) async {
    try {
      await taskService.Update_title(title: title, taskId: taskId);
    } on FirebaseException catch (e) {
      throw FirebaseException(plugin: "ADD NEW TITLE ERROR:${e.toString()}");
    }
  }

  @override // TODO: implement Get_data_State
  Future<TaskDataModel?> Get_data_State({required String uid}) async {
    try {
      TaskDataModel dataModel = await taskService.Get_Snapshot_data(uid: uid);
      return dataModel;
    } on FirebaseException catch (e) {
      throw FirebaseException(plugin: "ADD NEW USER ERROR:${e.toString()}");
    }
  }

  @override
  Future? addtaskId_From_into_User(String userUid, String taskUid) async {
    try {
      await taskService.Add_TaskId_into_User(userUid: userUid, taskUid: taskUid);
    } on FirebaseException catch (e) {
      throw FirebaseException(plugin: "ADD NEW TASK UID ERROR:${e.toString()}");
    }
  }

  @override
  Future? Save_Task_from_firestore({
    required String taskUid,
    required String taskPassword,
    DateTime? deadLine,
    String? title,
    String? taskText,
    required List<String?> TaskImages_URLs,
    required List<String?> TaskSound_URLs,
    bool isDone = false,
    List<String?>? AllAddedUsersUid,
    double? importantLevel,
  }) async {
    try {
      await taskService.Create_A_Task_save_to_FireStore(
          title: title,
          taskText: taskText,
          AllAddedUsersUid: AllAddedUsersUid,
          taskId: taskUid,
          taskPassword: taskPassword,
          TaskImages_URLs: TaskImages_URLs,
          TaskSound_URLs: TaskSound_URLs,
          deadLine: deadLine,
          importantLevel: importantLevel);
    } on FirebaseException catch (e) {
      throw FirebaseException(plugin: "ADD ALL TASK ERROR${e.toString()}");
    }
  }

  @override
  Future? Upgrade_Task_from_firestore({
    required String taskUid,
    required String taskPassword,
    DateTime? deadLine,
    String? title,
    String? taskText,
    required List<String?> TaskImages_URLs,
    required List<String?> TaskSound_URLs,
    bool isDone = false,
    double? importantLevel,
  }) async {
    try {
      await taskService.Upgrade_A_Task_save_to_FireStore(
          title: title,
          taskText: taskText,
          taskId: taskUid,
          taskPassword: taskPassword,
          TaskImages_URLs: TaskImages_URLs,
          TaskSound_URLs: TaskSound_URLs,
          deadLine: deadLine,
          importantLevel: importantLevel);
    } on FirebaseException catch (e) {
      throw FirebaseException(plugin: "ADD ALL TASK ERROR${e.toString()}");
    }
  }

  @override
  Future<String?>? save_image_or_Sound_From_FireStore(File file, String ref) async {
    try {
      return await task_Storage.saveImage_or_Sound_to_Storage(file, ref);
    } on FirebaseException catch (e) {
      throw FirebaseException(plugin: "ADD ALL IMAGE OR SOUND ERROR:${e.toString()}");
    }
  }

  @override
  Future<List<TaskDataModel>?> getFireStrire_All_Data({required String uid, required List<String> allUsertask}) async {
    try {
      List<TaskDataModel>? dataModel = await taskService.getFireStoreAllData(username: uid);
      emit(state.copyWith(TaskData: dataModel));
      return dataModel;
    } on FirebaseException catch (e) {
      throw FirebaseException(plugin: "FIRABASE FETCH ERROR :${e.toString()}");
    }
  }

  @override
  void filter_task_with_name({List<TaskDataModel>? allTask, String? filter_String}) {
    if (filter_String != null && allTask != null) {
      // Küçük harfe çevirerek büyük/küçük harf duyarsız bir arama yap
      List<TaskDataModel> filtered_data =
          allTask.where((task) => task.title?.toLowerCase().contains(filter_String.toLowerCase()) ?? false).toList();
      emit(state.copyWith(filterData: filtered_data));
    }
  }

  Future? deleteTaskForUserName({required String UserName}) async {
    try {
      await taskService.delete_task_for_UserName(userName: UserName);
    } on FirebaseException catch (e) {
      throw FirebaseException(plugin: "TASK DELETE ERROR :${e.toString()}");
    }
  }

  Future delete_This_Task({required String taskId}) async {
    try {
      List<TaskDataModel>? currentdata = await taskService.delete_task_with_uid(taskId: taskId);
      emit(state.copyWith(TaskData: currentdata));
    } on FirebaseException catch (e) {
      throw FirebaseException(plugin: "TASK DELETE ERROR :${e.toString()}");
    }
  }
}
