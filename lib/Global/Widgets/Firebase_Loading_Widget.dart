import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:gorev_yonetim/Global/Extensions/Project_Extensions.dart';

class FireBaseLoading_Screen extends StatefulWidget {
  bool isTask;
  FireBaseLoading_Screen({super.key, this.isTask = false});

  @override
  State<FireBaseLoading_Screen> createState() => _FireBaseLoading_ScreenState();
}

class _FireBaseLoading_ScreenState extends State<FireBaseLoading_Screen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: const Color.fromARGB(255, 1, 41, 74).withOpacity(0.2),
          width: double.infinity,
          height: widget.isTask ? context.sizeOf.height * 0.8 : context.sizeOf.height,
          child: Center(
            child: SpinKitThreeInOut(
              itemBuilder: (BuildContext context, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    shape: index.isEven ? BoxShape.circle : BoxShape.rectangle,
                    color: index.isEven ? Colors.lightBlue.withOpacity(0.8) : Colors.black.withOpacity(0.1),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
