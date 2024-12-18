import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  User? user;
  String? token;
  UserModel({
    this.user,
    this.token,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user?.toMap(),
      'token': token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      user: map['user'] != null ? User.fromMap(map['user'] as Map<String, dynamic>) : null,
      token: map['token'] != null ? map['token'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? emailVerifiedAt;
  String? password;
  String? confirmPassword;
  dynamic providerId;
  String? avatar;
  int? role;
  String? date;
  String? service;
  int? status;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.emailVerifiedAt,
    required this.password,
    required this.confirmPassword,
    required this.providerId,
    required this.avatar,
    required this.role,
    required this.date,
    required this.service,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'email_verified_at': emailVerifiedAt,
      'password': password,
      'password_confirmation': confirmPassword,
      'provider_id': providerId,
      'avatar': avatar,
      'role': role,
      'date': date,
      'service': service,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      emailVerifiedAt: map['email_verified_at'] ?? '',
      password: map['password'] ?? '',
      confirmPassword: map['password_confirmation'] ?? '',
      providerId: map['provider_id'] as dynamic ?? '',
      avatar: map['avatar'] ?? '',
      role: map['role'] ?? '',
      date: map['date'] ?? '',
      service: map['service'] ?? '',
      status: map['status'] ?? '',
      createdAt: map['createdAt'] ?? '',
      updatedAt: map['updatedAt'] ?? '',
      deletedAt: map['deletedAt'] as dynamic ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);
}
