// ignore_for_file: public_member_api_docs, sort_constructors_first
// class EducationList {
//   String? instituteName;
//   String? major;
//   String? from;
//   String? to;
//   EducationList({
//     this.instituteName,
//     this.major,
//     this.from,
//     this.to,
//   });
// }

// To parse this JSON data, do
//
//     final edocationList = edocationListFromJson(jsonString);

// import 'dart:convert';

// EdocationList edocationListFromJson(String str) => EdocationList.fromJson(json.decode(str));

// String edocationListToJson(EdocationList data) => json.encode(data.toJson());

// class EdocationList {
//     EdocationList({
//         this.educations,
//     });

//     List<Education>? educations;

//     factory EdocationList.fromJson(Map<String, dynamic> json) => EdocationList(
//         educations: json["educations"] == null ? [] : List<Education>.from(json["educations"]!.map((x) => Education.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "educations": educations == null ? [] : List<dynamic>.from(educations!.map((x) => x.toJson())),
//     };
// }

// class Education {
//     Education({
//         this.id,
//         this.name,
//         this.userId,
//         this.major,
//         this.to,
//         this.from,
//         this.current,
//         this.createdAt,
//         this.updatedAt,
//     });

//     int? id;
//     String? name;
//     int? userId;
//     String? major;
//     String? to;
//     DateTime? from;
//     int? current;
//     DateTime? createdAt;
//     DateTime? updatedAt;

//     factory Education.fromJson(Map<String, dynamic> json) => Education(
//         id: json["id"],
//         name: json["name"],
//         userId: json["user_id"],
//         major: json["major"],
//         to: json["to"],
//         from: json["from"] == null ? null : DateTime.parse(json["from"]),
//         current: json["current"],
//         createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
//         updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "user_id": userId,
//         "major": major,
//         "to": to,
//         "from": "${from!.year.toString().padLeft(4, '0')}-${from!.month.toString().padLeft(2, '0')}-${from!.day.toString().padLeft(2, '0')}",
//         "current": current,
//         "created_at": createdAt?.toIso8601String(),
//         "updated_at": updatedAt?.toIso8601String(),
//     };
// }

// class Education {
//   int? id;
//   String? name;
//   String? major;
//   String? to;
//   String? from;
//   int? current;
//   Education({
//     this.id,
//     this.name,
//     this.major,
//     this.to,
//     this.from,
//     this.current,
//   }) {
//     id = this.id;
//     name = this.name;
//     major = this.major;
//     to = this.to;
//     from = this.from;
//     current = this.current;
//   }

//   toJson() {
//     return {
//       "id": id,
//       "name": name,
//       "major": major,
//       "to": to,
//       "from": from,
//       "current": current,
//     };
//   }

//   fromjson(jsonData) {
//     return Education(
//       id: jsonData['id'],
//       name: jsonData['name'],
//       major: jsonData['major'],
//       to: jsonData['to'],
//       from: jsonData['from'],
//       current: jsonData['current'],
//     );
//   }
// }
