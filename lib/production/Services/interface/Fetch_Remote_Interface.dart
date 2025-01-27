// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gorev_yonetim/production/Models/User_Data/Active_Task_Model.g.dart';

import 'package:gorev_yonetim/production/Models/User_Data/Task_Data_Model.dart';

abstract class FetchRemoteInterface {
  FirebaseFirestore firestore;
  FetchRemoteInterface({
    required this.firestore,
  });

  // Future<List<String>> fetchTaskIdsByPassword({required String password, required String userId});
  // Future<List<String>> fetchTaskIdsByPassword({required String password, required String userId});

  // Future<Map<String, List<TaskDataModel>>> fetchRemoteTasksGroupedByFirstUid({required String userUid});
  // Future<List<TaskDataModel>> fetchTasksByTaskId({
  //   required List<String> taskIds, // Bu görev ID'leri arasında filtreleme yapmak için
  // });

  // Future<List<String>> fetchAllActiveTaskId({required String userId});

  Future<List<String>> fetchActiveTaskIds(String userId);
  Future<List<TaskDataModel>> fetchTasksByIds(List<String> taskIds, String? username);
  Future<List<TaskDataModel>> fetchActiveTasksForUser({required String userId});
}
