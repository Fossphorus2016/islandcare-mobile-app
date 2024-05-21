import 'dart:convert';

import 'package:island_app/models/child_info_model.dart';
import 'package:island_app/models/learning_model.dart';
import 'package:island_app/models/schedule_model.dart';
import 'package:island_app/models/service_model.dart';

SchoolSupportDetailDashboardModel schoolSupportDetailDashboardModelFromJson(String str) => SchoolSupportDetailDashboardModel.fromJson(json.decode(str));

String schoolSupportDetailDashboardModelToJson(SchoolSupportDetailDashboardModel data) => json.encode(data.toJson());

class SchoolSupportDetailDashboardModel {
  SchoolSupportDetailDashboardModel({
    this.jobDetail,
    this.isApplied,
  });

  List<JobDetail>? jobDetail;
  int? isApplied;

  factory SchoolSupportDetailDashboardModel.fromJson(Map<String, dynamic> json) => SchoolSupportDetailDashboardModel(
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
  Service? service;
  List<Schedule>? schedule;
  List<Childinfo>? childinfo;

  Learning? learning;
  String? additionalInfo;

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
        "service": service?.toJson(),
        "schedule": schedule == null ? [] : List<dynamic>.from(schedule!.map((x) => x.toJson())),
        "childinfo": childinfo == null ? [] : List<dynamic>.from(childinfo!.map((x) => x.toJson())),
        "learning": learning?.toJson(),
        "additionalInfo": additionalInfo,
      };
}
