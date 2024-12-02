import 'dart:convert';

ReviewsModel reviewsModelFromJson(String str) => ReviewsModel.fromJson(json.decode(str));

// String reviewsModelToJson(ReviewsModel data) => json.encode(data.toJson());

class ReviewsModel {
  int? id;
  int? providerId;
  int? jobId;
  int? rating;
  String? comment;
  int? ratingBy;
  String? createdAt;
  String? updatedAt;
  ReceiverRating? receiverRating;
  ProviderRating? providerRating;
  ReviewsModel({
    this.id,
    this.providerId,
    this.jobId,
    this.rating,
    this.comment,
    this.ratingBy,
    this.createdAt,
    this.updatedAt,
    this.receiverRating,
    this.providerRating,
    // this.data,
  });

  // List<Datum>? data;

  factory ReviewsModel.fromJson(Map<String, dynamic> json) => ReviewsModel(
        id: json["id"],
        providerId: json["provider_id"],
        jobId: json["job_id"],
        rating: json["rating"],
        comment: json["comment"],
        ratingBy: json["rating_by"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        receiverRating: json["receiver_rating"] == null ? null : ReceiverRating.fromJson(json["receiver_rating"]),
        providerRating: json["provider_rating"] == null ? null : ProviderRating.fromJson(json["provider_rating"]),
        // data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  // Map<String, dynamic> toJson() => {
  //       // "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  //     };

  static List<ReviewsModel> fromTislJson(List json) {
    return json.map((e) => ReviewsModel.fromJson(e)).toList();
  }
}

class Datum {
  Datum({
    this.id,
    this.providerId,
    this.jobId,
    this.rating,
    this.comment,
    this.ratingBy,
    this.createdAt,
    this.updatedAt,
    this.receiverRating,
    this.providerRating,
  });

  int? id;
  int? providerId;
  int? jobId;
  int? rating;
  String? comment;
  int? ratingBy;
  String? createdAt;
  String? updatedAt;
  ReceiverRating? receiverRating;
  ProviderRating? providerRating;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        providerId: json["provider_id"],
        jobId: json["job_id"],
        rating: json["rating"],
        comment: json["comment"],
        ratingBy: json["rating_by"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        receiverRating: json["receiver_rating"] == null ? null : ReceiverRating.fromJson(json["receiver_rating"]),
        providerRating: json["provider_rating"] == null ? null : ProviderRating.fromJson(json["provider_rating"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "provider_id": providerId,
        "job_id": jobId,
        "rating": rating,
        "comment": comment,
        "rating_by": ratingBy,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "receiver_rating": receiverRating?.toJson(),
      };
}

class ReceiverRating {
  ReceiverRating({
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

  factory ReceiverRating.fromJson(Map<String, dynamic> json) => ReceiverRating(
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

class ProviderRating {
  ProviderRating({
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

  factory ProviderRating.fromJson(Map<String, dynamic> json) => ProviderRating(
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
