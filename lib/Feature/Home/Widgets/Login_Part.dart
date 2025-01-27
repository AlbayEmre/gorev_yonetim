part of '../Screens/Login_Screen.dart';

class _LoginAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      iconTheme: const IconThemeData.fallback().copyWith(
        color: Colors.black,
      ),
      title: Text(
        LocaleKeys.home_login_title.tr(),
        style: context.themeOf.textTheme.titleLarge?.copyWith(
          fontFamily: TextStylee.fontFamilypacifico,
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

///
///
///
///
///TODO: Google button
///
///
///
class Sing_In_With_Google extends StatelessWidget {
  const Sing_In_With_Google({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.auth_Provider.Register_With_Google().then(
          (value) {
            ProjectSnackBar.showSnackbar(context, LocaleKeys.general_dialog_snackbar_text_register_successful.tr(),
                LocaleKeys.general_dialog_snackbar_text_register_Login_successful.tr());
            if (value != null) {
              SaveUser().updateUserModel(value);
              context.Connectivity_Provider.addNewActiveUser(SaveUser().userModel!);
              navigatorKey.currentState?.pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LandingScreen()),
                (Route<dynamic> route) => false,
              );
            }
          },
        );
      },
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: context.padding.onlyRightNormal,
              child: Image.asset(
                "assets/google.png",
                width: context.sizeOf.width * 0.09,
              ),
            ),
            Text(
              LocaleKeys.general_button_Login_with_google.tr(),
              style: context.themeOf.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            )
          ],
        ),
      ),
    );
  }
}
