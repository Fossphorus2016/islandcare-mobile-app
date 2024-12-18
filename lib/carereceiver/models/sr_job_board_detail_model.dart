import 'dart:convert';

import 'package:island_app/models/schedule_model.dart';
import 'package:island_app/models/service_model.dart';

ServiceReceiverJobBoardDetailModel serviceReceiverJobBoardDetailModelFromJson(String str) => ServiceReceiverJobBoardDetailModel.fromJson(json.decode(str));

String serviceReceiverJobBoardDetailModelToJson(ServiceReceiverJobBoardDetailModel data) => json.encode(data.toJson());

class ServiceReceiverJobBoardDetailModel {
  ServiceReceiverJobBoardDetailModel({
    this.job,
  });

  List<Job>? job;

  factory ServiceReceiverJobBoardDetailModel.fromJson(Map<String, dynamic> json) => ServiceReceiverJobBoardDetailModel(
        job: json["job"] == null ? [] : List<Job>.from(json["job"]!.map((x) => Job.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "job": job == null ? [] : List<dynamic>.from(job!.map((x) => x.toJson())),
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
    this.service,
    this.schedule,
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
        service: json["service"] == null ? null : Service.fromJson(json["service"]),
        schedule: json["schedule"] == null ? [] : List<Schedule>.from(json["schedule"]!.map((x) => Schedule.fromJson(x))),
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
      };
}
