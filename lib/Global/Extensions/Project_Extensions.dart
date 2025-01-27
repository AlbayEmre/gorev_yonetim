import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorev_yonetim/production/Provider/Auth/Auth_Home_State.dart';
import 'package:gorev_yonetim/production/Provider/Connectivity/Connectivity_State_home.dart';

import 'package:gorev_yonetim/production/Provider/Firebase/Laoding_Home_State.dart';
import 'package:gorev_yonetim/production/Provider/Task/Data/Task_Home_State.dart';
import 'package:gorev_yonetim/production/Provider/Task/Fetch_Remote_Task/Fetch_Remote_Home.dart';
import 'package:gorev_yonetim/production/Provider/distribution/Text_Theme_Home.dart';

extension Sizes on BuildContext {
  // or use kartal
  Size get sizeOf => MediaQuery.sizeOf(this);
  ThemeData get themeOf => Theme.of(this);
}

//Read with context
extension Provider on BuildContext {
  // this--> context
  AuthHomeState get auth_Provider => this.read<AuthHomeState>();
  FirebaseLaoding get FireLoading_Provider => this.read<FirebaseLaoding>();
  TaskHomeState get Task_Provicer => this.read<TaskHomeState>();
  FetchRemoteHome get FetchTask_Provider => this.read<FetchRemoteHome>();
  TextThemeHome get TextAndTheme_Provider => this.read<TextThemeHome>();

  ConnectivityStateHome get Connectivity_Provider => this.read<ConnectivityStateHome>();
}
