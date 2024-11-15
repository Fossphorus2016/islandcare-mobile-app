import 'dart:convert';

ServiceReceiverDashboardModel serviceReceiverDashboardModelFromJson(String str) => ServiceReceiverDashboardModel.fromJson(json.decode(str));

String serviceReceiverDashboardModelToJson(ServiceReceiverDashboardModel data) => json.encode(data.toJson());

class ServiceReceiverDashboardModel {
  ServiceReceiverDashboardModel({
    this.favourites,
    this.data,
  });

  List<int>? favourites;
  List<Datum>? data;

  factory ServiceReceiverDashboardModel.fromJson(Map<String, dynamic> json) => ServiceReceiverDashboardModel(
        favourites: json["favourites"] == null ? [] : List<int>.from(json["favourites"]!.map((x) => x)),
        data: json["providers"] == null ? [] : List<Datum>.from(json["providers"]!.map((x) => Datum.fromJson(x))).reversed.toList(),
      );

  Map<String, dynamic> toJson() => {
        "favourites": favourites == null ? [] : List<dynamic>.from(favourites!.map((x) => x)),
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.emailVerifiedAt,
    this.providerId,
    this.avatar,
    this.role,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.avgRating,
    this.userdetail,
    this.userdetailprovider,
  });

  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  DateTime? emailVerifiedAt;
  dynamic providerId;
  String? avatar;
  int? role;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  List<AvgRating>? avgRating;
  Userdetail? userdetail;
  Userdetailprovider? userdetailprovider;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        phone: json["phone"],
        emailVerifiedAt: json["email_verified_at"] == null ? null : DateTime.parse(json["email_verified_at"]),
        providerId: json["provider_id"],
        avatar: json["avatar"],
        role: json["role"],
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        avgRating: json["avg_rating"] == null ? [] : List<AvgRating>.from(json["avg_rating"]!.map((x) => AvgRating.fromJson(x))),
        userdetail: json["userdetail"] == null ? null : Userdetail.fromJson(json["userdetail"]),
        userdetailprovider: json["userdetailprovider"] == null ? null : Userdetailprovider.fromJson(json["userdetailprovider"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "email_verified_at": emailVerifiedAt?.toIso8601String(),
        "provider_id": providerId,
        "avatar": avatar,
        "role": role,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "avg_rating": avgRating == null ? [] : List<dynamic>.from(avgRating!.map((x) => x.toJson())),
        "userdetail": userdetail?.toJson(),
        "userdetailprovider": userdetailprovider?.toJson(),
      };
}

class AvgRating {
  AvgRating({
    this.rating,
    this.providerId,
  });

  int? rating;
  int? providerId;

  factory AvgRating.fromJson(Map<String, dynamic> json) => AvgRating(
        rating: json["rating"],
        providerId: json["provider_id"],
      );

  Map<String, dynamic> toJson() => {
        "rating": rating,
        "provider_id": providerId,
      };
}

class Userdetail {
  Userdetail({
    this.id,
    this.userId,
    this.gender,
    this.dob,
    this.servicesRequired,
    this.zip,
    this.address,
    this.userInfo,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? userId;
  int? gender;
  String? dob;
  String? servicesRequired;
  String? zip;
  String? address;
  String? userInfo;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Userdetail.fromJson(Map<String, dynamic> json) => Userdetail(
        id: json["id"],
        userId: json["user_id"],
        gender: json["gender"],
        dob: json["dob"],
        servicesRequired: json["services_required"],
        zip: json["zip"],
        address: json["address"],
        userInfo: json["user_info"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "gender": gender,
        "dob": dob,
        "services_required": servicesRequired,
        "zip": zip,
        "address": address,
        "user_info": userInfo,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Userdetailprovider {
  Userdetailprovider({
    this.id,
    this.userId,
    this.availability,
    this.experience,
    this.educations,
    this.keywords,
    this.badge,
    this.hourlyRate,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? userId;
  String? availability;
  int? experience;
  String? educations;
  String? keywords;
  dynamic badge;
  String? hourlyRate;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Userdetailprovider.fromJson(Map<String, dynamic> json) => Userdetailprovider(
        id: json["id"],
        userId: json["user_id"],
        availability: json["availability"],
        experience: json["experience"],
        educations: json["educations"],
        keywords: json["keywords"],
        badge: json["badge"],
        hourlyRate: json["hourly_rate"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "availability": availability,
        "experience": experience,
        "educations": educations,
        "keywords": keywords,
        "badge": badge,
        "hourly_rate": hourlyRate,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
