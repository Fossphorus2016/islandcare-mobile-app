// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/utils/utils.dart';

class RecommendationReceiverWidget extends StatelessWidget {
  final String? imgPath;
  final String? title;
  final String? experience;
  final String? hourly;
  final dynamic dob;
  final String? price;
  final Function()? onTap;
  dynamic ratingCount = 0.0;
  int? isFavourite = 0;
  final Function()? checkFavourite;
  final Widget? isFavouriteIcon;
  final dynamic isRatingShow;

  RecommendationReceiverWidget({
    super.key,
    this.imgPath,
    this.title,
    this.experience,
    this.hourly,
    this.dob,
    this.price,
    this.onTap,
    this.ratingCount,
    this.isFavourite,
    this.checkFavourite,
    this.isFavouriteIcon,
    this.isRatingShow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: imgPath != null
                          ? CachedNetworkImage(
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                              imageUrl: imgPath!,
                              placeholder: (context, url) => const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            )
                          : Container(
                              width: 50,
                              height: 50,
                              color: CustomColors.primaryColor,
                              child: Center(
                                child: Text(
                                  title![0].toString().toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title!,
                        style: TextStyle(
                          color: CustomColors.primaryText,
                          fontSize: 16,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      isRatingShow == true
                          ? RatingBar.builder(
                              initialRating: ratingCount.toDouble(),
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              ignoreGestures: true,
                              itemSize: 14,
                              itemCount: 5,
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                rating = rating;
                              },
                            )
                          : Container(),
                      Text(
                        "Experience ${experience!} Year",
                        style: TextStyle(
                          color: CustomColors.darkGreyRecommended,
                          fontSize: 12,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Hourly Rate ${hourly!} \$/hour",
                        style: TextStyle(
                          color: CustomColors.darkGreyRecommended,
                          fontSize: 12,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "$dob Years Old",
                        style: TextStyle(
                          color: CustomColors.darkGreyRecommended,
                          fontSize: 12,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                child: isFavouriteIcon,
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onTap,
                child: Container(
                  height: 43,
                  width: 110,
                  decoration: BoxDecoration(
                    color: ServiceRecieverColor.redButton,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      "View More",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: CustomColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.1849999428,
                    color: CustomColors.primaryText,
                  ),
                  children: [
                    TextSpan(
                      text: '$price',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.2575,
                        color: CustomColors.primaryText,
                      ),
                    ),
                    TextSpan(
                      text: ' \$/hour',
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        height: 1.185,
                        color: CustomColors.primaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
