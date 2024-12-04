// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:island_app/utils/app_colors.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/functions.dart';
import 'package:island_app/utils/http_handlers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:island_app/carereceiver/models/service_receiver_dashboard_detail_model.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ProviderProfileDetailForReceiver extends StatefulWidget {
  final double? rating;
  final String? id;
  const ProviderProfileDetailForReceiver({
    super.key,
    this.id,
    this.rating,
  });

  @override
  State<ProviderProfileDetailForReceiver> createState() => _ProviderProfileDetailForReceiverState();
}

class _ProviderProfileDetailForReceiverState extends State<ProviderProfileDetailForReceiver> {
  // Service Receiver Dashboard
  bool isLoading = true;
  ServiceReceiverDashboardDetailModel? futureReceiverDashboardDetail;
  fetchReceiverDashboardDetailModel() async {
    // try {
    var token = await getToken();
    final response = await getRequesthandler(
      url: "${CareReceiverURl.serviceReceiverProviderDetail}/${widget.id}",
      token: token,
    );
    if (response != null && response.statusCode == 200) {
      setState(() {
        isLoading = false;
        futureReceiverDashboardDetail = ServiceReceiverDashboardDetailModel.fromJson(response.data);
      });
    } else {
      setState(() {
        isLoading = false;
      });
      showErrorToast("Failed to load Provider Details");
      // throw Exception(
      //   'Failed to load Service Receiver Dashboard Details',
      // );
    }
    // } catch (error) {
    //   setState(() {
    //     isLoading = false;
    //   });
    //   showErrorToast("Failed to load Provider Details");
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
    var filname = fileUrl.split('.');
    String savename = '${filname.first}${DateTime.now()}.${filname.last}';
    var downloadingPdfPath = '$downloadDirectory/$savename';
    try {
      var fileRes = await Dio().download(
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
        showSuccessToast("file is downloaded successfully");
      }
    } catch (e) {
      showErrorToast("something went wrong please try again later");
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
                                  height: ResponsiveBreakpoints.of(context).isTablet ? 100 : 40,
                                ),
                                title: Text(
                                  "Verified Service Provider",
                                  style: TextStyle(
                                    color: CustomColors.primaryText,
                                    fontSize: ResponsiveBreakpoints.of(context).isTablet ? 18 : 12,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  "This service provider is verified, ensuring an added layer of safety and trust within our community. Thank you for choosing a secure and trustworthy caregiving experience.",
                                  style: TextStyle(
                                    color: CustomColors.primaryText,
                                    fontSize: ResponsiveBreakpoints.of(context).isTablet ? 16 : 10,
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
                                      imageUrl:
                                          "${AppUrl.webStorageUrl}/${futureReceiverDashboardDetail!.data!.avatar.toString()}",
                                      errorWidget: (context, url, error) => const Icon(
                                        Icons.error,
                                        color: Colors.white,
                                      ),
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
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: "Rubik",
                                              fontWeight: FontWeight.w700,
                                              color: CustomColors.white),
                                        ),
                                        const SizedBox(width: 10),
                                        if (futureReceiverDashboardDetail!.data!.avgRating != null) ...[
                                          RatingBar(
                                            ignoreGestures: true,
                                            itemCount: 5,
                                            itemSize: 20,
                                            initialRating: futureReceiverDashboardDetail!.data!.avgRating!['rating'] ==
                                                    null
                                                ? 0.0
                                                : double.parse(futureReceiverDashboardDetail!.data!.avgRating!['rating']
                                                    .toString()),
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
                                            onRatingUpdate: (rating) {},
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
                                          value: futureReceiverDashboardDetail!.percentage != null
                                              ? (futureReceiverDashboardDetail!.percentage! / 100)
                                              : 00,
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
                              children: List.generate(
                                  futureReceiverDashboardDetail!.data!.userdetailprovider!.badge!.length, (index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(500),
                                  child: CachedNetworkImage(
                                    height: 50,
                                    imageUrl:
                                        "${AppUrl.webStorageUrl}/${futureReceiverDashboardDetail!.data!.userdetailprovider!.badge![index]}",
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
                                              (futureReceiverDashboardDetail!.data!.userdetail!.gender.toString() ==
                                                      "1")
                                                  ? "Male"
                                                  : (futureReceiverDashboardDetail!.data!.userdetail!.gender
                                                              .toString() ==
                                                          "2")
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
                                                : futureReceiverDashboardDetail!.data!.userdetail!.area.toString() ==
                                                        "2"
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
                                        futureReceiverDashboardDetail!.data!.userdetail!.service!.name.toString() ==
                                                "null"
                                            ? "Not Available"
                                            : futureReceiverDashboardDetail!.data!.userdetail!.service!.name.toString(),
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
                                          futureReceiverDashboardDetail!.data!.userdetailprovider!.experience
                                              .toString(),
                                          softWrap: true,
                                          style: TextStyle(
                                              color: CustomColors.hintText,
                                              fontSize: 16,
                                              fontFamily: "Rubik",
                                              fontWeight: FontWeight.w200),
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
                                        futureReceiverDashboardDetail!.data!.userdetailprovider!.hourlyRate
                                                    .toString() !=
                                                "null"
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
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: CustomColors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
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
                                  const SizedBox(height: 8),
                                  if (futureReceiverDashboardDetail!.data!.userdetailprovider!.keywords != null) ...[
                                    Wrap(
                                      spacing: 10,
                                      children: [
                                        for (var item
                                            in futureReceiverDashboardDetail!.data!.userdetailprovider!.keywords!) ...[
                                          if (item.runtimeType == Map<String, dynamic>) ...[
                                            Container(
                                              padding: const EdgeInsets.all(05),
                                              margin: const EdgeInsets.only(bottom: 05),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade100,
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                              child: Text(
                                                item['value'],
                                                softWrap: true,
                                                style: TextStyle(
                                                  color: CustomColors.hintText,
                                                  fontSize: 12,
                                                  fontFamily: "Rubik",
                                                  fontWeight: FontWeight.w200,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ],
                                    ),
                                  ] else ...[
                                    Text(
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
                                                  if (futureReceiverDashboardDetail!.data!.educations![index].to ==
                                                      "") ...[
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
                                                futureReceiverDashboardDetail!.data!.userdetail!.userInfo.toString() ==
                                                        "null"
                                                    ? "Required"
                                                    : futureReceiverDashboardDetail!.data!.userdetail!.userInfo
                                                        .toString(),
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
                                        futureReceiverDashboardDetail!.data!.userdetailprovider!.availability
                                                    .toString() ==
                                                "null"
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
                                                futureReceiverDashboardDetail!.data!.userdetailprovider!.availability
                                                            .toString() ==
                                                        "null"
                                                    ? "Required"
                                                    : futureReceiverDashboardDetail!
                                                        .data!.userdetailprovider!.availability
                                                        .toString(),
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
                            if (futureReceiverDashboardDetail!.data!.ratings != null &&
                                futureReceiverDashboardDetail!.data!.ratings!.isNotEmpty) ...[
                              const SizedBox(height: 30),
                              Text(
                                "Reviews",
                                style: TextStyle(
                                  fontSize: ResponsiveBreakpoints.of(context).isTablet ? 24 : 18,
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
                                        fontSize: ResponsiveBreakpoints.of(context).isTablet ? 18 : 12,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (ResponsiveBreakpoints.of(context).isTablet ||
                                        ResponsiveBreakpoints.of(context).isDesktop) ...[
                                      Text(
                                        "Rating",
                                        style: TextStyle(
                                          color: CustomColors.white,
                                          fontSize: ResponsiveBreakpoints.of(context).isTablet ? 18 : 12,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                    Text(
                                      "Comment",
                                      style: TextStyle(
                                        color: CustomColors.white,
                                        fontSize: ResponsiveBreakpoints.of(context).isTablet ? 18 : 12,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ListView.separated(
                                itemCount: futureReceiverDashboardDetail!.data!.ratings!.length,
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(top: 16),
                                physics: const NeverScrollableScrollPhysics(),
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    height: 10,
                                  );
                                },
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: 60,
                                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 08),
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
                                          Expanded(
                                            child: Text(
                                              '${futureReceiverDashboardDetail!.data!.ratings![index].receiverRating!.firstName} ${futureReceiverDashboardDetail!.data!.ratings![index].receiverRating!.lastName}',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                        if (ResponsiveBreakpoints.of(context).isTablet ||
                                            ResponsiveBreakpoints.of(context).isDesktop) ...[
                                          Expanded(
                                            child: DecoratedBox(
                                              decoration: const BoxDecoration(),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  RatingBar.builder(
                                                    initialRating: futureReceiverDashboardDetail!
                                                        .data!.ratings![index].rating!
                                                        .toDouble(),
                                                    minRating: 1,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    ignoreGestures: false,
                                                    itemSize: ResponsiveBreakpoints.of(context).isTablet ? 26 : 15,
                                                    itemCount: 5,
                                                    itemBuilder: (context, _) => const Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                    onRatingUpdate: (rating) {},
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                        title: Center(
                                                            child: Text(
                                                                '${futureReceiverDashboardDetail!.data!.ratings![index].receiverRating!.firstName} ${futureReceiverDashboardDetail!.data!.ratings![index].receiverRating!.lastName}')),
                                                        alignment: Alignment.center,
                                                        content: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            RatingBar.builder(
                                                              initialRating: futureReceiverDashboardDetail!
                                                                  .data!.ratings![index].rating!
                                                                  .toDouble(),
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
                                                              futureReceiverDashboardDetail!
                                                                          .data!.ratings![index].comment
                                                                          .toString() ==
                                                                      "null"
                                                                  ? "Not Available"
                                                                  : futureReceiverDashboardDetail!
                                                                      .data!.ratings![index].comment
                                                                      .toString(),
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
                                                    size: ResponsiveBreakpoints.of(context).isTablet ? 36 : null,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ] else ...[
                                          InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  title: Center(
                                                      child: Text(
                                                          '${futureReceiverDashboardDetail!.data!.ratings![index].receiverRating!.firstName} ${futureReceiverDashboardDetail!.data!.ratings![index].receiverRating!.lastName}')),
                                                  alignment: Alignment.center,
                                                  content: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      RatingBar.builder(
                                                        initialRating: futureReceiverDashboardDetail!
                                                            .data!.ratings![index].rating!
                                                            .toDouble(),
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
                                                        futureReceiverDashboardDetail!.data!.ratings![index].comment
                                                                    .toString() ==
                                                                "null"
                                                            ? "Not Available"
                                                            : futureReceiverDashboardDetail!
                                                                .data!.ratings![index].comment
                                                                .toString(),
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
                                              size: ResponsiveBreakpoints.of(context).isTablet ? 36 : null,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ]
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : const Center(
                  child: Text("No Data Found"),
                ),
    );
  }
}
