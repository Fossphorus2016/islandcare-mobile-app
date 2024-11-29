import 'dart:convert';

import 'package:island_app/caregiver/models/giver_service.dart';

ServiceProviderDashboardModel serviceProviderDashboardModelFromJson(String str) => ServiceProviderDashboardModel.fromJson(json.decode(str));

String serviceProviderDashboardModelToJson(ServiceProviderDashboardModel data) => json.encode(data.toJson());

class ServiceProviderDashboardModel {
  ServiceProviderDashboardModel({
    this.jobs,
    this.appliedJobs,
    this.completedJobs,
  });

  List<Job>? jobs;
  List<int>? appliedJobs;
  List<int>? completedJobs;

  factory ServiceProviderDashboardModel.fromJson(Map<String, dynamic> json) => ServiceProviderDashboardModel(
        jobs: json["jobs"] == null ? [] : List<Job>.from(json["jobs"]!.map((x) => Job.fromJson(x))),
        appliedJobs: json["applied_jobs"] == null ? [] : List<int>.from(json["applied_jobs"]!.map((x) => x)),
        completedJobs: json["completed_jobs"] == null ? [] : List<int>.from(json["completed_jobs"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "jobs": jobs == null ? [] : List<dynamic>.from(jobs!.map((x) => x.toJson())),
        "applied_jobs": appliedJobs == null ? [] : List<dynamic>.from(appliedJobs!.map((x) => x)),
        "completed_jobs": completedJobs == null ? [] : List<dynamic>.from(completedJobs!.map((x) => x)),
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
    this.userImage,
    this.userFirstName,
    this.userLastName,
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
  GiverService? service;
  String? userImage;
  String? userFirstName;
  String? userLastName;
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
        service: json["service"] == null ? null : GiverService.fromJson(json["service"]),
        userImage: json['user']['avatar'],
        userFirstName: json['user']['first_name'],
        userLastName: json['user']['last_name'],
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
        "userImage": "",
        "userFirstName": "",
        "userLastName": "",
      };
}
