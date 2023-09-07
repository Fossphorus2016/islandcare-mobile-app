// To parse this JSON data, do
//
//     final addCardModel = addCardModelFromJson(jsonString);

import 'dart:convert';

AddCardModel addCardModelFromJson(String str) => AddCardModel.fromJson(json.decode(str));

String addCardModelToJson(AddCardModel data) => json.encode(data.toJson());

class AddCardModel {
    String? nameOnCard;
    String? cardNumber;
    String? cardExpirationMonth;
    String? cardExpirationYear;
    String? cvv;

    AddCardModel({
        this.nameOnCard,
        this.cardNumber,
        this.cardExpirationMonth,
        this.cardExpirationYear,
        this.cvv,
    });

    factory AddCardModel.fromJson(Map<String, dynamic> json) => AddCardModel(
        nameOnCard: json["name_on_card"],
        cardNumber: json["card_number"],
        cardExpirationMonth: json["card_expiration_month"],
        cardExpirationYear: json["card_expiration_year"],
        cvv: json["cvv"],
    );

    Map<String, dynamic> toJson() => {
        "name_on_card": nameOnCard,
        "card_number": cardNumber,
        "card_expiration_month": cardExpirationMonth,
        "card_expiration_year": cardExpirationYear,
        "cvv": cvv,
    };
}
