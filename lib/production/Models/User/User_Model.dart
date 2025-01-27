import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  DateTime? date;
  String? Username;
  String? e_mail;
  String? id; // Password field
  String? phoneNumber;
  String? ProfilePhoto;
  String? isOnline;
  List<String>? users_tasks; // Liste tipi dikkatlice işlenmeli
  List<UserModel>? friends;

  UserModel({
    this.Username,
    this.date,
    this.ProfilePhoto,
    this.e_mail,
    this.id,
    this.phoneNumber,
    this.users_tasks,
    this.isOnline,
    this.friends,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      isOnline: json["isOnline"],
      users_tasks: List<String>.from(json["users_tasks"] ?? []),
      Username: json["Username"],
      date: json['date'] != null
          ? (json['date'] as Timestamp).toDate()
          : DateTime.now(), // Firestore Timestamp'ını DateTime'a çevir
      ProfilePhoto: json["profilePhoto"],
      e_mail: json["e_mail"],
      id: json["id"],
      phoneNumber: json["phoneNumber"],
      friends: (json["friends"] as List<dynamic>?)
          ?.map((friendJson) => UserModel.fromJson(friendJson as Map<String, dynamic>))
          .toList(),
    );
  }
  factory UserModel.fromJson2(Map<String, dynamic> json) {
    return UserModel(
      Username: json["Username"] ?? '', // Boş string varsayılan olarak kullanılır

      ProfilePhoto: json["profilePhoto"] ?? '', // Boş string varsayılan olarak kullanılır
      e_mail: json["e_mail"] ?? '', // Boş string varsayılan olarak kullanılır
      id: json["id"] ?? '', // Boş string varsayılan olarak kullanılır
      phoneNumber: json["phoneNumber"] ?? '', // Boş string varsayılan olarak kullanılır
    );
  }

  factory UserModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> source) {
    final data = source.data();
    if (data == null) throw Exception('Document data is null');
    return UserModel.fromJson(data);
  }
  Map<String, dynamic> toJson2() {
    return {
      'Username': Username,

      'profilePhoto': ProfilePhoto,
      'e_mail': e_mail,
      'id': id,

      'users_tasks': users_tasks, // Doğrudan listeyi JSON'a eklemek
    };
  }

  Map<String, dynamic> toJson() {
    return {
      "isOnline": isOnline,
      'Username': Username,
      'date': date?.toUtc().millisecondsSinceEpoch, // Firestore için DateTime'ı Epoch'a çevirme
      'profilePhoto': ProfilePhoto,
      'e_mail': e_mail,
      'id': id,
      'phoneNumber': phoneNumber,
      'users_tasks': users_tasks, // Doğrudan listeyi JSON'a eklemek
    };
  }
}
