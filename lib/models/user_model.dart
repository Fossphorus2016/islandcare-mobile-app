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
  // Userdetail? userdetail;
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
    // required this.userdetail,
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
      // 'userdetail': userdetail?.toMap(),
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
      // userdetail: map['userdetail'] != null ? Userdetail.fromMap(map['user'] as Map<String, dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);
}

// class Userdetail {
//   String? id;
//   String? userId;
//   dynamic gender;
//   String? dob;
//   String? servicesRequired;
//   dynamic zip;
//   dynamic address;
//   dynamic area;
//   dynamic userInfo;
//   String? createdAt;
//   String? updatedAt;
//   Userdetail({
//     required this.id,
//     required this.userId,
//     required this.gender,
//     required this.dob,
//     required this.servicesRequired,
//     required this.zip,
//     required this.address,
//     required this.area,
//     required this.userInfo,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'id': id,
//       'user_id': userId,
//       'gender': gender,
//       'dob': dob,
//       'services_required': servicesRequired,
//       'zip': zip,
//       'address': address,
//       'area': area,
//       'user_info': userInfo,
//       'created_at': createdAt,
//       'updated_at': updatedAt,
//     };
//   }

//   factory Userdetail.fromMap(Map<String, dynamic> map) {
//     return Userdetail(
//       id: map['id'] != null ? map['id'] as String : null,
//       userId: map['user_id'] != null ? map['user_id'] as String : null,
//       gender: map['gender'] as dynamic,
//       dob: map['dob'] != null ? map['dob'] as String : null,
//       servicesRequired: map['services_required'] != null ? map['services_required'] as String : null,
//       zip: map['zip'] as dynamic,
//       address: map['address'] as dynamic,
//       area: map['area'] as dynamic,
//       userInfo: map['user_info'] as dynamic,
//       createdAt: map['created_at'] != null ? map['created_at'] as String : null,
//       updatedAt: map['updated_at'] != null ? map['updated_at'] as String : null,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory Userdetail.fromJson(String source) => Userdetail.fromMap(json.decode(source) as Map<String, dynamic>);
// }
