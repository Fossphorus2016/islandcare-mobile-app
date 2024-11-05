import 'dart:convert';

import 'package:island_app/models/service_model.dart';

JobApplicantDetailModel jobApplicantDetailModelFromJson(String str) => JobApplicantDetailModel.fromJson(json.decode(str));

String jobApplicantDetailModelToJson(JobApplicantDetailModel data) => json.encode(data.toJson());

class JobApplicantDetailModel {
  JobApplicantDetailModel({
    this.data,
  });

  List<Datum>? data;

  factory JobApplicantDetailModel.fromJson(Map<String, dynamic> json) => JobApplicantDetailModel(
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
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
    this.providerverification,
    this.userdetailprovider,
    this.educations,
    this.userdetail,
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
  Providerverification? providerverification;
  Userdetailprovider? userdetailprovider;
  List<Education>? educations;
  Userdetail? userdetail;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
        providerverification: json["providerverification"] == null ? null : Providerverification.fromJson(json["providerverification"]),
        userdetailprovider: json["userdetailprovider"] == null ? null : Userdetailprovider.fromJson(json["userdetailprovider"]),
        educations: json["educations"] == null ? [] : List<Education>.from(json["educations"]!.map((x) => Education.fromJson(x))),
        userdetail: json["userdetail"] == null ? null : Userdetail.fromJson(json["userdetail"]),
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
        "providerverification": providerverification?.toJson(),
        "userdetailprovider": userdetailprovider?.toJson(),
        "educations": educations == null ? [] : List<dynamic>.from(educations!.map((x) => x.toJson())),
        "userdetail": userdetail?.toJson(),
      };
}

class Education {
  Education({
    this.id,
    this.name,
    this.userId,
    this.major,
    this.to,
    this.from,
    this.current,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  int? userId;
  String? major;
  String? to;
  String? from;
  int? current;
  String? createdAt;
  String? updatedAt;

  factory Education.fromJson(Map<String, dynamic> json) => Education(
        id: json["id"],
        name: json["name"],
        userId: json["user_id"],
        major: json["major"],
        to: json["to"],
        from: json["from"],
        current: json["current"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "user_id": userId,
        "major": major,
        "to": to,
        "from": from,
        "current": current,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class Providerverification {
  Providerverification({
    this.id,
    this.userId,
    this.enhancedCriminal,
    this.enhancedCriminalVerify,
    this.basicCriminal,
    this.basicCriminalVerify,
    this.firstAid,
    this.firstAidVerify,
    this.vehicleRecord,
    this.vehicleRecordVerify,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? userId;
  String? enhancedCriminal;
  int? enhancedCriminalVerify;
  dynamic basicCriminal;
  int? basicCriminalVerify;
  dynamic firstAid;
  int? firstAidVerify;
  dynamic vehicleRecord;
  int? vehicleRecordVerify;
  String? createdAt;
  String? updatedAt;

  factory Providerverification.fromJson(Map<String, dynamic> json) => Providerverification(
        id: json["id"],
        userId: json["user_id"],
        enhancedCriminal: json["enhanced_criminal"],
        enhancedCriminalVerify: json["enhanced_criminal_verify"],
        basicCriminal: json["basic_criminal"],
        basicCriminalVerify: json["basic_criminal_verify"],
        firstAid: json["first_aid"],
        firstAidVerify: json["first_aid_verify"],
        vehicleRecord: json["vehicle_record"],
        vehicleRecordVerify: json["vehicle_record_verify"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "enhanced_criminal": enhancedCriminal,
        "enhanced_criminal_verify": enhancedCriminalVerify,
        "basic_criminal": basicCriminal,
        "basic_criminal_verify": basicCriminalVerify,
        "first_aid": firstAid,
        "first_aid_verify": firstAidVerify,
        "vehicle_record": vehicleRecord,
        "vehicle_record_verify": vehicleRecordVerify,
        "created_at": createdAt,
        "updated_at": updatedAt,
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
    this.area,
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
  String? area;
  String? userInfo;
  String? createdAt;
  String? updatedAt;
  Service? service;

  factory Userdetail.fromJson(Map<String, dynamic> json) => Userdetail(
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
        "area": area,
        "user_info": userInfo,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "service": service?.toJson(),
      };
}

class Userdetailprovider {
  Userdetailprovider({
    this.id,
    this.userId,
    this.availability,
    this.experience,
    this.educations,
    this.keywords,
    this.badge,
    this.hourlyRate,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? userId;
  String? availability;
  int? experience;
  String? educations;
  String? keywords;
  dynamic badge;
  String? hourlyRate;
  String? createdAt;
  String? updatedAt;

  factory Userdetailprovider.fromJson(Map<String, dynamic> json) => Userdetailprovider(
        id: json["id"],
        userId: json["user_id"],
        availability: json["availability"],
        experience: json["experience"],
        educations: json["educations"],
        keywords: json["keywords"],
        badge: json["badge"],
        hourlyRate: json["hourly_rate"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "availability": availability,
        "experience": experience,
        "educations": educations,
        "keywords": keywords,
        "badge": badge,
        "hourly_rate": hourlyRate,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
