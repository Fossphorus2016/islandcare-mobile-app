class SchoolCamp {
  SchoolCamp({
    this.id,
    this.jobId,
    this.interestForChild,
    this.costRange,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? jobId;
  String? interestForChild;
  String? costRange;
  String? createdAt;
  String? updatedAt;

  factory SchoolCamp.fromJson(Map<String, dynamic> json) => SchoolCamp(
        id: json["id"],
        jobId: json["job_id"],
        interestForChild: json["interest_for_child"],
        costRange: json["cost_range"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "job_id": jobId,
        "interest_for_child": interestForChild,
        "cost_range": costRange,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
