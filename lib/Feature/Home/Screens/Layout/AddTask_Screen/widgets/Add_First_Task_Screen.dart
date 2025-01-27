// import 'package:flutter/material.dart';

// import 'package:gorev_yonetim/Feature/Home/Screens/Layout/AddTask_Screen/Add_Task.dart';
// import '../../../../../../../Global/Extensions/Project_Extensions.dart';

// import 'package:kartal/kartal.dart';

// class AddFirstTaskScreen extends StatefulWidget {
//   AddFirstTaskScreen({super.key});

//   @override
//   State<AddFirstTaskScreen> createState() => _AddFirstTaskScreenState();
// }

// class _AddFirstTaskScreenState extends State<AddFirstTaskScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("Tasks added by you and owned by you appear here."),
//             Padding(
//               padding: context.padding.low,
//               child: Text(
//                 "Add a task here",
//                 style: context.themeOf.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
//               ),
//             ),
//             Padding(
//               padding: context.padding.onlyTopMedium,
//               child: InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => AddTask()),
//                   );
//                 },
//                 child: Image.asset(
//                   "assets/TaskImages/add.png",
//                   scale: 6,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
