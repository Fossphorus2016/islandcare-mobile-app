import 'dart:convert';

ChatRoomMessagesModel chatRoomMessagesModelFromJson(String str) => ChatRoomMessagesModel.fromJson(json.decode(str));

String chatRoomMessagesModelToJson(ChatRoomMessagesModel data) => json.encode(data.toJson());

class ChatRoomMessagesModel {
  List<ChatroomUser>? chatroomUsers;
  List<ChatroomMessage>? chatroomMessages;

  ChatRoomMessagesModel({this.chatroomUsers, this.chatroomMessages});

  factory ChatRoomMessagesModel.fromJson(Map<String, dynamic> json) => ChatRoomMessagesModel(
        chatroomUsers: json["chatroom_users"] == null ? [] : List<ChatroomUser>.from(json["chatroom_users"]!.map((x) => ChatroomUser.fromJson(x))),
        chatroomMessages: json["chatroom_messages"] == null ? [] : List<ChatroomMessage>.from(json["chatroom_messages"]!.map((x) => ChatroomMessage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "chatroom_users": chatroomUsers == null ? [] : List<dynamic>.from(chatroomUsers!.map((x) => x.toJson())),
        "chatroom_messages": chatroomMessages == null ? [] : List<dynamic>.from(chatroomMessages!.map((x) => x.toJson())),
      };
}

class ChatroomMessage {
  int? id;
  int? chatId;
  int? senderId;
  String? message;
  String? createdAt;
  String? updatedAt;

  ChatroomMessage({
    this.id,
    this.chatId,
    this.senderId,
    this.message,
    this.createdAt,
    this.updatedAt,
  });

  factory ChatroomMessage.fromJson(Map<String, dynamic> json) => ChatroomMessage(
        id: json['id'],
        chatId: json['chat_id'],
        senderId: json['sender_id'],
        message: json['message'],
        createdAt: json['created_at'],
        updatedAt: json['updated_At'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "chat_id": chatId,
        "sender_id": senderId,
        "message": message,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class ChatroomUser {
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

  ChatroomUser({
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

  factory ChatroomUser.fromJson(Map<String, dynamic> json) => ChatroomUser(
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
