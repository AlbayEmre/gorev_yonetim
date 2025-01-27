// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:gorev_yonetim/production/Models/User/User_Model.dart';

class ConnectivityState extends Equatable {
  List<UserModel> activeUsers;
  ConnectivityState({
    required this.activeUsers,
  });

  List<Object?> get props => [activeUsers];

  ConnectivityState copyWith({required List<UserModel>? activeUsers}) {
    return ConnectivityState(activeUsers: activeUsers ?? this.activeUsers);
  }
}
