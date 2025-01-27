import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gorev_yonetim/Global/Extensions/Project_Extensions.dart';
import 'package:gorev_yonetim/Global/Lottie/Project_Lottie.dart';
import 'package:gorev_yonetim/production/init/language/locale_keys.g.dart';
import 'package:lottie/lottie.dart';

class NodataWidget extends StatefulWidget {
  const NodataWidget({super.key});

  @override
  State<NodataWidget> createState() => _NodataWidgetState();
}

class _NodataWidgetState extends State<NodataWidget> with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Animasyon süresini 5 saniye yaparak yavaşlatın
    );
    controller.forward(); // Animasyonun otomatik olarak başlaması için
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            LocaleKeys.general_dialog_no_data_No_task.tr(),
            style: context.themeOf.textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(LocaleKeys.general_dialog_no_data_Remote_connection_task_not_found.tr()),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Lottie.asset(
              ProjectLottie.LottieNoData2,
              controller: controller, // Lottie'yi AnimationController ile kullanın
              width: 400,
              animate: true, // Animasyonun otomatik olarak oynatılmasını sağlar
              frameRate: FrameRate(10), // Kare hızını düşürerek daha yavaş bir animasyon elde edin
            ),
          ),
        ],
      ),
    );
  }
}
