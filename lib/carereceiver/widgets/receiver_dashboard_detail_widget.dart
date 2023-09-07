// import 'dart:html';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:island_app/carereceiver/utils/colors.dart';

class ReceiverDashboardDetailWidget extends StatelessWidget {
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
  final String? zip;
  final String? imgProviderPath;
  final String? providerName;
  final double? providerRating;
  final String? providerComment;
  final Widget? documentsSection;

  const ReceiverDashboardDetailWidget({
    Key? key,
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
    // this.firstAdd,
    this.zip,
    this.imgProviderPath,
    this.providerName,
    this.providerRating,
    this.providerComment,
    this.documentsSection,
  }) : super(key: key);

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
                      imageUrl: imgPath.toString(),
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
              Text(
                title.toString(),
                style: TextStyle(
                  color: CustomColors.primaryText,
                  fontFamily: "Poppins",
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                services.toString(),
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
                  "$experience years experience \n \$$hour/hour \n  $address \n $zip",
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
              if (initialRating != null) ...[
                RatingBar.builder(
                  initialRating: initialRating!,
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
              ],
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
                  desc.toString(),
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
                  "$experience Years",
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
                      "Institue Name: $instituteName",
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
                      "Major: $major",
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
                      "From: $from",
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
                      to == "" ? "Time Period: Currently Studying" : "",
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
              documentsSection!,
              const SizedBox(
                height: 5,
              ),
              // Verified

              // Reviews
              const SizedBox(
                height: 15,
              ),
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
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
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
                              // Container(
                              //   child: ListTile(
                              //     leading: CircleAvatar(
                              //       radius: 15,
                              //       child: ClipRRect(
                              //         borderRadius: BorderRadius.circular(15),
                              //         child: ClipRRect(
                              //           borderRadius: BorderRadius.circular(15),
                              //           child: CachedNetworkImage(
                              //             width: 100,
                              //             height: 100,
                              //             fit: BoxFit.cover,
                              //             imageUrl: "http://192.168.0.244:9999/storage/avatar/yqrIEO0yATogxq2V3aLD1gy9IwoWwcMmltBf1UmV.png",
                              //             // imageUrl: imgProviderPath!,
                              //             placeholder: (context, url) => const CircularProgressIndicator(),
                              //             errorWidget: (context, url, error) => const Icon(Icons.error),
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //     title: Text("data"),
                              //   ),
                              // ),
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
                                            imageUrl: imgProviderPath.toString(),
                                            // imageUrl: imgProviderPath!,
                                            placeholder: (context, url) => const CircularProgressIndicator(),
                                            errorWidget: (context, url, error) => const Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // CircleAvatar(
                                    //   radius: 15,
                                    //   child: ClipRRect(
                                    //     borderRadius: BorderRadius.circular(15),
                                    //     child: ClipRRect(
                                    //       borderRadius: BorderRadius.circular(15),
                                    //       child: SvgPicture.network(
                                    //         imgProviderPath.toString(),
                                    //         placeholderBuilder: (context) => CircularProgressIndicator(),
                                    //         width: 100,
                                    //         height: 100,
                                    //       ),
                                    //       // CachedNetworkImage(
                                    //       //   width: 100,
                                    //       //   height: 100,
                                    //       //   fit: BoxFit.cover,
                                    //       //   // imageUrl: "http://192.168.0.244:9999/storage/avatar/yqrIEO0yATogxq2V3aLD1gy9IwoWwcMmltBf1UmV.png",
                                    //       //   imageUrl: imgProviderPath.toString(),
                                    //       //   placeholder: (context, url) => const CircularProgressIndicator(),
                                    //       //   errorWidget: (context, url, error) => const Icon(Icons.error),
                                    //       // ),
                                    //     ),
                                    //   ),
                                    // ),
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
                                  initialRating: providerRating!.toDouble(),
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
                                  onRatingUpdate: (rating) {
                                    // print(rating);
                                  },
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 100,
                                child: Text(
                                  providerComment.toString(),
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
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
