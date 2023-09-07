// To parse this JSON data, do
//
//     final creditCardModel = creditCardModelFromJson(jsonString);

import 'dart:convert';

CreditCardModel creditCardModelFromJson(String str) => CreditCardModel.fromJson(json.decode(str));

String creditCardModelToJson(CreditCardModel data) => json.encode(data.toJson());

class CreditCardModel {
    List<CreditCard>? creditCards;

    CreditCardModel({
        this.creditCards,
    });

    factory CreditCardModel.fromJson(Map<String, dynamic> json) => CreditCardModel(
        creditCards: json["credit-cards"] == null ? [] : List<CreditCard>.from(json["credit-cards"]!.map((x) => CreditCard.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "credit-cards": creditCards == null ? [] : List<dynamic>.from(creditCards!.map((x) => x.toJson())),
    };
}

class CreditCard {
    int? id;
    int? userId;
    String? nameOnCard;
    String? cvv;
    String? cardNumber;
    int? cardExpirationYear;
    int? cardExpirationMonth;
    DateTime? createdAt;
    DateTime? updatedAt;
    dynamic deletedAt;

    CreditCard({
        this.id,
        this.userId,
        this.nameOnCard,
        this.cvv,
        this.cardNumber,
        this.cardExpirationYear,
        this.cardExpirationMonth,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
    });

    factory CreditCard.fromJson(Map<String, dynamic> json) => CreditCard(
        id: json["id"],
        userId: json["user_id"],
        nameOnCard: json["name_on_card"],
        cvv: json["cvv"],
        cardNumber: json["card_number"],
        cardExpirationYear: json["card_expiration_year"],
        cardExpirationMonth: json["card_expiration_month"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name_on_card": nameOnCard,
        "cvv": cvv,
        "card_number": cardNumber,
        "card_expiration_year": cardExpirationYear,
        "card_expiration_month": cardExpirationMonth,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
    };
}
