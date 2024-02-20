// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously, unnecessary_null_comparison

// import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:island_app/caregiver/screens/profile_edit.dart';
import 'package:island_app/caregiver/utils/profile_provider.dart';
import 'package:island_app/caregiver/widgets/drawer_widget.dart';
import 'package:island_app/caregiver/widgets/giver_app_bar.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/res/app_url.dart';
import 'package:island_app/utils/utils.dart';
import 'package:island_app/widgets/document_download_list.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ProfileGiver extends StatefulWidget {
  const ProfileGiver({super.key});

  @override
  State<ProfileGiver> createState() => _ProfileGiverState();
}

class _ProfileGiverState extends State<ProfileGiver> {
  bool downloading = false;
  String downloadProgress = '';
  String downloadPdfPath = '';

  var pdfEnhancePath;
  var pdfBasicPath;
  var pdfFirstAddPath;
  var pdfvehicleRecordPath;
  var hostPath;

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

    Provider.of<ServiceGiverProvider>(context, listen: false).fetchProfileGiverModel();
  }

  @override
  Widget build(BuildContext context) {
    var userProfile = Provider.of<ServiceGiverProvider>(context).fetchProfile;
    bool profileStatus = Provider.of<ServiceGiverProvider>(context).profileStatus;

    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColors.loginBg,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: GiverCustomAppBar(
            profileStatus: profileStatus,
            showProfileIcon: false,
            title: "Profile",
          ),
        ),
        drawer: const DrawerGiverWidget(),
        body: downloading
            ? Center(
                child: SizedBox(
                  height: 120.0,
                  width: 200.0,
                  child: Card(
                    color: ServiceGiverColor.black,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                        const SizedBox(height: 20.0),
                        Text(
                          "Downloading File: $downloadProgress",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  Provider.of<ServiceGiverProvider>(context, listen: false).fetchProfileGiverModel();
                },
                child: SingleChildScrollView(
                  child: userProfile != null
                      ? Column(
                          children: [
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
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(08),
                                          child: CachedNetworkImage(
                                            width: 130,
                                            height: 110,
                                            alignment: Alignment.center,
                                            imageUrl: "${AppUrl.webStorageUrl}/${userProfile.data!.avatar.toString()}",
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => ProfileGiverPendingEdit(
                                                          name: "${userProfile.data!.firstName} ${userProfile.data!.lastName}",
                                                          email: userProfile.data!.email,
                                                          avatar: userProfile.data!.avatar,
                                                          gender: userProfile.data!.userdetail!.gender.toString(),
                                                          phoneNumber: userProfile.data!.phone,
                                                          dob: userProfile.data!.userdetail!.dob,
                                                          yoe: userProfile.data!.userdetailprovider!.experience,
                                                          hourlyRate: userProfile.data!.userdetailprovider!.hourlyRate,
                                                          userAddress: userProfile.data!.userdetail!.address,
                                                          zipCode: userProfile.data!.userdetail!.zip,
                                                          additionalService: userProfile.data!.userdetailprovider!.keywords,
                                                          availability: userProfile.data!.userdetailprovider!.availability,
                                                          userInfo: userProfile.data!.userdetail!.userInfo,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    width: 30,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey.shade200,
                                                      borderRadius: BorderRadius.circular(05),
                                                    ),
                                                    child: const Icon(
                                                      Icons.edit,
                                                      color: Colors.grey,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "${userProfile.data!.firstName.toString()} ${userProfile.data!.lastName.toString()}",
                                                style: TextStyle(fontSize: 20, fontFamily: "Rubik", fontWeight: FontWeight.w700, color: CustomColors.white),
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                userProfile.data!.email.toString(),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: "Rubik",
                                                  fontWeight: FontWeight.w400,
                                                  color: CustomColors.white,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              if (userProfile.data!.avgRating != null) ...[
                                                RatingBar(
                                                  ignoreGestures: true,
                                                  itemCount: 5,
                                                  itemSize: 20,
                                                  initialRating: userProfile.data!.avgRating!['rating'] == null ? 0.0 : double.parse(userProfile.data!.avgRating!['rating'].toString()),
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
                                        Container(
                                          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
                                          width: 130,
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.phone_outlined,
                                                size: 14,
                                                color: Colors.white,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  userProfile.data!.phone.toString(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
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
                                                if (userProfile.data!.userdetail!.address != null) ...[
                                                  Flexible(
                                                    child: Text(
                                                      userProfile.data!.userdetail!.address.toString(),
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
                                                    "${Provider.of<ServiceGiverProvider>(context).profilePerentage}%",
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
                                                value: Provider.of<ServiceGiverProvider>(context).profilePerentage != null ? double.parse(Provider.of<ServiceGiverProvider>(context).profilePerentage) / 100 : 00,
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
                            Consumer<ServiceGiverProvider>(builder: (context, provider, __) {
                              return provider.badges != null
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 18),
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                                        child: Wrap(
                                          spacing: 05,
                                          crossAxisAlignment: WrapCrossAlignment.center,
                                          alignment: WrapAlignment.center,
                                          children: List.generate(provider.badges!.length, (index) {
                                            return ClipRRect(
                                              borderRadius: BorderRadius.circular(500),
                                              child: CachedNetworkImage(
                                                height: 50,
                                                imageUrl: "${AppUrl.webStorageUrl}/${provider.badges![index]}",
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                    )
                                  : Container();
                            }),
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
                                              "${userProfile.data!.firstName} ${userProfile.data!.lastName}",
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
                                            userProfile.data!.userdetail!.gender.toString() != "null"
                                                ? Text(
                                                    (userProfile.data!.userdetail!.gender.toString() == "1")
                                                        ? "Male"
                                                        : (userProfile.data!.userdetail!.gender.toString() == "2")
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
                                              "Area of Insterest",
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
                                              userProfile.data!.userdetail!.service!.name.toString() == "null" ? "Not Available" : userProfile.data!.userdetail!.service!.name.toString(),
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
                                                userProfile.data!.userdetail!.area.toString() == "0"
                                                    ? "East"
                                                    : userProfile.data!.userdetail!.area.toString() == "1"
                                                        ? "Central"
                                                        : userProfile.data!.userdetail!.area.toString() == "2"
                                                            ? "West"
                                                            : "Not Available",
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
                                              userProfile.data!.userdetailprovider!.hourlyRate.toString() != "null"
                                                  ? Text(
                                                      "\$ ${userProfile.data!.userdetailprovider!.hourlyRate.toString()}",
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
                                  // Date
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
                                              "Date Of Birth",
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
                                              userProfile.data!.userdetail!.dob.toString(),
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
                                  // Zip Code
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
                                              "Zip Code",
                                              style: TextStyle(
                                                color: ServiceGiverColor.black,
                                                fontSize: 10,
                                                fontFamily: "Rubik",
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            userProfile.data!.userdetail!.zip.toString() == "null"
                                                ? Text(
                                                    "Not Available",
                                                    style: TextStyle(
                                                      color: CustomColors.hintText,
                                                      fontSize: 16,
                                                      fontFamily: "Rubik",
                                                      fontWeight: FontWeight.w200,
                                                    ),
                                                  )
                                                : Text(
                                                    userProfile.data!.userdetail!.zip.toString() == "null" ? "Required" : userProfile.data!.userdetail!.zip.toString(),
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
                                              userProfile.data!.userdetailprovider!.keywords.toString() == "null"
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
                                                      userProfile.data!.userdetailprovider!.keywords.toString() == "null" ? "Required" : userProfile.data!.userdetailprovider!.keywords.toString(),
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
                                              if (userProfile.data!.educations!.isEmpty) ...[
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
                                                itemCount: userProfile.data!.educations!.length,
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
                                                          "Institue Name: ${userProfile.data!.educations![index].name}",
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
                                                          "Major: ${userProfile.data!.educations![index].major}",
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
                                                          "From: ${userProfile.data!.educations![index].from}",
                                                          softWrap: true,
                                                          style: TextStyle(
                                                            color: CustomColors.hintText,
                                                            fontSize: 12,
                                                            fontFamily: "Rubik",
                                                            fontWeight: FontWeight.w200,
                                                          ),
                                                        ),
                                                        userProfile.data!.educations![index].to == ""
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
                                                                "",
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
                                              userProfile.data!.userdetail!.userInfo.toString() == "null"
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
                                                      userProfile.data!.userdetail!.userInfo.toString() == "null" ? "Required" : userProfile.data!.userdetail!.userInfo.toString(),
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
                                              userProfile.data!.userdetailprovider!.availability.toString() == "null"
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
                                                      userProfile.data!.userdetailprovider!.availability.toString() == "null" ? "Required" : userProfile.data!.userdetailprovider!.availability.toString(),
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
                                  DottedBorder(
                                    radius: const Radius.circular(10),
                                    borderType: BorderType.RRect,
                                    color: CustomColors.red,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFf1416c),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.workspace_premium,
                                          color: ServiceGiverColor.black,
                                        ),
                                        title: Text(
                                          "Account Verification",
                                          style: TextStyle(
                                            color: CustomColors.white,
                                            fontSize: 12,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "Service Providers are encouraged to verify their accounts by submitting the required documents. Verified profiles build trust and safety in the community. Submit your documents to enhance your profile and gain the trust of care seekers.",
                                          style: TextStyle(
                                            color: CustomColors.white,
                                            fontSize: 10,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  DottedBorder(
                                    radius: const Radius.circular(10),
                                    borderType: BorderType.RRect,
                                    color: ServiceGiverColor.black,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      decoration: BoxDecoration(
                                        color: CustomColors.primaryLight,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.workspace_premium,
                                          color: ServiceGiverColor.black,
                                        ),
                                        title: Text(
                                          "Background Verified",
                                          style: TextStyle(
                                            color: CustomColors.primaryText,
                                            fontSize: 12,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "We encourage parents to conduct their own screenings using the background check tools. See what each of the badges covered, or learn more about keeping your family safe by visiting the Trust & Safety Center.",
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

                                  // file type 1
                                  if (userProfile.data!.providerverification!.validDriverLicense != null) ...[
                                    const SizedBox(height: 10),
                                    BasicDocumentDownloadList(
                                      onTap: () {
                                        doDownloadFile(userProfile.data!.providerverification!.validDriverLicense);
                                      },
                                      fileStatus: userProfile.data!.providerverification!.validDriverLicenseVerify.toString(),
                                      downloading: downloading,
                                      downloadProgress: downloadProgress,
                                      title: "Valid Driver's License",
                                    ),
                                  ],
                                  // file type 2
                                  if (userProfile.data!.providerverification!.scarsAwarenessCertification != null) ...[
                                    const SizedBox(height: 10),
                                    BasicDocumentDownloadList(
                                      onTap: () {
                                        doDownloadFile(userProfile.data!.providerverification!.scarsAwarenessCertification);
                                      },
                                      fileStatus: userProfile.data!.providerverification!.scarsAwarenessCertificationVerify.toString(),
                                      downloading: downloading,
                                      downloadProgress: downloadProgress,
                                      title: "Scars Awareness Certification",
                                    ),
                                  ],
                                  // file type 8
                                  if (userProfile.data!.providerverification!.policeBackgroundCheck != null) ...[
                                    const SizedBox(height: 10),
                                    BasicDocumentDownloadList(
                                      onTap: () {
                                        doDownloadFile(userProfile.data!.providerverification!.policeBackgroundCheck);
                                      },
                                      fileStatus: userProfile.data!.providerverification!.policeBackgroundCheckVerify.toString(),
                                      downloading: downloading,
                                      downloadProgress: downloadProgress,
                                      title: "Police Background Check",
                                    ),
                                  ],
                                  // file type 3
                                  if (userProfile.data!.providerverification!.cprFirstAidCertification != null) ...[
                                    const SizedBox(height: 10),
                                    BasicDocumentDownloadList(
                                      onTap: () {
                                        doDownloadFile(userProfile.data!.providerverification!.cprFirstAidCertification);
                                      },
                                      fileStatus: userProfile.data!.providerverification!.cprFirstAidCertificationVerify.toString(),
                                      downloading: downloading,
                                      downloadProgress: downloadProgress,
                                      title: "CPR/First Aid Certificate",
                                    ),
                                  ],
                                  // file type 7
                                  if (userProfile.data!.providerverification!.governmentRegisteredCareProvider != null) ...[
                                    const SizedBox(height: 10),
                                    BasicDocumentDownloadList(
                                      onTap: () {
                                        doDownloadFile(userProfile.data!.providerverification!.governmentRegisteredCareProvider);
                                      },
                                      fileStatus: userProfile.data!.providerverification!.governmentRegisteredCareProviderVerify.toString(),
                                      downloading: downloading,
                                      downloadProgress: downloadProgress,
                                      title: "Government Registered Care Provider",
                                    ),
                                  ],
                                  // file type 4
                                  if (userProfile.data!.providerverification!.animalCareProviderCertification != null) ...[
                                    const SizedBox(height: 10),
                                    BasicDocumentDownloadList(
                                      onTap: () {
                                        doDownloadFile(userProfile.data!.providerverification!.animalCareProviderCertification);
                                      },
                                      fileStatus: userProfile.data!.providerverification!.animalCareProviderCertificationVerify.toString(),
                                      downloading: downloading,
                                      downloadProgress: downloadProgress,
                                      title: "Animal Care Provider Certificate",
                                    ),
                                  ],

                                  // file type 6
                                  if (userProfile.data!.providerverification!.animailFirstAid != null) ...[
                                    const SizedBox(height: 10),
                                    BasicDocumentDownloadList(
                                      onTap: () {
                                        doDownloadFile(userProfile.data!.providerverification!.animailFirstAid);
                                      },
                                      fileStatus: userProfile.data!.providerverification!.animailFirstAidVerify.toString(),
                                      downloading: downloading,
                                      downloadProgress: downloadProgress,
                                      title: "Animal First Aid",
                                    ),
                                  ],
                                  // file type 3a

                                  if (userProfile.data!.providerverification!.redCrossBabysittingCertification != null) ...[
                                    const SizedBox(height: 10),
                                    BasicDocumentDownloadList(
                                      onTap: () {
                                        doDownloadFile(userProfile.data!.providerverification!.redCrossBabysittingCertification);
                                      },
                                      fileStatus: userProfile.data!.providerverification!.redCrossBabysittingCertificationVerify.toString(),
                                      downloading: downloading,
                                      downloadProgress: downloadProgress,
                                      title: "Red Cross Babysitting Certification",
                                    ),
                                  ],

                                  // file type 5
                                  if (userProfile.data!.providerverification!.chaildAndFamilyServicesAndAbuse != null) ...[
                                    const SizedBox(height: 10),
                                    BasicDocumentDownloadList(
                                      onTap: () {
                                        doDownloadFile(userProfile.data!.providerverification!.chaildAndFamilyServicesAndAbuse);
                                      },
                                      fileStatus: userProfile.data!.providerverification!.chaildAndFamilyServicesAndAbuseVerify.toString(),
                                      downloading: downloading,
                                      downloadProgress: downloadProgress,
                                      title: "Dept Child and Family Services Child Abuse Check",
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
              ),
      ),
    );
  }
}
