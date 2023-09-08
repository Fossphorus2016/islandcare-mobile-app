import 'dart:convert';

RegisterModel? registerModelFromJson(String str) => RegisterModel.fromJson(json.decode(str));

String registerModelToJson(RegisterModel? data) => json.encode(data!.toJson());

class RegisterModel {
  RegisterModel({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.date,
    this.role,
    this.service,
    this.password,
    this.passwordConfirmation,
  });

  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? date;
  String? role;
  String? service;
  String? password;
  String? passwordConfirmation;

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        phone: json["phone"],
        date: json["date"],
        role: json["role"],
        service: json["service"],
        password: json["password"],
        passwordConfirmation: json["password_confirmation"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "date": date,
        "role": role,
        "service": service,
        "password": password,
        "password_confirmation": passwordConfirmation,
      };
}
