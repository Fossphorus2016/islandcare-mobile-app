import 'dart:convert';

import 'package:island_app/models/service_model.dart';

ServiceReceiverJobApplicantModel serviceReceiverJobApplicantModelFromJson(String str) => ServiceReceiverJobApplicantModel.fromJson(json.decode(str));

String serviceReceiverJobApplicantModelToJson(ServiceReceiverJobApplicantModel data) => json.encode(data.toJson());

class ServiceReceiverJobApplicantModel {
  ServiceReceiverJobApplicantModel({
    this.data,
    this.applicationCounts,
  });

  List<Datum>? data;
  List<ApplicationCount>? applicationCounts;

  factory ServiceReceiverJobApplicantModel.fromJson(Map<String, dynamic> json) => ServiceReceiverJobApplicantModel(
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        applicationCounts: json["applicationCounts"] == null ? [] : List<ApplicationCount>.from(json["applicationCounts"]!.map((x) => ApplicationCount.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "applicationCounts": applicationCounts == null ? [] : List<dynamic>.from(applicationCounts!.map((x) => x.toJson())),
      };
}

class ApplicationCount {
  ApplicationCount({
    this.id,
    this.count,
  });

  int? id;
  int? count;

  factory ApplicationCount.fromJson(Map<String, dynamic> json) => ApplicationCount(
        id: json["id"],
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "count": count,
      };
}

class Datum {
  Datum({
    this.id,
    this.jobTitle,
    this.serviceId,
    this.service,
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
  Service? service;
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

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        jobTitle: json["job_title"],
        serviceId: json["service_id"],
        service: json['service'] != null ? Service.fromJson(json['service']) : null,
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
        "service": service,
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
