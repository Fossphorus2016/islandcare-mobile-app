// ignore_for_file: unrelated_type_equality_checks, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:island_app/carereceiver/screens/chat_detail_screen.dart';
import 'package:island_app/carereceiver/screens/messages_screen.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/utils/utils.dart';
import 'package:provider/provider.dart';

class JobApplicantProfileWidget extends StatefulWidget {
  final Map? dataMap;
  final String id;
  final String? imgPath;
  final String? title;
  final String? services;
  final String? experience;
  final String? hour;
  final String? address;
  final dynamic initialRating;
  final String? desc;
  final String? instituteName;
  final String? major;
  final String? from;
  final String? to;
  final Widget? documentsSection;
  final String? zip;
  final Widget? review;
  final String? imgProviderPath;
  final String? providerName;
  final double? providerRating;
  final String? providerComment;
  final Function()? acceptApplicant;
  final Function()? declineApplicant;
  final Widget? acceptBtn;
  Function()? acceptBtnFunc;
  Color? acceptBtnColor;

  JobApplicantProfileWidget({
    Key? key,
    required this.dataMap,
    required this.id,
    this.imgPath,
    this.title,
    this.services,
    this.experience,
    this.hour,
    this.address,
    this.initialRating = 0.0,
    this.desc,
    this.instituteName,
    this.major,
    this.from,
    this.to,
    this.zip,
    this.review,
    this.imgProviderPath,
    this.providerName,
    this.providerRating,
    this.providerComment,
    this.acceptApplicant,
    this.declineApplicant,
    this.acceptBtn,
    this.acceptBtnFunc,
    this.acceptBtnColor,
    required this.documentsSection,
  }) : super(key: key);

  @override
  State<JobApplicantProfileWidget> createState() => _JobApplicantProfileWidgetState();
}

class _JobApplicantProfileWidgetState extends State<JobApplicantProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 250,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          color: ServiceRecieverColor.primaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(08),
                      child: CachedNetworkImage(
                        width: 130,
                        height: 110,
                        alignment: Alignment.center,
                        imageUrl: widget.imgPath.toString(),
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Rubik",
                              fontWeight: FontWeight.w700,
                              color: CustomColors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            widget.services.toString(),
                            style: TextStyle(fontSize: 14, fontFamily: "Rubik", fontWeight: FontWeight.w400, color: CustomColors.white),
                          ),
                          const SizedBox(width: 10),
                          RatingBar(
                            ignoreGestures: true,
                            itemCount: 5,
                            itemSize: 26,
                            initialRating: widget.initialRating! == null ? 0.0 : double.parse(widget.initialRating.toString()),
                            minRating: 0,
                            ratingWidget: RatingWidget(
                              full: const Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                              ),
                              half: const Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                              ),
                              empty: const Icon(
                                Icons.star_rounded,
                                color: Colors.grey,
                              ),
                            ),
                            onRatingUpdate: (rating) {
                              // print(rating);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(13, 0, 0, 0),
                          blurRadius: 4.0,
                          spreadRadius: 2.0,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(6),
                        bottomRight: Radius.circular(6),
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                    ),
                    child: Text(
                      "${widget.hour}/hour ",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: CustomColors.primaryTextLight,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                      // margin: const EdgeInsets.symmetric(
                      //     horizontal: 14),
                      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(13, 0, 0, 0),
                            blurRadius: 4.0,
                            spreadRadius: 2.0,
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(6),
                          bottomRight: Radius.circular(6),
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                      ),
                      child: Text(
                        "${widget.experience} years experience",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: CustomColors.primaryTextLight,
                        ),
                      )),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    // margin: const EdgeInsets.symmetric(
                    //     horizontal: 14),
                    padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(13, 0, 0, 0),
                          blurRadius: 4.0,
                          spreadRadius: 2.0,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(6),
                        bottomRight: Radius.circular(6),
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 3, right: 5),
                              child: Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: CustomColors.primaryTextLight,
                              ),
                            ),
                          ),
                          TextSpan(
                            text: "${widget.address}",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: CustomColors.primaryTextLight,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "About Olivia",
                  style: TextStyle(
                    color: CustomColors.primaryText,
                    fontFamily: "Poppins",
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.desc.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: CustomColors.primaryText,
                    fontFamily: "Poppins",
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "Experience",
                  style: TextStyle(
                    color: CustomColors.primaryText,
                    fontFamily: "Poppins",
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "${widget.experience} Years",
                  style: TextStyle(
                    color: CustomColors.primaryText,
                    fontFamily: "Poppins",
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "Education",
                  style: TextStyle(
                    color: CustomColors.primaryText,
                    fontFamily: "Poppins",
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: CustomColors.paraColor,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Institue Name: ${widget.instituteName}",
                      softWrap: true,
                      style: TextStyle(
                        color: CustomColors.hintText,
                        fontSize: 14,
                        fontFamily: "Rubik",
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Major: ${widget.major}",
                      softWrap: true,
                      style: TextStyle(
                        color: CustomColors.hintText,
                        fontSize: 12,
                        fontFamily: "Rubik",
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "From: ${widget.from}",
                      softWrap: true,
                      style: TextStyle(
                        color: CustomColors.hintText,
                        fontSize: 12,
                        fontFamily: "Rubik",
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    Text(
                      widget.to == "" ? "Time Period: Currently Studying" : "",
                      softWrap: true,
                      style: TextStyle(
                        height: 2,
                        color: CustomColors.hintText,
                        fontSize: 12,
                        fontFamily: "Rubik",
                        fontWeight: FontWeight.w200,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "Background Verified",
                  style: TextStyle(
                    color: CustomColors.primaryText,
                    fontFamily: "Poppins",
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              // Verified
              widget.documentsSection!,
              // Reviews
              const SizedBox(height: 15),
              if (widget.review != null) ...[
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: CustomColors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 5),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: CustomColors.paraColor,
                              width: .5,
                            ),
                          ),
                        ),
                        child: Text(
                          "Reviews",
                          style: TextStyle(
                            fontFamily: "Rubik",
                            fontSize: 18,
                            color: CustomColors.primaryText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Name",
                                style: TextStyle(
                                  fontFamily: "Rubik",
                                  fontSize: 14,
                                  color: CustomColors.primaryTextLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "Ratings",
                                style: TextStyle(
                                  fontFamily: "Rubik",
                                  fontSize: 14,
                                  color: CustomColors.primaryTextLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "Comment",
                                style: TextStyle(
                                  fontFamily: "Rubik",
                                  fontSize: 14,
                                  color: CustomColors.primaryTextLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          widget.review!
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: widget.acceptBtnFunc,
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * .4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: widget.acceptBtnColor == 0 ? CustomColors.green : CustomColors.red,
                        ),
                        child: Center(
                          child: Text(
                            "Accept Applicant",
                            style: TextStyle(
                              color: CustomColors.white,
                              fontFamily: "Rubik",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.declineApplicant,
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * .4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: CustomColors.loginBorder,
                        ),
                        child: Center(
                          child: Text(
                            "Decline Applicant",
                            style: TextStyle(
                              color: CustomColors.white,
                              fontFamily: "Rubik",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Provider.of<ChatProvider>(context, listen: false).setActiveChat("new", widget.dataMap);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatDetailPage()));
                },
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: CustomColors.primaryColor,
                    ),
                    child: const Center(
                        child: Text(
                      "Chat with User",
                      style: TextStyle(color: Colors.white),
                    ))),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
