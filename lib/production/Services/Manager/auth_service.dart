import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:gorev_yonetim/Feature/Home/Otp_screen.dart';
import 'package:gorev_yonetim/Feature/Landing_Screen.dart';
import 'package:gorev_yonetim/production/Models/User/User_Model.dart';
import 'package:gorev_yonetim/production/Services/interface/auth_interface_Method.dart';

import '../../Models/User/User_process.dart';

class AuthService extends AuthInterface {
  AuthService(super.auth, super.google_sing_in); //tamamdır
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override //todo: OK
  Future<User?> register_with_email(String email, String password) async {
    UserCredential credential = await auth.createUserWithEmailAndPassword(email: email, password: password);

    return credential.user;
  }

//FirebaseUser -->Bizim usere dünmeden kullanılmaz
  @override //todo: OK
  Future<User?> Login_With_Email(String email, String password) async {
    UserCredential credential = await auth.signInWithEmailAndPassword(email: email, password: password);
    return credential.user;
  }

  ///
  ///
  ///

  @override //todo: OK
  Future<User?> Register_With_Google() async {
    var account = await google_sing_in.signIn();
    if (account != null) {
      var auth_ = await account.authentication;
      if (auth_.accessToken != null && auth_.idToken != null) {
        var credential = GoogleAuthProvider.credential(accessToken: auth_.accessToken, idToken: auth_.idToken);
        UserCredential userCredential = await auth.signInWithCredential(credential);
        return userCredential.user;
      }
    }
  }

  @override //todo: OK
  // ignore: non_constant_identifier_names
  Future<GoogleSignInAccount?>? Sing_Out() async //Tüm çıkış için
  {
    await google_sing_in.signOut();
    await auth.signOut();
  }

  ///
  ///
  ///

  @override //todo: OK half --> OTP DE YAPIALCAK
  Future<User?> phoneNumberConttrol(String smsCode, verificationId) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode); //!Doğrulama ve bizim dönderdimiz sms kodu
    UserCredential Credential_user = await auth.signInWithCredential(credential);

    return Credential_user.user;
  }

  final userprocess = UserProcess(); //UserModel Yapmak için
  @override //todo: OK half
  // ignore: non_constant_identifier_names
  Future<User?> register_phone(String phone) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        UserCredential userCredential = await auth.signInWithCredential(credential);
        userprocess.saveUser(
            uid: userCredential.user!.uid,
            name: userCredential.user?.displayName,
            phone: userCredential.user?.phoneNumber);

//GET TO LEADİNG
        //!Tamamlandında bunu yap
      },
      verificationFailed: (FirebaseAuthException firebaseException) {
        // Hata işleme
        print('Phone number verification failed: ${firebaseException.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
              builder: (context) => OtpScreen(
                    verificationId: verificationId,
                  )),
        );

        //Contex yok
        // Get.to(
        //   () => OtpScreen(
        //     verificationId: verificationId,
        //   ),
        // );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Otomatik kod alma zaman aşımına uğradığında işleme
        print("Time Out"); //!Süre Bittiğinde
      },
    );
    return null;
  }

  @override
  Future<void> forget_Password(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email.trim());
      print("Şifre sıfırlama bağlantısı e-posta ile gönderildi.");
    } on FirebaseAuthException catch (e) {
      print("Şifre sıfırlama bağlantısı gönderilirken hata oluştu: ${e.message}");
    }
  }

  @override
  Future<void> deleteUser() async {
    try {
      // Mevcut kullanıcıyı al
      User? user = FirebaseAuth.instance.currentUser;

      // Kullanıcıyı sil
      await user?.delete();

      // Silme işlemi başarılı olduğunda
      print('Kullanıcı başarıyla silindi.');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print('Kullanıcıyı silmek için son girişin yeniden yapılması gerekiyor.');
        // Burada kullanıcıdan tekrar giriş yapması istenebilir
      } else {
        print('Bir hata oluştu: ${e.message}');
      }
    }
  }
}
