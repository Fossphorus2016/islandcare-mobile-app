// To parse this JSON data, do
//
//     final bankDetailsModel = bankDetailsModelFromJson(jsonString);

import 'dart:convert';

BankDetailsModel bankDetailsModelFromJson(String str) => BankDetailsModel.fromJson(json.decode(str));

String bankDetailsModelToJson(BankDetailsModel data) => json.encode(data.toJson());

class BankDetailsModel {
    List<BankDetail>? bankDetails;

    BankDetailsModel({
        this.bankDetails,
    });

    factory BankDetailsModel.fromJson(Map<String, dynamic> json) => BankDetailsModel(
        bankDetails: json["bank_details"] == null ? [] : List<BankDetail>.from(json["bank_details"]!.map((x) => BankDetail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "bank_details": bankDetails == null ? [] : List<dynamic>.from(bankDetails!.map((x) => x.toJson())),
    };
}

class BankDetail {
    int? id;
    String? nameOfBank;
    String? nameOnAccount;
    String? accountNumber;
    String? userId;
    dynamic deletedAt;
    String? createdAt;
    String? updatedAt;
    int? selected;
    int? status;

    BankDetail({
        this.id,
        this.nameOfBank,
        this.nameOnAccount,
        this.accountNumber,
        this.userId,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.selected,
        this.status,
    });

    factory BankDetail.fromJson(Map<String, dynamic> json) => BankDetail(
        id: json["id"],
        nameOfBank: json["name_of_bank"],
        nameOnAccount: json["name_on_account"],
        accountNumber: json["account_number"],
        userId: json["user_id"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        selected: json["selected"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name_of_bank": nameOfBank,
        "name_on_account": nameOnAccount,
        "account_number": accountNumber,
        "user_id": userId,
        "deleted_at": deletedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "selected": selected,
        "status": status,
    };
}
