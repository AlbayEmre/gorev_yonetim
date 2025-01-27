import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

@immutable
// ignore: must_be_immutable
abstract class AuthInterface {
  final FirebaseAuth auth;
  final GoogleSignIn google_sing_in;

  AuthInterface(this.auth, this.google_sing_in);

  Future<User?> register_with_email(String email, String password); //todo :OK

  Future<User?>? register_phone(String phone); //todo :OK

  Future<User?> phoneNumberConttrol(String smsCode, verificationId); //todo :OK

  Future<User?> Register_With_Google(); //todo :OK

  Future<GoogleSignInAccount?>? Sing_Out(); //todo :OK

  Future<User?> Login_With_Email(String email, String password); //todo :OK

  Future<void> forget_Password(String email);
  Future<void> deleteUser();
}
