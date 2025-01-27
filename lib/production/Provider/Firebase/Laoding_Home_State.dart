import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gorev_yonetim/production/State/FireLoding_State.dart';

class FirebaseLaoding extends Cubit<FirelodingState> {
  FirebaseLaoding() : super(FirelodingState(Fire_isLoading: false));

  void FireChange_IsLoading() {
    state.Fire_isLoading = !state.Fire_isLoading;
    emit(state.copyWith(isLaoding: state.Fire_isLoading));
  }

  void Save_isLoding_IsLoading() {
    state.fire_issave = !state.fire_issave;
    emit(state.copyWith(isLaoding: state.fire_issave));
  }
}
