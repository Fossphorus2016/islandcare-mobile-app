import 'dart:convert';

import 'package:island_app/models/schedule_model.dart';
import 'package:island_app/models/service_model.dart';

PetCareDetailModel petCareDetailModelFromJson(String str) => PetCareDetailModel.fromJson(json.decode(str));

String petCareDetailModelToJson(PetCareDetailModel data) => json.encode(data.toJson());

class PetCareDetailModel {
  PetCareDetailModel({
    this.job,
  });

  List<Job>? job;

  factory PetCareDetailModel.fromJson(Map<String, dynamic> json) => PetCareDetailModel(
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
    this.petCare,
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
  PetCare? petCare;
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
        petCare: json["pet_care"] == null ? null : PetCare.fromJson(json["pet_care"]),
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
        "pet_care": petCare?.toJson(),
        "service": service?.toJson(),
        "schedule": schedule == null ? [] : List<dynamic>.from(schedule!.map((x) => x.toJson())),
        "additional_info": additionalInfo,
      };
}

class PetCare {
  PetCare({
    this.id,
    this.jobId,
    this.petType,
    this.numberOfPets,
    this.petBreed,
    this.sizeOfPet,
    this.temperament,
    this.walking,
    this.daycare,
    this.feeding,
    this.socialization,
    this.grooming,
    this.boarding,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? jobId;
  String? petType;
  int? numberOfPets;
  String? petBreed;
  String? sizeOfPet;
  String? temperament;
  int? walking;
  int? daycare;
  int? feeding;
  int? socialization;
  int? grooming;
  int? boarding;
  String? createdAt;
  String? updatedAt;

  factory PetCare.fromJson(Map<String, dynamic> json) => PetCare(
        id: json["id"],
        jobId: json["job_id"],
        petType: json["pet_type"],
        numberOfPets: json["number_of_pets"],
        petBreed: json["pet_breed"],
        sizeOfPet: json["size_of_pet"],
        temperament: json["temperament"],
        walking: json["walking"],
        daycare: json["daycare"],
        feeding: json["feeding"],
        socialization: json["socialization"],
        grooming: json["grooming"],
        boarding: json["boarding"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "job_id": jobId,
        "pet_type": petType,
        "number_of_pets": numberOfPets,
        "pet_breed": petBreed,
        "size_of_pet": sizeOfPet,
        "temperament": temperament,
        "walking": walking,
        "daycare": daycare,
        "feeding": feeding,
        "socialization": socialization,
        "grooming": grooming,
        "boarding": boarding,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
