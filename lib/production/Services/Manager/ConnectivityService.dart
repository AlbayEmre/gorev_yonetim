import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gorev_yonetim/production/Models/User/User_Model.dart';

class ConnectivityService {
  final FirebaseFirestore firestore;

  ConnectivityService(this.firestore);

  Stream<List<UserModel>> addNewActiveUser({required UserModel user}) async* {
    DocumentReference docRef = firestore.collection("active").doc("active_user_1");

    try {
      await docRef.update({
        "active_list": FieldValue.arrayUnion([user.toJson2()])
      });
    } catch (e) {
      await docRef.set({
        "active_list": [user.toJson2()]
      }, SetOptions(merge: true));
    }

    yield* docRef.snapshots().map((snapshot) {
      List<dynamic> activeList = snapshot.get('active_list') ?? [];
      return activeList.map((data) => UserModel.fromJson2(data as Map<String, dynamic>)).toList();
    });
  }

  Stream<List<UserModel>> deleteActiveUserFromListAndReturnUpdatedList({required UserModel user}) async* {
    DocumentReference docRef = firestore.collection("active").doc("active_user_1");

    DocumentSnapshot snapshot = await docRef.get();
    List<dynamic> activeList = snapshot.get('active_list') ?? [];
    List<Map<String, dynamic>> updatedList = List<Map<String, dynamic>>.from(activeList);

    updatedList.removeWhere((item) => item['id'] == user.id);

    await docRef.update({"active_list": updatedList});

    yield* docRef.snapshots().map((snapshot) {
      List<dynamic> activeList = snapshot.get('active_list') ?? [];
      return activeList.map((data) => UserModel.fromJson2(data as Map<String, dynamic>)).toList();
    });
  }
}
