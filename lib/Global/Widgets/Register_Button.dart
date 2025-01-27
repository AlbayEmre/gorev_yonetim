import 'package:flutter/material.dart';
import '../Extensions/Project_Extensions.dart';

class LoginButton extends StatelessWidget {
  TextEditingController? e_mail;
  TextEditingController? password;

  LoginButton({super.key, required this.text, required this.onPressed, this.e_mail, this.password});
  String text;
  VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.resolveWith(
            (value) {
              return RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));
            },
          ),
          backgroundColor: WidgetStateProperty.resolveWith(
            (state) {
              if (state.contains(WidgetState.pressed)) {
                return Colors.blue;
              }
              return Colors.blueGrey[100];
            },
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: context.themeOf.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
