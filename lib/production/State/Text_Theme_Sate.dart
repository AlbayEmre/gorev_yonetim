// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class TextThemeSate extends Equatable {
  bool isDark;
  double ktextSize;
  TextThemeSate({
    required this.isDark,
    required this.ktextSize,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [isDark, ktextSize];

  TextThemeSate copyWith({double? ktextSize, bool? isDark}) {
    return TextThemeSate(
      isDark: isDark ?? this.isDark,
      ktextSize: ktextSize ?? this.ktextSize,
    );
  }
}
