// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_navigation/src/root/get_material_app.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await EasyLocalization.ensureInitialized();
//   runApp(
//     EasyLocalization(
//       supportedLocales: [Locale('en', 'US'), Locale('tr', 'TR')],
//       path: 'assets/translations',
//       fallbackLocale: Locale('en', 'US'),
//       child: MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       localizationsDelegates: context.localizationDelegates,
//       supportedLocales: context.supportedLocales,
//       locale: context.locale,
//       title: 'Gorevlerini Yonet',
//       home: HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('title'.tr()),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             TextButton(
//                 onPressed: () {
//                   context.setLocale(Locale('en', 'US'));
//                 },
//                 child: Text('English')),
//             TextButton(
//                 onPressed: () {
//                   context.setLocale(Locale('tr', 'TR'));
//                 },
//                 child: Text('Türkçe')),
//           ],
//         ),
//       ),
//     );
//   }
// }
