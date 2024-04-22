// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/models/manage_cards_model.dart';
import 'package:island_app/providers/user_provider.dart';
import 'package:island_app/utils/app_url.dart';

class SubscriptionProvider extends ChangeNotifier {
  List allPackages = [];
  getPackages() async {
    try {
      // print("user provider token ${RecieverUserProvider.userToken}");
      var response = await Dio().get(
        CareReceiverURl.serviceSubscribe,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${RecieverUserProvider.userToken}',
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        allPackages = response.data['subscription_package'];
        notifyListeners();
      }
    } on DioError {
      // print("error on get packages $e");
    }
  }

  Future get allcaheck async => allPackages;

  Map selectedPackage = {};

  setSelectedPackage(value) {
    selectedPackage = value;
    notifyListeners();
  }

  Future<Response> unSubscribe(id) async {
    var response = await Dio().post(
      CareReceiverURl.serviceReceiverUnSubscribe,
      data: {
        "subscription_id": id,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${RecieverUserProvider.userToken}',
          'Accept': 'application/json',
        },
      ),
    );
    return response;
  }

  CreditCard? cardValue;
  setSelectCard(value) {
    cardValue = value;
    addNewCard = false;
    notifyListeners();
  }

  bool addNewCard = false;
  setSelectCardToNull() {
    cardValue = null;
    addNewCard = true;
    notifyListeners();
  }

  // setSelectCardOnInit(value) {
  //   cardValue = value;
  // }

  Future<Response> subscribePackage(
    id,
    cardId,
    saveCard,
    nameCard,
    cardNumber,
    cardExpirationMonth,
    cardExpirationYear,
    cvv,
  ) async {
    var response = await Dio().post(
      CareReceiverURl.serviceReceiverUnSubscribe,
      data: {
        "subscription_id": id,
        "card_data": cardId,
        "save_card": saveCard,
        "name_on_card": nameCard,
        "card_number": cardNumber,
        "card_expiration_month": cardExpirationMonth,
        "card_expiration_year": cardExpirationYear,
        "cvv": cvv,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${RecieverUserProvider.userToken}',
          'Accept': 'application/json',
        },
      ),
    );
    return response;
  }
}
