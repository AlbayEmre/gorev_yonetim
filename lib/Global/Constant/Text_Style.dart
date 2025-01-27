import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

@immutable
class TextStylee extends TextStyle {
  TextStylee._();
  @override
  static String? get fontFamilypacifico => GoogleFonts.pacifico().fontFamily;
  static String? get fontFamilyaBeeZee => GoogleFonts.aBeeZee().fontFamily;
}
