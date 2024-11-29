// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:island_app/caregiver/models/giver_service.dart';
import 'package:island_app/models/schedule_model.dart';

SeniorCareDetailDashboardModel SeniorCareDetailDashboardModelFromJson(String str) => SeniorCareDetailDashboardModel.fromJson(json.decode(str));

String SeniorCareDetailDashboardModelToJson(SeniorCareDetailDashboardModel data) => json.encode(data.toJson());

class SeniorCareDetailDashboardModel {
  SeniorCareDetailDashboardModel({
    this.jobDetail,
    this.isApplied,
  });

  List<JobDetail>? jobDetail;
  int? isApplied;

  factory SeniorCareDetailDashboardModel.fromJson(Map<String, dynamic> json) => SeniorCareDetailDashboardModel(
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
    this.seniorCare,
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
  GiverService? service;
  List<Schedule>? schedule;
  SeniorCare? seniorCare;
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
        service: json["service"] == null ? null : GiverService.fromJson(json["service"]),
        schedule: json["schedule"] == null ? [] : List<Schedule>.from(json["schedule"]!.map((x) => Schedule.fromJson(x))),
        seniorCare: json["senior_care"] == null ? null : SeniorCare.fromJson(json["senior_care"]),
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
        "service": service?.toJson(),
        "schedule": schedule == null ? [] : List<dynamic>.from(schedule!.map((x) => x.toJson())),
        "senior_care": seniorCare?.toJson(),
        "additional_info": additionalInfo,
      };
}

class SeniorCare {
  SeniorCare({
    this.id,
    this.jobId,
    this.seniorName,
    this.dob,
    this.medicalCondition,
    this.bathing,
    this.dressing,
    this.feeding,
    this.mealPreparation,
    this.groceryShopping,
    this.walking,
    this.bedTransfer,
    this.lightCleaning,
    this.companionship,
    this.medicationAdministration,
    this.dressingWoundCare,
    this.bloodPressureMonetoring,
    this.bloodSugarMonetoring,
    this.groomingHairAndNailTrimming,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? jobId;
  String? seniorName;
  String? dob;
  String? medicalCondition;
  int? bathing;
  int? dressing;
  int? feeding;
  int? mealPreparation;
  int? groceryShopping;
  int? walking;
  int? bedTransfer;
  int? lightCleaning;
  int? companionship;
  int? medicationAdministration;
  int? dressingWoundCare;
  int? bloodPressureMonetoring;
  int? bloodSugarMonetoring;
  int? groomingHairAndNailTrimming;
  String? createdAt;
  String? updatedAt;

  factory SeniorCare.fromJson(Map<String, dynamic> json) => SeniorCare(
        id: json["id"],
        jobId: json["job_id"],
        seniorName: json["senior_name"],
        dob: json["dob"],
        medicalCondition: json["medical_condition"],
        bathing: json["bathing"],
        dressing: json["dressing"],
        feeding: json["feeding"],
        mealPreparation: json["meal_preparation"],
        groceryShopping: json["grocery_shopping"],
        walking: json["walking"],
        bedTransfer: json["bed_transfer"],
        lightCleaning: json["light_cleaning"],
        companionship: json["companionship"],
        medicationAdministration: json["medication_administration"],
        dressingWoundCare: json["dressing_wound_care"],
        bloodPressureMonetoring: json["blood_pressure_monetoring"],
        bloodSugarMonetoring: json["blood_sugar_monetoring"],
        groomingHairAndNailTrimming: json["grooming_hair_and_nail_trimming"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "job_id": jobId,
        "senior_name": seniorName,
        "dob": dob,
        "medical_condition": medicalCondition,
        "bathing": bathing,
        "dressing": dressing,
        "feeding": feeding,
        "meal_preparation": mealPreparation,
        "grocery_shopping": groceryShopping,
        "walking": walking,
        "bed_transfer": bedTransfer,
        "light_cleaning": lightCleaning,
        "companionship": companionship,
        "medication_administration": medicationAdministration,
        "dressing_wound_care": dressingWoundCare,
        "blood_pressure_monetoring": bloodPressureMonetoring,
        "blood_sugar_monetoring": bloodSugarMonetoring,
        "grooming_hair_and_nail_trimming": groomingHairAndNailTrimming,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
