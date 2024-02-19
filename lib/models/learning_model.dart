class Learning {
  Learning({
    this.id,
    this.jobId,
    this.learningStyle,
    this.learningChallenge,
    this.assistanceInMath,
    this.assistanceInEnglish,
    this.assistanceInScience,
    this.assistanceInReading,
    this.assistanceInOther,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? jobId;
  String? learningStyle;
  String? learningChallenge;
  int? assistanceInMath;
  int? assistanceInEnglish;
  dynamic assistanceInScience;
  int? assistanceInReading;
  dynamic assistanceInOther;
  String? createdAt;
  String? updatedAt;

  factory Learning.fromJson(Map<String, dynamic> json) => Learning(
        id: json["id"],
        jobId: json["job_id"],
        learningStyle: json["learning_style"],
        learningChallenge: json["learning_challenge"],
        assistanceInMath: json["assistance_in_math"],
        assistanceInEnglish: json["assistance_in_english"],
        assistanceInScience: json["assistance_in_science"],
        assistanceInReading: json["assistance_in_reading"],
        assistanceInOther: json["assistance_in_other"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "job_id": jobId,
        "learning_style": learningStyle,
        "learning_challenge": learningChallenge,
        "assistance_in_math": assistanceInMath,
        "assistance_in_english": assistanceInEnglish,
        "assistance_in_science": assistanceInScience,
        "assistance_in_reading": assistanceInReading,
        "assistance_in_other": assistanceInOther,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
