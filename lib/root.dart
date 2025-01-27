import 'package:convex_bottom_bar/convex_bottom_bar.dart';

import 'package:flutter/material.dart';
import 'package:gorev_yonetim/Feature/Home/Screens/Layout/AddTask_Screen/widgets/Add_First_Task_Screen.dart';
import 'package:gorev_yonetim/Feature/Home/Screens/Layout/AddTask_Screen/Add_Screen.dart';
import 'package:gorev_yonetim/Feature/Home/Screens/Layout/Connect_Remote_Screen/Connect_Remote_Screen.dart';
import 'package:gorev_yonetim/Feature/Home/Screens/Layout/Home_Screen/Home.dart';
import 'package:gorev_yonetim/Feature/Home/Screens/Layout/User_Screen/User_Screen.dart';
import 'package:gorev_yonetim/production/Models/User/User_Model.dart';

class Root extends StatefulWidget {
  int? page;

  Root({super.key, this.page});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> with TickerProviderStateMixin {
  late TabController _controller;
  @override
  void initState() {
    _controller = TabController(length: ScreenCount.values.length, vsync: this);
    if (widget.page != null) {
      _controller.index = widget.page!;
      value = widget.page!;
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int value = 0;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: ScreenCount.values.length,
      child: Scaffold(
        //  resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _controller,
          children: <Widget>[
            Home(), //1
            AddScreen(), //2
            ConnectRemoteScreen(),
            UserScreen() //4
          ],
        ),
        bottomNavigationBar: ConvexAppBar(
          top: -20,
          gradient: const LinearGradient(
            colors: [
              Colors.white,
              Color.fromARGB(255, 219, 255, 254),
              Colors.white,
              Color.fromARGB(255, 219, 255, 254),
              Colors.white,
              Color.fromARGB(255, 219, 255, 254),
              Colors.white,
            ],
          ),
          shadowColor: Colors.black,
          activeColor: Color.fromARGB(255, 189, 221, 248),
          backgroundColor: Colors.white,
          controller: _controller,
          color: Colors.grey,
          height: 40,
          style: TabStyle.reactCircle,
          items: [
            TabItem(
              icon: value == 0
                  ? const Icon(
                      Icons.home,
                      size: 35,
                    )
                  : const Icon(
                      Icons.home_outlined,
                    ),
            ),
            TabItem(
              icon: value == 1
                  ? const Icon(
                      Icons.note_add_rounded,
                      size: 35,
                    )
                  : const Icon(Icons.note_add_outlined),
            ),
            TabItem(
              icon: value == 2
                  ? const Icon(
                      Icons.bookmark,
                      size: 35,
                    )
                  : Icon(Icons.bookmark_border),
            ),
            TabItem(
              icon: value == 3
                  ? const Icon(
                      Icons.person,
                      size: 35,
                    )
                  : const Icon(Icons.person_outline_outlined),
            ),
          ],
          initialActiveIndex: 1,
          onTap: (int i) {
            value = i;
            setState(() {});
          },
        ),
      ),
    );
  }
}

enum ScreenCount {
  Home,
  Profile,
  NewTaskPage,
  DonneTask,
}
