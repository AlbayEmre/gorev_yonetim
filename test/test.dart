import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gorev_yonetim/production/constant/enums/locales.dart';
import 'package:gorev_yonetim/production/init/language/locale_keys.g.dart';
import 'package:gorev_yonetim/production/init/product_Localization.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                ProductLocalization.updateLanguage(context: context, value: Locales.tr);
              },
              child: Text(LocaleKeys.home_page1_title).tr(),
            ),
          ],
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //Bu kısım olmaz ise çalışmaz
  await EasyLocalization.ensureInitialized();
  runApp(
    ProductLocalization(
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Bu kısım olmaz ise çalışmaz
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      home: MyWidget(),
    );
  }
}
