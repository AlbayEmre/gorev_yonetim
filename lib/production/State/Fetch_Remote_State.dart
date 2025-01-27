// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gorev_yonetim/production/Models/User_Data/Active_Task_Model.g.dart';

import 'package:gorev_yonetim/production/Models/User_Data/Task_Data_Model.dart';

// ignore: must_be_immutable
class FetchRemoteState extends Equatable {
  List<String> activeTask;
  List<TaskDataModel> activeTaskData;
  List<TaskDataModel> isDoneList;
  List<TaskDataModel> View_recently = [];
  List<TaskDataModel>? filter_active;
  FetchRemoteState(
      {required this.activeTask,
      required this.activeTaskData,
      required this.isDoneList,
      required this.View_recently,
      this.filter_active});

  @override
  // TODO: implement props
  List<Object?> get props => [activeTask, activeTaskData, isDoneList, View_recently, filter_active];

  FetchRemoteState copyWith(
      {List<String>? activeTask,
      List<TaskDataModel>? activeTaskData,
      List<TaskDataModel>? View_Recently,
      List<TaskDataModel>? filterTask}) {
    List<TaskDataModel>? complated_task = activeTaskData?.where((task) => task.isDone == true).toList() ?? [];
    return FetchRemoteState(
        View_recently: View_Recently ?? this.View_recently,
        isDoneList: complated_task,
        activeTaskData: activeTaskData ?? this.activeTaskData,
        activeTask: activeTask ?? this.activeTask,
        filter_active: filterTask ?? this.filter_active);
  }
}
