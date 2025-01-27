import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorev_yonetim/production/Models/User/User_Model.dart';
import 'package:gorev_yonetim/production/Services/Manager/ConnectivityService.dart';
import 'package:gorev_yonetim/production/State/Connectivity_State.dart';

class ConnectivityStateHome extends Cubit<ConnectivityState> {
  ConnectivityService connectivityService = ConnectivityService(FirebaseFirestore.instance);
  StreamSubscription<List<UserModel>>? _userStreamSubscription;

  ConnectivityStateHome() : super(ConnectivityState(activeUsers: []));

  void addNewActiveUser(UserModel user) {
    _userStreamSubscription?.cancel(); // Önceki dinlemeyi iptal edin
    _userStreamSubscription = connectivityService.addNewActiveUser(user: user).listen((activeUsers) {
      emit(state.copyWith(activeUsers: activeUsers));
    });
  }

  void deleteActiveUserFromListAndReturnUpdatedList(UserModel user) {
    _userStreamSubscription?.cancel(); // Önceki dinlemeyi iptal edin
    _userStreamSubscription =
        connectivityService.deleteActiveUserFromListAndReturnUpdatedList(user: user).listen((activeUsers) {
      emit(state.copyWith(activeUsers: activeUsers));
    });
  }

  @override
  Future<void> close() {
    _userStreamSubscription?.cancel();
    return super.close();
  }
}
