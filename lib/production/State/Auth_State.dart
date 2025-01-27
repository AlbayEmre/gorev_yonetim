// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:gorev_yonetim/production/Models/User/User_Model.dart';

class AuthState extends Equatable {
  UserModel userModel;

  List<UserModel> friends;

  AuthState({required this.userModel, required this.friends});

  @override
  // TODO: implement props
  List<Object?> get props => [userModel, friends];

  AuthState copyWith({UserModel? user, List<UserModel>? allUser, List<UserModel>? friends}) {
    return AuthState(
      userModel: user ?? this.userModel,
      friends: friends ?? this.friends,
    );
  }

  UserModel returnUser() {
    return this.userModel;
  }
}
