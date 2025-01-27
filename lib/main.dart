///
///
///
///
///
///

import 'package:auto_localized/auto_localized.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gorev_yonetim/Feature/Home/Screens/Layout/Connect_Remote_Screen/Connect_Remote_Screen.dart';
import 'package:gorev_yonetim/Feature/Home/Screens/Layout/Connect_Remote_Screen/Widgets/Task_Information.dart';
import 'package:gorev_yonetim/Feature/Home/Screens/Layout/Home_Screen/FilterTask_Screen.dart';
import 'package:gorev_yonetim/Feature/Home/Screens/Layout/Home_Screen/Home.dart';
import 'package:gorev_yonetim/Feature/Home/Screens/Login_Screen.dart';

import 'package:gorev_yonetim/Feature/Home/Screens/Register_Screen.dart';
import 'package:gorev_yonetim/Global/Constant/Text_Style.dart';
import 'package:gorev_yonetim/Global/Extensions/Project_Extensions.dart';
import 'package:gorev_yonetim/Global/Widgets/NoUser_Screen.dart';
import 'package:gorev_yonetim/production/Provider/Auth/Auth_Home_State.dart';
import 'package:gorev_yonetim/production/Provider/Connectivity/Connectivity_State_home.dart';

import 'package:gorev_yonetim/production/Provider/Firebase/Laoding_Home_State.dart';
import 'package:gorev_yonetim/production/Provider/Task/Data/Task_Home_State.dart';
import 'package:gorev_yonetim/production/Provider/Task/Fetch_Remote_Task/Fetch_Remote_Home.dart';
import 'package:gorev_yonetim/production/Provider/distribution/Text_Theme_Home.dart';
import 'package:gorev_yonetim/production/State/Text_Theme_Sate.dart';
import 'package:gorev_yonetim/production/constant/enums/locales.dart';

import 'package:gorev_yonetim/production/init/FireBase_init.dart';
import 'package:gorev_yonetim/production/init/language/locale_keys.g.dart';
import 'package:gorev_yonetim/production/init/product_Localization.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../Global/Theme/ProjectTheme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //Bu kısım olmaz ise çalışmaz

  /// init [FirebaseApp]
  await FirebaseInit.FireInitFunction();

  /// init [EasyLocalization]

  await EasyLocalization.ensureInitialized();

  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.openBox('language');
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthHomeState(),
        ),
        BlocProvider(
          create: (context) => FirebaseLaoding(),
        ),
        BlocProvider(
          create: (context) => TaskHomeState(),
        ),
        BlocProvider(
          create: (context) => FetchRemoteHome(),
        ),
        BlocProvider(
          create: (context) => TextThemeHome(),
        ),
        BlocProvider(
          create: (context) => ConnectivityStateHome(),
        ),
      ],
      child: MaterialApp(
        locale: context.locale, // EasyLocalization'dan gelen locale
        supportedLocales: context.supportedLocales, // Desteklenen diller
        localizationsDelegates: context.localizationDelegates, // Localization delegeleri
        debugShowCheckedModeBanner: false,
        title: 'Gorevlerini Yonet',
        navigatorKey: navigatorKey, //Global navigator

        ///
        //  theme: Projecttheme.theme,
        //   theme: styles.themeData(isDarkTheme: state.isDark, context: context),

        home: LoginScreen(),
      ),
    );
  }
}
