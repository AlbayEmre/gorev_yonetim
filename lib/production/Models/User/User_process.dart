import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gorev_yonetim/Global/Constant/SaveUser.dart';
import 'package:gorev_yonetim/production/Models/User/User_Model.dart';

class UserProcess {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<void> saveUser({String? name, String? e_mail, required String uid, String? ImageUrl, String? phone}) async {
    await fireStore.collection("users").doc(uid).set({
      "date": DateTime.now(),
      "Username": name, // Düzeltildi: İsim ve e-mail yer değiştirdi
      "e_mail": e_mail,
      "id": uid,
      "profilePhoto": ImageUrl, // Üye olurken kullanılır
      "phoneNumber": phone
    });
  }

  Future<UserModel> readUser(String uid) async {
    var source = await fireStore.collection("users").doc(uid).get();
    if (source.data() != null) {
      // Null kontrolü sağlandı
      return UserModel.fromDoc(source);
    } else {
      throw Exception('No user data available.'); // Uygun hata fırlatma
    }
  }

  Future<UserModel?> controlUser(String uid) async {
    var source = await fireStore.collection("users").doc(uid).get();
    if (source.data() != null) {
      return readUser(uid);
    } else {
      return null;
    }
  }

  Future<void> saveUserWithPhone({String? phoneNumber, String? uid, String? name}) async {
    await fireStore.collection("users").doc(uid).set({"phoneNumber": phoneNumber, "Username": name});
  }

  //Update to image from this Url[Not save update]
  Future Update_to_firestore(String? url, String uid, String? name) async {
    if (url != null) {
      await fireStore.collection("users").doc(uid).update({"profilePhoto": url});
    }
    if (name != null) {
      await fireStore.collection("users").doc(uid).update({"Username": name});
    }
  }

  Future Chnage_User_IsOnline({required bool isOnline, required String uid}) async {
    //Mobil mi internet mi yapılabilir
    await fireStore.collection("users").doc(uid).update({"isOnline": isOnline});
  }

  Future<UserModel> Add_New_Task_to_User({required String userUid, required String taskUid}) async {
    await fireStore.collection("users").doc(userUid).update(
      {
        "users_tasks": FieldValue.arrayUnion([taskUid])
      },
    );
    var source = await fireStore.collection("users").doc(userUid).get();
    return UserModel.fromDoc(source);
  }

  Future DeleteUserFromFireStore({required String userUid}) async {
    await fireStore.collection("users").doc(userUid).delete();
    await fireStore.collection("activeTask").doc(userUid).delete();
  }

  ///
  ///
  Future<List<UserModel>?> fetchFriends({required String userUid}) async {
    // Firestore'dan 'users' koleksiyonundaki belirli bir kullanıcı belgesini alır
    var snapshot = await fireStore.collection("users").doc(userUid).get();

    if (snapshot.exists) {
      // Kullanıcı verilerini alır
      Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>?;

      if (userData != null && userData['friends'] != null) {
        // friends listesini işler ve UserModel listesine dönüştürür
        List<UserModel> friendsList = (userData['friends'] as List<dynamic>)
            .map((friendData) => UserModel.fromJson(friendData as Map<String, dynamic>))
            .toList();

        print("Arkadaş sayısı");
        print(friendsList.length);
        return friendsList;
      } else {
        // friends listesi yoksa veya boşsa null döner
        return null;
      }
    } else {
      // Kullanıcı bulunamazsa null döner
      return null;
    }
  }

  Future<UserModel?> addFriendByEmail({required String userEmail, required String userUid}) async {
    // Firestore'dan 'users' koleksiyonundaki e-posta adresi eşleşen, ancak id'si userUid olmayan belgeleri alır
    var snapshot = await fireStore.collection("users").where("e_mail", isEqualTo: userEmail).get();

    if (snapshot.docs.isNotEmpty) {
      // E-posta adresiyle eşleşen ve id'si farklı olan ilk kullanıcıyı bul
      var matchedUserDoc = snapshot.docs.firstWhere(
        (doc) => doc.id != userUid,
      );

      if (matchedUserDoc != null) {
        // Bulunan kullanıcıyı UserModel olarak al
        UserModel matchedUser = UserModel.fromJson(matchedUserDoc.data() as Map<String, dynamic>);

        // Şimdi mevcut kullanıcıyı al ve arkadaş listesine ekle
        var currentUserDoc = await fireStore.collection("users").doc(userUid).get();

        if (currentUserDoc.exists) {
          // Mevcut kullanıcının arkadaş listesini al
          List<dynamic> currentFriends = currentUserDoc.data()?['friends'] ?? [];

          // Zaten eklenmiş mi kontrol et
          bool isAlreadyFriend = currentFriends.any((friend) => friend['id'] == matchedUser.id);

          if (isAlreadyFriend) {
            print('Bu kullanıcı zaten arkadaş listenizde.');
            return null; // Kullanıcı zaten arkadaş listesinde
          }

          // Yeni arkadaşı listeye ekle
          currentFriends.add(matchedUserDoc.data());

          // Firestore'daki kullanıcı belgesini güncelle
          await fireStore.collection("users").doc(userUid).update({
            'friends': currentFriends,
          });

          // Yeni eklenen arkadaşı UserModel olarak döndür
          return matchedUser;
        }
      } else {
        print('E-posta adresiyle eşleşen başka bir kullanıcı bulunamadı.');
      }
    } else {
      print('E-posta adresiyle eşleşen kullanıcı bulunamadı.');
    }

    // Eğer kullanıcı bulunamazsa null döndür
    return null;
  }

  Future<List<UserModel>?> removeFriendAtIndex({required int index}) async {
    // Kullanıcının belgesini Firestore'dan al
    String userUid = SaveUser().userModel?.id ?? "";
    var userDoc = await fireStore.collection("users").doc(userUid).get();

    if (userDoc.exists) {
      // Mevcut arkadaş listesini al
      List<dynamic> currentFriends = userDoc.data()?['friends'] ?? [];

      if (index >= 0 && index < currentFriends.length) {
        // Verilen index geçerliyse, listedeki bu öğeyi sil
        currentFriends.removeAt(index);

        // Güncellenmiş listeyi Firestore'a geri yaz
        await fireStore.collection("users").doc(userUid).update({
          'friends': currentFriends,
        });

        print('Arkadaş başarıyla silindi!');
      } else {
        print('Geçersiz index: $index');
      }

      // Arkadaş listesini UserModel listesine dönüştür ve döndür
      return currentFriends.map((friend) => UserModel.fromJson(friend as Map<String, dynamic>)).toList();
    } else {
      print('Kullanıcı bulunamadı.');
      return null;
    }
  }
}
