// ignore_for_file: use_build_context_synchronously, unused_local_variable, avoid_print

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:island_app/constants/error_handling.dart';
import 'package:island_app/models/user_model.dart';
import 'package:island_app/providers/user_provider.dart';
import 'package:island_app/res/app_url.dart';
import 'package:island_app/screens/verify_email.dart';
import 'package:island_app/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // sign up user
  void signUpUser({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String date,
    required int role,
    required String service,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      UserModel userModel = UserModel(
          token: '',
          user: User(
            id: 1,
            firstName: firstName,
            lastName: lastName,
            email: email,
            phone: phone,
            password: '',
            confirmPassword: '',
            date: '',
            service: '',
            emailVerifiedAt: '',
            providerId: '',
            avatar: '',
            role: role,
            status: null,
            createdAt: '',
            updatedAt: '',
            deletedAt: '',
          ));

      Response res = await Dio().post(
        SessionUrl.signup,
        data: userModel.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          customSuccesSnackBar(
            context,
            'Account created successfully!',
          );
        },
      );
    } catch (e) {
      customErrorSnackBar(
        context,
        e.toString(),
      );
    }
  }

  // sign in user
  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      UserModel userModel = UserModel(
          token: '',
          user: User(
            id: 1,
            firstName: '',
            lastName: '',
            email: email,
            phone: '',
            password: password,
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
          ));
      Response res = await Dio().post(
        SessionUrl.login,
        data: jsonEncode({
          'email': email,
          'password': password,
        }),
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          if (res.statusCode == 200) {
            var data = res.data;
            var role = data["user"]["role"];
            var status = data["user"]["status"];
            var token = data["token"];
            var userId = data["user"]['id'];
            var avatar = data["user"]['avatar'];
            SharedPreferences prefs = await SharedPreferences.getInstance();
            Provider.of<UserProvider>(context, listen: false).fetchProfileReceiverModel();
            await prefs.setString('x-auth-token', token);
            // print("UserData = $data");
            if (status == 3) {
              customErrorSnackBar(
                context,
                "User Blocked",
              );
            } else {
              if (data["user"]["email_verified_at"] == null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VerifyEmail(token: data["token"]),
                  ),
                );
              } else if (data["user"]["role"] == 3) {
                if (data["user"]["status"] == 0) {
                  SharedPreferences pref = await SharedPreferences.getInstance();
                  await pref.setString('userStatus', status.toString());
                  await pref.setString('userTokenProfile', data["token"].toString());
                  await pref.setString('userAvatar', avatar.toString());
                  await pref.setString('userId', userId.toString());

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    'bottom-bar-giver-2',
                    (route) => false,
                  );
                } else {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    'bottom-bar-giver',
                    (route) => false,
                  );

                  SharedPreferences pref = await SharedPreferences.getInstance();
                  await pref.setString('userRole', data["user"]["role"].toString());
                  await pref.setString('userToken', data["token"].toString());
                  await pref.setString('userStatus', status.toString());
                  await pref.setString('userId', userId.toString());
                  await pref.setString('userAvatar', avatar.toString());
                }
              } else if (data["user"]["role"] == 4) {
                if (data["user"]["status"] == 0) {
                  SharedPreferences pref = await SharedPreferences.getInstance();
                  await pref.setString('userStatus', status.toString());
                  await pref.setString('userTokenProfile', data["token"].toString());
                  await pref.setString('userAvatar', avatar.toString());
                  await pref.setString('userId', userId.toString());
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    'bottom-bar-2',
                    (route) => false,
                  );
                } else {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    'bottom-bar',
                    (route) => false,
                  );

                  SharedPreferences pref = await SharedPreferences.getInstance();
                  await pref.setString('userRole', data["user"]["role"].toString());
                  await pref.setString('userToken', data["token"].toString());
                  await pref.setString('userStatus', status.toString());
                  await pref.setString('userId', userId.toString());
                  await pref.setString('userAvatar', avatar.toString());
                }
              }
            }
          } else {
            customErrorSnackBar(
              context,
              "Bad Credentials",
            );
          }
        },
      );
    } catch (e) {
      customErrorSnackBar(
        context,
        e.toString(),
      );
    }
  }

  // get user data
  void getUserData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      var userProvider = Provider.of<UserProvider>(context, listen: false);
    } catch (e) {
      customErrorSnackBar(
        context,
        e.toString(),
      );
    }
  }
}
