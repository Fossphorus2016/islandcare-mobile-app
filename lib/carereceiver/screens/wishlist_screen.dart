// ignore_for_file: prefer_typing_uninitialized_variables, prefer_interpolation_to_compose_strings

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:island_app/carereceiver/models/favourite_get_model.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/carereceiver/widgets/recommendation_widget.dart';
import 'package:island_app/providers/user_provider.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/functions.dart';
import 'package:island_app/utils/http_handlers.dart';
import 'package:island_app/utils/navigation_service.dart';
import 'package:island_app/utils/routes_name.dart';
import 'package:island_app/widgets/loading_with_icon_button.dart';
import 'package:island_app/widgets/profile_not_approved_text.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<WishListProvider>(context, listen: false).fetchFavourite();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<WishListProvider, RecieverUserProvider>(
      builder: (context, wishListProvider, recieverUserProvider, child) {
        return Scaffold(
          backgroundColor: CustomColors.loginBg,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: CustomColors.primaryColor,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(
              "Favourites",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: "Rubik",
                color: CustomColors.white,
              ),
            ),
          ),
          body: SafeArea(
            child: recieverUserProvider.profileIsApprove()
                ? SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: [
                          // Card Box Widget
                          const SizedBox(height: 5),
                          wishListProvider.futureFavourite != null &&
                                  wishListProvider.futureFavourite!.data != null &&
                                  wishListProvider.futureFavourite!.data!.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: wishListProvider.futureFavourite!.data!.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    var item = wishListProvider.futureFavourite!.data![index];
                                    if (item.users != null &&
                                        item.userdetailproviders != null &&
                                        item.userdetails != null) {
                                      return RecommendationReceiverWidget(
                                        imgPath: item.users!.avatar != null
                                            ? "${AppUrl.webStorageUrl}" '/' + item.users!.avatar.toString()
                                            : "https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/832px-No-Image-Placeholder.svg.png",
                                        title:
                                            "${wishListProvider.foundProviders[index]['users']['first_name']} ${wishListProvider.foundProviders[index]['users']['last_name']}",
                                        experience: wishListProvider.foundProviders[index]['userdetailproviders']
                                                    ['experience'] ==
                                                null
                                            ? "0"
                                            : wishListProvider.foundProviders[index]['userdetailproviders']
                                                    ['experience']
                                                .toString(),
                                        hourly: wishListProvider.foundProviders[index]['userdetailproviders']
                                                        ['hourly_rate']
                                                    .toString() ==
                                                "null"
                                            ? "0"
                                            : wishListProvider.foundProviders[index]['userdetailproviders']
                                                    ['hourly_rate']
                                                .toString(),
                                        price: wishListProvider.foundProviders[index]['userdetailproviders']
                                                        ['hourly_rate']
                                                    .toString() ==
                                                "null"
                                            ? "0"
                                            : wishListProvider.foundProviders[index]['userdetailproviders']
                                                    ['hourly_rate']
                                                .toString(),
                                        dob: wishListProvider.isAdult(
                                            wishListProvider.foundProviders[index]['userdetails']['dob'] != null
                                                ? "${wishListProvider.foundProviders[index]['userdetails']['dob']}"
                                                : "00-00-0000"),
                                        isRatingShow: false,
                                        isFavouriteIcon: LoadingButtonWithIcon(
                                          onPressed: () async {
                                            if (item.users != null) {
                                              await wishListProvider.favourited(item.users!.id);
                                            }
                                            return false;
                                          },
                                          icon: wishListProvider.favouriteList.contains(
                                                  wishListProvider.foundProviders[index]['users']['id'].toString())
                                              ? Icon(
                                                  Icons.favorite_outline,
                                                  color: CustomColors.darkGreyRecommended,
                                                  size: 24,
                                                )
                                              : Icon(
                                                  Icons.favorite,
                                                  color: CustomColors.red,
                                                  size: 24,
                                                ),
                                        ),
                                        onTap: () {
                                          navigationService.push(
                                            RoutesName.recieverProviderDetail,
                                            arguments: {"id": item.users!.id.toString()},
                                          );
                                        },
                                      );
                                    }

                                    return wishListProvider.foundProviders[index]['data'] == 0
                                        ? Container()
                                        : Container();
                                  },
                                )
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(20),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromRGBO(26, 41, 96, 0.05999999865889549),
                                        offset: Offset(0, 4),
                                        blurRadius: 45,
                                      )
                                    ],
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                  ),
                                  child: const Text("Favourites Not Available..."),
                                ),
                        ],
                      ),
                    ),
                  )
                : const ProfileNotApprovedText(),
          ),
        );
      },
    );
  }
}

class WishListProvider extends ChangeNotifier {
  // final ratingController;
  double rating = 0;
  final double userRating = 3.0;
  final int ratingBarMode = 1;
  final double initialRating = 2.0;
  final bool isRTLMode = false;
  final bool isVertical = false;
  List providerList = [];

  FavouriteGetModel? futureFavourite;
  fetchFavourite() async {
    try {
      var token = await getToken();
      final response = await getRequesthandler(
        url: CareReceiverURl.serviceReceiverFavourite,
        token: token,
      );

      if (response != null && response.statusCode == 200) {
        var json = response.data as Map;
        var listOfProviders = json['data'] as List;

        providerList = listOfProviders;
        foundProviders = listOfProviders;
        futureFavourite = FavouriteGetModel.fromJson(response.data);
        notifyListeners();
      } else {
        showErrorToast("Failed to Favourites Provider List");
      }
    } catch (e) {
      showErrorToast("Failed to Favourites Provider List");
    }
  }

  // Favourite API
  var favouriteList = [];
  Future<void> favourited(providerId) async {
    var token = await getToken();
    var url = '${CareReceiverURl.serviceReceiverAddFavourite}?favourite_id=$providerId';
    var response = await postRequesthandler(
      url: url,
      token: token,
    );
    if (response != null && response.statusCode == 200) {
      if (response.data["data"].toString() == "1") {
        favouriteList.add(providerId);
        showSuccessToast("Added To Favourite");
      } else {
        favouriteList.remove(providerId);
        foundProviders.remove(providerId);
        showErrorToast("Remove from favourite");
      }

      futureFavourite = fetchFavourite();
      notifyListeners();
    }
  }

  // Search bar
  List foundProviders = [];
  void runFilter(String enteredKeyword) {
    List results = [];

    if (enteredKeyword.isEmpty) {
      results = providerList;
    } else {
      results = providerList
          .where((user) => user['first_name'].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    foundProviders = results;
    notifyListeners();
  }

  String isAdult(String enteredAge) {
    var birthDate = DateFormat('yyyy-mm-dd').parse(enteredAge);
    var today = DateTime.now();

    final difference = today.difference(birthDate).inDays;
    final year = difference / 365;
    return year.toStringAsFixed(0);
  }
}
