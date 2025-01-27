part of '../Home.dart';

class Home_AppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // Bu satır otomatik geri okunu kaldırır
      backgroundColor: Colors.transparent,
      centerTitle: true,
      iconTheme: const IconThemeData.fallback().copyWith(
        color: Colors.black,
      ),
      title: Text(LocaleKeys.home_page1_title,
          style: context.themeOf.textTheme.titleLarge?.copyWith(
            fontFamily: TextStylee.fontFamilypacifico,
          )).tr(),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
