import 'dart:convert';

HiredCandidateModel hiredCandidateModelFromJson(String str) => HiredCandidateModel.fromJson(json.decode(str));

String hiredCandidateModelToJson(HiredCandidateModel data) => json.encode(data.toJson());

class HiredCandidateModel {
  HiredCandidateModel({
    this.data,
  });

  List<HiredCandidateData>? data;

  factory HiredCandidateModel.fromJson(Map<String, dynamic> json) => HiredCandidateModel(
        data: json["data"] == null ? [] : List<HiredCandidateData>.from(json["data"]!.map((x) => HiredCandidateData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class HiredCandidateData {
  HiredCandidateData({
    this.id,
    this.providerId,
    this.jobId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.users,
    this.jobs,
    this.userDetail,
  });

  int? id;
  int? providerId;
  int? jobId;
  int? status;
  String? createdAt;
  String? updatedAt;
  Users? users;
  Jobs? jobs;
  UserDetail? userDetail;

  factory HiredCandidateData.fromJson(Map<String, dynamic> json) => HiredCandidateData(
        id: json["id"],
        providerId: json["provider_id"],
        jobId: json["job_id"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        users: json["users"] == null ? null : Users.fromJson(json["users"]),
        jobs: json["jobs"] == null ? null : Jobs.fromJson(json["jobs"]),
        userDetail: json["user_detail"] == null ? null : UserDetail.fromJson(json["user_detail"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "provider_id": providerId,
        "job_id": jobId,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "users": users?.toJson(),
        "jobs": jobs?.toJson(),
        "user_detail": userDetail?.toJson(),
      };
}

class Jobs {
  Jobs({
    this.id,
    this.jobTitle,
    this.serviceId,
    this.hourlyRate,
    this.address,
    this.location,
    this.userId,
    this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.totalAmount,
    this.adminCommission,
    this.providerPayout,
    this.isFunded,
    this.providerId,
    this.fundsTransferedToProvider,
    this.totalDuration,
  });

  int? id;
  String? jobTitle;
  int? serviceId;
  int? hourlyRate;
  String? address;
  String? location;
  int? userId;
  int? status;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  String? totalAmount;
  String? adminCommission;
  String? providerPayout;
  int? isFunded;
  int? providerId;
  int? fundsTransferedToProvider;
  String? totalDuration;

  factory Jobs.fromJson(Map<String, dynamic> json) => Jobs(
        id: json["id"],
        jobTitle: json["job_title"],
        serviceId: json["service_id"],
        hourlyRate: json["hourly_rate"],
        address: json["address"],
        location: json["location"],
        userId: json["user_id"],
        status: json["status"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        totalAmount: json["total_amount"],
        adminCommission: json["admin_commission"],
        providerPayout: json["provider_payout"],
        isFunded: json["is_funded"],
        providerId: json["provider_id"],
        fundsTransferedToProvider: json["funds_transfered_to_provider"],
        totalDuration: json["total_duration"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "job_title": jobTitle,
        "service_id": serviceId,
        "hourly_rate": hourlyRate,
        "address": address,
        "location": location,
        "user_id": userId,
        "status": status,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "total_amount": totalAmount,
        "admin_commission": adminCommission,
        "provider_payout": providerPayout,
        "is_funded": isFunded,
        "provider_id": providerId,
        "funds_transfered_to_provider": fundsTransferedToProvider,
        "total_duration": totalDuration,
      };
}

class UserDetail {
  UserDetail({
    this.id,
    this.userId,
    this.gender,
    this.dob,
    this.servicesRequired,
    this.zip,
    this.address,
    this.area,
    this.userInfo,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? userId;
  int? gender;
  String? dob;
  String? servicesRequired;
  String? zip;
  String? address;
  String? area;
  String? userInfo;
  String? createdAt;
  String? updatedAt;

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        id: json["id"],
        userId: json["user_id"],
        gender: json["gender"],
        dob: json["dob"],
        servicesRequired: json["services_required"],
        zip: json["zip"],
        address: json["address"],
        area: json["area"],
        userInfo: json["user_info"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "gender": gender,
        "dob": dob,
        "services_required": servicesRequired,
        "zip": zip,
        "address": address,
        "area": area,
        "user_info": userInfo,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class Users {
  Users({
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
  });

  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? emailVerifiedAt;
  dynamic providerId;
  String? avatar;
  int? role;
  int? status;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        phone: json["phone"],
        emailVerifiedAt: json["email_verified_at"],
        providerId: json["provider_id"],
        avatar: json["avatar"],
        role: json["role"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "email_verified_at": emailVerifiedAt,
        "provider_id": providerId,
        "avatar": avatar,
        "role": role,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
      };
}
