import 'dart:convert';

import 'package:island_app/models/schedule_model.dart';
import 'package:island_app/models/service_model.dart';

HouseKeepingDetailModel houseKeepingDetailModelFromJson(String str) => HouseKeepingDetailModel.fromJson(json.decode(str));

String houseKeepingDetailModelToJson(HouseKeepingDetailModel data) => json.encode(data.toJson());

class HouseKeepingDetailModel {
  HouseKeepingDetailModel({
    this.job,
  });

  List<Job>? job;

  factory HouseKeepingDetailModel.fromJson(Map<String, dynamic> json) => HouseKeepingDetailModel(
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
    this.houseKeeping,
    this.service,
    this.schedule,
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
  HouseKeeping? houseKeeping;
  Service? service;
  List<Schedule>? schedule;
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
        houseKeeping: json["house_keeping"] == null ? null : HouseKeeping.fromJson(json["house_keeping"]),
        service: json["service"] == null ? null : Service.fromJson(json["service"]),
        schedule: json["schedule"] == null ? [] : List<Schedule>.from(json["schedule"]!.map((x) => Schedule.fromJson(x))),
        additionalInfo: json["additional_info"],
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
        "house_keeping": houseKeeping?.toJson(),
        "service": service?.toJson(),
        "schedule": schedule == null ? [] : List<dynamic>.from(schedule!.map((x) => x.toJson())),
        "additional_info": additionalInfo,
      };
}

class HouseKeeping {
  HouseKeeping({
    this.id,
    this.jobId,
    this.cleaningType,
    this.numberOfBathrooms,
    this.numberOfBedrooms,
    this.laundry,
    this.ironing,
    this.other,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? jobId;
  String? cleaningType;
  int? numberOfBathrooms;
  int? numberOfBedrooms;
  dynamic laundry;
  dynamic ironing;
  dynamic other;
  String? createdAt;
  String? updatedAt;

  factory HouseKeeping.fromJson(Map<String, dynamic> json) => HouseKeeping(
        id: json["id"],
        jobId: json["job_id"],
        cleaningType: json["cleaning_type"],
        numberOfBathrooms: json["number_of_bathrooms"],
        numberOfBedrooms: json["number_of_bedrooms"],
        laundry: json["laundry"],
        ironing: json["ironing"],
        other: json["other"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "job_id": jobId,
        "cleaning_type": cleaningType,
        "number_of_bathrooms": numberOfBathrooms,
        "number_of_bedrooms": numberOfBedrooms,
        "laundry": laundry,
        "ironing": ironing,
        "other": other,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
