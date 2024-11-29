class GiverService {
  GiverService({
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

  factory GiverService.fromJson(Map<String, dynamic> json) => GiverService(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        description: json["description"],
        isActive: json["is_active"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );
  static List<GiverService> fromJsonList(List json) {
    return json
        .map(
          (e) => GiverService.fromJson(e),
        )
        .toList();
  }

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
