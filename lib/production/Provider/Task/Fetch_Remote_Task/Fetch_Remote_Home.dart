import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorev_yonetim/production/Models/User_Data/Task_Data_Model.dart';
import 'package:gorev_yonetim/production/Provider/Task/Fetch_Remote_Task/Remote_Home_Interface.dart';
import 'package:gorev_yonetim/production/Services/Manager/Fetch_Remote_Service.dart';
import 'package:gorev_yonetim/production/State/Fetch_Remote_State.dart';

class FetchRemoteHome extends Cubit<FetchRemoteState> implements RemoteHomeInterface {
  FetchRemoteService remoteService = FetchRemoteService();

  FetchRemoteHome() : super(FetchRemoteState(activeTask: [], activeTaskData: [], isDoneList: [], View_recently: []));

  @override
  Future<List<TaskDataModel>?> fetchActiveTask({required String userId, String? username}) async {
    try {
      List<TaskDataModel>? activeTaskModel =
          await remoteService.fetchActiveTasksForUser(userId: userId, username: username);
      print("ÇEKİLEN AKTİF GÖREV UZUNLUĞU : ${activeTaskModel.length}");
      emit(state.copyWith(activeTaskData: activeTaskModel));
      return activeTaskModel;
    } catch (e) {
      print("Aktif görev çekme işlemi sırasında hata oluştu: $e");
      return null;
    }
  }

  @override
  Future<void> savetaskFromActiveTask({required String userId, required String password}) async {
    List<String> activetask = await remoteService.fetchTaskIdsByPassword(password: password, userId: userId);
    // Eğer yeni bir task listesi varsa state'i güncelle
    emit(state.copyWith(activeTask: activetask));
  }

  void ViewRecently({required TaskDataModel data}) {
    // ignore: unnecessary_null_comparison
    if (data != null) {
      List<TaskDataModel> viewRecently = state.View_recently;

      // Eğer taskId daha önce listeye eklenmemişse ekle
      if (!viewRecently.any((task) => task.taskId == data.taskId)) {
        viewRecently.add(data);
        emit(state.copyWith(View_Recently: viewRecently));
      }
    }
  }

  @override
  void filter_task_with_name({List<TaskDataModel>? allTask, String? filter_String}) {
    if (filter_String != null && allTask != null) {
      // Küçük harfe çevirerek büyük/küçük harf duyarsız bir arama yap
      List<TaskDataModel> filtered_data =
          allTask.where((task) => task.title?.toLowerCase().contains(filter_String.toLowerCase()) ?? false).toList();
      emit(state.copyWith(filterTask: filtered_data));
    }
  }
}
