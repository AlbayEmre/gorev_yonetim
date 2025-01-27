import 'package:connectivity_plus/connectivity_plus.dart';

abstract class ConnectivityInterface {
  List<ConnectivityResult> connectivityResult;

  ConnectivityInterface({required this.connectivityResult});

  Future connectivity_Save_to_firestore({required String uid});
}
