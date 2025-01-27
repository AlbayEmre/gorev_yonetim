import 'package:gorev_yonetim/production/Models/User_Data/Active_Task_Model.g.dart';
import 'package:gorev_yonetim/production/Models/User_Data/Task_Data_Model.dart';

abstract class RemoteHomeInterface {
//   Future<List<String>?>? fetchTaskIdsByPassword({required String password, required String userId});
  //  Future<Map<String, List<TaskDataModel>>?>? fetchRemoteTasksGroupedByFirstUid({required String userUid});
//   Future<List<TaskDataModel>?>? fetchRemoteTasksGroupedByFirstUid({required List<String> attends_Tasks});
//   Future<List<String>?> fetchActiveTask({required String userId});

  Future<List<TaskDataModel>?>? fetchActiveTask({required String userId});
  Future<void> savetaskFromActiveTask({required String userId, required String password});
}
