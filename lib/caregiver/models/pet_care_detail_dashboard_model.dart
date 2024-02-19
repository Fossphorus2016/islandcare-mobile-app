import 'dart:convert';

import 'package:island_app/models/schedule_model.dart';
import 'package:island_app/models/service_model.dart';

PetCareDetailDashboardModel petCareDetailDashboardModelFromJson(String str) => PetCareDetailDashboardModel.fromJson(json.decode(str));

String petCareDetailDashboardModelToJson(PetCareDetailDashboardModel data) => json.encode(data.toJson());

class PetCareDetailDashboardModel {
  PetCareDetailDashboardModel({
    this.jobDetail,
    this.isApplied,
  });

  List<JobDetail>? jobDetail;
  int? isApplied;

  factory PetCareDetailDashboardModel.fromJson(Map<String, dynamic> json) => PetCareDetailDashboardModel(
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
    this.petCare,
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
  PetCare? petCare;
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
        petCare: json["pet_care"] == null ? null : PetCare.fromJson(json["pet_care"]),
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
        "pet_care": petCare?.toJson(),
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
