import 'dart:convert';

import 'package:island_app/models/child_info_model.dart';
import 'package:island_app/models/learning_model.dart';
import 'package:island_app/models/schedule_model.dart';
import 'package:island_app/models/service_model.dart';

SchoolSupportDetailModel schoolSupportDetailModelFromJson(String str) => SchoolSupportDetailModel.fromJson(json.decode(str));

String schoolSupportDetailModelToJson(SchoolSupportDetailModel data) => json.encode(data.toJson());

class SchoolSupportDetailModel {
  SchoolSupportDetailModel({
    this.job,
  });

  List<Job>? job;

  factory SchoolSupportDetailModel.fromJson(Map<String, dynamic> json) => SchoolSupportDetailModel(
        job: json["job_detail"] == null ? [] : List<Job>.from(json["job_detail"]!.map((x) => Job.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "job_detail": job == null ? [] : List<dynamic>.from(job!.map((x) => x.toJson())),
      };
}

class Job {
  Job({
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
    this.childinfo,
    this.schoolCamp,
    this.service,
    this.schedule,
    this.learning,
    this.additionalInfo,
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
  List<Childinfo>? childinfo;
  SchoolCamp? schoolCamp;
  Service? service;
  List<Schedule>? schedule;
  Learning? learning;
  String? additionalInfo;

  factory Job.fromJson(Map<String, dynamic> json) => Job(
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
        childinfo: json["childinfo"] == null ? [] : List<Childinfo>.from(json["childinfo"]!.map((x) => Childinfo.fromJson(x))),
        schoolCamp: json["school_camp"] == null ? null : SchoolCamp.fromJson(json["school_camp"]),
        service: json["service"] == null ? null : Service.fromJson(json["service"]),
        schedule: json["schedule"] == null ? [] : List<Schedule>.from(json["schedule"]!.map((x) => Schedule.fromJson(x))),
        learning: json["learning"] == null ? null : Learning.fromJson(json["learning"]),
        additionalInfo: json['additional_info'],
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
        "childinfo": childinfo == null ? [] : List<dynamic>.from(childinfo!.map((x) => x.toJson())),
        "school_camp": schoolCamp?.toJson(),
        "service": service?.toJson(),
        "schedule": schedule == null ? [] : List<dynamic>.from(schedule!.map((x) => x.toJson())),
        "learning": learning?.toJson(),
        "additionalInfo": additionalInfo,
      };
}

class SchoolCamp {
  SchoolCamp({
    this.id,
    this.jobId,
    this.interestForChild,
    this.costRange,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? jobId;
  String? interestForChild;
  String? costRange;
  String? createdAt;
  String? updatedAt;

  factory SchoolCamp.fromJson(Map<String, dynamic> json) => SchoolCamp(
        id: json["id"],
        jobId: json["job_id"],
        interestForChild: json["interest_for_child"],
        costRange: json["cost_range"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "job_id": jobId,
        "interest_for_child": interestForChild,
        "cost_range": costRange,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
