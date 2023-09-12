// ignore_for_file: file_names

import 'dart:convert';

ChildCareDetailDashboardModel childCareDetailDashboardModelFromJson(String str) => ChildCareDetailDashboardModel.fromJson(json.decode(str));

String childCareDetailDashboardModelToJson(ChildCareDetailDashboardModel data) => json.encode(data.toJson());

class ChildCareDetailDashboardModel {
  ChildCareDetailDashboardModel({
    this.jobDetail,
    this.isApplied,
  });

  List<JobDetail>? jobDetail;
  int? isApplied;

  factory ChildCareDetailDashboardModel.fromJson(Map<String, dynamic> json) => ChildCareDetailDashboardModel(
        jobDetail: json["job_detail"] == null ? [] : List<JobDetail>.from(json["job_detail"]!.map((x) => JobDetail.fromJson(x))),
        isApplied: json["is_applied"],
      );

  Map<String, dynamic> toJson() => {
        "job_detail": jobDetail == null ? [] : List<dynamic>.from(jobDetail!.map((x) => x.toJson())),
        "is_applied": isApplied,
      };
}

class JobDetail {
  JobDetail({
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
    this.service,
    this.schedule,
    this.childinfo,
    this.learning,
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
  dynamic providerId;
  int? fundsTransferedToProvider;
  String? totalDuration;
  Service? service;
  List<Schedule>? schedule;
  List<Childinfo>? childinfo;
  Learning? learning;

  factory JobDetail.fromJson(Map<String, dynamic> json) => JobDetail(
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
        service: json["service"] == null ? null : Service.fromJson(json["service"]),
        schedule: json["schedule"] == null ? [] : List<Schedule>.from(json["schedule"]!.map((x) => Schedule.fromJson(x))),
        childinfo: json["childinfo"] == null ? [] : List<Childinfo>.from(json["childinfo"]!.map((x) => Childinfo.fromJson(x))),
        learning: json["learning"] == null ? null : Learning.fromJson(json["learning"]),
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
        "service": service?.toJson(),
        "schedule": schedule == null ? [] : List<dynamic>.from(schedule!.map((x) => x.toJson())),
        "childinfo": childinfo == null ? [] : List<dynamic>.from(childinfo!.map((x) => x.toJson())),
        "learning": learning?.toJson(),
      };
}

class Childinfo {
  Childinfo({
    this.id,
    this.jobId,
    this.name,
    this.age,
    this.grade,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? jobId;
  String? name;
  String? age;
  String? grade;
  String? createdAt;
  String? updatedAt;

  factory Childinfo.fromJson(Map<String, dynamic> json) => Childinfo(
        id: json["id"],
        jobId: json["job_id"],
        name: json["name"],
        age: json["age"],
        grade: json["grade"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "job_id": jobId,
        "name": name,
        "age": age,
        "grade": grade,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class Learning {
  Learning({
    this.id,
    this.jobId,
    this.learningStyle,
    this.learningChallenge,
    this.assistanceInMath,
    this.assistanceInEnglish,
    this.assistanceInScience,
    this.assistanceInReading,
    this.assistanceInOther,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? jobId;
  String? learningStyle;
  String? learningChallenge;
  int? assistanceInMath;
  int? assistanceInEnglish;
  int? assistanceInScience;
  int? assistanceInReading;
  String? assistanceInOther;
  String? createdAt;
  String? updatedAt;

  factory Learning.fromJson(Map<String, dynamic> json) => Learning(
        id: json["id"],
        jobId: json["job_id"],
        learningStyle: json["learning_style"],
        learningChallenge: json["learning_challenge"],
        assistanceInMath: json["assistance_in_math"],
        assistanceInEnglish: json["assistance_in_english"],
        assistanceInScience: json["assistance_in_science"],
        assistanceInReading: json["assistance_in_reading"],
        assistanceInOther: json["assistance_in_other"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "job_id": jobId,
        "learning_style": learningStyle,
        "learning_challenge": learningChallenge,
        "assistance_in_math": assistanceInMath,
        "assistance_in_english": assistanceInEnglish,
        "assistance_in_science": assistanceInScience,
        "assistance_in_reading": assistanceInReading,
        "assistance_in_other": assistanceInOther,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class Schedule {
  Schedule({
    this.id,
    this.jobId,
    this.startingDate,
    this.startingTime,
    this.duration,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? jobId;
  String? startingDate;
  String? startingTime;
  String? duration;
  String? createdAt;
  String? updatedAt;

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        id: json["id"],
        jobId: json["job_id"],
        startingDate: json["starting_date"],
        startingTime: json["starting_time"],
        duration: json["duration"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "job_id": jobId,
        "starting_date": startingDate,
        "starting_time": startingTime,
        "duration": duration,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class Service {
  Service({
    this.id,
    this.name,
    this.image,
    this.description,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  String? image;
  String? description;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        description: json["description"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "description": description,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
