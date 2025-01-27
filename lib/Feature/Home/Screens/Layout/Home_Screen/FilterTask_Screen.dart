import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gorev_yonetim/Feature/Home/Screens/Layout/Connect_Remote_Screen/Widgets/Task_Information.dart';
import 'package:gorev_yonetim/Global/Constant/Custom_Snack_bar.dart';
import 'package:gorev_yonetim/Global/Extensions/Project_Extensions.dart';
import 'package:gorev_yonetim/production/Models/User_Data/Task_Data_Model.dart';
import 'package:gorev_yonetim/production/Provider/Task/Fetch_Remote_Task/Fetch_Remote_Home.dart';
import 'package:gorev_yonetim/production/State/Fetch_Remote_State.dart';
import 'package:gorev_yonetim/production/State/Task_State.dart';
import 'package:gorev_yonetim/production/init/language/locale_keys.g.dart';

class FiltertaskScreen extends StatefulWidget {
  String text;

  final Color apbarColors;
  final Color labelColors;
  final double maximportantLevel;
  final double minimportantLevel;
  Color bookmark;

  FiltertaskScreen(
      {super.key,
      required this.text,
      required this.apbarColors,
      required this.labelColors,
      required this.maximportantLevel,
      required this.minimportantLevel,
      required this.bookmark});

  @override
  State<FiltertaskScreen> createState() => _FiltertaskScreenState();
}

class _FiltertaskScreenState extends State<FiltertaskScreen> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.labelColors,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 65),
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(color: widget.apbarColors, boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 5, spreadRadius: 0, offset: Offset(0, 5)),
            ]),
            alignment: Alignment.center,
            child: BlocBuilder<FetchRemoteHome, FetchRemoteState>(
              builder: (context, state) {
                return AnimationSearchBar(
                  hintText: LocaleKeys.text_field_Search_here.tr(),
                  backIconColor: Colors.black,
                  centerTitle: widget.text,
                  onChanged: (text) {
                    setState(() {});
                    // Arama metnine ve importanceLevel'a göre filtreleme
                    context.FetchTask_Provider.filter_task_with_name(
                      allTask: state.activeTaskData
                          .where((task) =>
                              task.importantLevel != null &&
                              task.importantLevel! <= widget.maximportantLevel &&
                              task.importantLevel! >= widget.minimportantLevel &&
                              (task.title?.toLowerCase().contains(text.toLowerCase()) ??
                                  false || task.taskText!.toLowerCase().contains(text.toLowerCase()) ??
                                  false))
                          .toList(),
                      filter_String: text,
                    );
                  },
                  horizontalPadding: 5,
                  searchTextEditingController: controller,
                );
              },
            ),
          ),
        ),
      ),
      body: BlocSelector<FetchRemoteHome, FetchRemoteState, List<TaskDataModel>>(
        selector: (state) {
          // importantLevel ve filtre aktif kontrolü
          return (state.filter_active ?? state.activeTaskData)
              .where((task) =>
                  task.importantLevel != null &&
                  task.importantLevel! <= widget.maximportantLevel &&
                  task.importantLevel! >= widget.minimportantLevel)
              .toList();
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Yatayda 2 kart olacak
                crossAxisSpacing: 10.0, // Kartlar arasındaki yatay boşluk
                mainAxisSpacing: 10.0, // Kartlar arasındaki dikey boşluk
                childAspectRatio: 4 / 4, // Kartların en/boy oranı
              ),
              itemCount: state.length, // Toplam gösterilecek kart sayısı
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    if (!state[index].date!.isAfter(state[index].deadLine ?? DateTime.now())) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TaskInformation(data: state[index])),
                      );
                      context.FetchTask_Provider.ViewRecently(data: state[index]);
                    } else {
                      ProjectSnackBar.showSnackbar(
                          context, LocaleKeys.general_dialog_snackbar_text_Filtered_tasks_Task_expired.tr(), " ");
                    }
                  },
                  child: Card(
                    color: state[index].date!.isAfter(state[index].deadLine ?? DateTime.now())
                        ? Colors.red
                        : !state[index].isDone
                            ? Colors.green.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0), // Kart köşeleri yuvarlatılmış
                    ),
                    elevation: 5, // Gölgelendirme
                    shadowColor: Colors.grey.withOpacity(0.5), // Gölge rengi
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bookmark,
                            color: widget.bookmark,
                            size: 40.0,
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            state[index].title ?? "",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            state[index].taskText!.length <= 10
                                ? state[index].taskText!
                                : '${state[index].taskText!.substring(0, 10)}...',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
