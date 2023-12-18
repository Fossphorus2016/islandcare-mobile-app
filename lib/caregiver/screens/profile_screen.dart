// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

// import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:island_app/caregiver/models/profile_model.dart';
import 'package:island_app/caregiver/screens/profile_edit.dart';
import 'package:island_app/caregiver/widgets/drawer_widget.dart';
import 'package:island_app/screens/notification.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/res/app_url.dart';
import 'package:island_app/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      customErrorSnackBar(
          context, "something went wrong please try again later");
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

  // fetchPRofile
  late Future<ProfileGiverModel> fetchProfile;
  Future<ProfileGiverModel> fetchProfileGiverModel() async {
    var token = await getUserToken();
    final response = await Dio().get(
      CareGiverUrl.serviceProviderProfile,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );
    if (response.statusCode == 200) {
      return ProfileGiverModel.fromJson(response.data);
    } else {
      throw Exception(
        customErrorSnackBar(
          context,
          'Failed to load Profile Model',
        ),
      );
    }
  }

  getUserToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userToken = preferences.getString(
      'userToken',
    );
    return userToken.toString();
  }

  @override
  void initState() {
    getUserToken();
    super.initState();
    fetchProfile = fetchProfileGiverModel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColors.loginBg,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: CustomColors.primaryColor,
          centerTitle: true,
          title: Text(
            "Profile",
            style: TextStyle(
              fontSize: 20,
              color: CustomColors.white,
              fontWeight: FontWeight.w600,
              fontFamily: "Rubik",
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Badge(
                  child: Icon(
                    Icons.notifications_none,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
        drawer: Drawer(
          backgroundColor: CustomColors.primaryColor,
          child: const DrawerGiverWidget(),
        ),
        body: downloading
            ? Center(
                child: SizedBox(
                  height: 120.0,
                  width: 200.0,
                  child: Card(
                    color: CustomColors.primaryColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const CircularProgressIndicator(),
                        const SizedBox(
                          height: 20.0,
                        ),
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
            : SingleChildScrollView(
                child: FutureBuilder<ProfileGiverModel>(
                  future: fetchProfile,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 250,
                            width: MediaQuery.of(context).size.width,
                            child: Stack(
                              children: [
                                Positioned(
                                  top: -25,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: CustomColors.primaryColor,
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                      ),
                                    ),
                                    alignment: Alignment.centerLeft,
                                    width: MediaQuery.of(context).size.width,
                                    height: 150,
                                  ),
                                ),
                                Positioned(
                                  top: 35,
                                  bottom: 5,
                                  right: 8,
                                  left: 8,
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width,
                                    clipBehavior: Clip.antiAlias,

                                    // transform: ,
                                    margin: const EdgeInsets.all(7),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(50),
                                        bottomRight: Radius.circular(50),
                                      ),
                                      image: DecorationImage(
                                        alignment: Alignment.topCenter,
                                        fit: BoxFit.fitWidth,
                                        image: AssetImage(
                                          "assets/images/profileBackground.png",
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          snapshot.data!.data!.firstName
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: "Rubik",
                                            fontWeight: FontWeight.w700,
                                            color: CustomColors.white,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data!.data!.email.toString(),
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: "Rubik",
                                            fontWeight: FontWeight.w400,
                                            color: CustomColors.white,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 7,
                                                      horizontal: 4),
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color.fromARGB(
                                                        13, 0, 0, 0),
                                                    blurRadius: 4.0,
                                                    spreadRadius: 2.0,
                                                    offset: Offset(2.0, 2.0),
                                                  ),
                                                ],
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(6),
                                                  bottomRight:
                                                      Radius.circular(6),
                                                  topLeft: Radius.circular(6),
                                                  topRight: Radius.circular(6),
                                                ),
                                              ),
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    WidgetSpan(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 1,
                                                                right: 5),
                                                        child: Icon(
                                                          Icons.phone_outlined,
                                                          size: 14,
                                                          color: CustomColors
                                                              .primaryTextLight,
                                                        ),
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: snapshot
                                                          .data!.data!.phone
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: CustomColors
                                                            .primaryTextLight,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 14),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 7,
                                                      horizontal: 4),
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color.fromARGB(
                                                        13, 0, 0, 0),
                                                    blurRadius: 4.0,
                                                    spreadRadius: 2.0,
                                                    offset: Offset(2.0, 2.0),
                                                  ),
                                                ],
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(6),
                                                  bottomRight:
                                                      Radius.circular(6),
                                                  topLeft: Radius.circular(6),
                                                  topRight: Radius.circular(6),
                                                ),
                                              ),
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    WidgetSpan(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 3,
                                                                right: 5),
                                                        child: Icon(
                                                          Icons
                                                              .location_on_outlined,
                                                          size: 14,
                                                          color: CustomColors
                                                              .primaryTextLight,
                                                        ),
                                                      ),
                                                    ),
                                                    snapshot
                                                                .data!
                                                                .data!
                                                                .userdetail!
                                                                .address
                                                                .toString() !=
                                                            "null"
                                                        ? TextSpan(
                                                            text: snapshot
                                                                        .data!
                                                                        .data!
                                                                        .userdetail!
                                                                        .address
                                                                        .toString() ==
                                                                    "null"
                                                                ? "Not Available"
                                                                : snapshot
                                                                    .data!
                                                                    .data!
                                                                    .userdetail!
                                                                    .address
                                                                    .toString(),
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: CustomColors
                                                                  .primaryTextLight,
                                                            ),
                                                          )
                                                        : TextSpan(
                                                            text: "Required",
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  CustomColors
                                                                      .red,
                                                            ),
                                                          ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 5,
                                  left: 100,
                                  right: 100,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(50),
                                        bottomRight: Radius.circular(50),
                                        topLeft: Radius.circular(50),
                                        topRight: Radius.circular(50),
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    width: 90,
                                    height: 90,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        // color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromARGB(13, 0, 0, 0),
                                            blurRadius: 4.0,
                                            spreadRadius: 2.0,
                                            offset: Offset(2.0, 2.0),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(50),
                                          bottomRight: Radius.circular(50),
                                          topLeft: Radius.circular(50),
                                          topRight: Radius.circular(50),
                                        ),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfileGiverPendingEdit(
                                                avatar: snapshot
                                                    .data!.data!.avatar
                                                    .toString(),
                                                gender: snapshot.data!.data!
                                                    .userdetail!.gender
                                                    .toString(),
                                                phoneNumber: snapshot
                                                    .data!.data!.phone
                                                    .toString(),
                                                dob: snapshot
                                                    .data!.data!.userdetail!.dob
                                                    .toString(),
                                                yoe: snapshot
                                                    .data!
                                                    .data!
                                                    .userdetailprovider!
                                                    .experience
                                                    .toString(),
                                                hourlyRate: snapshot
                                                    .data!
                                                    .data!
                                                    .userdetailprovider!
                                                    .hourlyRate
                                                    .toString(),
                                                userAddress: snapshot.data!
                                                    .data!.userdetail!.address
                                                    .toString(),
                                                zipCode: snapshot
                                                    .data!.data!.userdetail!.zip
                                                    .toString(),
                                                additionalService: snapshot
                                                    .data!
                                                    .data!
                                                    .userdetailprovider!
                                                    .keywords
                                                    .toString(),
                                                availability: snapshot
                                                    .data!
                                                    .data!
                                                    .userdetailprovider!
                                                    .availability
                                                    .toString(),
                                                userInfo: snapshot.data!.data!
                                                    .userdetail!.userInfo
                                                    .toString(),
                                                enhancedCriminal: snapshot
                                                    .data!
                                                    .data!
                                                    .providerverification!
                                                    .enhancedCriminal,
                                                enhancedCriminalStatus: snapshot
                                                    .data!
                                                    .data!
                                                    .providerverification!
                                                    .enhancedCriminalVerify,
                                                basicCriminal: snapshot
                                                    .data!
                                                    .data!
                                                    .providerverification!
                                                    .basicCriminal,
                                                basicCriminalStatus: snapshot
                                                    .data!
                                                    .data!
                                                    .providerverification!
                                                    .basicCriminalVerify,
                                                firstAid: snapshot
                                                    .data!
                                                    .data!
                                                    .providerverification!
                                                    .firstAid,
                                                firstAidStatus: snapshot
                                                    .data!
                                                    .data!
                                                    .providerverification!
                                                    .firstAidVerify,
                                                vehicleRecord: snapshot
                                                    .data!
                                                    .data!
                                                    .providerverification!
                                                    .vehicleRecord,
                                                vehicleRecordStatus: snapshot
                                                    .data!
                                                    .data!
                                                    .providerverification!
                                                    .vehicleRecordVerify,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Center(
                                            child: ClipRRect(
                                          // clipper: const ShapeBorderClipper(shape: ),
                                          borderRadius:
                                              BorderRadius.circular(500),
                                          child: Image(
                                            image: NetworkImage(
                                                "${AppUrl.webStorageUrl}/${snapshot.data!.data!.avatar.toString()}"),
                                          ),
                                        )),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // CustomPaint(
                          //   painter: HeaderCurvedContainer(),
                          //   child: SizedBox(
                          //     width: MediaQuery.of(context).size.width,
                          //     height: MediaQuery.of(context).size.height,
                          //   ),
                          // ),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 17, vertical: 10),
                                  margin: const EdgeInsets.only(bottom: 15),
                                  decoration: BoxDecoration(
                                    color: CustomColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Name",
                                            style: TextStyle(
                                              color: CustomColors.primaryColor,
                                              fontSize: 10,
                                              fontFamily: "Rubik",
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "${snapshot.data!.data!.firstName} ${snapshot.data!.data!.lastName}",
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 17, vertical: 10),
                                  margin: const EdgeInsets.only(bottom: 15),
                                  decoration: BoxDecoration(
                                    color: CustomColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Gender",
                                            style: TextStyle(
                                              color: CustomColors.primaryColor,
                                              fontSize: 10,
                                              fontFamily: "Rubik",
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          snapshot.data!.data!.userdetail!
                                                      .gender
                                                      .toString() !=
                                                  "null"
                                              ? Text(
                                                  (snapshot
                                                              .data!
                                                              .data!
                                                              .userdetail!
                                                              .gender
                                                              .toString() ==
                                                          "1")
                                                      ? "Male"
                                                      : (snapshot
                                                                  .data!
                                                                  .data!
                                                                  .userdetail!
                                                                  .gender
                                                                  .toString() ==
                                                              "2")
                                                          ? "Female"
                                                          : "Required",
                                                  style: TextStyle(
                                                    color:
                                                        CustomColors.hintText,
                                                    fontSize: 16,
                                                    fontFamily: "Rubik",
                                                    fontWeight: FontWeight.w200,
                                                  ),
                                                )
                                              : Text(
                                                  (snapshot
                                                              .data!
                                                              .data!
                                                              .userdetail!
                                                              .gender
                                                              .toString() ==
                                                          "1")
                                                      ? "Male"
                                                      : (snapshot
                                                                  .data!
                                                                  .data!
                                                                  .userdetail!
                                                                  .gender
                                                                  .toString() ==
                                                              "2")
                                                          ? "Female"
                                                          : "Required",
                                                  style: TextStyle(
                                                    color: CustomColors.red,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 17, vertical: 10),
                                  margin: const EdgeInsets.only(bottom: 15),
                                  decoration: BoxDecoration(
                                    color: CustomColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Area of Insterest",
                                            style: TextStyle(
                                              color: CustomColors.primaryColor,
                                              fontSize: 10,
                                              fontFamily: "Rubik",
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            snapshot.data!.data!.userdetail!
                                                        .service!.name
                                                        .toString() ==
                                                    "null"
                                                ? "Not Available"
                                                : snapshot.data!.data!
                                                    .userdetail!.service!.name
                                                    .toString(),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 17, vertical: 10),
                                  margin: const EdgeInsets.only(bottom: 15),
                                  decoration: BoxDecoration(
                                    color: CustomColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Years of Experience",
                                              style: TextStyle(
                                                color:
                                                    CustomColors.primaryColor,
                                                fontSize: 10,
                                                fontFamily: "Rubik",
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            snapshot
                                                        .data!
                                                        .data!
                                                        .userdetailprovider!
                                                        .experience
                                                        .toString() ==
                                                    "null"
                                                ? Text(
                                                    snapshot
                                                                .data!
                                                                .data!
                                                                .userdetailprovider!
                                                                .experience
                                                                .toString() ==
                                                            "null"
                                                        ? "Required"
                                                        : snapshot
                                                            .data!
                                                            .data!
                                                            .userdetailprovider!
                                                            .experience
                                                            .toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: CustomColors.red,
                                                      fontSize: 16,
                                                      fontFamily: "Rubik",
                                                      fontWeight:
                                                          FontWeight.w200,
                                                    ),
                                                  )
                                                : Text(
                                                    snapshot
                                                                .data!
                                                                .data!
                                                                .userdetailprovider!
                                                                .experience
                                                                .toString() ==
                                                            "null"
                                                        ? "Required"
                                                        : snapshot
                                                            .data!
                                                            .data!
                                                            .userdetailprovider!
                                                            .experience
                                                            .toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color:
                                                          CustomColors.hintText,
                                                      fontSize: 16,
                                                      fontFamily: "Rubik",
                                                      fontWeight:
                                                          FontWeight.w200,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Hourly
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 17, vertical: 10),
                                  margin: const EdgeInsets.only(bottom: 15),
                                  decoration: BoxDecoration(
                                    color: CustomColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Hourly Rate",
                                              style: TextStyle(
                                                color:
                                                    CustomColors.primaryColor,
                                                fontSize: 10,
                                                fontFamily: "Rubik",
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            snapshot
                                                        .data!
                                                        .data!
                                                        .userdetailprovider!
                                                        .hourlyRate
                                                        .toString() ==
                                                    "null"
                                                ? Text(
                                                    snapshot
                                                                .data!
                                                                .data!
                                                                .userdetailprovider!
                                                                .hourlyRate
                                                                .toString() ==
                                                            "null"
                                                        ? "Required"
                                                        : snapshot
                                                            .data!
                                                            .data!
                                                            .userdetailprovider!
                                                            .hourlyRate
                                                            .toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: CustomColors.red,
                                                      fontSize: 16,
                                                      fontFamily: "Rubik",
                                                      fontWeight:
                                                          FontWeight.w200,
                                                    ),
                                                  )
                                                : Text(
                                                    "\$ ${snapshot.data!.data!.userdetailprovider!.hourlyRate.toString() == "null" ? "Required" : snapshot.data!.data!.userdetailprovider!.hourlyRate.toString()}",
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color:
                                                          CustomColors.hintText,
                                                      fontSize: 16,
                                                      fontFamily: "Rubik",
                                                      fontWeight:
                                                          FontWeight.w200,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 17, vertical: 10),
                                  margin: const EdgeInsets.only(bottom: 15),
                                  decoration: BoxDecoration(
                                    color: CustomColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Date Of Birth",
                                            style: TextStyle(
                                              color: CustomColors.primaryColor,
                                              fontSize: 10,
                                              fontFamily: "Rubik",
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            snapshot.data!.data!.userdetail!.dob
                                                .toString(),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 17, vertical: 10),
                                  margin: const EdgeInsets.only(bottom: 15),
                                  decoration: BoxDecoration(
                                    color: CustomColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Zip Code",
                                            style: TextStyle(
                                              color: CustomColors.primaryColor,
                                              fontSize: 10,
                                              fontFamily: "Rubik",
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          snapshot.data!.data!.userdetail!.zip
                                                      .toString() ==
                                                  "null"
                                              ? Text(
                                                  snapshot.data!.data!
                                                              .userdetail!.zip
                                                              .toString() ==
                                                          "null"
                                                      ? "Required"
                                                      : snapshot.data!.data!
                                                          .userdetail!.zip
                                                          .toString(),
                                                  style: TextStyle(
                                                    color: CustomColors.red,
                                                    fontSize: 16,
                                                    fontFamily: "Rubik",
                                                    fontWeight: FontWeight.w200,
                                                  ),
                                                )
                                              : Text(
                                                  snapshot.data!.data!
                                                              .userdetail!.zip
                                                              .toString() ==
                                                          "null"
                                                      ? "Required"
                                                      : snapshot.data!.data!
                                                          .userdetail!.zip
                                                          .toString(),
                                                  style: TextStyle(
                                                    color:
                                                        CustomColors.hintText,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 17, vertical: 10),
                                  margin: const EdgeInsets.only(bottom: 15),
                                  decoration: BoxDecoration(
                                    color: CustomColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Additional Services",
                                              style: TextStyle(
                                                color:
                                                    CustomColors.primaryColor,
                                                fontSize: 10,
                                                fontFamily: "Rubik",
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            snapshot
                                                        .data!
                                                        .data!
                                                        .userdetailprovider!
                                                        .keywords
                                                        .toString() ==
                                                    "null"
                                                ? Text(
                                                    snapshot
                                                                .data!
                                                                .data!
                                                                .userdetailprovider!
                                                                .keywords
                                                                .toString() ==
                                                            "null"
                                                        ? "Required"
                                                        : snapshot
                                                            .data!
                                                            .data!
                                                            .userdetailprovider!
                                                            .keywords
                                                            .toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: CustomColors.red,
                                                      fontSize: 16,
                                                      fontFamily: "Rubik",
                                                      fontWeight:
                                                          FontWeight.w200,
                                                    ),
                                                  )
                                                : Text(
                                                    snapshot
                                                                .data!
                                                                .data!
                                                                .userdetailprovider!
                                                                .keywords
                                                                .toString() ==
                                                            "null"
                                                        ? "Required"
                                                        : snapshot
                                                            .data!
                                                            .data!
                                                            .userdetailprovider!
                                                            .keywords
                                                            .toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color:
                                                          CustomColors.hintText,
                                                      fontSize: 16,
                                                      fontFamily: "Rubik",
                                                      fontWeight:
                                                          FontWeight.w200,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 17, vertical: 10),
                                  margin: const EdgeInsets.only(bottom: 15),
                                  decoration: BoxDecoration(
                                    color: CustomColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Education",
                                              style: TextStyle(
                                                color:
                                                    CustomColors.primaryColor,
                                                fontSize: 10,
                                                fontFamily: "Rubik",
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: snapshot.data!.data!
                                                  .educations!.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 10,
                                                      horizontal: 5),
                                                  margin: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: CustomColors
                                                          .paraColor,
                                                      width: 0.5,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Institue Name: ${snapshot.data!.data!.educations![index].name}",
                                                        softWrap: true,
                                                        style: TextStyle(
                                                          color: CustomColors
                                                              .hintText,
                                                          fontSize: 14,
                                                          fontFamily: "Rubik",
                                                          fontWeight:
                                                              FontWeight.w200,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        "Major: ${snapshot.data!.data!.educations![index].major}",
                                                        softWrap: true,
                                                        style: TextStyle(
                                                          color: CustomColors
                                                              .hintText,
                                                          fontSize: 12,
                                                          fontFamily: "Rubik",
                                                          fontWeight:
                                                              FontWeight.w200,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        "From: ${snapshot.data!.data!.educations![index].from}",
                                                        softWrap: true,
                                                        style: TextStyle(
                                                          color: CustomColors
                                                              .hintText,
                                                          fontSize: 12,
                                                          fontFamily: "Rubik",
                                                          fontWeight:
                                                              FontWeight.w200,
                                                        ),
                                                      ),
                                                      snapshot
                                                                  .data!
                                                                  .data!
                                                                  .educations![
                                                                      index]
                                                                  .to ==
                                                              ""
                                                          ? Text(
                                                              "Time Period: Currently Studying",
                                                              softWrap: true,
                                                              style: TextStyle(
                                                                height: 2,
                                                                color:
                                                                    CustomColors
                                                                        .hintText,
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    "Rubik",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w200,
                                                              ),
                                                            )
                                                          : Text(
                                                              "",
                                                              softWrap: true,
                                                              style: TextStyle(
                                                                height: 0,
                                                                color:
                                                                    CustomColors
                                                                        .hintText,
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    "Rubik",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w200,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 17, vertical: 10),
                                  margin: const EdgeInsets.only(bottom: 15),
                                  decoration: BoxDecoration(
                                    color: CustomColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "User Information",
                                              style: TextStyle(
                                                color:
                                                    CustomColors.primaryColor,
                                                fontSize: 10,
                                                fontFamily: "Rubik",
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            snapshot.data!.data!.userdetail!
                                                        .userInfo
                                                        .toString() ==
                                                    "null"
                                                ? Text(
                                                    snapshot
                                                                .data!
                                                                .data!
                                                                .userdetail!
                                                                .userInfo
                                                                .toString() ==
                                                            "null"
                                                        ? "Required"
                                                        : snapshot
                                                            .data!
                                                            .data!
                                                            .userdetail!
                                                            .userInfo
                                                            .toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: CustomColors.red,
                                                      fontSize: 16,
                                                      fontFamily: "Rubik",
                                                      fontWeight:
                                                          FontWeight.w200,
                                                    ),
                                                  )
                                                : Text(
                                                    snapshot
                                                                .data!
                                                                .data!
                                                                .userdetail!
                                                                .userInfo
                                                                .toString() ==
                                                            "null"
                                                        ? "Required"
                                                        : snapshot
                                                            .data!
                                                            .data!
                                                            .userdetail!
                                                            .userInfo
                                                            .toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color:
                                                          CustomColors.hintText,
                                                      fontSize: 16,
                                                      fontFamily: "Rubik",
                                                      fontWeight:
                                                          FontWeight.w200,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 17, vertical: 10),
                                  margin: const EdgeInsets.only(bottom: 15),
                                  decoration: BoxDecoration(
                                    color: CustomColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Availability",
                                              style: TextStyle(
                                                color:
                                                    CustomColors.primaryColor,
                                                fontSize: 10,
                                                fontFamily: "Rubik",
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            snapshot
                                                        .data!
                                                        .data!
                                                        .userdetailprovider!
                                                        .availability
                                                        .toString() ==
                                                    "null"
                                                ? Text(
                                                    snapshot
                                                                .data!
                                                                .data!
                                                                .userdetailprovider!
                                                                .availability
                                                                .toString() ==
                                                            "null"
                                                        ? "Required"
                                                        : snapshot
                                                            .data!
                                                            .data!
                                                            .userdetailprovider!
                                                            .availability
                                                            .toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: CustomColors.red,
                                                      fontSize: 16,
                                                      fontFamily: "Rubik",
                                                      fontWeight:
                                                          FontWeight.w200,
                                                    ),
                                                  )
                                                : Text(
                                                    snapshot
                                                                .data!
                                                                .data!
                                                                .userdetailprovider!
                                                                .availability
                                                                .toString() ==
                                                            "null"
                                                        ? "Required"
                                                        : snapshot
                                                            .data!
                                                            .data!
                                                            .userdetailprovider!
                                                            .availability
                                                            .toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color:
                                                          CustomColors.hintText,
                                                      fontSize: 16,
                                                      fontFamily: "Rubik",
                                                      fontWeight:
                                                          FontWeight.w200,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 17, vertical: 10),
                                  margin: const EdgeInsets.only(bottom: 15),
                                  decoration: BoxDecoration(
                                    color: CustomColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Additional Services",
                                              style: TextStyle(
                                                color:
                                                    CustomColors.primaryColor,
                                                fontSize: 10,
                                                fontFamily: "Rubik",
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            snapshot
                                                        .data!
                                                        .data!
                                                        .userdetailprovider!
                                                        .keywords
                                                        .toString() ==
                                                    "null"
                                                ? Text(
                                                    snapshot
                                                                .data!
                                                                .data!
                                                                .userdetailprovider!
                                                                .keywords
                                                                .toString() ==
                                                            "null"
                                                        ? "Required"
                                                        : snapshot
                                                            .data!
                                                            .data!
                                                            .userdetailprovider!
                                                            .keywords
                                                            .toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: CustomColors.red,
                                                      fontSize: 16,
                                                      fontFamily: "Rubik",
                                                      fontWeight:
                                                          FontWeight.w200,
                                                    ),
                                                  )
                                                : Text(
                                                    snapshot
                                                                .data!
                                                                .data!
                                                                .userdetailprovider!
                                                                .keywords
                                                                .toString() ==
                                                            "null"
                                                        ? "Required"
                                                        : snapshot
                                                            .data!
                                                            .data!
                                                            .userdetailprovider!
                                                            .keywords
                                                            .toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color:
                                                          CustomColors.hintText,
                                                      fontSize: 16,
                                                      fontFamily: "Rubik",
                                                      fontWeight:
                                                          FontWeight.w200,
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
                                  color: CustomColors.primaryColor,
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                      color: CustomColors.primaryLight,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.workspace_premium,
                                        color: CustomColors.primaryColor,
                                      ),
                                      title: Text(
                                        "Background Varified",
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
                                const SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () {
                                    if (snapshot
                                        .data!
                                        .data!
                                        .providerverification!
                                        .enhancedCriminal!
                                        .isNotEmpty) {
                                      doDownloadFile(snapshot
                                          .data!
                                          .data!
                                          .providerverification!
                                          .enhancedCriminal);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: CustomColors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton.icon(
                                          onPressed: () {
                                            if (snapshot
                                                .data!
                                                .data!
                                                .providerverification!
                                                .enhancedCriminal!
                                                .isNotEmpty) {
                                              doDownloadFile(snapshot
                                                  .data!
                                                  .data!
                                                  .providerverification!
                                                  .enhancedCriminal);
                                            }
                                          },
                                          icon: Icon(
                                            Icons.picture_as_pdf_rounded,
                                            color: CustomColors.red,
                                          ),
                                          label: Text(
                                            downloading
                                                ? "Download Enhanced Criminal Document $downloadProgress"
                                                : "Download Enhanced Criminal Document",
                                            style: TextStyle(
                                                fontSize: 10,
                                                color:
                                                    CustomColors.primaryText),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {},
                                          child: DottedBorder(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 14, horizontal: 5),
                                            radius: const Radius.circular(4),
                                            borderType: BorderType.RRect,
                                            color: CustomColors.primaryColor,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.picture_as_pdf_rounded,
                                                  color: CustomColors.red,
                                                  size: 16,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  (snapshot
                                                              .data!
                                                              .data!
                                                              .providerverification!
                                                              .enhancedCriminalVerify
                                                              .toString() ==
                                                          "0")
                                                      ? "Pending"
                                                      : (snapshot
                                                                  .data!
                                                                  .data!
                                                                  .providerverification!
                                                                  .enhancedCriminalVerify
                                                                  .toString() ==
                                                              "1")
                                                          ? "Approved"
                                                          : (snapshot
                                                                      .data!
                                                                      .data!
                                                                      .providerverification!
                                                                      .enhancedCriminalVerify
                                                                      .toString() ==
                                                                  "2")
                                                              ? "Rejected"
                                                              : "File Not Available",
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: CustomColors
                                                        .primaryText,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                GestureDetector(
                                  onTap: () {
                                    doDownloadFile(snapshot.data!.data!
                                        .providerverification!.basicCriminal);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: CustomColors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton.icon(
                                          onPressed: () {
                                            doDownloadFile(snapshot
                                                .data!
                                                .data!
                                                .providerverification!
                                                .basicCriminal);
                                          },
                                          icon: Icon(
                                            Icons.picture_as_pdf_rounded,
                                            color: CustomColors.red,
                                          ),
                                          label: Text(
                                            downloading
                                                ? "Download Basic Criminal Document $downloadProgress"
                                                : "Download Basic Criminal Document",
                                            style: TextStyle(
                                                fontSize: 10,
                                                color:
                                                    CustomColors.primaryText),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            // getEnhancedPdfFile();
                                          },
                                          child: DottedBorder(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 14, horizontal: 5),
                                            radius: const Radius.circular(4),
                                            borderType: BorderType.RRect,
                                            color: CustomColors.primaryColor,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.picture_as_pdf_rounded,
                                                  color: CustomColors.red,
                                                  size: 16,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  (snapshot
                                                              .data!
                                                              .data!
                                                              .providerverification!
                                                              .basicCriminalVerify
                                                              .toString() ==
                                                          "0")
                                                      ? "Pending"
                                                      : (snapshot
                                                                  .data!
                                                                  .data!
                                                                  .providerverification!
                                                                  .basicCriminalVerify
                                                                  .toString() ==
                                                              "1")
                                                          ? "Approved"
                                                          : (snapshot
                                                                      .data!
                                                                      .data!
                                                                      .providerverification!
                                                                      .basicCriminalVerify
                                                                      .toString() ==
                                                                  "2")
                                                              ? "Rejected"
                                                              : "File Not Available",
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: CustomColors
                                                        .primaryText,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                GestureDetector(
                                  onTap: () {
                                    doDownloadFile(snapshot.data!.data!
                                        .providerverification!.firstAid);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: CustomColors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton.icon(
                                          onPressed: () {
                                            doDownloadFile(snapshot
                                                .data!
                                                .data!
                                                .providerverification!
                                                .firstAid);
                                          },
                                          icon: Icon(
                                            Icons.picture_as_pdf_rounded,
                                            color: CustomColors.red,
                                          ),
                                          label: Text(
                                            "Download First Aid Document",
                                            style: TextStyle(
                                                fontSize: 10,
                                                color:
                                                    CustomColors.primaryText),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            // getEnhancedPdfFile();
                                          },
                                          child: DottedBorder(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 14, horizontal: 5),
                                            radius: const Radius.circular(4),
                                            borderType: BorderType.RRect,
                                            color: CustomColors.primaryColor,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.picture_as_pdf_rounded,
                                                  color: CustomColors.red,
                                                  size: 16,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  (snapshot
                                                              .data!
                                                              .data!
                                                              .providerverification!
                                                              .firstAidVerify
                                                              .toString() ==
                                                          "0")
                                                      ? "Pending"
                                                      : (snapshot
                                                                  .data!
                                                                  .data!
                                                                  .providerverification!
                                                                  .firstAidVerify
                                                                  .toString() ==
                                                              "1")
                                                          ? "Approved"
                                                          : (snapshot
                                                                      .data!
                                                                      .data!
                                                                      .providerverification!
                                                                      .firstAidVerify
                                                                      .toString() ==
                                                                  "2")
                                                              ? "Rejected"
                                                              : "File Not Available",
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: CustomColors
                                                        .primaryText,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                GestureDetector(
                                  onTap: () {
                                    doDownloadFile(snapshot.data!.data!
                                        .providerverification!.vehicleRecord);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: CustomColors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton.icon(
                                          onPressed: () {
                                            doDownloadFile(snapshot
                                                .data!
                                                .data!
                                                .providerverification!
                                                .vehicleRecord);
                                          },
                                          icon: Icon(
                                            Icons.picture_as_pdf_rounded,
                                            color: CustomColors.red,
                                          ),
                                          label: Text(
                                            "Download Vehicle Record Document",
                                            style: TextStyle(
                                                fontSize: 10,
                                                color:
                                                    CustomColors.primaryText),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            // getEnhancedPdfFile();
                                          },
                                          child: DottedBorder(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 14, horizontal: 5),
                                            radius: const Radius.circular(4),
                                            borderType: BorderType.RRect,
                                            color: CustomColors.primaryColor,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.picture_as_pdf_rounded,
                                                  color: CustomColors.red,
                                                  size: 16,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  (snapshot
                                                              .data!
                                                              .data!
                                                              .providerverification!
                                                              .vehicleRecordVerify
                                                              .toString() ==
                                                          "0")
                                                      ? "Pending"
                                                      : (snapshot
                                                                  .data!
                                                                  .data!
                                                                  .providerverification!
                                                                  .vehicleRecordVerify
                                                                  .toString() ==
                                                              "1")
                                                          ? "Approved"
                                                          : (snapshot
                                                                      .data!
                                                                      .data!
                                                                      .providerverification!
                                                                      .vehicleRecordVerify
                                                                      .toString() ==
                                                                  "2")
                                                              ? "Rejected"
                                                              : "File Not Available",
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: CustomColors
                                                        .primaryText,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
      ),
    );
  }
}

// class HeaderCurvedContainer extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color = const Color(0xffea5d49)
//       ..style = PaintingStyle.fill;

//     Path path = Path()
//       ..relativeLineTo(0, 100)
//       ..quadraticBezierTo(size.width / 2, 80, size.width, 100)
//       ..relativeLineTo(0, -100)
//       ..close();
//     // Path topStrokePath = Path()
//     //   ..moveTo(0, 0)
//     //   ..lineTo(size.width, 0);

//     // // Combine the main path and top stroke path
//     // path.addPath(topStrokePath, Offset.zero);

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }

class ProfileGiverPending extends StatefulWidget {
  const ProfileGiverPending({super.key});

  @override
  State<ProfileGiverPending> createState() => _ProfileGiverPendingState();
}

class _ProfileGiverPendingState extends State<ProfileGiverPending> {
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

  Future downloadEnhancedFile(String downloadDirectory) async {
    Dio dio = Dio();
    var downloadingPdfPath = '$downloadDirectory/enhanced.pdf';

    try {
      await dio.download(
        hostPath + '/' + pdfEnhancePath!,
        downloadingPdfPath,
        onReceiveProgress: (rec, total) {
          setState(() {
            downloading = true;
            downloadProgress = "${((rec / total) * 100).toStringAsFixed(0)}%";
          });
        },
      );
    } catch (e) {
      customErrorSnackBar(
          context, "something went wrong please try again later");
    }
    await Future.delayed(const Duration(seconds: 3));

    return downloadingPdfPath;
  }

  Future downloadBasicFile(String downloadDirectory) async {
    Dio dio = Dio();
    var downloadingPdfPath = '$downloadDirectory/enhanced.pdf';

    try {
      await dio.download(
        hostPath + '/' + pdfBasicPath!,
        downloadingPdfPath,
        onReceiveProgress: (rec, total) {
          setState(() {
            downloading = true;
            downloadProgress = "${((rec / total) * 100).toStringAsFixed(0)}%";
          });
        },
      );
    } catch (e) {
      customErrorSnackBar(
          context, "something went wrong please try again later");
    }
    await Future.delayed(const Duration(seconds: 3));

    return downloadingPdfPath;
  }

  Future downloadFirstAidFile(String downloadDirectory) async {
    Dio dio = Dio();
    var downloadingPdfPath = '$downloadDirectory/enhanced.pdf';

    try {
      await dio.download(
        hostPath + '/' + pdfFirstAddPath!,
        downloadingPdfPath,
        onReceiveProgress: (rec, total) {
          setState(() {
            downloading = true;
            downloadProgress = "${((rec / total) * 100).toStringAsFixed(0)}%";
          });
        },
      );
    } catch (e) {
      customErrorSnackBar(
          context, "something went wrong please try again later");
    }
    await Future.delayed(const Duration(seconds: 3));

    return downloadingPdfPath;
  }

  Future downloadVehicleRecordFile(String downloadDirectory) async {
    Dio dio = Dio();
    var downloadingPdfPath = '$downloadDirectory/enhanced.pdf';

    try {
      await dio.download(
        hostPath + '/' + pdfvehicleRecordPath!,
        downloadingPdfPath,
        onReceiveProgress: (rec, total) {
          setState(() {
            downloading = true;
            downloadProgress = "${((rec / total) * 100).toStringAsFixed(0)}%";
          });
        },
      );
    } catch (e) {
      customErrorSnackBar(
          context, "something went wrong please try again later");
    }
    await Future.delayed(const Duration(seconds: 3));

    return downloadingPdfPath;
  }

  // Download by user click
  Future<void> doDownloadEnhancedFile() async {
    if (await getStoragePermission()) {
      String downloadDirectory = await getDownloadFolderPath();
      await downloadEnhancedFile(downloadDirectory).then(
        (value) {
          displayPDF(value);
        },
      );
    }
  }

  Future<void> doDownloadBasicFile() async {
    if (await getStoragePermission()) {
      String downloadDirectory = await getDownloadFolderPath();
      await downloadBasicFile(downloadDirectory).then(
        (value) {
          displayPDF(value);
        },
      );
    }
  }

  Future<void> doDownloadFirstAidFile() async {
    if (await getStoragePermission()) {
      String downloadDirectory = await getDownloadFolderPath();
      await downloadFirstAidFile(downloadDirectory).then(
        (value) {
          displayPDF(value);
        },
      );
    }
  }

  Future<void> doDownloadVehicleFile() async {
    if (await getStoragePermission()) {
      String downloadDirectory = await getDownloadFolderPath();
      await downloadVehicleRecordFile(downloadDirectory).then(
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

  // fetchPRofile
  late Future<ProfileGiverModel> fetchProfile;
  Future<ProfileGiverModel> fetchProfileGiverModel() async {
    var token = await userTokenProfile();
    final response = await Dio().get(
      CareGiverUrl.serviceProviderProfile,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );
    if (response.statusCode == 200) {
      return ProfileGiverModel.fromJson(response.data);
    } else {
      throw Exception(
        customErrorSnackBar(
          context,
          'Failed to load Profile Model',
        ),
      );
    }
  }

  getUserToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userToken = preferences.getString(
      'userToken',
    );

    return userToken.toString();
  }

  userTokenProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userToken = preferences.getString(
      'userTokenProfile',
    );

    return userToken.toString();
  }

  @override
  void initState() {
    getUserToken();
    userTokenProfile();
    super.initState();
    fetchProfile = fetchProfileGiverModel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColors.loginBg,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: CustomColors.primaryColor,
          centerTitle: true,
          title: Text(
            "Profile",
            style: TextStyle(
              fontSize: 20,
              color: CustomColors.white,
              fontWeight: FontWeight.w600,
              fontFamily: "Rubik",
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(12.0),
              ),
            )
          ],
        ),
        drawer: Drawer(
          backgroundColor: CustomColors.primaryColor,
          child: const DrawerGiverWidget(),
        ),
        body: downloading
            ? Center(
                child: SizedBox(
                  height: 120.0,
                  width: 200.0,
                  child: Card(
                    color: CustomColors.primaryColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const CircularProgressIndicator(),
                        const SizedBox(
                          height: 20.0,
                        ),
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
            : SingleChildScrollView(
                child: FutureBuilder<ProfileGiverModel>(
                  future: fetchProfile,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                alignment: Alignment.centerRight,
                                width: MediaQuery.of(context).size.width,
                                height: 250,
                                child: const RotatedBox(
                                  quarterTurns: 1,
                                  child: Text(
                                    'Container 1',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: -25,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: CustomColors.primaryColor,
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  width: MediaQuery.of(context).size.width,
                                  height: 150,
                                ),
                              ),
                              Positioned(
                                top: 35,
                                bottom: 5,
                                right: 8,
                                left: 8,
                                child: Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.all(7),
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                        "assets/images/profileBackground.png",
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 20),
                                      Text(
                                        snapshot.data!.data!.firstName
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: "Rubik",
                                          fontWeight: FontWeight.w700,
                                          color: CustomColors.white,
                                        ),
                                      ),
                                      Text(
                                        snapshot.data!.data!.email.toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: "Rubik",
                                          fontWeight: FontWeight.w400,
                                          color: CustomColors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 7, horizontal: 4),
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color.fromARGB(
                                                      13, 0, 0, 0),
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
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 1,
                                                              right: 5),
                                                      child: Icon(
                                                        Icons.phone_outlined,
                                                        size: 14,
                                                        color: CustomColors
                                                            .primaryTextLight,
                                                      ),
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: snapshot
                                                        .data!.data!.phone
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: CustomColors
                                                          .primaryTextLight,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 14),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 7, horizontal: 4),
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color.fromARGB(
                                                      13, 0, 0, 0),
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
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 3,
                                                              right: 5),
                                                      child: Icon(
                                                        Icons
                                                            .location_on_outlined,
                                                        size: 14,
                                                        color: CustomColors
                                                            .primaryTextLight,
                                                      ),
                                                    ),
                                                  ),
                                                  snapshot
                                                              .data!
                                                              .data!
                                                              .userdetail!
                                                              .address
                                                              .toString() !=
                                                          "null"
                                                      ? TextSpan(
                                                          text: snapshot
                                                                      .data!
                                                                      .data!
                                                                      .userdetail!
                                                                      .address
                                                                      .toString() ==
                                                                  "null"
                                                              ? "Not Available"
                                                              : snapshot
                                                                  .data!
                                                                  .data!
                                                                  .userdetail!
                                                                  .address
                                                                  .toString(),
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: CustomColors
                                                                .primaryTextLight,
                                                          ),
                                                        )
                                                      : TextSpan(
                                                          text: "Required",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: CustomColors
                                                                .red,
                                                          ),
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 5,
                                left: 100,
                                right: 100,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(50),
                                      bottomRight: Radius.circular(50),
                                      topLeft: Radius.circular(50),
                                      topRight: Radius.circular(50),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  width: 84,
                                  height: 84,
                                  child: Container(
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
                                        bottomLeft: Radius.circular(50),
                                        bottomRight: Radius.circular(50),
                                        topLeft: Radius.circular(50),
                                        topRight: Radius.circular(50),
                                      ),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProfileGiverPendingEdit(
                                              avatar: snapshot
                                                  .data!.data!.avatar
                                                  .toString(),
                                              gender: snapshot.data!.data!
                                                  .userdetail!.gender
                                                  .toString(),
                                              phoneNumber: snapshot
                                                  .data!.data!.phone
                                                  .toString(),
                                              dob: snapshot
                                                  .data!.data!.userdetail!.dob
                                                  .toString(),
                                              yoe: snapshot
                                                  .data!
                                                  .data!
                                                  .userdetailprovider!
                                                  .experience
                                                  .toString(),
                                              hourlyRate: snapshot
                                                  .data!
                                                  .data!
                                                  .userdetailprovider!
                                                  .hourlyRate
                                                  .toString(),
                                              userAddress: snapshot.data!.data!
                                                  .userdetail!.address
                                                  .toString(),
                                              zipCode: snapshot
                                                  .data!.data!.userdetail!.zip
                                                  .toString(),
                                              additionalService: snapshot
                                                  .data!
                                                  .data!
                                                  .userdetailprovider!
                                                  .keywords
                                                  .toString(),
                                              availability: snapshot
                                                  .data!
                                                  .data!
                                                  .userdetailprovider!
                                                  .availability
                                                  .toString(),
                                              userInfo: snapshot.data!.data!
                                                  .userdetail!.userInfo
                                                  .toString(),
                                              enhancedCriminal: snapshot
                                                  .data!
                                                  .data!
                                                  .providerverification!
                                                  .enhancedCriminal,
                                              enhancedCriminalStatus: snapshot
                                                  .data!
                                                  .data!
                                                  .providerverification!
                                                  .enhancedCriminalVerify,
                                              basicCriminal: snapshot
                                                  .data!
                                                  .data!
                                                  .providerverification!
                                                  .basicCriminal,
                                              basicCriminalStatus: snapshot
                                                  .data!
                                                  .data!
                                                  .providerverification!
                                                  .basicCriminalVerify,
                                              firstAid: snapshot
                                                  .data!
                                                  .data!
                                                  .providerverification!
                                                  .firstAid,
                                              firstAidStatus: snapshot
                                                  .data!
                                                  .data!
                                                  .providerverification!
                                                  .firstAidVerify,
                                              vehicleRecord: snapshot
                                                  .data!
                                                  .data!
                                                  .providerverification!
                                                  .vehicleRecord,
                                              vehicleRecordStatus: snapshot
                                                  .data!
                                                  .data!
                                                  .providerverification!
                                                  .vehicleRecordVerify,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                                const SizedBox(
                                  height: 10,
                                ),
                                // Name
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 17, vertical: 10),
                                  margin: const EdgeInsets.only(bottom: 15),
                                  decoration: BoxDecoration(
                                    color: CustomColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Name",
                                            style: TextStyle(
                                              color: CustomColors.primaryColor,
                                              fontSize: 10,
                                              fontFamily: "Rubik",
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            "${snapshot.data!.data!.firstName} ${snapshot.data!.data!.lastName}",
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 17, vertical: 10),
                                  margin: const EdgeInsets.only(bottom: 15),
                                  decoration: BoxDecoration(
                                    color: CustomColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Gender",
                                            style: TextStyle(
                                              color: CustomColors.primaryColor,
                                              fontSize: 10,
                                              fontFamily: "Rubik",
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          snapshot.data!.data!.userdetail!
                                                      .gender
                                                      .toString() !=
                                                  "null"
                                              ? Text(
                                                  (snapshot
                                                              .data!
                                                              .data!
                                                              .userdetail!
                                                              .gender
                                                              .toString() ==
                                                          "1")
                                                      ? "Male"
                                                      : (snapshot
                                                                  .data!
                                                                  .data!
                                                                  .userdetail!
                                                                  .gender
                                                                  .toString() ==
                                                              "2")
                                                          ? "Female"
                                                          : "Required",
                                                  style: TextStyle(
                                                    color:
                                                        CustomColors.hintText,
                                                    fontSize: 16,
                                                    fontFamily: "Rubik",
                                                    fontWeight: FontWeight.w200,
                                                  ),
                                                )
                                              : Text(
                                                  (snapshot
                                                              .data!
                                                              .data!
                                                              .userdetail!
                                                              .gender
                                                              .toString() ==
                                                          "1")
                                                      ? "Male"
                                                      : (snapshot
                                                                  .data!
                                                                  .data!
                                                                  .userdetail!
                                                                  .gender
                                                                  .toString() ==
                                                              "2")
                                                          ? "Female"
                                                          : "Required",
                                                  style: TextStyle(
                                                    color: CustomColors.red,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 17, vertical: 10),
                                  margin: const EdgeInsets.only(bottom: 15),
                                  decoration: BoxDecoration(
                                    color: CustomColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Area of Insterest",
                                            style: TextStyle(
                                              color: CustomColors.primaryColor,
                                              fontSize: 10,
                                              fontFamily: "Rubik",
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            snapshot.data!.data!.userdetail!
                                                        .service!.name
                                                        .toString() ==
                                                    "null"
                                                ? "Not Available"
                                                : snapshot.data!.data!
                                                    .userdetail!.service!.name
                                                    .toString(),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 17, vertical: 10),
                                  margin: const EdgeInsets.only(bottom: 15),
                                  decoration: BoxDecoration(
                                    color: CustomColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Years of Experience",
                                              style: TextStyle(
                                                color:
                                                    CustomColors.primaryColor,
                                                fontSize: 10,
                                                fontFamily: "Rubik",
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            snapshot
                                                        .data!
                                                        .data!
                                                        .userdetailprovider!
                                                        .experience
                                                        .toString() ==
                                                    "null"
                                                ? Text(
                                                    snapshot
                                                                .data!
                                                                .data!
                                                                .userdetailprovider!
                                                                .experience
                                                                .toString() ==
                                                            "null"
                                                        ? "Required"
                                                        : snapshot
                                                            .data!
                                                            .data!
                                                            .userdetailprovider!
                                                            .experience
                                                            .toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: CustomColors.red,
                                                      fontSize: 16,
                                                      fontFamily: "Rubik",
                                                      fontWeight:
                                                          FontWeight.w200,
                                                    ),
                                                  )
                                                : Text(
                                                    snapshot
                                                                .data!
                                                                .data!
                                                                .userdetailprovider!
                                                                .experience
                                                                .toString() ==
                                                            "null"
                                                        ? "Required"
                                                        : snapshot
                                                            .data!
                                                            .data!
                                                            .userdetailprovider!
                                                            .experience
                                                            .toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color:
                                                          CustomColors.hintText,
                                                      fontSize: 16,
                                                      fontFamily: "Rubik",
                                                      fontWeight:
                                                          FontWeight.w200,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Hourly
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 17, vertical: 10),
                                  margin: const EdgeInsets.only(bottom: 15),
                                  decoration: BoxDecoration(
                                    color: CustomColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Hourly Rate",
                                              style: TextStyle(
                                                color:
                                                    CustomColors.primaryColor,
                                                fontSize: 10,
                                                fontFamily: "Rubik",
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            snapshot
                                                        .data!
                                                        .data!
                                                        .userdetailprovider!
                                                        .hourlyRate
                                                        .toString() ==
                                                    "null"
                                                ? Text(
                                                    snapshot
                                                                .data!
                                                                .data!
                                                                .userdetailprovider!
                                                                .hourlyRate
                                                                .toString() ==
                                                            "null"
                                                        ? "Required"
                                                        : snapshot
                                                            .data!
                                                            .data!
                                                            .userdetailprovider!
                                                            .hourlyRate
                                                            .toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: CustomColors.red,
                                                      fontSize: 16,
                                                      fontFamily: "Rubik",
                                                      fontWeight:
                                                          FontWeight.w200,
                                                    ),
                                                  )
                                                : Text(
                                                    "\$ ${snapshot.data!.data!.userdetailprovider!.hourlyRate.toString() == "null" ? "Required" : snapshot.data!.data!.userdetailprovider!.hourlyRate.toString()}",
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color:
                                                          CustomColors.hintText,
                                                      fontSize: 16,
                                                      fontFamily: "Rubik",
                                                      fontWeight:
                                                          FontWeight.w200,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 17, vertical: 10),
                                  margin: const EdgeInsets.only(bottom: 15),
                                  decoration: BoxDecoration(
                                    color: CustomColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Date Of Birth",
                                            style: TextStyle(
                                              color: CustomColors.primaryColor,
                                              fontSize: 10,
                                              fontFamily: "Rubik",
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            snapshot.data!.data!.userdetail!.dob
                                                .toString(),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 17, vertical: 10),
                                  margin: const EdgeInsets.only(bottom: 15),
                                  decoration: BoxDecoration(
                                    color: CustomColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Zip Code",
                                            style: TextStyle(
                                              color: CustomColors.primaryColor,
                                              fontSize: 10,
                                              fontFamily: "Rubik",
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          snapshot.data!.data!.userdetail!.zip
                                                      .toString() ==
                                                  "null"
                                              ? Text(
                                                  snapshot.data!.data!
                                                              .userdetail!.zip
                                                              .toString() ==
                                                          "null"
                                                      ? "Required"
                                                      : snapshot.data!.data!
                                                          .userdetail!.zip
                                                          .toString(),
                                                  style: TextStyle(
                                                    color: CustomColors.red,
                                                    fontSize: 16,
                                                    fontFamily: "Rubik",
                                                    fontWeight: FontWeight.w200,
                                                  ),
                                                )
                                              : Text(
                                                  snapshot.data!.data!
                                                              .userdetail!.zip
                                                              .toString() ==
                                                          "null"
                                                      ? "Required"
                                                      : snapshot.data!.data!
                                                          .userdetail!.zip
                                                          .toString(),
                                                  style: TextStyle(
                                                    color:
                                                        CustomColors.hintText,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 17, vertical: 10),
                                  margin: const EdgeInsets.only(bottom: 15),
                                  decoration: BoxDecoration(
                                    color: CustomColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Additional Services",
                                              style: TextStyle(
                                                color:
                                                    CustomColors.primaryColor,
                                                fontSize: 10,
                                                fontFamily: "Rubik",
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            snapshot
                                                        .data!
                                                        .data!
                                                        .userdetailprovider!
                                                        .keywords
                                                        .toString() ==
                                                    "null"
                                                ? Text(
                                                    snapshot
                                                                .data!
                                                                .data!
                                                                .userdetailprovider!
                                                                .keywords
                                                                .toString() ==
                                                            "null"
                                                        ? "Required"
                                                        : snapshot
                                                            .data!
                                                            .data!
                                                            .userdetailprovider!
                                                            .keywords
                                                            .toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: CustomColors.red,
                                                      fontSize: 16,
                                                      fontFamily: "Rubik",
                                                      fontWeight:
                                                          FontWeight.w200,
                                                    ),
                                                  )
                                                : Text(
                                                    snapshot
                                                                .data!
                                                                .data!
                                                                .userdetailprovider!
                                                                .keywords
                                                                .toString() ==
                                                            "null"
                                                        ? "Required"
                                                        : snapshot
                                                            .data!
                                                            .data!
                                                            .userdetailprovider!
                                                            .keywords
                                                            .toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color:
                                                          CustomColors.hintText,
                                                      fontSize: 16,
                                                      fontFamily: "Rubik",
                                                      fontWeight:
                                                          FontWeight.w200,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 17, vertical: 10),
                                  margin: const EdgeInsets.only(bottom: 15),
                                  decoration: BoxDecoration(
                                    color: CustomColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Education",
                                              style: TextStyle(
                                                color:
                                                    CustomColors.primaryColor,
                                                fontSize: 10,
                                                fontFamily: "Rubik",
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: snapshot.data!.data!
                                                  .educations!.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 10,
                                                      horizontal: 5),
                                                  margin: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: CustomColors
                                                          .paraColor,
                                                      width: 0.5,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Institue Name: ${snapshot.data!.data!.educations![index].name}",
                                                        softWrap: true,
                                                        style: TextStyle(
                                                          color: CustomColors
                                                              .hintText,
                                                          fontSize: 14,
                                                          fontFamily: "Rubik",
                                                          fontWeight:
                                                              FontWeight.w200,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        "Major: ${snapshot.data!.data!.educations![index].major}",
                                                        softWrap: true,
                                                        style: TextStyle(
                                                          color: CustomColors
                                                              .hintText,
                                                          fontSize: 12,
                                                          fontFamily: "Rubik",
                                                          fontWeight:
                                                              FontWeight.w200,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        "From: ${snapshot.data!.data!.educations![index].from}",
                                                        softWrap: true,
                                                        style: TextStyle(
                                                          color: CustomColors
                                                              .hintText,
                                                          fontSize: 12,
                                                          fontFamily: "Rubik",
                                                          fontWeight:
                                                              FontWeight.w200,
                                                        ),
                                                      ),
                                                      snapshot
                                                                  .data!
                                                                  .data!
                                                                  .educations![
                                                                      index]
                                                                  .to ==
                                                              ""
                                                          ? Text(
                                                              "Time Period: Currently Studying",
                                                              softWrap: true,
                                                              style: TextStyle(
                                                                height: 2,
                                                                color:
                                                                    CustomColors
                                                                        .hintText,
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    "Rubik",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w200,
                                                              ),
                                                            )
                                                          : Text(
                                                              "",
                                                              softWrap: true,
                                                              style: TextStyle(
                                                                height: 0,
                                                                color:
                                                                    CustomColors
                                                                        .hintText,
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    "Rubik",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w200,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 17, vertical: 10),
                                  margin: const EdgeInsets.only(bottom: 15),
                                  decoration: BoxDecoration(
                                    color: CustomColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "User Information",
                                              style: TextStyle(
                                                color:
                                                    CustomColors.primaryColor,
                                                fontSize: 10,
                                                fontFamily: "Rubik",
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            snapshot.data!.data!.userdetail!
                                                        .userInfo
                                                        .toString() ==
                                                    "null"
                                                ? Text(
                                                    snapshot
                                                                .data!
                                                                .data!
                                                                .userdetail!
                                                                .userInfo
                                                                .toString() ==
                                                            "null"
                                                        ? "Required"
                                                        : snapshot
                                                            .data!
                                                            .data!
                                                            .userdetail!
                                                            .userInfo
                                                            .toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: CustomColors.red,
                                                      fontSize: 16,
                                                      fontFamily: "Rubik",
                                                      fontWeight:
                                                          FontWeight.w200,
                                                    ),
                                                  )
                                                : Text(
                                                    snapshot
                                                                .data!
                                                                .data!
                                                                .userdetail!
                                                                .userInfo
                                                                .toString() ==
                                                            "null"
                                                        ? "Required"
                                                        : snapshot
                                                            .data!
                                                            .data!
                                                            .userdetail!
                                                            .userInfo
                                                            .toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color:
                                                          CustomColors.hintText,
                                                      fontSize: 16,
                                                      fontFamily: "Rubik",
                                                      fontWeight:
                                                          FontWeight.w200,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 17, vertical: 10),
                                  margin: const EdgeInsets.only(bottom: 15),
                                  decoration: BoxDecoration(
                                    color: CustomColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Availability",
                                              style: TextStyle(
                                                color:
                                                    CustomColors.primaryColor,
                                                fontSize: 10,
                                                fontFamily: "Rubik",
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            snapshot
                                                        .data!
                                                        .data!
                                                        .userdetailprovider!
                                                        .availability
                                                        .toString() ==
                                                    "null"
                                                ? Text(
                                                    snapshot
                                                                .data!
                                                                .data!
                                                                .userdetailprovider!
                                                                .availability
                                                                .toString() ==
                                                            "null"
                                                        ? "Required"
                                                        : snapshot
                                                            .data!
                                                            .data!
                                                            .userdetailprovider!
                                                            .availability
                                                            .toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: CustomColors.red,
                                                      fontSize: 16,
                                                      fontFamily: "Rubik",
                                                      fontWeight:
                                                          FontWeight.w200,
                                                    ),
                                                  )
                                                : Text(
                                                    snapshot
                                                                .data!
                                                                .data!
                                                                .userdetailprovider!
                                                                .availability
                                                                .toString() ==
                                                            "null"
                                                        ? "Required"
                                                        : snapshot
                                                            .data!
                                                            .data!
                                                            .userdetailprovider!
                                                            .availability
                                                            .toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color:
                                                          CustomColors.hintText,
                                                      fontSize: 16,
                                                      fontFamily: "Rubik",
                                                      fontWeight:
                                                          FontWeight.w200,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 17, vertical: 10),
                                  margin: const EdgeInsets.only(bottom: 15),
                                  decoration: BoxDecoration(
                                    color: CustomColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Additional Services",
                                              style: TextStyle(
                                                color:
                                                    CustomColors.primaryColor,
                                                fontSize: 10,
                                                fontFamily: "Rubik",
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            snapshot
                                                        .data!
                                                        .data!
                                                        .userdetailprovider!
                                                        .keywords
                                                        .toString() ==
                                                    "null"
                                                ? Text(
                                                    snapshot
                                                                .data!
                                                                .data!
                                                                .userdetailprovider!
                                                                .keywords
                                                                .toString() ==
                                                            "null"
                                                        ? "Required"
                                                        : snapshot
                                                            .data!
                                                            .data!
                                                            .userdetailprovider!
                                                            .keywords
                                                            .toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: CustomColors.red,
                                                      fontSize: 16,
                                                      fontFamily: "Rubik",
                                                      fontWeight:
                                                          FontWeight.w200,
                                                    ),
                                                  )
                                                : Text(
                                                    snapshot
                                                                .data!
                                                                .data!
                                                                .userdetailprovider!
                                                                .keywords
                                                                .toString() ==
                                                            "null"
                                                        ? "Required"
                                                        : snapshot
                                                            .data!
                                                            .data!
                                                            .userdetailprovider!
                                                            .keywords
                                                            .toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color:
                                                          CustomColors.hintText,
                                                      fontSize: 16,
                                                      fontFamily: "Rubik",
                                                      fontWeight:
                                                          FontWeight.w200,
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
                                  color: CustomColors.primaryColor,
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                      color: CustomColors.primaryLight,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.workspace_premium,
                                        color: CustomColors.primaryColor,
                                      ),
                                      title: Text(
                                        "Background Varified",
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
                                const SizedBox(height: 10),
                                // Download Enhanced File
                                GestureDetector(
                                  onTap: () {
                                    doDownloadEnhancedFile();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: CustomColors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton.icon(
                                          onPressed: () {
                                            doDownloadEnhancedFile();
                                          },
                                          icon: Icon(
                                            Icons.picture_as_pdf_rounded,
                                            color: CustomColors.red,
                                          ),
                                          label: Text(
                                            downloading
                                                ? "Download Enhanced Criminal Document $downloadProgress"
                                                : "Download Enhanced Criminal Document",
                                            style: TextStyle(
                                                fontSize: 10,
                                                color:
                                                    CustomColors.primaryText),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {},
                                          child: DottedBorder(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 14, horizontal: 5),
                                            radius: const Radius.circular(4),
                                            borderType: BorderType.RRect,
                                            color: CustomColors.primaryColor,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.picture_as_pdf_rounded,
                                                  color: CustomColors.red,
                                                  size: 16,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  (snapshot
                                                              .data!
                                                              .data!
                                                              .providerverification!
                                                              .enhancedCriminalVerify
                                                              .toString() ==
                                                          "0")
                                                      ? "Pending"
                                                      : (snapshot
                                                                  .data!
                                                                  .data!
                                                                  .providerverification!
                                                                  .enhancedCriminalVerify
                                                                  .toString() ==
                                                              "1")
                                                          ? "Approved"
                                                          : (snapshot
                                                                      .data!
                                                                      .data!
                                                                      .providerverification!
                                                                      .enhancedCriminalVerify
                                                                      .toString() ==
                                                                  "2")
                                                              ? "Rejected"
                                                              : "File Not Available Enhanced Criminal Document",
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: CustomColors
                                                        .primaryText,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                // doDownloadBasicFile
                                GestureDetector(
                                  onTap: () {
                                    doDownloadBasicFile();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: CustomColors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton.icon(
                                          onPressed: () {
                                            doDownloadBasicFile();
                                          },
                                          icon: Icon(
                                            Icons.picture_as_pdf_rounded,
                                            color: CustomColors.red,
                                          ),
                                          label: Text(
                                            downloading
                                                ? "Download Basic Criminal Document $downloadProgress"
                                                : "Download Basic Criminal Document",
                                            style: TextStyle(
                                                fontSize: 10,
                                                color:
                                                    CustomColors.primaryText),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            // getEnhancedPdfFile();
                                          },
                                          child: DottedBorder(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 14, horizontal: 5),
                                            radius: const Radius.circular(4),
                                            borderType: BorderType.RRect,
                                            color: CustomColors.primaryColor,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.picture_as_pdf_rounded,
                                                  color: CustomColors.red,
                                                  size: 16,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  (snapshot
                                                              .data!
                                                              .data!
                                                              .providerverification!
                                                              .basicCriminalVerify
                                                              .toString() ==
                                                          "0")
                                                      ? "Pending"
                                                      : (snapshot
                                                                  .data!
                                                                  .data!
                                                                  .providerverification!
                                                                  .basicCriminalVerify
                                                                  .toString() ==
                                                              "1")
                                                          ? "Approved"
                                                          : (snapshot
                                                                      .data!
                                                                      .data!
                                                                      .providerverification!
                                                                      .basicCriminalVerify
                                                                      .toString() ==
                                                                  "2")
                                                              ? "Rejected"
                                                              : "File Not Available Basic Criminal Document",
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: CustomColors
                                                        .primaryText,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                // doDownloadFirstAidFile
                                GestureDetector(
                                  onTap: () {
                                    doDownloadFirstAidFile();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: CustomColors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton.icon(
                                          onPressed: () {
                                            doDownloadFirstAidFile();
                                          },
                                          icon: Icon(
                                            Icons.picture_as_pdf_rounded,
                                            color: CustomColors.red,
                                          ),
                                          label: Text(
                                            "Download First Aid Document",
                                            style: TextStyle(
                                                fontSize: 10,
                                                color:
                                                    CustomColors.primaryText),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            // getEnhancedPdfFile();
                                          },
                                          child: DottedBorder(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 14, horizontal: 5),
                                            radius: const Radius.circular(4),
                                            borderType: BorderType.RRect,
                                            color: CustomColors.primaryColor,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.picture_as_pdf_rounded,
                                                  color: CustomColors.red,
                                                  size: 16,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  (snapshot
                                                              .data!
                                                              .data!
                                                              .providerverification!
                                                              .firstAidVerify
                                                              .toString() ==
                                                          "0")
                                                      ? "Pending"
                                                      : (snapshot
                                                                  .data!
                                                                  .data!
                                                                  .providerverification!
                                                                  .firstAidVerify
                                                                  .toString() ==
                                                              "1")
                                                          ? "Approved"
                                                          : (snapshot
                                                                      .data!
                                                                      .data!
                                                                      .providerverification!
                                                                      .firstAidVerify
                                                                      .toString() ==
                                                                  "2")
                                                              ? "Rejected"
                                                              : "File Not Available First Aid Document",
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: CustomColors
                                                        .primaryText,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                GestureDetector(
                                  onTap: () {
                                    doDownloadVehicleFile();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: CustomColors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton.icon(
                                          onPressed: () {
                                            doDownloadVehicleFile();
                                          },
                                          icon: Icon(
                                            Icons.picture_as_pdf_rounded,
                                            color: CustomColors.red,
                                          ),
                                          label: Text(
                                            "Download Vehicle Record Document",
                                            style: TextStyle(
                                                fontSize: 10,
                                                color:
                                                    CustomColors.primaryText),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            // getEnhancedPdfFile();
                                          },
                                          child: DottedBorder(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 14, horizontal: 5),
                                            radius: const Radius.circular(4),
                                            borderType: BorderType.RRect,
                                            color: CustomColors.primaryColor,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.picture_as_pdf_rounded,
                                                  color: CustomColors.red,
                                                  size: 16,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  (snapshot
                                                              .data!
                                                              .data!
                                                              .providerverification!
                                                              .vehicleRecordVerify
                                                              .toString() ==
                                                          "0")
                                                      ? "Pending"
                                                      : (snapshot
                                                                  .data!
                                                                  .data!
                                                                  .providerverification!
                                                                  .vehicleRecordVerify
                                                                  .toString() ==
                                                              "1")
                                                          ? "Approved"
                                                          : (snapshot
                                                                      .data!
                                                                      .data!
                                                                      .providerverification!
                                                                      .vehicleRecordVerify
                                                                      .toString() ==
                                                                  "2")
                                                              ? "Rejected"
                                                              : "File Not Available Vehicle Record  Document",
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: CustomColors
                                                        .primaryText,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
      ),
    );
  }
}
