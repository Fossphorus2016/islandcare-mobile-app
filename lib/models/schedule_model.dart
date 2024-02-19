class Schedule {
  Schedule({
    this.id,
    this.jobId,
    this.startingDate,
    this.startingTime,
    this.duration,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? jobId;
  String? startingDate;
  String? startingTime;
  String? duration;
  String? createdAt;
  String? updatedAt;

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        id: json["id"],
        jobId: json["job_id"],
        startingDate: json["starting_date"],
        startingTime: json["starting_time"],
        duration: json["duration"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "job_id": jobId,
        "starting_date": startingDate,
        "starting_time": startingTime,
        "duration": duration,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
