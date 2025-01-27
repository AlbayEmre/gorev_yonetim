// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class FirelodingState extends Equatable {
  bool Fire_isLoading = false;
  bool fire_issave = false;
  FirelodingState({
    required this.Fire_isLoading,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [Fire_isLoading];

  FirelodingState copyWith({bool? isLaoding}) {
    return FirelodingState(Fire_isLoading: isLaoding ?? this.Fire_isLoading);
  }
}
