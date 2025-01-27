// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:gorev_yonetim/production/Models/User_Data/Task_Data_Model.dart';

// class ActiveTaskModel {
//   final String taskId;
//   final List<TaskDataModel> tasks;

//   ActiveTaskModel({required this.taskId, required this.tasks});

//   factory ActiveTaskModel.fromJson(Map<String, dynamic> json) {
//     return ActiveTaskModel(
//       taskId: json['taskId'],
//       tasks: List<TaskDataModel>.from(json['tasks'].map((task) => TaskDataModel.fromJson(task))),
//     );
//   }

//   factory ActiveTaskModel.fromdoc(DocumentSnapshot<Map<String, dynamic>> snapshot) {
//     var data = snapshot.data();
//     if (data == null) throw Exception();
//     return ActiveTaskModel.fromJson(data);
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'taskId': taskId,
//       'tasks': tasks.map((task) => task.toJson()).toList(),
//     };
//   }
// }
