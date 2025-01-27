import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gorev_yonetim/Feature/Landing_Screen.dart';
import 'package:gorev_yonetim/main.dart';
import '../../../Global/Extensions/Project_Extensions.dart';
import 'package:gorev_yonetim/production/Models/User/User_Model.dart';
import 'package:gorev_yonetim/production/Provider/Auth/Auth_Home_State.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  String? verificationId;
  OtpScreen({super.key, this.verificationId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String code = "";

  UserModel? userModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Pinput(
              length: 6,
              onChanged: (value) {
                code = value;
              },
            ),
            TextButton(
              onPressed: () async {
                try {
                  User? user = await context.auth_Provider.phoneNumberConttrol(code, widget.verificationId);
                  if (user != null && user.phoneNumber != null) {
                    // Do something with the user

                    navigatorKey.currentState?.pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LandingScreen()),
                      (Route<dynamic> route) => false,
                    );
                  } else {
                    print("User or phone number is null");
                    // Handle null user or phone number
                  }
                } catch (e) {
                  print("Error during phone number verification: $e");
                  // Handle exceptions
                }
              },
              child: Text("Submit"),
            ),
            Text(userModel?.phoneNumber ?? ""),
          ],
        ),
      ),
    );
  }
}
