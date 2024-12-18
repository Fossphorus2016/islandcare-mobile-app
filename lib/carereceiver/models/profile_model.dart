import 'dart:convert';

import 'package:island_app/models/service_model.dart';

ProfileReceiverModel profileReceiverModelFromJson(String str) => ProfileReceiverModel.fromJson(json.decode(str));

String profileReceiverModelToJson(ProfileReceiverModel data) => json.encode(data.toJson());

class ProfileReceiverModel {
  ProfileReceiverModel({
    this.folderPath,
    this.data,
  });

  String? folderPath;
  Datum? data;

  factory ProfileReceiverModel.fromJson(Map<String, dynamic> json) => ProfileReceiverModel(
        folderPath: json["folder_path"],
        data: Datum.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "folder_path": folderPath,
        "data": data ?? {},
      };
}

class Datum {
  Datum({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.emailVerifiedAt,
    this.providerId,
    this.avatar,
    this.role,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.userdetailprovider,
    this.userdetail,
    this.userSubscriptionDetail,
  });

  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  DateTime? emailVerifiedAt;
  dynamic providerId;
  String? avatar;
  int? role;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  dynamic userdetailprovider;
  Userdetail? userdetail;
  UserSubscriptionDetail? userSubscriptionDetail;
  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["user"]["id"],
        firstName: json["user"]["first_name"],
        lastName: json["user"]["last_name"],
        email: json["user"]["email"],
        phone: json["user"]["phone"],
        emailVerifiedAt:
            json["user"]["email_verified_at"] == null ? null : DateTime.parse(json["user"]["email_verified_at"]),
        providerId: json["user"]["provider_id"],
        avatar: json["user"]["avatar"],
        role: json["user"]["role"],
        status: json["user"]["status"],
        createdAt: json["user"]["created_at"] == null ? null : DateTime.parse(json["user"]["created_at"]),
        updatedAt: json["user"]["updated_at"] == null ? null : DateTime.parse(json["user"]["updated_at"]),
        deletedAt: json["user"]["deleted_at"],
        userdetailprovider: json["user"]["userdetailprovider"],
        userdetail: json["user"]["userdetail"] == null ? null : Userdetail.fromJson(json['user']["userdetail"]),
        userSubscriptionDetail:
            json['subscription'] == null ? null : UserSubscriptionDetail.fromJson(json['subscription']),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "email_verified_at": emailVerifiedAt?.toIso8601String(),
        "provider_id": providerId,
        "avatar": avatar,
        "role": role,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "userdetailprovider": userdetailprovider,
        "userdetail": userdetail?.toJson(),
        "userSubscriptionDetail": userSubscriptionDetail?.toJson(),
      };
}

class Userdetail {
  Userdetail({
    this.id,
    this.userId,
    this.gender,
    this.dob,
    this.servicesRequired,
    this.zip,
    this.address,
    this.userInfo,
    this.createdAt,
    this.updatedAt,
    this.service,
  });

  int? id;
  int? userId;
  int? gender;
  String? dob;
  String? servicesRequired;
  String? zip;
  String? address;
  String? userInfo;
  DateTime? createdAt;
  DateTime? updatedAt;
  Service? service;

  // List<Service>? service;

  factory Userdetail.fromJson(Map<String, dynamic> json) => Userdetail(
        id: json["id"],
        userId: json["user_id"],
        gender: json["gender"],
        dob: json["dob"],
        servicesRequired: json["services_required"],
        zip: json["zip"],
        address: json["address"],
        userInfo: json["user_info"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        service: json["service"] == null ? null : Service.fromJson(json["service"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "gender": gender,
        "dob": dob,
        "services_required": servicesRequired,
        "zip": zip,
        "address": address,
        "user_info": userInfo,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        // "service": service?.toJson(),
      };
}

class UserSubscriptionDetail {
  UserSubscriptionDetail({
    required this.id,
    required this.userId,
    required this.subscriptionId,
    required this.subscriptionName,
    required this.periodType,
    required this.price,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final int userId;
  final int subscriptionId;
  final String subscriptionName;
  final String periodType;
  final String price;
  final int isActive;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory UserSubscriptionDetail.fromJson(Map<String, dynamic> json) => UserSubscriptionDetail(
        id: json["id"],
        userId: json["user_id"],
        subscriptionId: json["subscription_id"],
        subscriptionName: json["subscription_name"],
        periodType: json["period_type"],
        price: json["price"],
        isActive: json["is_active"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "subscription_id": subscriptionId,
        "subscription_name": subscriptionName,
        "period_type": periodType,
        "price": price,
        "is_active": isActive,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
