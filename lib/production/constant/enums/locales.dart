import 'package:flutter/material.dart';

/// Proje desteklenen yerel ayarlar enum
enum Locales {
  tr(Locale("tr", "TR")),
  en(Locale("en", "US"));

  final Locale locale;
  const Locales(this.locale);
}
