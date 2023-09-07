// To parse this JSON data, do
//
//     final changePasswordModel = changePasswordModelFromJson(jsonString);

import 'dart:convert';

ChangePasswordModel changePasswordModelFromJson(String str) => ChangePasswordModel.fromJson(json.decode(str));

String changePasswordModelToJson(ChangePasswordModel data) => json.encode(data.toJson());

class ChangePasswordModel {
    ChangePasswordModel({
        this.method,
        this.oldPassword,
        this.password,
        this.passwordConfirmation,
    });

    String? method;
    String? oldPassword;
    String? password;
    String? passwordConfirmation;

    factory ChangePasswordModel.fromJson(Map<String, dynamic> json) => ChangePasswordModel(
        method: json["_method"],
        oldPassword: json["old_password"],
        password: json["password"],
        passwordConfirmation: json["password_confirmation"],
    );

    Map<String, dynamic> toJson() => {
        "_method": method,
        "old_password": oldPassword,
        "password": password,
        "password_confirmation": passwordConfirmation,
    };
}
