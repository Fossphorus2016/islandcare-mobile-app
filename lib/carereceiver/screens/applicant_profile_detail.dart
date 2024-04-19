// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:island_app/carereceiver/screens/chat_detail_screen.dart';
import 'package:island_app/carereceiver/screens/messages_screen.dart';
import 'package:island_app/providers/user_provider.dart';
import 'package:island_app/res/app_url.dart';
import 'package:island_app/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:island_app/carereceiver/models/applicant_profile_detail-model.dart';
import 'package:island_app/carereceiver/utils/colors.dart';

class ApplicantProfileDetail extends StatefulWidget {
  final String jobTitle;
  final String jobId;
  final String profileId;
  const ApplicantProfileDetail({
    Key? key,
    required this.jobTitle,
    required this.jobId,
    required this.profileId,
  }) : super(key: key);

  @override
  State<ApplicantProfileDetail> createState() => _ApplicantProfileDetailState();
}

class _ApplicantProfileDetailState extends State<ApplicantProfileDetail> {
  // Service Receiver Dashboard
  // int? ratings;
  ApplicantDetailProfileModel? futureapplicantProfileDetail;
  var id;
  var isHiredd;

  // var fetchData;

  fetchApplicantProfileDetailModel() async {
    try {
      var token = await Provider.of<RecieverUserProvider>(context, listen: false).getUserToken();
      //
      final response = await Dio().get(
        "${CareReceiverURl.serviceReceiverApplicantDetails}/${widget.jobTitle}/${widget.profileId}/${widget.jobId}",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      // print(response.data);
      if (response.statusCode == 200) {
        // fetchData = response.data;
        Map<String, dynamic> map = response.data;
        // var ratingList = map['data'][0]["ratings"];
        // var jobname = map["job_title"];
        // var id = map['data'][0]["id"];
        // var hired = map['is_hired'];
        // var sumRating = map['data'][0]['ratings'];
        // double sum = 0;
        // for (int i = 0; i < sumRating.length; i++) {
        //   sum += sumRating[i]['rating'];
        // }
        // int average = sum ~/ sumRating.length;
        // setState(() {
        //   // ratings = average;
        // });
        setState(() {
          futureapplicantProfileDetail = ApplicantDetailProfileModel.fromJson(response.data);
        });
      } else {
        throw 'Failed to load Applicant Profile Details';
      }
    } catch (e) {
      customErrorSnackBar(context, "something went wrong please try again later");
    }
  }

  acceptApplicant() async {
    var token = await Provider.of<RecieverUserProvider>(context, listen: false).getUserToken();
    var formData = FormData.fromMap(
      {
        "_method": "put",
      },
    );
    Dio dio = Dio();

    try {
      var response = await dio.post(
        '${CareReceiverURl.serviceReceiverApplicantionApplicantsAccept}/${widget.profileId}/${widget.jobId}',
        data: formData,
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
      if (response.statusCode == 200) {
        customSuccesSnackBar(
          context,
          "Applicant Hired Successfully",
        );
      } else {
        customErrorSnackBar(
          context,
          "Server Error Occured!",
        );
      }
    } catch (e) {
      customErrorSnackBar(
        context,
        e.toString(),
      );
    }
  }

  declineApplicant() async {
    var token = await Provider.of<RecieverUserProvider>(context, listen: false).getUserToken();
    var formData = FormData.fromMap(
      {
        "_method": "put",
      },
    );
    Dio dio = Dio();
    try {
      var response = await dio.post(
        '${AppUrl.webBaseURL}/api/service-receiver-my-application-applicant-details-reject/${widget.profileId}/${widget.jobId}',
        data: formData,
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
      if (response.statusCode == 200) {
        customSuccesSnackBar(
          context,
          "Applicant Declined Successfully",
        );
      } else {
        customErrorSnackBar(
          context,
          "Server Error Occured!",
        );
      }
    } catch (e) {
      customErrorSnackBar(
        context,
        e.toString(),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchApplicantProfileDetailModel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(30, 0, 0, 0),
                      offset: Offset(2, 2),
                      spreadRadius: 1,
                      blurRadius: 7,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: CustomColors.primaryColor,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
          title: Text(
            "Job Applicants Profile",
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              fontFamily: "Rubik",
              color: CustomColors.primaryText,
            ),
          ),
        ),
        body: futureapplicantProfileDetail != null
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    if (futureapplicantProfileDetail!.isVerified == true) ...[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DottedBorder(
                          radius: const Radius.circular(10),
                          borderType: BorderType.RRect,
                          color: const Color(0xff009ef7),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xfff1faff),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              leading: SvgPicture.asset(
                                "assets/images/icons/account-verified.svg",
                              ),
                              title: Text(
                                "Verified Service Provider",
                                style: TextStyle(
                                  color: CustomColors.primaryText,
                                  fontSize: 12,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                "This service provider is verified, ensuring an added layer of safety and trust within our community. Thank you for choosing a secure and trustworthy caregiving experience.",
                                style: TextStyle(
                                  color: CustomColors.primaryText,
                                  fontSize: 10,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                    Container(
                      height: 260,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      color: ServiceGiverColor.black,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 110,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(08),
                                  child: CachedNetworkImage(
                                    width: 130,
                                    height: 110,
                                    alignment: Alignment.center,
                                    imageUrl: "${AppUrl.webStorageUrl}/${futureapplicantProfileDetail!.data!.avatar.toString()}",
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      if (futureapplicantProfileDetail!.isVerified == true) ...[
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(05)),
                                            child: const Icon(
                                              Icons.verified_outlined,
                                              color: Colors.blue,
                                              size: 28,
                                            ),
                                          ),
                                        ),
                                      ],
                                      Text(
                                        "${futureapplicantProfileDetail!.data!.firstName.toString()} ${futureapplicantProfileDetail!.data!.lastName.toString()}",
                                        style: TextStyle(fontSize: 20, fontFamily: "Rubik", fontWeight: FontWeight.w700, color: CustomColors.white),
                                      ),
                                      const SizedBox(width: 10),
                                      // Text(
                                      //   futureapplicantProfileDetail!.data!.email.toString(),
                                      //   style: TextStyle(
                                      //     fontSize: 12,
                                      //     fontFamily: "Rubik",
                                      //     fontWeight: FontWeight.w400,
                                      //     color: CustomColors.white,
                                      //   ),
                                      // ),
                                      // const SizedBox(width: 10),
                                      if (futureapplicantProfileDetail!.data!.avgRating != null) ...[
                                        RatingBar(
                                          ignoreGestures: true,
                                          itemCount: 5,
                                          itemSize: 20,
                                          initialRating: futureapplicantProfileDetail!.data!.avgRating!['rating'] == null ? 0.0 : double.parse(futureapplicantProfileDetail!.data!.avgRating!['rating'].toString()),
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: [
                                const SizedBox(width: 05),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
                                    child: Flex(
                                      direction: Axis.horizontal,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.location_on_outlined,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                        if (futureapplicantProfileDetail!.data!.userdetail!.address != null) ...[
                                          Flexible(
                                            child: Text(
                                              futureapplicantProfileDetail!.data!.userdetail!.address.toString(),
                                              maxLines: 6,
                                              overflow: TextOverflow.visible,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ] else ...[
                                          const Text(
                                            "Not Available",
                                            maxLines: 6,
                                            overflow: TextOverflow.visible,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            height: 40,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Profile Completion",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Rubik",
                                              fontWeight: FontWeight.w400,
                                              color: CustomColors.white,
                                            ),
                                          ),
                                          Text(
                                            "${futureapplicantProfileDetail!.percentage}%",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Rubik",
                                              fontWeight: FontWeight.w400,
                                              color: CustomColors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 05),
                                      LinearProgressIndicator(
                                        minHeight: 08,
                                        borderRadius: BorderRadius.circular(08),
                                        value: futureapplicantProfileDetail!.percentage != null ? (futureapplicantProfileDetail!.percentage! / 100) : 00,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.pink.shade400),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Bages
                    if (futureapplicantProfileDetail!.data!.userdetailprovider!.badge != null) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                          child: Wrap(
                            spacing: 05,
                            runSpacing: 05,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.center,
                            children: List.generate(futureapplicantProfileDetail!.data!.userdetailprovider!.badge!.length, (index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(500),
                                child: CachedNetworkImage(
                                  height: 50,
                                  imageUrl: "${AppUrl.webStorageUrl}/${futureapplicantProfileDetail!.data!.userdetailprovider!.badge![index]}",
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Personal Information",
                            style: TextStyle(
                              color: CustomColors.primaryText,
                              fontFamily: "Rubik",
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              color: CustomColors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Name",
                                      style: TextStyle(
                                        color: ServiceGiverColor.black,
                                        fontSize: 10,
                                        fontFamily: "Rubik",
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "${futureapplicantProfileDetail!.data!.firstName} ${futureapplicantProfileDetail!.data!.lastName}",
                                      style: TextStyle(
                                        color: CustomColors.hintText,
                                        fontSize: 16,
                                        fontFamily: "Rubik",
                                        fontWeight: FontWeight.w200,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Gender
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              color: CustomColors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Gender",
                                      style: TextStyle(
                                        color: ServiceGiverColor.black,
                                        fontSize: 10,
                                        fontFamily: "Rubik",
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    futureapplicantProfileDetail!.data!.userdetail!.gender.toString() != "null"
                                        ? Text(
                                            (futureapplicantProfileDetail!.data!.userdetail!.gender.toString() == "1")
                                                ? "Male"
                                                : (futureapplicantProfileDetail!.data!.userdetail!.gender.toString() == "2")
                                                    ? "Female"
                                                    : "Not Available",
                                            style: TextStyle(
                                              color: CustomColors.hintText,
                                              fontSize: 16,
                                              fontFamily: "Rubik",
                                              fontWeight: FontWeight.w200,
                                            ),
                                          )
                                        : Text(
                                            "Not Available",
                                            style: TextStyle(
                                              color: CustomColors.hintText,
                                              fontSize: 16,
                                              fontFamily: "Rubik",
                                              fontWeight: FontWeight.w200,
                                            ),
                                          ),
                                  ],
                                ),
                                const Column(),
                              ],
                            ),
                          ),
                          // Parish
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              color: CustomColors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Parish",
                                      style: TextStyle(
                                        color: ServiceGiverColor.black,
                                        fontSize: 10,
                                        fontFamily: "Rubik",
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      futureapplicantProfileDetail!.data!.userdetail!.area.toString() == "0"
                                          ? "East"
                                          : futureapplicantProfileDetail!.data!.userdetail!.area.toString() == "1"
                                              ? "Central"
                                              : futureapplicantProfileDetail!.data!.userdetail!.area.toString() == "2"
                                                  ? "West"
                                                  : "Not Available",
                                      style: TextStyle(
                                        color: CustomColors.hintText,
                                        fontSize: 16,
                                        fontFamily: "Rubik",
                                        fontWeight: FontWeight.w200,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Services
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              color: CustomColors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Service Provided",
                                      style: TextStyle(
                                        color: ServiceGiverColor.black,
                                        fontSize: 10,
                                        fontFamily: "Rubik",
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      futureapplicantProfileDetail!.data!.userdetail!.service!.name.toString() == "null" ? "Not Available" : futureapplicantProfileDetail!.data!.userdetail!.service!.name.toString(),
                                      style: TextStyle(
                                        color: CustomColors.hintText,
                                        fontSize: 16,
                                        fontFamily: "Rubik",
                                        fontWeight: FontWeight.w200,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          //  Experience
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              color: CustomColors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Years of Experience",
                                        style: TextStyle(
                                          color: ServiceGiverColor.black,
                                          fontSize: 10,
                                          fontFamily: "Rubik",
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        futureapplicantProfileDetail!.data!.userdetailprovider!.experience.toString(),
                                        softWrap: true,
                                        style: TextStyle(color: CustomColors.hintText, fontSize: 16, fontFamily: "Rubik", fontWeight: FontWeight.w200),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Hourly
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              color: CustomColors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Hourly Rate",
                                        style: TextStyle(
                                          color: ServiceGiverColor.black,
                                          fontSize: 10,
                                          fontFamily: "Rubik",
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      futureapplicantProfileDetail!.data!.userdetailprovider!.hourlyRate.toString() != "null"
                                          ? Text(
                                              "\$ ${futureapplicantProfileDetail!.data!.userdetailprovider!.hourlyRate.toString()}",
                                              softWrap: true,
                                              style: TextStyle(
                                                color: CustomColors.hintText,
                                                fontSize: 16,
                                                fontFamily: "Rubik",
                                                fontWeight: FontWeight.w200,
                                              ),
                                            )
                                          : Text(
                                              "Not Available",
                                              softWrap: true,
                                              style: TextStyle(
                                                color: CustomColors.hintText,
                                                fontSize: 16,
                                                fontFamily: "Rubik",
                                                fontWeight: FontWeight.w200,
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Additional Service
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              color: CustomColors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Additional Services",
                                        style: TextStyle(
                                          color: ServiceGiverColor.black,
                                          fontSize: 10,
                                          fontFamily: "Rubik",
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      futureapplicantProfileDetail!.data!.userdetailprovider!.keywords.toString() == "null"
                                          ? Text(
                                              "Not Available",
                                              softWrap: true,
                                              style: TextStyle(
                                                color: CustomColors.hintText,
                                                fontSize: 16,
                                                fontFamily: "Rubik",
                                                fontWeight: FontWeight.w200,
                                              ),
                                            )
                                          : Text(
                                              futureapplicantProfileDetail!.data!.userdetailprovider!.keywords.toString() == "null" ? "Required" : futureapplicantProfileDetail!.data!.userdetailprovider!.keywords.toString(),
                                              softWrap: true,
                                              style: TextStyle(
                                                color: CustomColors.hintText,
                                                fontSize: 16,
                                                fontFamily: "Rubik",
                                                fontWeight: FontWeight.w200,
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Education
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              color: CustomColors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Education",
                                        style: TextStyle(
                                          color: ServiceGiverColor.black,
                                          fontSize: 10,
                                          fontFamily: "Rubik",
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      if (futureapplicantProfileDetail!.data!.educations!.isEmpty) ...[
                                        Text(
                                          "Not Available",
                                          softWrap: true,
                                          style: TextStyle(
                                            color: CustomColors.hintText,
                                            fontSize: 16,
                                            fontFamily: "Rubik",
                                            fontWeight: FontWeight.w200,
                                          ),
                                        )
                                      ],
                                      ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: futureapplicantProfileDetail!.data!.educations!.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                            margin: const EdgeInsets.symmetric(vertical: 5),
                                            decoration: BoxDecoration(
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
                                                  "Institue Name: ${futureapplicantProfileDetail!.data!.educations![index].name}",
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
                                                  "Degree/Certification: ${futureapplicantProfileDetail!.data!.educations![index].major}",
                                                  softWrap: true,
                                                  style: TextStyle(
                                                    color: CustomColors.hintText,
                                                    fontSize: 12,
                                                    fontFamily: "Rubik",
                                                    fontWeight: FontWeight.w200,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  "From: ${futureapplicantProfileDetail!.data!.educations![index].from}",
                                                  softWrap: true,
                                                  style: TextStyle(
                                                    color: CustomColors.hintText,
                                                    fontSize: 12,
                                                    fontFamily: "Rubik",
                                                    fontWeight: FontWeight.w200,
                                                  ),
                                                ),
                                                futureapplicantProfileDetail!.data!.educations![index].to == ""
                                                    ? Text(
                                                        "Time Period: Currently Studying",
                                                        softWrap: true,
                                                        style: TextStyle(
                                                          height: 2,
                                                          color: CustomColors.hintText,
                                                          fontSize: 12,
                                                          fontFamily: "Rubik",
                                                          fontWeight: FontWeight.w200,
                                                        ),
                                                      )
                                                    : Text(
                                                        futureapplicantProfileDetail!.data!.educations![index].to.toString(),
                                                        softWrap: true,
                                                        style: TextStyle(
                                                          height: 0,
                                                          color: CustomColors.hintText,
                                                          fontSize: 12,
                                                          fontFamily: "Rubik",
                                                          fontWeight: FontWeight.w200,
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // User Information
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              color: CustomColors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "User Information",
                                        style: TextStyle(
                                          color: ServiceGiverColor.black,
                                          fontSize: 10,
                                          fontFamily: "Rubik",
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      futureapplicantProfileDetail!.data!.userdetail!.userInfo.toString() == "null"
                                          ? Text(
                                              "Not Available",
                                              softWrap: true,
                                              style: TextStyle(
                                                color: CustomColors.hintText,
                                                fontSize: 16,
                                                fontFamily: "Rubik",
                                                fontWeight: FontWeight.w200,
                                              ),
                                            )
                                          : Text(
                                              futureapplicantProfileDetail!.data!.userdetail!.userInfo.toString() == "null" ? "Required" : futureapplicantProfileDetail!.data!.userdetail!.userInfo.toString(),
                                              softWrap: true,
                                              style: TextStyle(
                                                color: CustomColors.hintText,
                                                fontSize: 16,
                                                fontFamily: "Rubik",
                                                fontWeight: FontWeight.w200,
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Availability
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              color: CustomColors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Availability",
                                        style: TextStyle(
                                          color: ServiceGiverColor.black,
                                          fontSize: 10,
                                          fontFamily: "Rubik",
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      futureapplicantProfileDetail!.data!.userdetailprovider!.availability.toString() == "null"
                                          ? Text(
                                              "Not Available",
                                              softWrap: true,
                                              style: TextStyle(
                                                color: CustomColors.hintText,
                                                fontSize: 16,
                                                fontFamily: "Rubik",
                                                fontWeight: FontWeight.w200,
                                              ),
                                            )
                                          : Text(
                                              futureapplicantProfileDetail!.data!.userdetailprovider!.availability.toString() == "null" ? "Required" : futureapplicantProfileDetail!.data!.userdetailprovider!.availability.toString(),
                                              softWrap: true,
                                              style: TextStyle(
                                                color: CustomColors.hintText,
                                                fontSize: 16,
                                                fontFamily: "Rubik",
                                                fontWeight: FontWeight.w200,
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (futureapplicantProfileDetail!.data!.ratings != null && futureapplicantProfileDetail!.data!.ratings!.isNotEmpty) ...[
                            const SizedBox(height: 30),
                            const Text(
                              "Reviews",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                              decoration: BoxDecoration(
                                color: ServiceGiverColor.black,
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
                                  Text(
                                    "Name",
                                    style: TextStyle(
                                      color: CustomColors.white,
                                      fontSize: 12,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (ResponsiveBreakpoints.of(context).isTablet || ResponsiveBreakpoints.of(context).isDesktop) ...[
                                    Text(
                                      "Rating",
                                      style: TextStyle(
                                        color: CustomColors.white,
                                        fontSize: 12,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                  Text(
                                    "Comment",
                                    style: TextStyle(
                                      color: CustomColors.white,
                                      fontSize: 12,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ListView.builder(
                              itemCount: futureapplicantProfileDetail!.data!.ratings!.length,
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(top: 16),
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 60,
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 08),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: ServiceGiverColor.black),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      if (ResponsiveBreakpoints.of(context).isMobile) ...[
                                        Expanded(
                                          child: Text(
                                            '${futureapplicantProfileDetail!.data!.ratings![index].receiverRating!.firstName} ${futureapplicantProfileDetail!.data!.ratings![index].receiverRating!.lastName}',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ] else ...[
                                        Text(
                                          '${futureapplicantProfileDetail!.data!.ratings![index].receiverRating!.firstName} ${futureapplicantProfileDetail!.data!.ratings![index].receiverRating!.lastName}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                      if (ResponsiveBreakpoints.of(context).isTablet || ResponsiveBreakpoints.of(context).isDesktop) ...[
                                        RatingBar.builder(
                                          initialRating: futureapplicantProfileDetail!.data!.ratings![index].rating!.toDouble(),
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
                                      ],
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Center(child: Text('${futureapplicantProfileDetail!.data!.ratings![index].receiverRating!.firstName} ${futureapplicantProfileDetail!.data!.ratings![index].receiverRating!.lastName}')),
                                              alignment: Alignment.center,
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  RatingBar.builder(
                                                    initialRating: futureapplicantProfileDetail!.data!.ratings![index].rating!.toDouble(),
                                                    minRating: 1,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    ignoreGestures: false,
                                                    itemSize: 24,
                                                    itemCount: 5,
                                                    itemBuilder: (context, _) => const Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                    onRatingUpdate: (rating) {},
                                                  ),
                                                  Text(
                                                    futureapplicantProfileDetail!.data!.ratings![index].comment.toString() == "null" ? "Not Available" : futureapplicantProfileDetail!.data!.ratings![index].comment.toString(),
                                                    maxLines: 20,
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: "Poppins",
                                                      fontWeight: FontWeight.w400,
                                                      color: CustomColors.primaryText,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Icon(
                                          Icons.arrow_circle_right_outlined,
                                          color: ServiceGiverColor.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ]
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          if (futureapplicantProfileDetail!.isHired == 0) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    acceptApplicant();
                                    setState(() {
                                      isHiredd = 1;
                                    });
                                  },
                                  child: Container(
                                    height: 40,
                                    width: MediaQuery.of(context).size.width * .4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: ServiceRecieverColor.redButton,
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
                                  onTap: () {
                                    declineApplicant();
                                  },
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
                          ] else ...[
                            InkWell(
                              onTap: () {},
                              child: Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: ServiceRecieverColor.redButtonLigth,
                                ),
                                child: Center(
                                  child: Text(
                                    "Already Hired",
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
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () async {
                              var resp = await Dio().post(
                                "${ChatUrl.serviceReceiverChat}?provider_id=${widget.profileId}",
                                options: Options(
                                  headers: {
                                    'Authorization': 'Bearer ${RecieverUserProvider.userToken}',
                                    'Accept': 'application/json',
                                  },
                                ),
                              );
                              // print("${ChatUrl.serviceReceiverChat}?provider_id=${widget.profileId}");
                              if (resp.statusCode == 200 && resp.data['message'].toString().contains("success")) {
                                Provider.of<RecieverChatProvider>(context, listen: false).setActiveChat(resp.data['chat_room']);
                              }
                              // await Provider.of<RecieverChatProvider>(context, listen: false).getSingleChat(futureapplicantProfileDetail!.data!.id.toString());
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
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  color: ServiceRecieverColor.primaryColor,
                ),
              ),
      ),
    );
  }
}
