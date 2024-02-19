import 'dart:convert';

import 'package:island_app/models/schedule_model.dart';
import 'package:island_app/models/service_model.dart';

SeniorCareDetailModel seniorCareDetailModelFromJson(String str) => SeniorCareDetailModel.fromJson(json.decode(str));

String seniorCareDetailModelToJson(SeniorCareDetailModel data) => json.encode(data.toJson());

class SeniorCareDetailModel {
  SeniorCareDetailModel({
    this.job,
  });

  List<Job>? job;

  factory SeniorCareDetailModel.fromJson(Map<String, dynamic> json) => SeniorCareDetailModel(
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
    this.seniorCare,
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
  SeniorCare? seniorCare;
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
        seniorCare: json["senior_care"] == null ? null : SeniorCare.fromJson(json["senior_care"]),
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
        "senior_care": seniorCare?.toJson(),
        "service": service?.toJson(),
        "schedule": schedule == null ? [] : List<dynamic>.from(schedule!.map((x) => x.toJson())),
      };
}

// class Schedule {
//   Schedule({
//     this.id,
//     this.jobId,
//     this.startingDate,
//     this.startingTime,
//     this.duration,
//     this.createdAt,
//     this.updatedAt,
//   });

//   int? id;
//   int? jobId;
//   String? startingDate;
//   String? startingTime;
//   String? duration;
//   String? createdAt;
//   String? updatedAt;

//   factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
//         id: json["id"],
//         jobId: json["job_id"],
//         startingDate: json["starting_date"],
//         startingTime: json["starting_time"],
//         duration: json["duration"],
//         createdAt: json["created_at"],
//         updatedAt: json["updated_at"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "job_id": jobId,
//         "starting_date": startingDate,
//         "starting_time": startingTime,
//         "duration": duration,
//         "created_at": createdAt,
//         "updated_at": updatedAt,
//       };
// }

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
  dynamic medicalCondition;
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

// class Service {
//   Service({
//     this.id,
//     this.name,
//     this.image,
//     this.description,
//     this.deletedAt,
//     this.createdAt,
//     this.updatedAt,
//   });

//   int? id;
//   String? name;
//   String? image;
//   String? description;
//   dynamic deletedAt;
//   String? createdAt;
//   String? updatedAt;

//   factory Service.fromJson(Map<String, dynamic> json) => Service(
//         id: json["id"],
//         name: json["name"],
//         image: json["image"],
//         description: json["description"],
//         deletedAt: json["deleted_at"],
//         createdAt: json["created_at"],
//         updatedAt: json["updated_at"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "image": image,
//         "description": description,
//         "deleted_at": deletedAt,
//         "created_at": createdAt,
//         "updated_at": updatedAt,
//       };
// }
