// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/models/manage_cards_model.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/functions.dart';
import 'package:island_app/utils/http_handlers.dart';

class SubscriptionProvider extends ChangeNotifier {
  setDefault() {
    allPackages = [];
    selectedPackage = {};
    cardValue = null;
    addNewCard = false;
  }

  List allPackages = [];
  getPackages() async {
    var token = await getToken();
    try {
      var response = await getRequesthandler(
        url: CareReceiverURl.serviceSubscribe,
        token: token,
      );
      if (response.statusCode == 200) {
        allPackages = response.data['subscription_package'];
        notifyListeners();
      }
    } on DioError {
      //
    }
  }

  Future get allcaheck async => allPackages;

  Map selectedPackage = {};

  setSelectedPackage(value) {
    selectedPackage = value;
    notifyListeners();
  }

  Future<Response> unSubscribe(id) async {
    var token = await getToken();
    var response = await postRequesthandler(
      url: CareReceiverURl.serviceReceiverUnSubscribe,
      formData: FormData.fromMap({
        "subscription_id": id,
      }),
      token: token,
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
    var token = await getToken();
    var response = await postRequesthandler(
      url: CareReceiverURl.serviceReceiverUnSubscribe,
      formData: FormData.fromMap({
        "subscription_id": id,
        "card_data": cardId,
        "save_card": saveCard,
        "name_on_card": nameCard,
        "card_number": cardNumber,
        "card_expiration_month": cardExpirationMonth,
        "card_expiration_year": cardExpirationYear,
        "cvv": cvv,
      }),
      token: token,
    );
    return response;
  }
}
