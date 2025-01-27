import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Bu kısım olmaz ise çalışmaz

      home: ConnectivityPlusExample(),
    );
  }
}

class ConnectivityPlusExample extends StatefulWidget {
  const ConnectivityPlusExample({super.key});

  @override
  State<ConnectivityPlusExample> createState() => _ConnectivityPlusExampleState();
}

class _ConnectivityPlusExampleState extends State<ConnectivityPlusExample> {
  late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;
  Color connectedColor = Colors.red;

  @override
  void initState() {
    super.initState();
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        if (result[0] == ConnectivityResult.wifi) {
          print(result);
          connectedColor = Colors.green;
        } else {
          print(result);
          print("2. kısm ");
          connectedColor = Colors.red;
        }
      });
    });
  }

  @override
  void dispose() {
    connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                var temp = await Connectivity().checkConnectivity(); // Bağlanma durumunu kontrol et
                print(temp);
              },
              child: Container(
                width: 100,
                height: 100,
                color: connectedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
