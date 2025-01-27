import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gorev_yonetim/Global/Constant/SaveUser.dart';
import 'package:gorev_yonetim/production/Models/User/User_Model.dart';
import 'package:gorev_yonetim/production/Models/User_Data/Task_Data_Model.dart';
import 'package:gorev_yonetim/production/Services/interface/Task_Interface.dart';

class TaskService extends TaskInterface {
  TaskService(super.firestore, super.taskstorage);

  @override
  // ignore: non_constant_identifier_names
  Future Create_A_Task_save_to_FireStore({
    required String taskId,
    required String taskPassword,
    DateTime? deadLine,
    String? title,
    String? taskText,
    required List<String?> TaskImages_URLs,
    required List<String?> TaskSound_URLs,
    bool isDone = false,
    List<String?>? AllAddedUsersUid,
    double? importantLevel,
  }) async {
    await firestore.collection("tasks").doc(taskId).set(
      {
        "taskId": taskId,
        "taskPassword": taskPassword,
        "deadLine": deadLine,
        "title": title,
        "taskText": taskText,
        "taskImages": TaskImages_URLs,
        "taskSound": TaskSound_URLs,
        "isdone": isDone,
        "AllAddedUsersUdi": AllAddedUsersUid,
        "importantLevel": importantLevel
      },
    );
  }

  @override
  // ignore: non_constant_identifier_names
  Future Upgrade_A_Task_save_to_FireStore({
    required String taskId,
    required String taskPassword,
    DateTime? deadLine,
    String? title,
    String? taskText,
    required List<String?> TaskImages_URLs,
    required List<String?> TaskSound_URLs,
    bool isDone = false,
    double? importantLevel,
  }) async {
    await firestore.collection("tasks").doc(taskId).update(
      {
        "taskId": taskId,
        "taskPassword": taskPassword,
        "deadLine": deadLine,
        "title": title,
        "taskText": taskText,
        "taskImages": TaskImages_URLs,
        "taskSound": TaskSound_URLs,
        "isdone": isDone,
        "importantLevel": importantLevel
      },
    );
  }

  @override
  Future Update_AllAddedUsers({required List<String>? AllAddedUsersUid, required String taskId}) async {
    await firestore.collection("tasks").doc(taskId).update({"AllAddedUsersUdi": AllAddedUsersUid});
  }

  @override
  Future Update_DeadLine({required DateTime deadline, required String taskId}) async {
    await firestore.collection("tasks").doc(taskId).update({"deadline": deadline});
  }

  @override
  Future Update_TaskImages_URLs({required List<String?> TaskImages_URLs, required String taskId}) async {
    await firestore.collection("tasks").doc(taskId).update({"TaskImages_URLs": TaskImages_URLs});
  }

  @override
  Future Update_TaskSound_URLs({required List<String?> TaskSound_URLs, required String taskId}) async {
    await firestore.collection("tasks").doc(taskId).update({"TaskSound_URLs": TaskSound_URLs});
  }

  @override
  Future Update_isDone({required bool isDone, required String taskId}) async {
    await firestore.collection("tasks").doc(taskId).update({"isDone": isDone});
  }

  @override
  Future Update_taskText({required String taskText, required String taskId}) async {
    await firestore.collection("tasks").doc(taskId).update({"taskText": taskText});
  }

  @override
  Future Update_title({required String title, required String taskId}) async {
    await firestore.collection("tasks").doc(taskId).update({"title": title});
  }

  @override
  Future Add_New_Imge({required String image, required String taskId}) async {
    await firestore.collection("tasks").doc(taskId).update({
      'TaskImages_URLs': FieldValue.arrayUnion([image])
    });
  }

  @override
  Future Add_New_Sound({required String sound, required String taskId}) async {
    await firestore.collection("tasks").doc(taskId).update({
      'TaskSound_URLs': FieldValue.arrayUnion([sound])
    });
  }

  @override
  Future Add_New_User({required UserModel user, required String taskId}) async {
    await firestore.collection("tasks").doc(taskId).update({
      'AllAddedUsers': FieldValue.arrayUnion([user])
    });
  }

  @override
  Future<TaskDataModel> Get_Snapshot_data({required String uid}) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await firestore.collection("tasks").doc(uid).get();

    return TaskDataModel.fromdoc(snapshot);
  }

  @override
  Future Add_TaskId_into_User({required String userUid, required String taskUid}) async {
    await firestore.collection("users").doc(userUid).update(
      {
        "users_tasks": FieldValue.arrayUnion([taskUid]),
      },
    );
  }

  //Bir kulanıcının tüm verilerini çek
  @override
  Future<List<TaskDataModel>> getFireStoreAllData({
    required String username,
  }) async {
    // Firestore'dan tüm 'tasks' koleksiyonunu çekiyoruz.
    QuerySnapshot snapshot = await firestore.collection("tasks").get();

    // Elde edilen dokümanları TaskDataModel nesnelerine dönüştürüyoruz.
    List<TaskDataModel> datamodel = snapshot.docs.map((doc) {
      return TaskDataModel.fromJson({
        'taskId': doc.id,
        ...doc.data() as Map<String, dynamic>,
      });
    }).toList();

    // Kullanıcı adına göre filtreleme yapıyoruz.
    List<TaskDataModel> usersTask = datamodel.where((task) {
      // AllAddedUsersUid listesi null veya boş olmayacak şekilde kontrol ediliyor
      if (task.AllAddedUsersUid != null && task.AllAddedUsersUid!.isNotEmpty) {
        return task.AllAddedUsersUid![0] == username; // İlk kullanıcı adı ile karşılaştırma
      }
      return false;
    }).toList();

    print(usersTask.length);

    return usersTask; // Filtrelenmiş kullanıcı görevlerini döndür
  }

  @override
  Future<void> delete_task_for_UserName({required String userName}) async {
    try {
      // Tüm 'tasks' koleksiyonundaki belgeleri al
      var allTasks = await firestore.collection("tasks").get();
      // ignore: unnecessary_null_comparison
      if (allTasks != null) {
        // Her bir belgeyi incele
        for (var doc in allTasks.docs) {
          var data = doc.data();

          // AllAddedUsersUid listesini al
          List<dynamic>? allAddedUsersUid = data['AllAddedUsersUdi'];
          print("allAddedUsersUid?[0].toString()");
          print(allAddedUsersUid?[0].toString());

          // Eğer liste varsa ve ilk eleman userName ile eşleşiyorsa belgeyi sil
          if (allAddedUsersUid != null && allAddedUsersUid.isNotEmpty && allAddedUsersUid[0] == userName) {
            await firestore.collection("tasks").doc(doc.id).delete();
            print('Task ${doc.id} silindi.');
          }
        }
      }
    } catch (e) {
      print('Hata: $e');
    }
  }

  // ignore: non_constant_identifier_names
  Future<List<TaskDataModel>?> delete_task_with_uid({required String taskId}) async {
    await firestore.collection("tasks").doc(taskId).delete();

    DocumentReference<Map<String, dynamic>> userDocRef =
        firestore.collection("users").doc(SaveUser().userModel?.id ?? "");

    // Belgeyi getir
    DocumentSnapshot<Map<String, dynamic>> userDocSnapshot = await userDocRef.get();

    if (userDocSnapshot.exists && userDocSnapshot.data() != null) {
      // users_tasks listesini al
      List<dynamic> usersTasks = List.from(userDocSnapshot.data()!['users_tasks'] ?? []);

      // taskId içeren görevleri listeden kaldır
      List<dynamic> updatedTasks = usersTasks.where((task) => task != taskId).toList();

      // Güncellenmiş users_tasks listesiyle kullanıcının belgesini güncelle
      await userDocRef.update({'users_tasks': updatedTasks});
    } else {
      print("Belge bulunamadı veya users_tasks listesi boş.");
    }

    QuerySnapshot querySnapshot = await firestore.collection("tasks").get();
    // Her bir dokümanı TaskDataModel'a dönüştür ve listeye ekle
    List<TaskDataModel> datamodel = querySnapshot.docs.map((doc) {
      return TaskDataModel.fromJson({
        'taskId': doc.id,
        ...doc.data() as Map<String, dynamic>,
      });
    }).toList();

    return datamodel;
  }
}
