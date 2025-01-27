import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:gorev_yonetim/production/Models/User_Data/Task_Data_Model.dart';

import '../../Models/User/User_Model.dart';

abstract class TaskInterface {
  ///This interface stored other thing with [FirebaseFirestore];
  final FirebaseFirestore firestore;
  FirebaseStorage taskstorage;

  TaskInterface(this.firestore, this.taskstorage);

  Future Create_A_Task_save_to_FireStore({
    required String taskId,
    required String taskPassword,
    DateTime? deadLine,
    String? title,
    String? taskText,
    required List<String?> TaskImages_URLs,
    required List<String?> TaskSound_URLs,
    bool isDone = false,
    List<String>? AllAddedUsersUid,
  });

  Future Update_DeadLine({required DateTime deadline, required String taskId});
  Future Update_title({required String title, required String taskId});
  Future Update_taskText({required String taskText, required String taskId});
  Future Update_TaskImages_URLs({required List<String?> TaskImages_URLs, required String taskId});
  Future Update_TaskSound_URLs({required List<String?> TaskSound_URLs, required String taskId});
  Future Update_isDone({required bool isDone, required String taskId});
  Future Update_AllAddedUsers({required List<String>? AllAddedUsersUid, required String taskId});
  Future Add_New_User({required UserModel user, required String taskId});
  Future Add_New_Imge({required String image, required String taskId});
  Future Add_New_Sound({required String sound, required String taskId});
  Future<TaskDataModel?> Get_Snapshot_data({required String uid});
  Future Add_TaskId_into_User({required String userUid, required String taskUid});

  Future<List<TaskDataModel>> getFireStoreAllData({
    required String username,
  });
  Future<void> delete_task_for_UserName({required String userName});
}
