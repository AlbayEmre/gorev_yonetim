import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:gorev_yonetim/production/Models/User/User_Model.dart';
import 'package:gorev_yonetim/production/Models/User_Data/Task_Data_Model.dart';

abstract class TaskHomeInterface {
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
  });

  Future? Update_DeadLine_State({required DateTime deadline, required String taskId});
  Future? Update_title_State({required String title, required String taskId});
  Future? Update_taskText_State({required String taskText, required String taskId});
  Future? Update_TaskImages_URLs_State({required List<String?> TaskImages_URLs, required String taskId});
  Future? Update_TaskSound_URLs_State({required List<String?> TaskSound_URLs, required String taskId});
  Future? Update_isDone_State({required bool isDone, required String taskId});
  Future? Update_AllAddedUsers_State({required List<String>? AllAddedUsersUid, required String taskId});
  Future? Add_New_User_State({required UserModel user, required String taskId});
  Future? Add_New_Imge_State({required String image, required String taskId});
  Future? Add_New_Sound_State({required String sound, required String taskId});
  Future<TaskDataModel?> Get_data_State({required String uid});

  Future? addtaskId_From_into_User(String userUid, String taskUid);
  Future<String?>? save_image_or_Sound_From_FireStore(File file, String ref);

  Future<List<TaskDataModel>?> getFireStrire_All_Data({required String uid, required List<String> allUsertask});

  ///Other functions

  void filter_task_with_name({List<TaskDataModel>? allTask, String? filter_String});
  Future? deleteTaskForUserName({required String UserName});
}
