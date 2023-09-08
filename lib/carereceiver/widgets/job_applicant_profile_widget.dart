// import 'dart:html';

// ignore_for_file: unrelated_type_equality_checks, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:island_app/carereceiver/screens/chat_detail_screen.dart';
import 'package:island_app/carereceiver/screens/messages_screen.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
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
  // String? firstAdd;
  final Widget? documentsSection;
  final String? zip;
  final Widget? review;
  final String? imgProviderPath;
  final String? providerName;
  final double? providerRating;
  final String? providerComment;
  // int? isHired;
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
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: CustomColors.white,
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child:
                        //  Image.network(
                        //   imgPath.toString(),
                        // )
                        CachedNetworkImage(
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      imageUrl: widget.imgPath.toString(),
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
              Text(
                widget.title.toString(),
                style: TextStyle(
                  color: CustomColors.primaryText,
                  fontFamily: "Poppins",
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                widget.services.toString(),
                style: TextStyle(
                  color: CustomColors.primaryText,
                  fontFamily: "Poppins",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                // width: 130,
                child: Text(
                  "${widget.experience} years experience \n \$${widget.hour}/hour \n  ${widget.address} \n ${widget.zip}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: CustomColors.primaryText,
                    fontFamily: "Poppins",
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              RatingBar.builder(
                initialRating: widget.initialRating!,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                ignoreGestures: false,
                itemSize: 20,
                itemCount: 5,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  // print(rating);
                },
              ),
              const SizedBox(
                height: 10,
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
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
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
              const SizedBox(
                height: 5,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "${widget.experience} Years",
                  // textAlign: TextAlign.center,
                  style: TextStyle(
                    color: CustomColors.primaryText,
                    fontFamily: "Poppins",
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
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
              const SizedBox(
                height: 5,
              ),
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
                    // snapshot.data!.data![0].educations![index].to == ""
                    //     ?
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
                    // : Text(
                    //     "",
                    //     softWrap: true,
                    //     style: TextStyle(
                    //       height: 0,
                    //       color: CustomColors.hintText,
                    //       fontSize: 12,
                    //       fontFamily: "Rubik",
                    //       fontWeight: FontWeight.w200,
                    //     ),
                    //   ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "Background Varified",
                  style: TextStyle(
                    color: CustomColors.primaryText,
                    fontFamily: "Poppins",
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              // Verified
              widget.documentsSection!,
              // Reviews
              const SizedBox(
                height: 15,
              ),
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
                      const SizedBox(
                        height: 10,
                      ),
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
                    // widget.acceptBtn!,
                    // GestureDetector(
                    //   onTap: acceptApplicant,
                    //   child: Container(
                    //     height: 40,
                    //     width: MediaQuery.of(context).size.width * .4,
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(6),
                    //       color: isHired == 0 ? CustomColors.green : Color.fromARGB(255, 156, 202, 177),
                    //     ),
                    //     child: Center(
                    //       child: Text(
                    //         "Accept Applicant",
                    //         style: TextStyle(
                    //           color: CustomColors.white,
                    //           fontFamily: "Rubik",
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // : GestureDetector(
                    //     onTap: () {},
                    //     child: Container(
                    //       height: 40,
                    //       width: MediaQuery.of(context).size.width * .4,
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(6),
                    //         color: const Color.fromARGB(255, 156, 202, 177),
                    //       ),
                    //       child: Center(
                    //         child: Text(
                    //           "Accept Applicant",
                    //           style: TextStyle(
                    //             color: CustomColors.white,
                    //             fontFamily: "Rubik",
                    //             fontWeight: FontWeight.w500,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
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
                    // if (isHired == "0") ...[
                    //   Container(
                    //     width: MediaQuery.of(context).size.width * .9,
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         GestureDetector(
                    //           onTap: acceptApplicant,
                    //           child: Container(
                    //             height: 40,
                    //             width: MediaQuery.of(context).size.width * .4,
                    //             decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(6),
                    //               color: isHired == "1" ? Color.fromARGB(255, 156, 202, 177) : CustomColors.green,
                    //             ),
                    //             child: Center(
                    //               child: Text(
                    //                 "Accept Applicant",
                    //                 style: TextStyle(
                    //                   color: CustomColors.white,
                    //                   fontFamily: "Rubik",
                    //                   fontWeight: FontWeight.w500,
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //         GestureDetector(
                    //           onTap: declineApplicant,
                    //           child: Container(
                    //             height: 40,
                    //             width: MediaQuery.of(context).size.width * .4,
                    //             decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(6),
                    //               color: CustomColors.loginBorder,
                    //             ),
                    //             child: Center(
                    //               child: Text(
                    //                 "Decline Applicant",
                    //                 style: TextStyle(
                    //                   color: CustomColors.white,
                    //                   fontFamily: "Rubik",
                    //                   fontWeight: FontWeight.w500,
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ] else if (isHired == "1") ...[
                    //   Container(
                    //     width: MediaQuery.of(context).size.width * .9,
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Container(
                    //           height: 40,
                    //           width: MediaQuery.of(context).size.width * .4,
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(6),
                    //             color: isHired == "1" ? Color.fromARGB(255, 156, 202, 177) : CustomColors.green,
                    //           ),
                    //           child: Center(
                    //             child: Text(
                    //               "Accept Applicant",
                    //               style: TextStyle(
                    //                 color: CustomColors.white,
                    //                 fontFamily: "Rubik",
                    //                 fontWeight: FontWeight.w500,
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //         GestureDetector(
                    //           onTap: declineApplicant,
                    //           child: Container(
                    //             height: 40,
                    //             width: MediaQuery.of(context).size.width * .4,
                    //             decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(6),
                    //               color: CustomColors.loginBorder,
                    //             ),
                    //             child: Center(
                    //               child: Text(
                    //                 "Decline Applicant",
                    //                 style: TextStyle(
                    //                   color: CustomColors.white,
                    //                   fontFamily: "Rubik",
                    //                   fontWeight: FontWeight.w500,
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ],
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
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
