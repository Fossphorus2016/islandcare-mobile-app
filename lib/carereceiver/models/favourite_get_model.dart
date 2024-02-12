import 'dart:convert';

FavouriteGetModel favouriteGetModelFromJson(String str) => FavouriteGetModel.fromJson(json.decode(str));

String favouriteGetModelToJson(FavouriteGetModel data) => json.encode(data.toJson());

class FavouriteGetModel {
  FavouriteGetModel({
    this.data,
  });

  List<Datum>? data;

  factory FavouriteGetModel.fromJson(Map<String, dynamic> json) => FavouriteGetModel(
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.id,
    this.userId,
    this.favouriteId,
    this.createdAt,
    this.updatedAt,
    this.users,
    this.userdetails,
    this.userdetailproviders,
  });

  int? id;
  int? userId;
  int? favouriteId;
  String? createdAt;
  String? updatedAt;
  Users? users;
  Userdetails? userdetails;
  Userdetailproviders? userdetailproviders;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        favouriteId: json["favourite_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        users: json["users"] == null ? null : Users.fromJson(json["users"]),
        userdetails: json["userdetails"] == null ? null : Userdetails.fromJson(json["userdetails"]),
        userdetailproviders: json["userdetailproviders"] == null ? null : Userdetailproviders.fromJson(json["userdetailproviders"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "favourite_id": favouriteId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "users": users?.toJson(),
        "userdetails": userdetails?.toJson(),
        "userdetailproviders": userdetailproviders?.toJson(),
      };
}

class Userdetailproviders {
  Userdetailproviders({
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
  String? createdAt;
  String? updatedAt;

  factory Userdetailproviders.fromJson(Map<String, dynamic> json) => Userdetailproviders(
        id: json["id"],
        userId: json["user_id"],
        availability: json["availability"],
        experience: json["experience"],
        educations: json["educations"],
        keywords: json["keywords"],
        badge: json["badge"],
        hourlyRate: json["hourly_rate"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
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
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class Userdetails {
  Userdetails({
    this.id,
    this.userId,
    this.gender,
    this.dob,
    this.servicesRequired,
    this.zip,
    this.address,
    this.area,
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
  String? area;
  String? userInfo;
  String? createdAt;
  String? updatedAt;

  factory Userdetails.fromJson(Map<String, dynamic> json) => Userdetails(
        id: json["id"],
        userId: json["user_id"],
        gender: json["gender"],
        dob: json["dob"],
        servicesRequired: json["services_required"],
        zip: json["zip"],
        address: json["address"],
        area: json["area"],
        userInfo: json["user_info"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "gender": gender,
        "dob": dob,
        "services_required": servicesRequired,
        "zip": zip,
        "address": address,
        "area": area,
        "user_info": userInfo,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class Users {
  Users({
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
  });

  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? emailVerifiedAt;
  dynamic providerId;
  String? avatar;
  int? role;
  int? status;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        phone: json["phone"],
        emailVerifiedAt: json["email_verified_at"],
        providerId: json["provider_id"],
        avatar: json["avatar"],
        role: json["role"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "email_verified_at": emailVerifiedAt,
        "provider_id": providerId,
        "avatar": avatar,
        "role": role,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
      };
}
