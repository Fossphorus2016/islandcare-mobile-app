// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:island_app/carereceiver/utils/colors.dart';

// ignore: must_be_immutable
class ReviewsGivenWidget extends StatelessWidget {
  String? name;
  var rating;
  String? comment;
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
                  // "Babysitters",
                  style: TextStyle(
                    color: CustomColors.primaryText,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * .3,
                alignment: Alignment.center,
                child: Text(
                  email.toString(),
                  // "One-Time",
                  style: TextStyle(
                    color: CustomColors.hintText,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
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
                  // print(rating);
                  rating = rating;
                },
              )),
          Container(
            width: MediaQuery.of(context).size.width * .3,
            alignment: Alignment.center,
            child: Text(comment.toString()),
          ),
          // Row(
          //   children: [
          //     Container(
          //       padding: const EdgeInsets.symmetric(horizontal: 8),
          //       height: 24,
          //       // width: 70,
          //       // decoration: BoxDecoration(
          //       //   borderRadius: BorderRadius.circular(2),
          //       //   color: CustomColors.blackLight,
          //       // ),
          //       child: Center(
          //         child: Text(
          //           comment.toString(),
          //           style: TextStyle(
          //             color: CustomColors.black,
          //             fontSize: 12,
          //             fontFamily: "Poppins",
          //             fontWeight: FontWeight.w500,
          //           ),
          //         ),
          //       ),
          //     ),
          //     const SizedBox(
          //       width: 10,
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }
}
