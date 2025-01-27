import 'package:card_swiper/card_swiper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gorev_yonetim/Feature/Home/Screens/Layout/Connect_Remote_Screen/Widgets/Task_Information.dart';
import 'package:gorev_yonetim/Feature/Home/Screens/Layout/Home_Screen/FilterTask_Screen.dart';
import 'package:gorev_yonetim/Feature/Home/Screens/Layout/Home_Screen/Mixin/Home_Mixin.dart';
import 'package:gorev_yonetim/Global/Constant/Project_Images.dart';
import 'package:gorev_yonetim/Global/Constant/SaveUser.dart';
import 'package:gorev_yonetim/production/Models/User/User_Model.dart';
import 'package:gorev_yonetim/production/Models/User_Data/Task_Data_Model.dart';
import 'package:gorev_yonetim/production/Provider/Task/Fetch_Remote_Task/Fetch_Remote_Home.dart';
import 'package:gorev_yonetim/production/State/Fetch_Remote_State.dart';
import 'package:gorev_yonetim/production/constant/enums/locales.dart';
import 'package:gorev_yonetim/production/init/language/locale_keys.g.dart';
import 'package:gorev_yonetim/production/init/product_Localization.dart';

import '../../../../../../Global/Extensions/Project_Extensions.dart';

import 'package:kartal/kartal.dart';

import '../../../../../../Global/Constant/Text_Style.dart';

part 'Widgets/Home_Part.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

/// all page listen with this  [WidgetsBindingObserver]
class _HomeState extends State<Home> with HomeMixin, WidgetsBindingObserver {
  ///[connectivity_plus]
  @override
  void initState() {
    super.initState();

    if (mounted) {
      WidgetsBinding.instance.addObserver(this);
      connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) {
        if (result[0] != (ConnectivityResult.none)) {
          context.Connectivity_Provider.addNewActiveUser(SaveUser().userModel!);
        }

        print(result[0].toString());
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (mounted) {
      print(state);

      if (state == AppLifecycleState.inactive || state == AppLifecycleState.detached) {
        context.Connectivity_Provider.deleteActiveUserFromListAndReturnUpdatedList(SaveUser().userModel!);
      }
      if (state == AppLifecycleState.resumed) {
        context.Connectivity_Provider.addNewActiveUser(SaveUser().userModel!);
      }
      super.didChangeAppLifecycleState(state);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Home_AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              LocaleKeys.general_dialog_home_news,
              style: context.themeOf.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ).tr(),
            Expanded(
              flex: 2,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return ClipRRect(borderRadius: BorderRadius.circular(40), child: Image.asset(swiper_String[index]));
                },
                itemCount: 3,
                viewportFraction: 0.8,
                scale: 0.9,
              ),
            ),
            Text(
              LocaleKeys.general_dialog_home_view_recently,
              style: context.themeOf.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ).tr(),
            BlocSelector<FetchRemoteHome, FetchRemoteState, List<TaskDataModel>>(
              selector: (state) {
                return state.View_recently;
              },
              builder: (context, state) {
                if (state.length != 0) {
                  return Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.length < 6 ? state.length : 5,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => TaskInformation(data: state[index])),
                                  );
                                },
                                child: Card(
                                  color: Colors.blue.withOpacity(0.1),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.blue.withOpacity(0.5), width: 3),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Container(
                                    width: 150, // Kartın genişliğini sabit bir değer yapabilirsiniz.
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: context.padding.low,
                                          child: Text(
                                            state[index].title ?? "",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: context.padding.low,
                                          child: Text(
                                            state[index].taskText!.length <= 10
                                                ? state[index].taskText!
                                                : '${state[index].taskText!.substring(0, 10)}...',
                                          ),
                                        ),
                                        Padding(
                                          padding: context.padding.low,
                                          child: Text(
                                              style: TextStyle(color: context.themeOf.colorScheme.error),
                                              "${state[index].deadLine?.year}-${state[index].deadLine?.month}-${state[index].deadLine?.day}"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(LocaleKeys.general_dialog_home_Filtered_tasks).tr(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FiltertaskScreen(
                                text: LocaleKeys.home_task_Importent_level_title_low.tr(),
                                apbarColors: Color.fromARGB(255, 201, 201, 201),
                                labelColors: Colors.white,
                                maximportantLevel: 1,
                                minimportantLevel: 0,
                                bookmark: Colors.white,
                              ),
                            ),
                          );
                        },
                        icon: Image.asset(
                          ProjectImages.low,
                          scale: 10,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FiltertaskScreen(
                                text: LocaleKeys.home_task_Importent_level_title_medium.tr(),
                                apbarColors: Colors.blue,
                                labelColors: Colors.white,
                                maximportantLevel: 2,
                                minimportantLevel: 1,
                                bookmark: Colors.blue,
                              ),
                            ),
                          );
                        },
                        icon: Image.asset(
                          ProjectImages.medium,
                          scale: 10,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FiltertaskScreen(
                                text: LocaleKeys.home_task_Importent_level_title_exalted.tr(),
                                apbarColors: Colors.red,
                                labelColors: Colors.white,
                                maximportantLevel: 3,
                                minimportantLevel: 2,
                                bookmark: Colors.red,
                              ),
                            ),
                          );
                        },
                        icon: Image.asset(
                          ProjectImages.hight,
                          scale: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
