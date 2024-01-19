// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

// import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:island_app/caregiver/models/profile_model.dart';
import 'package:island_app/caregiver/screens/profile_edit.dart';
import 'package:island_app/caregiver/utils/profile_provider.dart';
import 'package:island_app/caregiver/widgets/drawer_widget.dart';
import 'package:island_app/screens/notification.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/res/app_url.dart';
import 'package:island_app/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
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

  // fetchPRofile
  late Future<ProfileGiverModel> fetchProfile;
  Future<ProfileGiverModel> fetchProfileGiverModel() async {
    var token = await Provider.of<ProfileProvider>(context, listen: false).getUserToken();
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

  // getUserToken() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   var userToken = preferences.getString(
  //     'userToken',
  //   );
  //   return userToken.toString();
  // }

  @override
  void initState() {
    // getUserToken();
    super.initState();
    fetchProfile = fetchProfileGiverModel();
    Provider.of<ProfileProvider>(context, listen: false).fetchProfileGiverModel();
  }

  @override
  Widget build(BuildContext context) {
    var userProfile = Provider.of<ProfileProvider>(context).fetchProfile;
    bool profileStatus = Provider.of<ProfileProvider>(context).profileStatus;
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
                if (profileStatus) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationScreen(),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      content: const Text(
                        "Please Complete Your \n Profile For Approval",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                  );
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Badge(
                  child: Icon(
                    Icons.message_outlined,
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
                child: userProfile != null
                    ? Column(
                        children: [
                          Container(
                            height: 250,
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                            color: CustomColors.primaryColor,
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
                                        child: Image(
                                          width: 130,
                                          height: 110,
                                          alignment: Alignment.center,
                                          image: NetworkImage("${AppUrl.webStorageUrl}/${userProfile.data!.avatar.toString()}"),
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
                                                        avatar: userProfile.data!.avatar.toString(),
                                                        gender: userProfile.data!.userdetail!.gender.toString(),
                                                        phoneNumber: userProfile.data!.phone.toString(),
                                                        dob: userProfile.data!.userdetail!.dob.toString(),
                                                        yoe: userProfile.data!.userdetailprovider!.experience.toString(),
                                                        hourlyRate: userProfile.data!.userdetailprovider!.hourlyRate.toString(),
                                                        userAddress: userProfile.data!.userdetail!.address.toString(),
                                                        zipCode: userProfile.data!.userdetail!.zip.toString(),
                                                        additionalService: userProfile.data!.userdetailprovider!.keywords.toString(),
                                                        availability: userProfile.data!.userdetailprovider!.availability.toString(),
                                                        userInfo: userProfile.data!.userdetail!.userInfo.toString(),
                                                        enhancedCriminal: userProfile.data!.providerverification!.enhancedCriminal,
                                                        enhancedCriminalStatus: userProfile.data!.providerverification!.enhancedCriminalVerify,
                                                        basicCriminal: userProfile.data!.providerverification!.basicCriminal,
                                                        basicCriminalStatus: userProfile.data!.providerverification!.basicCriminalVerify,
                                                        firstAid: userProfile.data!.providerverification!.firstAid,
                                                        firstAidStatus: userProfile.data!.providerverification!.firstAidVerify,
                                                        vehicleRecord: userProfile.data!.providerverification!.vehicleRecord,
                                                        vehicleRecordStatus: userProfile.data!.providerverification!.vehicleRecordVerify,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: const Icon(Icons.edit, color: Colors.white),
                                              ),
                                            ),
                                            Text(
                                              "${userProfile.data!.firstName.toString()} ${userProfile.data!.lastName.toString()}",
                                              style: TextStyle(fontSize: 20, fontFamily: "Rubik", fontWeight: FontWeight.w700, color: CustomColors.white),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              userProfile.data!.email.toString(),
                                              style: TextStyle(fontSize: 12, fontFamily: "Rubik", fontWeight: FontWeight.w400, color: CustomColors.white),
                                            ),
                                            const SizedBox(width: 10),
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
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 40,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
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
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  WidgetSpan(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 1, right: 5),
                                                      child: Icon(
                                                        Icons.phone_outlined,
                                                        size: 14,
                                                        color: CustomColors.primaryTextLight,
                                                      ),
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: userProfile.data!.phone,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400,
                                                      color: CustomColors.primaryTextLight,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 15),
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
                                                      "${Provider.of<ProfileProvider>(context).profilePerentage}%",
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
                                                  value: double.parse(Provider.of<ProfileProvider>(context).profilePerentage) / 100,
                                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red.shade300),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5),
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
                                            userProfile.data!.userdetail!.address.toString() != "null"
                                                ? TextSpan(
                                                    text: userProfile.data!.userdetail!.address.toString(),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400,
                                                      color: CustomColors.primaryTextLight,
                                                    ),
                                                  )
                                                : TextSpan(
                                                    text: "Not Available",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400,
                                                      color: CustomColors.red,
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
                          const SizedBox(height: 10),
                          // Bages
                          Consumer<ProfileProvider>(builder: (context, provider, __) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                                child: Wrap(
                                  spacing: 05,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  alignment: WrapAlignment.center,
                                  children: List.generate(provider.badges.length, (index) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(500),
                                      child: Image(
                                        height: 50,
                                        image: NetworkImage("${AppUrl.webStorageUrl}/${provider.badges[index]}"),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            );
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
                                              color: CustomColors.primaryColor,
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
                                              color: CustomColors.primaryColor,
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
                                                          : "Required",
                                                  style: TextStyle(
                                                    color: CustomColors.hintText,
                                                    fontSize: 16,
                                                    fontFamily: "Rubik",
                                                    fontWeight: FontWeight.w200,
                                                  ),
                                                )
                                              : Text(
                                                  (userProfile.data!.userdetail!.gender.toString() == "1")
                                                      ? "Male"
                                                      : (userProfile.data!.userdetail!.gender.toString() == "2")
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
                                                color: CustomColors.primaryColor,
                                                fontSize: 10,
                                                fontFamily: "Rubik",
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            userProfile.data!.userdetailprovider!.experience.toString() == "null"
                                                ? Text(
                                                    userProfile.data!.userdetailprovider!.experience.toString() == "null" ? "Required" : userProfile.data!.userdetailprovider!.experience.toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: CustomColors.red,
                                                      fontSize: 16,
                                                      fontFamily: "Rubik",
                                                      fontWeight: FontWeight.w200,
                                                    ),
                                                  )
                                                : Text(
                                                    userProfile.data!.userdetailprovider!.experience.toString() == "null" ? "Required" : userProfile.data!.userdetailprovider!.experience.toString(),
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
                                                color: CustomColors.primaryColor,
                                                fontSize: 10,
                                                fontFamily: "Rubik",
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            userProfile.data!.userdetailprovider!.hourlyRate.toString() == "null"
                                                ? Text(
                                                    userProfile.data!.userdetailprovider!.hourlyRate.toString() == "null" ? "Required" : userProfile.data!.userdetailprovider!.hourlyRate.toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: CustomColors.red,
                                                      fontSize: 16,
                                                      fontFamily: "Rubik",
                                                      fontWeight: FontWeight.w200,
                                                    ),
                                                  )
                                                : Text(
                                                    "\$ ${userProfile.data!.userdetailprovider!.hourlyRate.toString() == "null" ? "Required" : userProfile.data!.userdetailprovider!.hourlyRate.toString()}",
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
                                              color: CustomColors.primaryColor,
                                              fontSize: 10,
                                              fontFamily: "Rubik",
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          userProfile.data!.userdetail!.zip.toString() == "null"
                                              ? Text(
                                                  userProfile.data!.userdetail!.zip.toString() == "null" ? "Required" : userProfile.data!.userdetail!.zip.toString(),
                                                  style: TextStyle(
                                                    color: CustomColors.red,
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
                                                color: CustomColors.primaryColor,
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
                                                    userProfile.data!.userdetailprovider!.keywords.toString() == "null" ? "Required" : userProfile.data!.userdetailprovider!.keywords.toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: CustomColors.red,
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
                                                color: CustomColors.primaryColor,
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
                                                color: CustomColors.primaryColor,
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
                                                    userProfile.data!.userdetail!.userInfo.toString() == "null" ? "Required" : userProfile.data!.userdetail!.userInfo.toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: CustomColors.red,
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
                                                color: CustomColors.primaryColor,
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
                                                    userProfile.data!.userdetailprovider!.availability.toString() == "null" ? "Required" : userProfile.data!.userdetailprovider!.availability.toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: CustomColors.red,
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
                                                color: CustomColors.primaryColor,
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
                                                    userProfile.data!.userdetailprovider!.keywords.toString() == "null" ? "Required" : userProfile.data!.userdetailprovider!.keywords.toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: CustomColors.red,
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

                                // Badges

                                // Container(
                                //   padding: const EdgeInsets.symmetric(
                                //       horizontal: 17, vertical: 10),
                                //   margin: const EdgeInsets.only(bottom: 15),
                                //   width: MediaQuery.of(context).size.width,
                                //   decoration: BoxDecoration(
                                //     color: CustomColors.white,
                                //     borderRadius: BorderRadius.circular(12),
                                //   ),
                                //   child: Column(
                                //     crossAxisAlignment:
                                //         CrossAxisAlignment.start,
                                //     children: [
                                //       Text(
                                //         "Badges",
                                //         style: TextStyle(
                                //           color: CustomColors.primaryColor,
                                //           fontSize: 10,
                                //           fontFamily: "Rubik",
                                //           fontWeight: FontWeight.w600,
                                //         ),
                                //       ),
                                //       Wrap(
                                //         spacing: 05,
                                //         children: List.generate(badges.length,
                                //             (index) {
                                //           return Image(
                                //             height: 50,
                                //             image: NetworkImage(
                                //                 "${AppUrl.webStorageUrl}/${badges[index]}"),
                                //           );
                                //         }),
                                //       ),
                                //     ],
                                //   ),
                                // ),

                                // Background Verified
                                DottedBorder(
                                  radius: const Radius.circular(10),
                                  borderType: BorderType.RRect,
                                  color: CustomColors.primaryColor,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
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
                                BasicDocumentDownloadList(
                                  onTap: () {
                                    if (userProfile.data!.providerverification!.enhancedCriminal!.isNotEmpty) {
                                      doDownloadFile(userProfile.data!.providerverification!.enhancedCriminal);
                                    }
                                  },
                                  fileStatus: userProfile.data!.providerverification!.enhancedCriminalVerify.toString(),
                                  downloading: downloading,
                                  downloadProgress: downloadProgress,
                                  title: "Download Enhanced Criminal Document",
                                ),

                                const SizedBox(height: 15),
                                BasicDocumentDownloadList(
                                  onTap: () {
                                    if (userProfile.data!.providerverification!.basicCriminal!.isNotEmpty) {
                                      doDownloadFile(userProfile.data!.providerverification!.basicCriminal);
                                    }
                                  },
                                  fileStatus: userProfile.data!.providerverification!.basicCriminalVerify.toString(),
                                  downloading: downloading,
                                  downloadProgress: downloadProgress,
                                  title: "Download Basic Criminal Document",
                                ),
                                const SizedBox(height: 15),
                                BasicDocumentDownloadList(
                                  onTap: () {
                                    if (userProfile.data!.providerverification!.firstAid.isNotEmpty) {
                                      doDownloadFile(userProfile.data!.providerverification!.firstAid);
                                    }
                                  },
                                  fileStatus: userProfile.data!.providerverification!.firstAidVerify.toString(),
                                  downloading: downloading,
                                  downloadProgress: downloadProgress,
                                  title: "Download First Aid Document",
                                ),

                                const SizedBox(height: 15),
                                BasicDocumentDownloadList(
                                  onTap: () {
                                    if (userProfile.data!.providerverification!.vehicleRecord.isNotEmpty) {
                                      doDownloadFile(userProfile.data!.providerverification!.vehicleRecord);
                                    }
                                  },
                                  fileStatus: userProfile.data!.providerverification!.vehicleRecordVerify.toString(),
                                  downloading: downloading,
                                  downloadProgress: downloadProgress,
                                  title: "Download Vehicle Record Document",
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
      ),
    );
  }
}

class BasicDocumentDownloadList extends StatelessWidget {
  const BasicDocumentDownloadList({
    super.key,
    required this.onTap,
    required this.downloading,
    required this.downloadProgress,
    required this.fileStatus,
    required this.title,
  });
  final void Function()? onTap;
  final bool downloading;
  final String downloadProgress;
  final String fileStatus;
  final String title;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: CustomColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.picture_as_pdf_rounded,
              color: CustomColors.red,
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                downloading ? "$title $downloadProgress" : title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 10, color: CustomColors.primaryText),
              ),
            ),
            DottedBorder(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              radius: const Radius.circular(4),
              borderType: BorderType.RRect,
              color: CustomColors.primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                    (fileStatus == "0")
                        ? "Pending"
                        : (fileStatus == "1")
                            ? "Approved"
                            : (fileStatus == "2")
                                ? "Rejected"
                                : "File Not Available",
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: CustomColors.primaryText,
                    ),
                  ),
                ],
              ),
            ),
          ],
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
      customErrorSnackBar(context, "something went wrong please try again later");
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
      customErrorSnackBar(context, "something went wrong please try again later");
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
      customErrorSnackBar(context, "something went wrong please try again later");
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
      customErrorSnackBar(context, "something went wrong please try again later");
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
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                        snapshot.data!.data!.firstName.toString(),
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
                                        mainAxisAlignment: MainAxisAlignment.center,
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
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  WidgetSpan(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 1, right: 5),
                                                      child: Icon(
                                                        Icons.phone_outlined,
                                                        size: 14,
                                                        color: CustomColors.primaryTextLight,
                                                      ),
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: snapshot.data!.data!.phone.toString(),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400,
                                                      color: CustomColors.primaryTextLight,
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
                                            margin: const EdgeInsets.symmetric(horizontal: 14),
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
                                                  snapshot.data!.data!.userdetail!.address.toString() != "null"
                                                      ? TextSpan(
                                                          text: snapshot.data!.data!.userdetail!.address.toString() == "null" ? "Not Available" : snapshot.data!.data!.userdetail!.address.toString(),
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.w400,
                                                            color: CustomColors.primaryTextLight,
                                                          ),
                                                        )
                                                      : TextSpan(
                                                          text: "Required",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.w400,
                                                            color: CustomColors.red,
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
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                            builder: (context) => ProfileGiverPendingEdit(
                                              avatar: snapshot.data!.data!.avatar.toString(),
                                              gender: snapshot.data!.data!.userdetail!.gender.toString(),
                                              phoneNumber: snapshot.data!.data!.phone.toString(),
                                              dob: snapshot.data!.data!.userdetail!.dob.toString(),
                                              yoe: snapshot.data!.data!.userdetailprovider!.experience.toString(),
                                              hourlyRate: snapshot.data!.data!.userdetailprovider!.hourlyRate.toString(),
                                              userAddress: snapshot.data!.data!.userdetail!.address.toString(),
                                              zipCode: snapshot.data!.data!.userdetail!.zip.toString(),
                                              additionalService: snapshot.data!.data!.userdetailprovider!.keywords.toString(),
                                              availability: snapshot.data!.data!.userdetailprovider!.availability.toString(),
                                              userInfo: snapshot.data!.data!.userdetail!.userInfo.toString(),
                                              enhancedCriminal: snapshot.data!.data!.providerverification!.enhancedCriminal,
                                              enhancedCriminalStatus: snapshot.data!.data!.providerverification!.enhancedCriminalVerify,
                                              basicCriminal: snapshot.data!.data!.providerverification!.basicCriminal,
                                              basicCriminalStatus: snapshot.data!.data!.providerverification!.basicCriminalVerify,
                                              firstAid: snapshot.data!.data!.providerverification!.firstAid,
                                              firstAidStatus: snapshot.data!.data!.providerverification!.firstAidVerify,
                                              vehicleRecord: snapshot.data!.data!.providerverification!.vehicleRecord,
                                              vehicleRecordStatus: snapshot.data!.data!.providerverification!.vehicleRecordVerify,
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
                                              color: CustomColors.primaryColor,
                                              fontSize: 10,
                                              fontFamily: "Rubik",
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          snapshot.data!.data!.userdetail!.gender.toString() != "null"
                                              ? Text(
                                                  (snapshot.data!.data!.userdetail!.gender.toString() == "1")
                                                      ? "Male"
                                                      : (snapshot.data!.data!.userdetail!.gender.toString() == "2")
                                                          ? "Female"
                                                          : "Required",
                                                  style: TextStyle(
                                                    color: CustomColors.hintText,
                                                    fontSize: 16,
                                                    fontFamily: "Rubik",
                                                    fontWeight: FontWeight.w200,
                                                  ),
                                                )
                                              : Text(
                                                  (snapshot.data!.data!.userdetail!.gender.toString() == "1")
                                                      ? "Male"
                                                      : (snapshot.data!.data!.userdetail!.gender.toString() == "2")
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
                                            snapshot.data!.data!.userdetail!.service!.name.toString() == "null" ? "Not Available" : snapshot.data!.data!.userdetail!.service!.name.toString(),
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
                                                color: CustomColors.primaryColor,
                                                fontSize: 10,
                                                fontFamily: "Rubik",
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            snapshot.data!.data!.userdetailprovider!.experience.toString() == "null"
                                                ? Text(
                                                    snapshot.data!.data!.userdetailprovider!.experience.toString() == "null" ? "Required" : snapshot.data!.data!.userdetailprovider!.experience.toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: CustomColors.red,
                                                      fontSize: 16,
                                                      fontFamily: "Rubik",
                                                      fontWeight: FontWeight.w200,
                                                    ),
                                                  )
                                                : Text(
                                                    snapshot.data!.data!.userdetailprovider!.experience.toString() == "null" ? "Required" : snapshot.data!.data!.userdetailprovider!.experience.toString(),
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
                                                color: CustomColors.primaryColor,
                                                fontSize: 10,
                                                fontFamily: "Rubik",
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            snapshot.data!.data!.userdetailprovider!.hourlyRate.toString() == "null"
                                                ? Text(
                                                    snapshot.data!.data!.userdetailprovider!.hourlyRate.toString() == "null" ? "Required" : snapshot.data!.data!.userdetailprovider!.hourlyRate.toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: CustomColors.red,
                                                      fontSize: 16,
                                                      fontFamily: "Rubik",
                                                      fontWeight: FontWeight.w200,
                                                    ),
                                                  )
                                                : Text(
                                                    "\$ ${snapshot.data!.data!.userdetailprovider!.hourlyRate.toString() == "null" ? "Required" : snapshot.data!.data!.userdetailprovider!.hourlyRate.toString()}",
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
                                            snapshot.data!.data!.userdetail!.dob.toString(),
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
                                              color: CustomColors.primaryColor,
                                              fontSize: 10,
                                              fontFamily: "Rubik",
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          snapshot.data!.data!.userdetail!.zip.toString() == "null"
                                              ? Text(
                                                  snapshot.data!.data!.userdetail!.zip.toString() == "null" ? "Required" : snapshot.data!.data!.userdetail!.zip.toString(),
                                                  style: TextStyle(
                                                    color: CustomColors.red,
                                                    fontSize: 16,
                                                    fontFamily: "Rubik",
                                                    fontWeight: FontWeight.w200,
                                                  ),
                                                )
                                              : Text(
                                                  snapshot.data!.data!.userdetail!.zip.toString() == "null" ? "Required" : snapshot.data!.data!.userdetail!.zip.toString(),
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
                                                color: CustomColors.primaryColor,
                                                fontSize: 10,
                                                fontFamily: "Rubik",
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            snapshot.data!.data!.userdetailprovider!.keywords.toString() == "null"
                                                ? Text(
                                                    snapshot.data!.data!.userdetailprovider!.keywords.toString() == "null" ? "Required" : snapshot.data!.data!.userdetailprovider!.keywords.toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: CustomColors.red,
                                                      fontSize: 16,
                                                      fontFamily: "Rubik",
                                                      fontWeight: FontWeight.w200,
                                                    ),
                                                  )
                                                : Text(
                                                    snapshot.data!.data!.userdetailprovider!.keywords.toString() == "null" ? "Required" : snapshot.data!.data!.userdetailprovider!.keywords.toString(),
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
                                                color: CustomColors.primaryColor,
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
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemCount: snapshot.data!.data!.educations!.length,
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
                                                        "Institue Name: ${snapshot.data!.data!.educations![index].name}",
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
                                                        "Major: ${snapshot.data!.data!.educations![index].major}",
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
                                                        "From: ${snapshot.data!.data!.educations![index].from}",
                                                        softWrap: true,
                                                        style: TextStyle(
                                                          color: CustomColors.hintText,
                                                          fontSize: 12,
                                                          fontFamily: "Rubik",
                                                          fontWeight: FontWeight.w200,
                                                        ),
                                                      ),
                                                      snapshot.data!.data!.educations![index].to == ""
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
                                                color: CustomColors.primaryColor,
                                                fontSize: 10,
                                                fontFamily: "Rubik",
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            snapshot.data!.data!.userdetail!.userInfo.toString() == "null"
                                                ? Text(
                                                    snapshot.data!.data!.userdetail!.userInfo.toString() == "null" ? "Required" : snapshot.data!.data!.userdetail!.userInfo.toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: CustomColors.red,
                                                      fontSize: 16,
                                                      fontFamily: "Rubik",
                                                      fontWeight: FontWeight.w200,
                                                    ),
                                                  )
                                                : Text(
                                                    snapshot.data!.data!.userdetail!.userInfo.toString() == "null" ? "Required" : snapshot.data!.data!.userdetail!.userInfo.toString(),
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
                                                color: CustomColors.primaryColor,
                                                fontSize: 10,
                                                fontFamily: "Rubik",
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            snapshot.data!.data!.userdetailprovider!.availability.toString() == "null"
                                                ? Text(
                                                    snapshot.data!.data!.userdetailprovider!.availability.toString() == "null" ? "Required" : snapshot.data!.data!.userdetailprovider!.availability.toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: CustomColors.red,
                                                      fontSize: 16,
                                                      fontFamily: "Rubik",
                                                      fontWeight: FontWeight.w200,
                                                    ),
                                                  )
                                                : Text(
                                                    snapshot.data!.data!.userdetailprovider!.availability.toString() == "null" ? "Required" : snapshot.data!.data!.userdetailprovider!.availability.toString(),
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
                                                color: CustomColors.primaryColor,
                                                fontSize: 10,
                                                fontFamily: "Rubik",
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            snapshot.data!.data!.userdetailprovider!.keywords.toString() == "null"
                                                ? Text(
                                                    snapshot.data!.data!.userdetailprovider!.keywords.toString() == "null" ? "Required" : snapshot.data!.data!.userdetailprovider!.keywords.toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: CustomColors.red,
                                                      fontSize: 16,
                                                      fontFamily: "Rubik",
                                                      fontWeight: FontWeight.w200,
                                                    ),
                                                  )
                                                : Text(
                                                    snapshot.data!.data!.userdetailprovider!.keywords.toString() == "null" ? "Required" : snapshot.data!.data!.userdetailprovider!.keywords.toString(),
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
                                  color: CustomColors.primaryColor,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
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
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            downloading ? "Download Enhanced Criminal Document $downloadProgress" : "Download Enhanced Criminal Document",
                                            style: TextStyle(fontSize: 10, color: CustomColors.primaryText),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {},
                                          child: DottedBorder(
                                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 5),
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
                                                  (snapshot.data!.data!.providerverification!.enhancedCriminalVerify.toString() == "0")
                                                      ? "Pending"
                                                      : (snapshot.data!.data!.providerverification!.enhancedCriminalVerify.toString() == "1")
                                                          ? "Approved"
                                                          : (snapshot.data!.data!.providerverification!.enhancedCriminalVerify.toString() == "2")
                                                              ? "Rejected"
                                                              : "File Not Available Enhanced Criminal Document",
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: CustomColors.primaryText,
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
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            downloading ? "Download Basic Criminal Document $downloadProgress" : "Download Basic Criminal Document",
                                            style: TextStyle(fontSize: 10, color: CustomColors.primaryText),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            // getEnhancedPdfFile();
                                          },
                                          child: DottedBorder(
                                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 5),
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
                                                  (snapshot.data!.data!.providerverification!.basicCriminalVerify.toString() == "0")
                                                      ? "Pending"
                                                      : (snapshot.data!.data!.providerverification!.basicCriminalVerify.toString() == "1")
                                                          ? "Approved"
                                                          : (snapshot.data!.data!.providerverification!.basicCriminalVerify.toString() == "2")
                                                              ? "Rejected"
                                                              : "File Not Available Basic Criminal Document",
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: CustomColors.primaryText,
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
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            style: TextStyle(fontSize: 10, color: CustomColors.primaryText),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            // getEnhancedPdfFile();
                                          },
                                          child: DottedBorder(
                                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 5),
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
                                                  (snapshot.data!.data!.providerverification!.firstAidVerify.toString() == "0")
                                                      ? "Pending"
                                                      : (snapshot.data!.data!.providerverification!.firstAidVerify.toString() == "1")
                                                          ? "Approved"
                                                          : (snapshot.data!.data!.providerverification!.firstAidVerify.toString() == "2")
                                                              ? "Rejected"
                                                              : "File Not Available First Aid Document",
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: CustomColors.primaryText,
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
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            style: TextStyle(fontSize: 10, color: CustomColors.primaryText),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            // getEnhancedPdfFile();
                                          },
                                          child: DottedBorder(
                                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 5),
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
                                                  (snapshot.data!.data!.providerverification!.vehicleRecordVerify.toString() == "0")
                                                      ? "Pending"
                                                      : (snapshot.data!.data!.providerverification!.vehicleRecordVerify.toString() == "1")
                                                          ? "Approved"
                                                          : (snapshot.data!.data!.providerverification!.vehicleRecordVerify.toString() == "2")
                                                              ? "Rejected"
                                                              : "File Not Available Vehicle Record  Document",
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: CustomColors.primaryText,
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
