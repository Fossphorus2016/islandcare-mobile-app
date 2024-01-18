// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:island_app/carereceiver/utils/colors.dart';

class ReviewsGivenWidget extends StatelessWidget {
  final String? name;
  var rating;
  final String? comment;
  var email;

  ReviewsGivenWidget({
    Key? key,
    this.name,
    this.rating,
    this.comment,
    this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CustomColors.borderLight,
            width: 0.1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * .3,
                alignment: Alignment.center,
                child: Text(
                  name.toString(),
                  style: TextStyle(
                    color: CustomColors.primaryText,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              if (email != null) ...[
                Container(
                  width: MediaQuery.of(context).size.width * .3,
                  alignment: Alignment.center,
                  child: Text(
                    email.toString(),
                    style: TextStyle(
                      color: CustomColors.hintText,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ],
          ),
          Container(
              width: MediaQuery.of(context).size.width * .3,
              alignment: Alignment.center,
              child: RatingBar.builder(
                initialRating: rating.toDouble(),
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
              )),
          Container(
            width: MediaQuery.of(context).size.width * .3,
            alignment: Alignment.center,
            child: Text(comment.toString()),
          ),
        ],
      ),
    );
  }
}
