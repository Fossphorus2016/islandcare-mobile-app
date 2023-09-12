// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:island_app/carereceiver/utils/colors.dart';

class ReviewsListWidget extends StatelessWidget {
  String? imgUrl;
  String? providerName;
  var reviewRating;
  String? rating;
  ReviewsListWidget({
    Key? key,
    this.imgUrl,
    this.providerName,
    this.reviewRating,
    this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: CustomColors.paraColor,
            width: .5,
          ),
          bottom: BorderSide(
            color: CustomColors.paraColor,
            width: .5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 15,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        imageUrl: imgUrl.toString(),
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  providerName.toString(),
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                    color: CustomColors.primaryText,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 100,
            child: RatingBar.builder(
              initialRating: reviewRating.toDouble(),
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              ignoreGestures: false,
              itemSize: 15,
              itemCount: 5,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {},
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: 100,
            child: Text(
              rating.toString(),
              style: TextStyle(
                fontSize: 13,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
                color: CustomColors.primaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
