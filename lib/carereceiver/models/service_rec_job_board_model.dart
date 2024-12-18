import 'dart:convert';

import 'package:island_app/models/learning_model.dart';
import 'package:island_app/models/schedule_model.dart';
import 'package:island_app/models/school_camp_model.dart';
import 'package:island_app/models/service_model.dart';

ServiceReceiverJobBoardModel serviceReceiverJobBoardModelFromJson(String str) => ServiceReceiverJobBoardModel.fromJson(json.decode(str));

String serviceReceiverJobBoardModelToJson(ServiceReceiverJobBoardModel data) => json.encode(data.toJson());

class ServiceReceiverJobBoardModel {
  ServiceReceiverJobBoardModel({
    this.job,
  });

  List<Job>? job;

  factory ServiceReceiverJobBoardModel.fromJson(Map<String, dynamic> json) => ServiceReceiverJobBoardModel(
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
    this.childinfo,
    this.service,
    this.schedule,
    this.seniorCare,
    this.petCare,
    this.houseKeeping,
    this.learning,
    this.schoolCamp,
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
  Service? service;
  List<Schedule>? schedule;
  SeniorCare? seniorCare;
  PetCare? petCare;
  HouseKeeping? houseKeeping;
  Learning? learning;
  SchoolCamp? schoolCamp;

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
        service: json["service"] == null ? null : Service.fromJson(json["service"]),
        schedule: json["schedule"] == null ? [] : List<Schedule>.from(json["schedule"]!.map((x) => Schedule.fromJson(x))),
        seniorCare: json["senior_care"] == null ? null : SeniorCare.fromJson(json["senior_care"]),
        petCare: json["pet_care"] == null ? null : PetCare.fromJson(json["pet_care"]),
        houseKeeping: json["house_keeping"] == null ? null : HouseKeeping.fromJson(json["house_keeping"]),
        learning: json["learning"] == null ? null : Learning.fromJson(json["learning"]),
        schoolCamp: json["school_camp"] == null ? null : SchoolCamp.fromJson(json["school_camp"]),
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
        "service": service?.toJson(),
        "schedule": schedule == null ? [] : List<dynamic>.from(schedule!.map((x) => x.toJson())),
        "senior_care": seniorCare?.toJson(),
        "pet_care": petCare?.toJson(),
        "house_keeping": houseKeeping?.toJson(),
        "learning": learning?.toJson(),
        "school_camp": schoolCamp?.toJson(),
      };
}

class Childinfo {
  Childinfo({
    this.id,
    this.jobId,
    this.name,
    this.age,
    this.grade,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? jobId;
  String? name;
  String? age;
  String? grade;
  String? createdAt;
  String? updatedAt;

  factory Childinfo.fromJson(Map<String, dynamic> json) => Childinfo(
        id: json["id"],
        jobId: json["job_id"],
        name: json["name"],
        age: json["age"],
        grade: json["grade"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "job_id": jobId,
        "name": name,
        "age": age,
        "grade": grade,
        "created_at": createdAt,
        "updated_at": updatedAt,
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
  int? laundry;
  int? ironing;
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
  dynamic walking;
  int? daycare;
  dynamic feeding;
  int? socialization;
  dynamic grooming;
  dynamic boarding;
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
