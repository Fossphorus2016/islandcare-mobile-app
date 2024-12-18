import 'dart:convert';

ServicesModel servicesModelFromJson(String str) => ServicesModel.fromJson(json.decode(str));

String servicesModelToJson(ServicesModel data) => json.encode(data.toJson());

class ServicesModel {
  ServicesModel({
    this.folderPath,
    this.services,
  });

  String? folderPath;
  List<Service>? services;

  factory ServicesModel.fromJson(Map<String, dynamic> json) => ServicesModel(
        folderPath: json["folder_path"],
        services: json["services"] == null ? [] : List<Service>.from(json["services"]!.map((x) => Service.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "folder_path": folderPath,
        "services": services != null ? Service.toJsonList(services!) : [],
        // List<dynamic>.from(services!.map((x) => x.toJson())),
      };
}

class Service {
  Service({
    this.id,
    this.name,
    this.image,
    this.description,
    this.isActive,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  String? image;
  String? description;
  int? isActive;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        description: json["description"],
        isActive: json["is_active"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );
  static List<Service> fromJsonList(List json) {
    return json
        .map(
          (e) => Service.fromJson(e),
        )
        .toList();
  }

  static List toJsonList(List<Service> json) {
    return json
        .map(
          (e) => Service.toJsonFromList(e),
        )
        .toList();
  }

  static Map<String, dynamic> toJsonFromList(Service data) => {
        "id": data.id,
        "name": data.name,
        "image": data.image,
        "description": data.description,
        "is_active": data.isActive,
        "deleted_at": data.deletedAt,
        "created_at": data.createdAt?.toIso8601String(),
        "updated_at": data.updatedAt?.toIso8601String(),
      };

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "description": description,
        "is_active": isActive,
        "deleted_at": deletedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
