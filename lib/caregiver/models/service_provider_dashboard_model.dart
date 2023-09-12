import 'dart:convert';

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
      };
}

class Service {
  Service({
    this.id,
    this.name,
    this.image,
    this.description,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  String? image;
  String? description;
  DateTime? deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        description: json["description"],
        deletedAt: json["deleted_at"] == null ? null : DateTime.parse(json["deleted_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "description": description,
        "deleted_at": deletedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}


// ServiceProviderDashboardModel serviceProviderDashboardModelFromJson(String str) => ServiceProviderDashboardModel.fromJson(json.decode(str));

// String serviceProviderDashboardModelToJson(ServiceProviderDashboardModel data) => json.encode(data.toJson());

// class ServiceProviderDashboardModel {
//   ServiceProviderDashboardModel({
//     this.jobs,
//     this.recentJobs,
//   });

//   List<Job>? jobs;
//   List<dynamic>? recentJobs;

//   factory ServiceProviderDashboardModel.fromJson(Map<String, dynamic> json) => ServiceProviderDashboardModel(
//         jobs: json["jobs"] == null ? [] : List<Job>.from(json["jobs"]!.map((x) => Job.fromJson(x))),
//         recentJobs: json["recent_jobs"] == null ? [] : List<dynamic>.from(json["recent_jobs"]!.map((x) => x)),
//       );

//   Map<String, dynamic> toJson() => {
//         "jobs": jobs == null ? [] : List<dynamic>.from(jobs!.map((x) => x.toJson())),
//         "recent_jobs": recentJobs == null ? [] : List<dynamic>.from(recentJobs!.map((x) => x)),
//       };
// }

// class Job {
//   Job({
//     this.id,
//     this.jobType,
//     this.jobTitle,
//     this.userId,
//     this.serviceId,
//     this.address,
//     this.zip,
//     this.responsibilities,
//     this.requirements,
//     this.rate,
//     this.notes,
//     this.status,
//     this.deletedAt,
//     this.createdAt,
//     this.updatedAt,
//     this.service,
//     this.user,
//   });

//   int? id;
//   int? jobType;
//   String? jobTitle;
//   int? userId;
//   int? serviceId;
//   String? address;
//   String? zip;
//   String? responsibilities;
//   String? requirements;
//   int? rate;
//   String? notes;
//   int? status;
//   dynamic deletedAt;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   Service? service;
//   User? user;

//   factory Job.fromJson(Map<String, dynamic> json) => Job(
//         id: json["id"],
//         jobType: json["job_type"],
//         jobTitle: json["job_title"],
//         userId: json["user_id"],
//         serviceId: json["service_id"],
//         address: json["address"],
//         zip: json["zip"],
//         responsibilities: json["responsibilities"],
//         requirements: json["requirements"],
//         rate: json["rate"],
//         notes: json["notes"],
//         status: json["status"],
//         // ignore: prefer_if_null_operators
//         deletedAt: json["deleted_at"] == null ? null : json["deleted_at"],
//         createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
//         updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
//         service: json["service"] == null ? null : Service.fromJson(json["service"]),
//         user: json["user"] == null ? null : User.fromJson(json["user"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "job_type": jobType,
//         "job_title": jobTitle,
//         "user_id": userId,
//         "service_id": serviceId,
//         "address": address,
//         "zip": zip,
//         "responsibilities": responsibilities,
//         "requirements": requirements,
//         "rate": rate,
//         "notes": notes,
//         "status": status,
//         "deleted_at": deletedAt,
//         "created_at": createdAt?.toIso8601String(),
//         "updated_at": updatedAt?.toIso8601String(),
//         "service": service?.toJson(),
//         "user": user?.toJson(),
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
//   DateTime? deletedAt;
//   DateTime? createdAt;
//   DateTime? updatedAt;

//   factory Service.fromJson(Map<String, dynamic> json) => Service(
//         id: json["id"],
//         name: json["name"],
//         image: json["image"],
//         description: json["description"], 
//         deletedAt: json["deleted_at"] == null ? null : DateTime.parse(json["deleted_at"]),
//         createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
//         updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "image": image,
//         "description": description,
//         "is_active": isActive,
//         "deleted_at": deletedAt?.toIso8601String(),
//         "created_at": createdAt?.toIso8601String(),
//         "updated_at": updatedAt?.toIso8601String(),
//       };
// }

// class User {
//   User({
//     this.id,
//     this.firstName,
//     this.lastName,
//     this.email,
//     this.phone,
//     this.emailVerifiedAt,
//     this.providerId,
//     this.avatar,
//     this.role,
//     this.status,
//     this.createdAt,
//     this.updatedAt,
//     this.deletedAt,
//   });

//   int? id;
//   String? firstName;
//   String? lastName;
//   String? email;
//   String? phone;
//   DateTime? emailVerifiedAt;
//   dynamic providerId;
//   String? avatar;
//   int? role;
//   int? status;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   dynamic deletedAt;

//   factory User.fromJson(Map<String, dynamic> json) => User(
//         id: json["id"],
//         firstName: json["first_name"],
//         lastName: json["last_name"],
//         email: json["email"],
//         phone: json["phone"],
//         emailVerifiedAt: json["email_verified_at"] == null ? null : DateTime.parse(json["email_verified_at"]),
//         providerId: json["provider_id"],
//         avatar: json["avatar"],
//         role: json["role"],
//         status: json["status"],
//         createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
//         updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
//         deletedAt: json["deleted_at"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "first_name": firstName,
//         "last_name": lastName,
//         "email": email,
//         "phone": phone,
//         "email_verified_at": emailVerifiedAt?.toIso8601String(),
//         "provider_id": providerId,
//         "avatar": avatar,
//         "role": role,
//         "status": status,
//         "created_at": createdAt?.toIso8601String(),
//         "updated_at": updatedAt?.toIso8601String(),
//         "deleted_at": deletedAt,
//       };
// }
