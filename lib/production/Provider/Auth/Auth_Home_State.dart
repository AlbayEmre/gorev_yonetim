import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:gorev_yonetim/Feature/Home/Screens/Login_Screen.dart';
import 'package:gorev_yonetim/main.dart';
import 'package:gorev_yonetim/production/Models/User/User_Model.dart';
import 'package:gorev_yonetim/production/Models/User/User_process.dart';
import 'package:gorev_yonetim/production/Services/Manager/Storage_Service.dart';
import 'package:gorev_yonetim/production/Services/Manager/auth_service.dart';
import 'package:gorev_yonetim/production/State/Auth_State.dart';

class AuthHomeState extends Cubit<AuthState> {
  AuthHomeState() : super(AuthState(userModel: UserModel(), friends: []));

  final authService = AuthService(FirebaseAuth.instance, GoogleSignIn());
  final MyStorageService = StorageService(FirebaseStorage.instance);
  final userprocess = UserProcess();
  UserModel userModel = UserModel();

  ///
  ///
  Future<String?> Register_with_Email(String e_mail, String pasword, String name, String? imageUrl) async {
    try {
      User? user = await authService.register_with_email(e_mail, pasword);

      user?.sendEmailVerification(); //Mail gönder

      await userprocess.saveUser(uid: user!.uid, name: name, e_mail: e_mail, ImageUrl: imageUrl);

      return "Mailinize onay Kodu gönderilmiştir";
    } on FirebaseException catch (e) {
      print("ERROR Register_with_Email:${e.toString()}");
    }
  }

  Future<UserModel?> login_With_Email(String email, String password) async {
    try {
      User? fireuser = await authService.Login_With_Email(email, password);
      if (fireuser != null && fireuser.emailVerified) {
        UserModel userModel = await userprocess.readUser(fireuser.uid);
        emit(state.copyWith(user: userModel));
        return userModel;
      }
    } on FirebaseException catch (e) {
      print("ERROR login_With_Email:${e.toString()}");
    }
  }

  Future<UserModel?> Register_With_Google() async {
    try {
      User? fireuser = await authService.Register_With_Google();
      var result = await userprocess.controlUser(fireuser!.uid); //Hazırda profil varsa oku ve çevir
      if (result != null) {
        userModel = result;
        emit(state.copyWith(user: userModel));
        return userModel;
      } else {
        await userprocess.saveUser(name: fireuser.displayName, e_mail: fireuser.email, uid: fireuser.uid); //Save user

        UserModel readUser = await userprocess.readUser(fireuser.uid);
        emit(state.copyWith(user: readUser));
        return userModel;
      }
    } on FirebaseException catch (e) {
      print("ERROR Register_With_Google:${e.toString()}");
    }
  }

  Future singOut() async {
    try {
      authService.Sing_Out();

      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (Route<dynamic> route) => false,
      );
    } on FirebaseException catch (e) {
      print("SİNG OUT ERROR:${e.toString()}");
    }
  }

  // ignore: non_constant_identifier_names
  Future<User?> register_with_phone(String phone, String? name) async {
    try {
      User? user = await authService.register_phone(phone); //Firebase user
      var result = await userprocess.controlUser(user!.uid); //--> Adını deyiştirdiyse kontrol gerekebilir

      if (result != null) {
        userModel = result;
        emit(state.copyWith(user: userModel)); //Her deyer atandında güncelle
      }
      //telefon ile ilk kez üye oluyorsa
      //Sisteme kaydet
      else {
        await userprocess.saveUser(phone: user.phoneNumber, uid: user.uid, name: name);

        userModel = (await userprocess.readUser(user.uid));
        emit(state.copyWith(user: userModel)); //Her değer atandında güncelle
      }
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }
  }

  Future<User?> phoneNumberConttrol(String smsCode, verificationID) async {
    User? user = await authService.phoneNumberConttrol(smsCode, verificationID);

    return user;
  }

  ///
  ///

  ///
  Future updateProfilePhoto_And_Name(File? file, String uid, String? name) async {
    String? url;
    if (file != null) {
      url = await MyStorageService.save_to_Storage(file);
    }

    if (url != null) {
      userprocess.Update_to_firestore(url, uid, name);
    }
    emit(state.copyWith(user: UserModel(ProfilePhoto: url, Username: name))); //Model de güncellendi
  }

  Future<String?> file_to_Url(File? file) async {
    try {
      if (file != null) {
        String? url = await MyStorageService.save_to_Storage(file);
        return url;
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      print("Storage ERROR:${e.toString()}");
      throw FirebaseException(plugin: e.toString());
    }
  }

  Future<UserModel?> readFireBaseUser(User? user) async {
    return await userprocess.readUser(user!.uid);
  }

  Future<bool> forget_Password(String email) async {
    try {
      authService.forget_Password(email);
      return true;
    } on FirebaseException catch (e) {
      throw Exception("FORGET ERROR${e}");
    }
  }

  Future add_task_into_user({required String userUid, required String taskUid}) async {
    try {
      UserModel userModel = await userprocess.Add_New_Task_to_User(userUid: userUid, taskUid: taskUid);
      emit(state.copyWith(user: userModel));
      return true;
    } on FirebaseException catch (e) {
      throw Exception("FORGET ERROR${e}");
    }
  }

  Future<bool> deleteUserAuth({required String useruid}) async {
    try {
      //delete[User] and [ActiveUser]
      await authService.deleteUser();
      await userprocess.DeleteUserFromFireStore(userUid: useruid);
      singOut();

      return true;
    } on FirebaseException catch (e) {
      throw Exception("DELETE ERROR${e}");
    }
  }

  Future fetchFriends({required String userUid}) async {
    List<UserModel>? allUser = await userprocess.fetchFriends(userUid: userUid);

    emit(state.copyWith(friends: allUser));
  }

  Future addFriends({required String e_mail, required String userUid}) async {
    UserModel? allUser = await userprocess.addFriendByEmail(userEmail: e_mail, userUid: userUid);

    if (allUser != null) {
      List<UserModel> temp = state.friends;
      temp.add(allUser);
      emit(state.copyWith(friends: temp));
    }
  }

  Future deleteFriends({required int index}) async {
    List<UserModel>? currentFriends = await userprocess.removeFriendAtIndex(index: index);
    print("mevcut arakdaş");
    print(currentFriends);

    emit(state.copyWith(friends: currentFriends));
  }
}
