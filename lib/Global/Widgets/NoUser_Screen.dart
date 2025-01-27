import 'package:flutter/material.dart';
import 'package:gorev_yonetim/Global/Constant/Project_Images.dart';
import 'package:gorev_yonetim/Global/Extensions/Project_Extensions.dart';
import 'package:gorev_yonetim/Global/Lottie/Project_Lottie.dart';
import 'package:lottie/lottie.dart';

class NouserScreen extends StatelessWidget {
  const NouserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "No User Data ",
              style: context.themeOf.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text("Please exit and enter again."),
            Image.asset(
              ProjectImages.NoUser,
              scale: 2,
            ),
          ],
        ),
      ),
    );
  }
}
