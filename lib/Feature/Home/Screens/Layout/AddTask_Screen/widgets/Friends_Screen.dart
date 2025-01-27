import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gorev_yonetim/Global/Constant/Project_Images.dart';
import 'package:gorev_yonetim/Global/Constant/SaveUser.dart';
import 'package:gorev_yonetim/Global/Constant/Text_Style.dart';
import 'package:gorev_yonetim/Global/Extensions/Project_Extensions.dart';
import 'package:gorev_yonetim/production/Models/User/User_Model.dart';
import 'package:gorev_yonetim/production/Provider/Connectivity/Connectivity_State_home.dart';
import 'package:gorev_yonetim/production/State/Connectivity_State.dart';
import 'package:gorev_yonetim/production/init/language/locale_keys.g.dart';
import 'package:gorev_yonetim/root.dart';

class FriendsScreen extends StatefulWidget {
  FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _ActiveUserState();
}

class _ActiveUserState extends State<FriendsScreen> {
  late TextEditingController emailController;
  late List<UserModel>? friends;

  @override
  void initState() {
    super.initState();
    friends = context.auth_Provider.state.friends;
    print("init update");
    print(friends?.length);
    setState(() {});
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<String?> showEmailInputDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LocaleKeys.alert_dialog_add_friends).tr(),
          content: TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: LocaleKeys.text_field_email_address_label_text.tr(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialogu kapatır ve null döner
              },
              child: Text(LocaleKeys.general_button_cancel.tr()),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(emailController.text); // Dialogu kapatır ve email'i döner
                emailController.text = "";
              },
              child: Text(LocaleKeys.general_button_okay.tr()),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Root(
                          page: 1,
                        )),
              );
            },
            icon: Icon(Icons.arrow_back)),
        actions: [
          IconButton(
              onPressed: () async {
                String? email = await showEmailInputDialog(context);

                if (email != null && email.isNotEmpty) {
                  // E-mail null değil ve boş değilse addFriends fonksiyonunu çağırıyoruz
                  await context.auth_Provider.addFriends(userUid: SaveUser().userModel?.id ?? "", e_mail: email);
                  setState(() {});
                  // En güncel state'i kullanarak sayfaya yönlendirme yapıyoruz
                }
              },
              icon: Icon(Icons.person_add))
        ],
        centerTitle: true,
        title: Text(
          LocaleKeys.home_friends_screen_title.tr(),
          style: context.themeOf.textTheme.titleLarge?.copyWith(
            fontFamily: TextStylee.fontFamilypacifico,
          ),
        ),
      ),
      body: Column(
        children: [
          BlocBuilder<ConnectivityStateHome, ConnectivityState>(
            builder: (context, state) {
              return Expanded(
                child: ListView.builder(
                  itemCount: friends?.length ?? 0,
                  itemBuilder: (context, index) {
                    final user = friends?[index];

                    // Eğer state.activeUsers'daki ID ile bu kullanıcının ID'si eşleşiyorsa kenarlık yeşil olsun
                    bool isActive = state.activeUsers.any((activeUser) => activeUser.id == user?.id);

                    return Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: isActive ? Colors.green : Colors.red, // Kenarlık rengi
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        title: Text(user?.Username ?? ""), // Kullanıcının adını yazdır
                        leading: user?.ProfilePhoto == null
                            ? Image.asset(
                                ProjectImages.defaultUser,
                                scale: 18,
                              )
                            : Image.network(user?.ProfilePhoto ?? ""),
                        trailing: IconButton(
                          onPressed: () async {
                            await context.auth_Provider.deleteFriends(index: index);
                            friends = context.auth_Provider.state.friends;
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.person_off,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
