// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:gorev_yonetim/production/Models/User_Data/Task_Data_Model.dart';

class TaskStatee extends Equatable {
  List<TaskDataModel> TaskData;
  List<TaskDataModel>? filterData;

  TaskStatee({required this.TaskData, this.filterData});

  @override
  // TODO: implement props
  List<Object?> get props => [TaskData, filterData];

  TaskStatee copyWith({List<TaskDataModel>? TaskData, List<TaskDataModel>? filterData}) {
    return TaskStatee(
      TaskData: TaskData ?? this.TaskData,
      filterData: filterData ?? this.filterData,
    );
  }
}
