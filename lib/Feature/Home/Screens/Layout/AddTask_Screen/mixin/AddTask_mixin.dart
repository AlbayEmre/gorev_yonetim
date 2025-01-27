import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:gorev_yonetim/Feature/Home/Screens/Layout/AddTask_Screen/Add_Task.dart';
import 'package:gorev_yonetim/Global/Constant/Custom_Snack_bar.dart';
import 'package:gorev_yonetim/Global/Extensions/Project_Extensions.dart';
import 'package:gorev_yonetim/production/init/language/locale_keys.g.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

mixin AddtaskMixin on State<AddTask> {
  late TextEditingController titleConteoller;
  late TextEditingController taskTextConteoller;
  late TextEditingController passwordConteoller;
  ImagePicker picker = ImagePicker();
  final AudioPlayer audioPlayer = AudioPlayer();
  Map<int, bool> isPlayingMap = {};
  Map<int, Duration> currentPositionMap = {};
  Map<int, Duration> totalDurationMap = {};
  int? currentIndex;
  File? image;
  List<File> imageList = [];
  bool isLongPress = false;
  DateTime? deadLine;
  double importtentLevel = 0;

  /// conver to [URL]
  List<String?>? imageUrl = [];
  List<String?>? soundUrl = [];

  final record = AudioRecorder();
  bool _isRecording = false;
  String? filePath;

  File? soundFile;
  List<File> soundFileList = [];

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: deadLine,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked.isAfter(DateTime.now().subtract(Duration(days: 1)))) {
      setState(() {
        deadLine = picked;
      });
    } else {
      ProjectSnackBar.showSnackbar(context, LocaleKeys.general_dialog_snackbar_text_add_task_Failure.tr(),
          LocaleKeys.general_dialog_snackbar_text_add_task_The_deadline_cannot_be_before_today.tr());
    }
  }

  void initializePlayer() {
    audioPlayer.onPlayerComplete.listen((event) {
      if (currentIndex != null) {
        isPlayingMap[currentIndex!] = false;
        setState(() {});
      }
    });
  }

  void changeLongPress() {
    isLongPress = !isLongPress;
    setState(() {});
  }

  void deleteSound(int index) {
    soundUrl?.removeAt(index);
    soundFileList.removeAt(index);
    setState(() {});
  }

  @override
  void initState() {
    titleConteoller = TextEditingController();
    taskTextConteoller = TextEditingController();
    passwordConteoller = TextEditingController();
    if (widget.currentTask != null && widget.isUpdate) {
      titleConteoller.text = widget.currentTask?.title ?? "";
      taskTextConteoller.text = widget.currentTask?.taskText ?? "";
      passwordConteoller.text = widget.currentTask?.taskPassword ?? "";
      imageUrl = widget.currentTask?.taskImages ?? [];
      soundUrl = widget.currentTask?.taskSound ?? [];
      deadLine = widget.currentTask?.deadLine;
      importtentLevel = (widget.currentTask?.importantLevel ?? 0) / 3;
    }
    initializePlayer();
    super.initState();
  }

  @override
  void dispose() {
    titleConteoller.dispose();
    taskTextConteoller.dispose();
    passwordConteoller.dispose();
    super.dispose();
  }

  // Future<void> playSound() async {
  //   if (filePath != null) {
  //     await audioPlayer.play(DeviceFileSource(filePath!));
  //   }
  // }

  // Future<void> pauseSound() async {
  //   await audioPlayer.pause();
  // }

  // Future<void> shotDownSound() async {
  //   await audioPlayer.stop();
  // }

  Future<DateTime?> chooseDeadLine() async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // İlk açıldığında gösterilecek tarih
      firstDate: DateTime(2000), // Seçilebilecek en erken tarih
      lastDate: DateTime(2100), // Seçilebilecek en geç tarih
    );
  }

  Future<void> startRecording() async {
    try {
      if (await record.hasPermission()) {
        Directory? dir = await getApplicationDocumentsDirectory();
        String path = '${dir.path}/flutter_sound_record_${DateTime.now().millisecondsSinceEpoch}.aac';

        await record.start(const RecordConfig(), path: path); // Sadece path parametresini belirtiyoruz.
        setState(() => _isRecording = true);
      }
    } catch (e) {
      print('Failed to start recording: $e');
    }
  }

  Future<File?> stopRecording() async {
    filePath = await record.stop();
    setState(() => _isRecording = false);
    if (filePath != null) {
      soundFile = File(filePath!);
      soundFileList.add(soundFile!); // Listeye en son ekle
      for (var b in soundFileList) {
        var url1 = await context.Task_Provicer.save_image_or_Sound_From_FireStore(b, "TaskSound");

        soundUrl?.add(url1!);
      }
      setState(() {});
      print("SES DOSYASI FİRESTOREYE KAYDEDİLDİ");
      print(soundUrl?.length);
    }
  }

// Ses dosyasını çalan fonksiyon
  // Ses dosyasını çalan fonksiyon
  Future<void> playAudio(String url, int index) async {
    try {
      await audioPlayer.stop(); // Diğer tüm sesleri durdur
      currentIndex = index; // Şu an oynatılan ses dosyasının index'ini sakla
      await audioPlayer.play(UrlSource(url));
      isPlayingMap[index] = true; // Bu ses dosyasının oynatıldığını belirle
      setState(() {});
    } catch (e) {
      print('Ses dosyası çalınırken bir hata oluştu: $e');
    }
  }

  Future<void> pauseAudio(int index) async {
    try {
      await audioPlayer.pause();
      isPlayingMap[index] = false;
      setState(() {});
    } catch (e) {
      print('Ses dosyası durdurulurken bir hata oluştu: $e');
    }
  }

// Ses dosyasını başa alan fonksiyon
  Future<void> stopAndResetAudio() async {
    try {
      await audioPlayer.stop();
      await audioPlayer.seek(Duration.zero);
    } catch (e) {
      print('Ses dosyası başa alınırken bir hata oluştu: $e');
    }
  }

  Future<void> imageCatch(ImageSource source) async {
    XFile? pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      File newImage = File(pickedImage.path);
      imageList.add(newImage); // Yeni resmi liste ekleyin

      // Firestore'a kaydetme işlemi ve URL alınması
      var url = await context.Task_Provicer.save_image_or_Sound_From_FireStore(newImage, "TaskIamge");
      imageUrl?.add(url!); // URL'yi listeye ekleyin

      // UI güncellemesi için setState çağrısı
      setState(() {});
    }
  }

  Future<dynamic>? customBottomSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Arka planı tamamen şeffaf yapar
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white, // İçerik için arka plan rengi
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 2,
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.blue),
                title: Text(
                  LocaleKeys.general_dialog_image_catch_Camera.tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  imageCatch(ImageSource.camera); // Sadece File içine kaydet
                  Navigator.pop(context);
                },
              ),
              Divider(), // İki seçenek arasına ayırıcı ekler
              ListTile(
                leading: Icon(Icons.photo_album, color: Colors.green),
                title: Text(
                  LocaleKeys.general_dialog_image_catch_Gallery.tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  imageCatch(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
