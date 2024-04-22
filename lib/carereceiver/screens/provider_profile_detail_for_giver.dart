// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:island_app/providers/user_provider.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:island_app/carereceiver/models/service_receiver_dashboard_detail_model.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

class ProviderProfileDetailForReceiver extends StatefulWidget {
  final double? rating;
  final String? id;
  const ProviderProfileDetailForReceiver({
    Key? key,
    this.id,
    this.rating,
  }) : super(key: key);

  @override
  State<ProviderProfileDetailForReceiver> createState() => _ProviderProfileDetailForReceiverState();
}

class _ProviderProfileDetailForReceiverState extends State<ProviderProfileDetailForReceiver> {
  // Service Receiver Dashboard
  bool isLoading = true;
  ServiceReceiverDashboardDetailModel? futureReceiverDashboardDetail;
  fetchReceiverDashboardDetailModel() async {
    // try {
    var token = RecieverUserProvider.userToken;
    final response = await Dio().get(
      "${CareReceiverURl.serviceReceiverProviderDetail}/${widget.id}",
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
        futureReceiverDashboardDetail = ServiceReceiverDashboardDetailModel.fromJson(response.data);
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception(
        'Failed to load Service Receiver Dashboard Details',
      );
    }
    // } catch (error) {
    //   customErrorSnackBar(context, error.toString());
    // }
  }

  bool downloading = false;
  String downloadProgress = '';
  String downloadPdfPath = '';

  Future<bool> getStoragePermission() async {
    return await Permission.storage.request().isGranted;
  }

  Future<String> getDownloadFolderPath() async {
    return await ExternalPath.getExternalStoragePublicDirectory(
      ExternalPath.DIRECTORY_DOWNLOADS,
    );
  }

  Future downloadFile(String downloadDirectory, String fileUrl) async {
    Dio dio = Dio();

    var filname = fileUrl.split('.');
    String savename = '${filname.first}${DateTime.now()}.${filname.last}';
    var downloadingPdfPath = '$downloadDirectory/$savename';
    try {
      var fileRes = await dio.download(
        "${AppUrl.webStorageUrl}/$fileUrl",
        downloadingPdfPath,
        onReceiveProgress: (rec, total) {
          setState(() {
            downloading = true;
            downloadProgress = "${((rec / total) * 100).toStringAsFixed(0)}%";
          });
        },
      );
      if (fileRes.statusCode == 200) {
        customSuccesSnackBar(context, "file is downloaded successfully");
      }
    } catch (e) {
      customErrorSnackBar(context, "something went wrong please try again later");
    }
    await Future.delayed(const Duration(seconds: 3));

    return downloadingPdfPath;
  }

  // Download by user click
  Future<void> doDownloadFile(fileUrl) async {
    if (await getStoragePermission()) {
      String downloadDirectory = await getDownloadFolderPath();
      await downloadFile(downloadDirectory, fileUrl).then(
        (value) {
          displayPDF(value);
        },
      );
    }
  }

  void displayPDF(String downloadDirectory) {
    setState(() {
      downloading = false;
      downloadProgress = "COMPLETED";
      downloadPdfPath = downloadDirectory;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchReceiverDashboardDetailModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.loginBg,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: CustomColors.primaryText,
        ),
        elevation: 0,
        backgroundColor: CustomColors.white,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: ServiceRecieverColor.primaryColor,
              ),
            )
          : futureReceiverDashboardDetail != null
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      if (futureReceiverDashboardDetail!.isVerified == true) ...[
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
                                      imageUrl: "${AppUrl.webStorageUrl}/${futureReceiverDashboardDetail!.data!.avatar.toString()}",
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        if (futureReceiverDashboardDetail!.isVerified == true) ...[
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
                                          "${futureReceiverDashboardDetail!.data!.firstName.toString()} ${futureReceiverDashboardDetail!.data!.lastName.toString()}",
                                          style: TextStyle(fontSize: 20, fontFamily: "Rubik", fontWeight: FontWeight.w700, color: CustomColors.white),
                                        ),
                                        const SizedBox(width: 10),
                                        // Text(
                                        //   futureReceiverDashboardDetail!.data!.email.toString(),
                                        //   style: TextStyle(
                                        //     fontSize: 12,
                                        //     fontFamily: "Rubik",
                                        //     fontWeight: FontWeight.w400,
                                        //     color: CustomColors.white,
                                        //   ),
                                        // ),
                                        const SizedBox(width: 10),
                                        if (futureReceiverDashboardDetail!.data!.avgRating != null) ...[
                                          RatingBar(
                                            ignoreGestures: true,
                                            itemCount: 5,
                                            itemSize: 20,
                                            initialRating: futureReceiverDashboardDetail!.data!.avgRating!['rating'] == null ? 0.0 : double.parse(futureReceiverDashboardDetail!.data!.avgRating!['rating'].toString()),
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
                                          if (futureReceiverDashboardDetail!.data!.userdetail!.address != null) ...[
                                            Flexible(
                                              child: Text(
                                                futureReceiverDashboardDetail!.data!.userdetail!.address.toString(),
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
                                              "${futureReceiverDashboardDetail!.percentage}%",
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
                                          value: futureReceiverDashboardDetail!.percentage != null ? (futureReceiverDashboardDetail!.percentage! / 100) : 00,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.pink.shade400),
                                          // color: Colors.white,
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
                      if (futureReceiverDashboardDetail!.data!.userdetailprovider!.badge != null) ...[
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
                              children: List.generate(futureReceiverDashboardDetail!.data!.userdetailprovider!.badge!.length, (index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(500),
                                  child: CachedNetworkImage(
                                    height: 50,
                                    imageUrl: "${AppUrl.webStorageUrl}/${futureReceiverDashboardDetail!.data!.userdetailprovider!.badge![index]}",
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
                                        "${futureReceiverDashboardDetail!.data!.firstName} ${futureReceiverDashboardDetail!.data!.lastName}",
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
                                      futureReceiverDashboardDetail!.data!.userdetail!.gender.toString() != "null"
                                          ? Text(
                                              (futureReceiverDashboardDetail!.data!.userdetail!.gender.toString() == "1")
                                                  ? "Male"
                                                  : (futureReceiverDashboardDetail!.data!.userdetail!.gender.toString() == "2")
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
                                        futureReceiverDashboardDetail!.data!.userdetail!.area.toString() == "0"
                                            ? "East"
                                            : futureReceiverDashboardDetail!.data!.userdetail!.area.toString() == "1"
                                                ? "Central"
                                                : futureReceiverDashboardDetail!.data!.userdetail!.area.toString() == "2"
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
                                        futureReceiverDashboardDetail!.data!.userdetail!.service!.name.toString() == "null" ? "Not Available" : futureReceiverDashboardDetail!.data!.userdetail!.service!.name.toString(),
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
                                          futureReceiverDashboardDetail!.data!.userdetailprovider!.experience.toString(),
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
                                        futureReceiverDashboardDetail!.data!.userdetailprovider!.hourlyRate.toString() != "null"
                                            ? Text(
                                                "\$ ${futureReceiverDashboardDetail!.data!.userdetailprovider!.hourlyRate.toString()}",
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
                                        futureReceiverDashboardDetail!.data!.userdetailprovider!.keywords.toString() == "null"
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
                                                futureReceiverDashboardDetail!.data!.userdetailprovider!.keywords.toString() == "null" ? "Required" : futureReceiverDashboardDetail!.data!.userdetailprovider!.keywords.toString(),
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
                                        if (futureReceiverDashboardDetail!.data!.educations!.isEmpty) ...[
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
                                          itemCount: futureReceiverDashboardDetail!.data!.educations!.length,
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
                                                    "Institue Name: ${futureReceiverDashboardDetail!.data!.educations![index].name}",
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: CustomColors.hintText,
                                                      fontSize: 14,
                                                      fontFamily: "Rubik",
                                                      fontWeight: FontWeight.w200,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    "Degree/Certification: ${futureReceiverDashboardDetail!.data!.educations![index].major}",
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: CustomColors.hintText,
                                                      fontSize: 12,
                                                      fontFamily: "Rubik",
                                                      fontWeight: FontWeight.w200,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  if (futureReceiverDashboardDetail!.data!.educations![index].to == "") ...[
                                                    Text(
                                                      "Time Period: Currently Studying",
                                                      softWrap: true,
                                                      style: TextStyle(
                                                        height: 2,
                                                        color: CustomColors.hintText,
                                                        fontSize: 12,
                                                        fontFamily: "Rubik",
                                                        fontWeight: FontWeight.w200,
                                                      ),
                                                    ),
                                                  ],
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    "From: ${futureReceiverDashboardDetail!.data!.educations![index].from.toString()}",
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: CustomColors.hintText,
                                                      fontSize: 12,
                                                      fontFamily: "Rubik",
                                                      fontWeight: FontWeight.w200,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  futureReceiverDashboardDetail!.data!.educations![index].to == ""
                                                      ? Text(
                                                          "To: Currently Studying",
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
                                                          "To: ${futureReceiverDashboardDetail!.data!.educations![index].to.toString()}",
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
                                        const SizedBox(height: 8),
                                        futureReceiverDashboardDetail!.data!.userdetail!.userInfo.toString() == "null"
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
                                                futureReceiverDashboardDetail!.data!.userdetail!.userInfo.toString() == "null" ? "Required" : futureReceiverDashboardDetail!.data!.userdetail!.userInfo.toString(),
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
                                        futureReceiverDashboardDetail!.data!.userdetailprovider!.availability.toString() == "null"
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
                                                futureReceiverDashboardDetail!.data!.userdetailprovider!.availability.toString() == "null" ? "Required" : futureReceiverDashboardDetail!.data!.userdetailprovider!.availability.toString(),
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
                            // Background Verified
                            if (futureReceiverDashboardDetail!.data!.ratings != null && futureReceiverDashboardDetail!.data!.ratings!.isNotEmpty) ...[
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
                                itemCount: futureReceiverDashboardDetail!.data!.ratings!.length,
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
                                              '${futureReceiverDashboardDetail!.data!.ratings![index].receiverRating!.firstName} ${futureReceiverDashboardDetail!.data!.ratings![index].receiverRating!.lastName}',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ] else ...[
                                          Text(
                                            '${futureReceiverDashboardDetail!.data!.ratings![index].receiverRating!.firstName} ${futureReceiverDashboardDetail!.data!.ratings![index].receiverRating!.lastName}',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                        if (ResponsiveBreakpoints.of(context).isTablet || ResponsiveBreakpoints.of(context).isDesktop) ...[
                                          RatingBar.builder(
                                            initialRating: futureReceiverDashboardDetail!.data!.ratings![index].rating!.toDouble(),
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
                                                title: Center(child: Text('${futureReceiverDashboardDetail!.data!.ratings![index].receiverRating!.firstName} ${futureReceiverDashboardDetail!.data!.ratings![index].receiverRating!.lastName}')),
                                                alignment: Alignment.center,
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    RatingBar.builder(
                                                      initialRating: futureReceiverDashboardDetail!.data!.ratings![index].rating!.toDouble(),
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
                                                      futureReceiverDashboardDetail!.data!.ratings![index].comment.toString() == "null" ? "Not Available" : futureReceiverDashboardDetail!.data!.ratings![index].comment.toString(),
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
                            // else ...[
                            //   const Center(
                            //     child: Text("No Review Yet!"),
                            //   )
                            // ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  // FutureBuilder<ServiceReceiverDashboardDetailModel>(
                  //   future: futureReceiverDashboardDetail,
                  //   builder: (context, snapshot) {
                  //     if (snapshot.hasData) {
                  //       return ListView.builder(
                  //         shrinkWrap: true,
                  //         scrollDirection: Axis.vertical,
                  //         physics: const NeverScrollableScrollPhysics(),
                  //         itemCount: snapshot.data!.data!.length,
                  //         itemBuilder: (BuildContext context, int index) {
                  //           return ReceiverDashboardDetailWidget(
                  //             imgPath: snapshot.data!.data![0].avatar != null
                  //                 ? ("https://islandcare.bm/storage/${snapshot.data!.data![0].avatar}")
                  //                 : "https://img.icons8.com/material-rounded/256/question-mark.png",
                  //             title: "${snapshot.data!.data![0].firstName} ${snapshot.data!.data![0].lastName}",
                  //             services: snapshot.data!.data![0].userdetail!.service!.name.toString(),
                  //             desc: snapshot.data!.data![0].userdetail!.userInfo.toString() == "null"
                  //                 ? "Not Available"
                  //                 : snapshot.data!.data![0].userdetail!.userInfo.toString(),
                  //             experience: snapshot.data!.data![0].userdetailprovider != null
                  //                 ? snapshot.data!.data![0].userdetailprovider!.experience.toString() == "null"
                  //                     ? "0"
                  //                     : snapshot.data!.data![0].userdetailprovider!.experience.toString()
                  //                 : "",
                  //             address: snapshot.data!.data![0].userdetail!.address.toString() == "null"
                  //                 ? "Not Available"
                  //                 : snapshot.data!.data![0].userdetail!.address.toString(),
                  //             initialRating: widget.rating,
                  //             instituteName:
                  //                 snapshot.data!.data![0].educations!.isEmpty ? "Not Available" : snapshot.data!.data![0].educations![index].name.toString(),
                  //             major:
                  //                 snapshot.data!.data![0].educations!.isEmpty ? "Not Available" : snapshot.data!.data![0].educations![index].major.toString(),
                  //             from: snapshot.data!.data![0].educations!.isEmpty ? "Not Available" : snapshot.data!.data![0].educations![index].from.toString(),
                  //             to: snapshot.data!.data![0].educations!.isEmpty ? "Not Available" : snapshot.data!.data![0].educations![index].to.toString(),
                  //             hour: snapshot.data!.data![0].userdetailprovider != null
                  //                 ? snapshot.data!.data![0].userdetailprovider!.hourlyRate.toString() == "null"
                  //                     ? "0"
                  //                     : snapshot.data!.data![0].userdetailprovider!.hourlyRate.toString()
                  //                 : '',
                  //             zip: snapshot.data!.data![0].userdetail!.zip.toString() == "null"
                  //                 ? "Not Available"
                  //                 : snapshot.data!.data![0].userdetail!.zip.toString(),
                  //             documentsSection: Column(
                  //               children: [
                  //                 if (snapshot.data!.data![0].providerverification != null) ...[
                  //                   // file type 1
                  //                   if (snapshot.data!.data![0].providerverification!.validDriverLicense != null) ...[
                  //                     const SizedBox(height: 10),
                  //                     BasicDocumentDownloadList(
                  //                       onTap: () {
                  //                         doDownloadFile(snapshot.data!.data![0].providerverification!.validDriverLicense);
                  //                       },
                  //                       fileStatus: snapshot.data!.data![0].providerverification!.validDriverLicenseVerify.toString(),
                  //                       downloading: downloading,
                  //                       downloadProgress: downloadProgress,
                  //                       title: "Valid Driver's License",
                  //                     ),
                  //                   ],
                  //                   // file type 2
                  //                   if (snapshot.data!.data![0].providerverification!.scarsAwarenessCertification != null) ...[
                  //                     const SizedBox(height: 10),
                  //                     BasicDocumentDownloadList(
                  //                       onTap: () {
                  //                         doDownloadFile(snapshot.data!.data![0].providerverification!.scarsAwarenessCertification);
                  //                       },
                  //                       fileStatus: snapshot.data!.data![0].providerverification!.scarsAwarenessCertificationVerify.toString(),
                  //                       downloading: downloading,
                  //                       downloadProgress: downloadProgress,
                  //                       title: "Scars Awareness Certification",
                  //                     ),
                  //                   ],
                  //                   // file type 8
                  //                   if (snapshot.data!.data![0].providerverification!.policeBackgroundCheck != null) ...[
                  //                     const SizedBox(height: 10),
                  //                     BasicDocumentDownloadList(
                  //                       onTap: () {
                  //                         doDownloadFile(snapshot.data!.data![0].providerverification!.policeBackgroundCheck);
                  //                       },
                  //                       fileStatus: snapshot.data!.data![0].providerverification!.policeBackgroundCheckVerify.toString(),
                  //                       downloading: downloading,
                  //                       downloadProgress: downloadProgress,
                  //                       title: "Police Background Check",
                  //                     ),
                  //                   ],
                  //                   // file type 3
                  //                   if (snapshot.data!.data![0].providerverification!.cprFirstAidCertification != null) ...[
                  //                     const SizedBox(height: 10),
                  //                     BasicDocumentDownloadList(
                  //                       onTap: () {
                  //                         doDownloadFile(snapshot.data!.data![0].providerverification!.cprFirstAidCertification);
                  //                       },
                  //                       fileStatus: snapshot.data!.data![0].providerverification!.cprFirstAidCertificationVerify.toString(),
                  //                       downloading: downloading,
                  //                       downloadProgress: downloadProgress,
                  //                       title: "CPR/First Aid Certificate",
                  //                     ),
                  //                   ],
                  //                   // file type 7
                  //                   if (snapshot.data!.data![0].providerverification!.governmentRegisteredCareProvider != null) ...[
                  //                     const SizedBox(height: 10),
                  //                     BasicDocumentDownloadList(
                  //                       onTap: () {
                  //                         doDownloadFile(snapshot.data!.data![0].providerverification!.governmentRegisteredCareProvider);
                  //                       },
                  //                       fileStatus: snapshot.data!.data![0].providerverification!.governmentRegisteredCareProviderVerify.toString(),
                  //                       downloading: downloading,
                  //                       downloadProgress: downloadProgress,
                  //                       title: "Government Registered Care Provider",
                  //                     ),
                  //                   ],
                  //                   // file type 4
                  //                   if (snapshot.data!.data![0].providerverification!.animalCareProviderCertification != null) ...[
                  //                     const SizedBox(height: 10),
                  //                     BasicDocumentDownloadList(
                  //                       onTap: () {
                  //                         doDownloadFile(snapshot.data!.data![0].providerverification!.animalCareProviderCertification);
                  //                       },
                  //                       fileStatus: snapshot.data!.data![0].providerverification!.animalCareProviderCertificationVerify.toString(),
                  //                       downloading: downloading,
                  //                       downloadProgress: downloadProgress,
                  //                       title: "Animal Care Provider Certificate",
                  //                     ),
                  //                   ],
                  //                   // file type 6
                  //                   if (snapshot.data!.data![0].providerverification!.animailFirstAid != null) ...[
                  //                     const SizedBox(height: 10),
                  //                     BasicDocumentDownloadList(
                  //                       onTap: () {
                  //                         doDownloadFile(snapshot.data!.data![0].providerverification!.animailFirstAid);
                  //                       },
                  //                       fileStatus: snapshot.data!.data![0].providerverification!.animailFirstAidVerify.toString(),
                  //                       downloading: downloading,
                  //                       downloadProgress: downloadProgress,
                  //                       title: "Animal First Aid",
                  //                     ),
                  //                   ],
                  //                   // file type 3a
                  //                   if (snapshot.data!.data![0].providerverification!.redCrossBabysittingCertification != null) ...[
                  //                     const SizedBox(height: 10),
                  //                     BasicDocumentDownloadList(
                  //                       onTap: () {
                  //                         doDownloadFile(snapshot.data!.data![0].providerverification!.redCrossBabysittingCertification);
                  //                       },
                  //                       fileStatus: snapshot.data!.data![0].providerverification!.redCrossBabysittingCertificationVerify.toString(),
                  //                       downloading: downloading,
                  //                       downloadProgress: downloadProgress,
                  //                       title: "Red Cross Babysitting Certification",
                  //                     ),
                  //                   ],
                  //                   // file type 5
                  //                   if (snapshot.data!.data![0].providerverification!.chaildAndFamilyServicesAndAbuse != null) ...[
                  //                     const SizedBox(height: 10),
                  //                     BasicDocumentDownloadList(
                  //                       onTap: () {
                  //                         doDownloadFile(snapshot.data!.data![0].providerverification!.chaildAndFamilyServicesAndAbuse);
                  //                       },
                  //                       fileStatus: snapshot.data!.data![0].providerverification!.chaildAndFamilyServicesAndAbuseVerify.toString(),
                  //                       downloading: downloading,
                  //                       downloadProgress: downloadProgress,
                  //                       title: "Dept Child and Family Services Child Abuse Check",
                  //                     ),
                  //                   ],
                  //                 ]
                  //               ],
                  //             ),
                  //             imgProviderPath: snapshot.data!.data![index].ratings!.isEmpty
                  //                 ? "https://img.icons8.com/material-rounded/256/question-mark.png"
                  //                 : "https://islandcare.bm/storage/${snapshot.data!.data![index].ratings![index].receiverRating!.avatar}",
                  //             ratings: snapshot.data!.data![index].ratings,
                  //             // providerName: snapshot.data!.data![index].ratings!.isEmpty ? "Not Available" : "${snapshot.data!.data![index].ratings![index].receiverRating!.firstName} ${snapshot.data!.data![index].ratings![index].receiverRating!.lastName}",
                  //             // providerComment: snapshot.data!.data![index].ratings!.isEmpty ? "Not Available" : snapshot.data!.data![index].ratings![index].comment.toString(),
                  //             // providerRating: snapshot.data!.data![index].ratings!.isEmpty ? 0.0 : snapshot.data!.data![index].ratings![index].rating!.toDouble(),
                  //           );
                  //         },
                  //       );
                  //     } else {
                  //       return const Center(
                  //         child: CircularProgressIndicator(),
                  //       );
                  //     }
                  //   },
                  // ),
                )
              : const Center(
                  child: Text("No Data Found"),
                ),
    );
  }
}
