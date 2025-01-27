part of '../Add_Task.dart';

class Description_TextFiled extends StatelessWidget {
  const Description_TextFiled({
    super.key,
    required this.taskTextConteoller,
  });

  final TextEditingController taskTextConteoller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.padding.onlyTopMedium,
      child: TextFormField(
        minLines: 1,
        maxLines: 5,
        textAlign: TextAlign.left,
        autofocus: false,

        controller: taskTextConteoller,
        validator: (value) {},

        decoration: InputDecoration(
          label: Text(
            LocaleKeys.text_field_Task_description.tr(),
            style: TextStyle(color: Colors.blueGrey[800]),
          ),
          // labelText: labelText,
          labelStyle: TextStyle(fontWeight: FontWeight.w400),

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
        ),
        obscureText: false,

        keyboardType: TextInputType.text, //!
        textInputAction: TextInputAction.next,
      ),
    );
  }
}
