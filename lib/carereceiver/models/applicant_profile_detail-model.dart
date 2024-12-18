// ignore_for_file: file_names, prefer_null_aware_operators

import 'dart:convert';
import 'package:island_app/models/service_model.dart';

ApplicantDetailProfileModel applicantDetailProfileModelFromJson(String str) => ApplicantDetailProfileModel.fromJson(json.decode(str));

String applicantDetailProfileModelToJson(ApplicantDetailProfileModel data) => json.encode(data.toJson());

class ApplicantDetailProfileModel {
  int? isHired;
  Datum? data;
  int? percentage;
  bool? isVerified;
  String? jobTitle;

  ApplicantDetailProfileModel({
    this.isHired,
    this.data,
    this.jobTitle,
    this.isVerified,
    this.percentage,
  });

  factory ApplicantDetailProfileModel.fromJson(Map<String, dynamic> json) => ApplicantDetailProfileModel(
        isHired: json["application_status"],
        data: json["data"] == null ? null : Datum.fromJson(json["data"]),
        jobTitle: json["job_title"],
        percentage: json["percentage"],
        isVerified: json['isVerified'] == 1,
      );

  Map<String, dynamic> toJson() => {
        "application_status": isHired,
        "data": data == null ? null : Datum().toJson(),
        "job_title": jobTitle,
        "percentage": percentage,
        "isVerified": isVerified,
      };
}

class Datum {
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
  List<Rating>? ratings;
  Providerverification? providerverification;
  Userdetailprovider? userdetailprovider;
  List<Education>? educations;
  Userdetail? userdetail;
  Map? avgRating;

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
    this.ratings,
    this.providerverification,
    this.userdetailprovider,
    this.educations,
    this.userdetail,
    this.avgRating,
  });

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
        ratings: json["ratings"] == null ? [] : List<Rating>.from(json["ratings"]!.map((x) => Rating.fromJson(x))),
        providerverification: json["providerverification"] == null ? null : Providerverification.fromJson(json["providerverification"]),
        userdetailprovider: json["userdetailprovider"] == null ? null : Userdetailprovider.fromJson(json["userdetailprovider"]),
        educations: json["educations"] == null ? [] : List<Education>.from(json["educations"]!.map((x) => Education.fromJson(x))),
        userdetail: json["userdetail"] == null ? null : Userdetail.fromJson(json["userdetail"]),
        avgRating: json["avg_rating"].isEmpty ? null : json["avg_rating"][0],
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
        "ratings": ratings == null ? [] : List<dynamic>.from(ratings!.map((x) => x.toJson())),
        "providerverification": providerverification?.toJson(),
        "userdetailprovider": userdetailprovider?.toJson(),
        "educations": educations == null ? [] : List<dynamic>.from(educations!.map((x) => x.toJson())),
        "userdetail": userdetail?.toJson(),
        "avgRating": avgRating,
      };
}

class Education {
  int? id;
  String? name;
  int? userId;
  String? major;
  String? to;
  String? from;
  int? current;
  String? createdAt;
  String? updatedAt;

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
    required this.id,
    required this.userId,
    this.validDriverLicense,
    this.validDriverLicenseVerify,
    this.scarsAwarenessCertification,
    this.scarsAwarenessCertificationVerify,
    this.redCrossBabysittingCertification,
    this.redCrossBabysittingCertificationVerify,
    this.cprFirstAidCertification,
    this.cprFirstAidCertificationVerify,
    this.animalCareProviderCertification,
    this.animalCareProviderCertificationVerify,
    this.animailFirstAid,
    this.animalFirstAidVerify,
    this.chaildAndFamilyServicesAndAbuse,
    this.chaildAndFamilyServicesAndAbuseVerify,
    this.governmentRegisteredCareProvider,
    this.governmentRegisteredCareProviderVerify,
    this.policeBackgroundCheck,
    this.policeBackgroundCheckVerify,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int userId;
  String? validDriverLicense;
  int? validDriverLicenseVerify;
  String? scarsAwarenessCertification;
  int? scarsAwarenessCertificationVerify;
  String? redCrossBabysittingCertification;
  int? redCrossBabysittingCertificationVerify;
  String? cprFirstAidCertification;
  int? cprFirstAidCertificationVerify;
  String? animalCareProviderCertification;
  int? animalCareProviderCertificationVerify;
  String? chaildAndFamilyServicesAndAbuse;
  int? chaildAndFamilyServicesAndAbuseVerify;
  String? animailFirstAid;
  int? animalFirstAidVerify;
  String? governmentRegisteredCareProvider;
  int? governmentRegisteredCareProviderVerify;
  String? policeBackgroundCheck;
  int? policeBackgroundCheckVerify;

  String? createdAt;
  String? updatedAt;

  factory Providerverification.fromJson(Map<String, dynamic> json) => Providerverification(
        id: json["id"],
        userId: json["user_id"],
        validDriverLicense: json["valid_driver_license"],
        validDriverLicenseVerify: json["valid_driver_license_verify"],
        scarsAwarenessCertification: json["scars_awareness_certification"],
        scarsAwarenessCertificationVerify: json["scars_awareness_certification_verify"],
        redCrossBabysittingCertification: json["red_cross_babysitting_certification"],
        redCrossBabysittingCertificationVerify: json["red_cross_babysitting_certification_verify"],
        cprFirstAidCertification: json["cpr_first_aid_certification"],
        cprFirstAidCertificationVerify: json["cpr_first_aid_certification_verify"],
        animalCareProviderCertification: json["animal_care_provider_certification"],
        animalCareProviderCertificationVerify: json["animal_care_provider_certification_verify"],
        chaildAndFamilyServicesAndAbuse: json["child_and_family_services_and_abuse"],
        chaildAndFamilyServicesAndAbuseVerify: json["child_and_family_services_and_abuse_verify"],
        animailFirstAid: json["animail_first_aid"],
        animalFirstAidVerify: json["animail_first_aid_verify"],
        governmentRegisteredCareProvider: json["government_registered_care_provider"],
        governmentRegisteredCareProviderVerify: json["government_registered_care_provider_verify"],
        policeBackgroundCheck: json["police_background_check"],
        policeBackgroundCheckVerify: json["police_background_check_verify"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "valid_driver_license": validDriverLicense,
        "valid_driver_license_verify": validDriverLicenseVerify,
        "scars_awareness_certification": scarsAwarenessCertification,
        "scars_awareness_certification_verify": scarsAwarenessCertificationVerify,
        "red_cross_babysitting_certification": redCrossBabysittingCertification,
        "red_cross_babysitting_certification_verify": redCrossBabysittingCertificationVerify,
        "cpr_first_aid_certification": cprFirstAidCertification,
        "cpr_first_aid_certification_verify": cprFirstAidCertificationVerify,
        "animal_care_provider_certification": animalCareProviderCertification,
        "animal_care_provider_certification_verify": animalCareProviderCertificationVerify,
        "child_and_family_services_and_abuse": chaildAndFamilyServicesAndAbuse,
        "child_and_family_services_and_abuse_verify": chaildAndFamilyServicesAndAbuseVerify,
        "animail_first_aid": animailFirstAid,
        "animail_first_aid_verify": animalFirstAidVerify,
        "government_registered_care_provider": governmentRegisteredCareProvider,
        "government_registered_care_provider_verify": governmentRegisteredCareProviderVerify,
        "police_background_check": policeBackgroundCheck,
        "police_background_check_verify": policeBackgroundCheckVerify,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class Rating {
  int? id;
  int? providerId;
  int? jobId;
  int? rating;
  String? comment;
  int? ratingBy;
  String? createdAt;
  String? updatedAt;
  ReceiverRating? receiverRating;
  Rating({
    this.id,
    this.providerId,
    this.jobId,
    this.rating,
    this.comment,
    this.ratingBy,
    this.createdAt,
    this.updatedAt,
    this.receiverRating,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        id: json["id"],
        providerId: json["provider_id"],
        jobId: json["job_id"],
        rating: json["rating"],
        comment: json["comment"],
        ratingBy: json["rating_by"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        receiverRating: json["receiver_rating"] == null ? null : ReceiverRating.fromJson(json["receiver_rating"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "provider_id": providerId,
        "job_id": jobId,
        "rating": rating,
        "comment": comment,
        "rating_by": ratingBy,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "receiver_rating": receiverRating?.toJson(),
      };
}

class ReceiverRating {
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

  ReceiverRating({
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

  factory ReceiverRating.fromJson(Map<String, dynamic> json) => ReceiverRating(
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

class Userdetail {
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
  int? id;
  int? userId;
  String? availability;
  int? experience;
  String? educations;
  String? keywords;
  List? badge;
  String? hourlyRate;
  String? createdAt;
  String? updatedAt;

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

  factory Userdetailprovider.fromJson(Map<String, dynamic> json) => Userdetailprovider(
        id: json["id"],
        userId: json["user_id"],
        availability: json["availability"],
        experience: json["experience"],
        educations: json["educations"],
        keywords: json["keywords"],
        badge: json["badge"] == null ? null : json["badge"].toString().split(','),
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
