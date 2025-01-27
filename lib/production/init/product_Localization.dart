import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gorev_yonetim/production/constant/enums/locales.dart';

@immutable

///Product Localization Manager
final class ProductLocalization extends EasyLocalization {
  ProductLocalization({
    required super.child,
  }) : super(
          supportedLocales: _supportedItems,
          path: _translationPath,
          useOnlyLangCode: true,
        );

  static final List<Locale> _supportedItems = [
    Locales.en.locale,
    Locales.tr.locale,
  ];

  static const String _translationPath = "assets/translation";

  ///Change project language by using [Locales] for
  static Future<void> updateLanguage({
    required BuildContext context,
    required Locales value,
  }) =>
      context.setLocale(value.locale);
}
