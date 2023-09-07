import 'package:flutter/material.dart';
import 'package:island_app/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel _userModel = UserModel(
    token: '',
    user: User(
      id: 1,
      firstName: '',
      lastName: '',
      email: '',
      phone: '',
      password: '',
      confirmPassword: '',
      date: '',
      service: '',
      emailVerifiedAt: '',
      providerId: '',
      avatar: '',
      role: null,
      status: null,
      createdAt: '',
      updatedAt: '',
      deletedAt: '',
    ),
  );

  UserModel get userModel => _userModel;

  void setUser(String userModel) {
    _userModel = UserModel.fromJson(userModel);
    notifyListeners();
  }

  void setUserFromModel(UserModel userModel) {
    _userModel = userModel;
    notifyListeners();
  }
}
