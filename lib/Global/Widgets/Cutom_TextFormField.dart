import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField(
      {super.key,
      this.labelText,
      this.hintText,
      this.suffixIchon,
      required this.obscureText,
      required this.obscureChar,
      this.validator,
      this.keyboardType,
      this.controller,
      required this.maxlengt,
      required this.autofocus,
      this.buildCounter,
      this.paswordVizible,
      this.isOnlyRead = false,
      this.textAlign = TextAlign.left,
      this.maxlines,
      this.minlines});

  String? labelText;
  String? hintText;
  IconData? suffixIchon;
  bool obscureText;
  String obscureChar;
  int? maxlengt;
  bool autofocus;
  bool isOnlyRead;
  TextAlign textAlign;
  int? maxlines;
  int? minlines;
  String? Function(String?)? validator;
  String? Function(String)? onchanged;
  Widget? Function(BuildContext, {required int currentLength, required bool isFocused, required int? maxLength})?
      buildCounter;
  TextInputType? keyboardType;
  TextEditingController? controller;
  IconButton? paswordVizible;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: minlines,
      maxLines: maxlines,
      textAlign: textAlign,
      readOnly: isOnlyRead,
      onChanged: onchanged,
      buildCounter: buildCounter,

      maxLength: maxlengt,

      autofocus: autofocus,

      controller: controller,
      validator: validator,

      decoration: InputDecoration(
        label: Text(
          labelText ?? "",
          style: TextStyle(color: Colors.blueGrey[800]),
        ),
        // labelText: labelText,
        labelStyle: TextStyle(fontWeight: FontWeight.w400),
        hintText: hintText,
        hintStyle: TextStyle(fontWeight: FontWeight.w100),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.values[0])),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 3, style: BorderStyle.values[1]),
          borderRadius: BorderRadius.circular(10),
          gapPadding: 20,
        ),
        iconColor: Colors.blue,
        filled: true,
        fillColor: Colors.blueGrey.shade300.withOpacity(0.25),
        border: OutlineInputBorder(),
        suffix: SizedBox(
          height: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                suffixIchon,
                color: Colors.grey.shade600,
              ),
              paswordVizible ?? SizedBox.shrink(),
            ],
          ),
        ),
      ),
      obscureText: obscureText,
      obscuringCharacter: obscureChar,
      keyboardType: keyboardType, //!
      textInputAction: TextInputAction.next,
    );
  }
}
