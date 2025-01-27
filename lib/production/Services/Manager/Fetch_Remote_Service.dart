import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:gorev_yonetim/production/Models/User_Data/Task_Data_Model.dart';
import 'package:gorev_yonetim/production/Services/interface/Fetch_Remote_Interface.dart';

class FetchRemoteService extends FetchRemoteInterface {
  FetchRemoteService() : super(firestore: FirebaseFirestore.instance);

  // Future<List<TaskDataModel>> fetchTasksByTaskId({
  //   required List<String> taskIds, // Bu görev ID'leri arasında filtreleme yapmak için
  // }) async {
  //   // Firestore'dan "tasks" koleksiyonundaki tüm görevleri çek
  //   QuerySnapshot snapshot = await firestore.collection("tasks").get();
  //   List<TaskDataModel> allTasks = snapshot.docs.map((doc) {
  //     return TaskDataModel.fromJson({
  //       'taskId': doc.id,
  //       ...doc.data() as Map<String, dynamic>,
  //     });
  //   }).toList();

  //   // Görevleri taskId'lerine göre filtrele
  //   List<TaskDataModel> filteredTasks = allTasks.where((task) => taskIds.contains(task.taskId)).toList();

  //   return filteredTasks;
  // }

  @override
  Future<List<String>> fetchTaskIdsByPassword({required String password, required String userId}) async {
    // Firestore'dan "tasks" koleksiyonundaki tüm görevleri çek
    QuerySnapshot snapshot = await firestore.collection("tasks").get();
    List<TaskDataModel> allTasks = snapshot.docs.map((doc) {
      return TaskDataModel.fromJson({
        'taskId': doc.id,
        ...doc.data() as Map<String, dynamic>,
      });
    }).toList();

    //   // Şifreye göre görevleri filtrele ve görev ID'lerini döndür
    List<String> taskIds = allTasks
        .where((task) => task.taskPassword == password) // Şifre kontrolü
        .map((task) => task.taskId) // Görev ID'lerini al
        .toList();

    // Açılan görevin ID'lerini Firestore'ye ekle
    //!Görevlei ekle sonra güncel halini çek
    await firestore.collection("activeTask").doc(userId).set({"ActiveTaskList": FieldValue.arrayUnion(taskIds)},
        SetOptions(merge: true)); // Eğer doküman zaten varsa üzerine yaz (merge)

    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("activeTask").doc(userId).get();
    if (documentSnapshot.exists) {
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      if (data.containsKey('ActiveTaskList')) {
        List<dynamic> dynamicList = data['ActiveTaskList'];
        List<String> stringList = dynamicList.map((item) => item.toString()).toList();
        return stringList;
      }
    }

    return [];
  }

  @override
  Future<List<String>> fetchActiveTaskIds(String userId) async {
    DocumentSnapshot snapshot = await firestore.collection("activeTask").doc(userId).get();

    if (snapshot.exists) {
      // Verileri güvenli bir şekilde çekmek için null kontrolü yapılıyor
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic> ?? {};
      if (data.containsKey('ActiveTaskList')) {
        // 'ActiveTaskList' anahtarını kontrol et ve List<String> olarak döndür
        List<dynamic> activeTaskList = data['ActiveTaskList'];
        return List<String>.from(activeTaskList);
      }
    }
    return []; // Görev listesi bulunamazsa boş liste döndür
  }

  Future<List<TaskDataModel>> fetchTasksByIds(List<String> taskIds, String? username) async {
    List<TaskDataModel> tasks = [];
    for (String taskId in taskIds) {
      DocumentSnapshot docSnapshot = await firestore.collection("tasks").doc(taskId).get();
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        TaskDataModel task = TaskDataModel.fromJson({'taskId': docSnapshot.id, ...data});

        // AllAddedUsersUid listesini kontrol eder ve ilk elemanı username ile eşleşiyorsa listeye ekler
        if (task.AllAddedUsersUid != null &&
            task.AllAddedUsersUid!.isNotEmpty &&
            task.AllAddedUsersUid![0] != username) {
          tasks.add(task);
        }
      }
    }
    return tasks;
  }

  @override
  Future<List<TaskDataModel>> fetchActiveTasksForUser({String? userId, String? username}) async {
    List<String> activeTaskIds = await fetchActiveTaskIds(userId ?? "");
    List<TaskDataModel> activeTasks = await fetchTasksByIds(activeTaskIds, username);
    return activeTasks;
  }
}
