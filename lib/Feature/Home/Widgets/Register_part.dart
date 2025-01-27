part of '../Screens/Register_Screen.dart';

class ProjectAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      iconTheme: const IconThemeData.fallback().copyWith(
        color: Colors.black,
      ),
      title: Text(
        LocaleKeys.general_button_save.tr(),
        style: context.themeOf.textTheme.titleLarge?.copyWith(
          fontFamily: TextStylee.fontFamilypacifico,
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kTextTabBarHeight);
}

class _CustomTextFormField extends StatelessWidget {
  _CustomTextFormField({
    super.key,
    this.labelText,
    this.hintText,
    this.suffixIchon,
    required this.obscureText,
    required this.obscureChar,
    this.validator,
    this.keyboardType,
    required this.controller,
    required this.maxlengt,
    required this.autofocus,
    this.buildCounter,
  });

  String? labelText;
  String? hintText;
  IconData? suffixIchon;
  bool obscureText;
  String obscureChar;
  int? maxlengt;
  bool autofocus;

  String? Function(String?)? validator;
  Widget? Function(BuildContext, {required int currentLength, required bool isFocused, required int? maxLength})?
      buildCounter;
  TextInputType? keyboardType;
  TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      buildCounter: buildCounter,

      maxLength: maxlengt,

      autofocus: autofocus,

      controller: controller,
      validator: validator,

      decoration: InputDecoration(
        label: Text(
          labelText ?? "",
          style: TextStyle(color: Colors.blueGrey[800]),
        ),
        // labelText: labelText,
        labelStyle: TextStyle(fontWeight: FontWeight.w400),
        hintText: hintText,
        hintStyle: TextStyle(fontWeight: FontWeight.w100),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.values[0])),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 3, style: BorderStyle.values[1]),
          borderRadius: BorderRadius.circular(10),
          gapPadding: 20,
        ),
        iconColor: Colors.blue,
        filled: true,
        fillColor: Colors.blueGrey.shade300.withOpacity(0.25),
        border: OutlineInputBorder(),
        suffix: Icon(
          suffixIchon,
          color: Colors.grey.shade600,
        ),
      ),
      obscureText: obscureText,
      obscuringCharacter: obscureChar,
      keyboardType: keyboardType, //!
      textInputAction: TextInputAction.next,
    );
  }
}

class _RegisterButton extends StatefulWidget {
  GlobalKey<FormState> globalKeybutton = GlobalKey<FormState>();
  bool isphone;
  TextEditingController phone;
  TextEditingController name;
  TextEditingController email;
  TextEditingController password;
  File? UserImageFile;

  _RegisterButton({
    super.key,
    required this.globalKeybutton,
    required this.isphone,
    required this.email,
    required this.name,
    required this.password,
    required this.phone,
    this.UserImageFile,
  });

  @override
  State<_RegisterButton> createState() => _RegisterButtonState();
}

class _RegisterButtonState extends State<_RegisterButton> {
  String? imageUrl = null;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.resolveWith(
            (value) {
              return RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));
            },
          ),
          backgroundColor: WidgetStateProperty.resolveWith(
            (state) {
              if (state.contains(WidgetState.pressed)) {
                return Colors.blue;
              }
              return Colors.blueGrey[100];
            },
          ),
        ),
        onPressed: () async {
          if (widget.globalKeybutton.currentState!.validate()) {
            dynamic result;
            if (widget.isphone) {
              context.FireLoading_Provider.FireChange_IsLoading();
              await context.auth_Provider.register_with_phone(widget.phone.text, widget.name.text);

              context.FireLoading_Provider.FireChange_IsLoading();
            } else {
              context.FireLoading_Provider.FireChange_IsLoading(); //Wait

              imageUrl = await context.auth_Provider.file_to_Url(widget.UserImageFile);

              result = await context.auth_Provider
                  .Register_with_Email(widget.email.text, widget.password.text, widget.name.text, imageUrl);

              context.FireLoading_Provider.FireChange_IsLoading(); // continue

              print(context.FireLoading_Provider.state.Fire_isLoading);
            }

            if (result != null) {
              ProjectSnackBar.showSnackbar(context, LocaleKeys.general_dialog_snackbar_text_register_successful.tr(),
                  LocaleKeys.general_dialog_snackbar_text_register_You_have_been_successfully_registered.tr());

              // Wait for the snackbar to show and then navigate
              await Future.delayed(Duration(seconds: 2));

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            } else {
              ProjectSnackBar.showSnackbar(
                  context,
                  LocaleKeys.general_dialog_snackbar_text_register_Registe_falied.tr(),
                  LocaleKeys.general_dialog_snackbar_text_register_Please_try_again_later.tr());
            }
          }
        },
        child: Text(
          LocaleKeys.general_button_register.tr(),
          style: context.themeOf.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
