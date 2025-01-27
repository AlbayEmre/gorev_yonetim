import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gorev_yonetim/Feature/Home/Screens/Layout/Home_Screen/Home.dart';
import 'package:gorev_yonetim/Feature/Home/Screens/Register_Screen.dart';
import 'package:gorev_yonetim/production/Models/User/User_Model.dart';
import 'package:gorev_yonetim/root.dart';

/// Creates a new [StreamBuilder] that builds itself based on the latest
/// snapshot of interaction with the specified [stream] and whose build
/// strategy is given by [builder].

class LandingScreen extends StatefulWidget {
  LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  UserModel? currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(), //--> Anlık giriş çıkış dinle
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Something went wrong ->${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            return Root();
          }
          return RegisterScreen();
        },
      ),
    );
  }
}
