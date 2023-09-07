class NotificationModel {
  int? id;
  String? message;
  int? byId;
  int? forId;
  int? forRoll;
  int? isRead;
  String? createdAt;
  String? updatedAt;

  NotificationModel({
    this.id,
    this.message,
    this.byId,
    this.forId,
    this.forRoll,
    this.isRead,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        id: json['id'],
        message: json['message'],
        byId: json['by_id'],
        forId: json['for_id'],
        forRoll: json['for_roll'],
        isRead: json['is_read'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );
}

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? emailVerifiedAt;
  String? providerId;
  String? avatar;
  int? roll;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.emailVerifiedAt,
    this.providerId,
    this.avatar,
    this.roll,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        email: json['email'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        phone: json['phone'],
        avatar: json['avatar'],
        emailVerifiedAt: json['email_verified_at'],
      );
}
