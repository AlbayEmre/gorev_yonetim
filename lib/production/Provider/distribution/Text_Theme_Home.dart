import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gorev_yonetim/production/State/Text_Theme_Sate.dart';

class TextThemeHome extends Cubit<TextThemeSate> {
  TextThemeHome() : super(TextThemeSate(isDark: false, ktextSize: 1)); //text size kat

  void changeTheme() {
    emit(state.copyWith(isDark: !state.isDark));
  }

  void changedTextSize({required double ktextSize}) {
    if (ktextSize > 0) {
      emit(state.copyWith(ktextSize: ktextSize));
    }
  }
}
