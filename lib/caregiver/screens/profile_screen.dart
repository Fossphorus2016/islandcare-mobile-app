// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously, unnecessary_null_comparison

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:island_app/caregiver/screens/profile_edit.dart';
import 'package:island_app/caregiver/utils/profile_provider.dart';
import 'package:island_app/caregiver/widgets/drawer_widget.dart';
import 'package:island_app/caregiver/widgets/giver_app_bar.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/utils/app_colors.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/functions.dart';
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

    Provider.of<ServiceGiverProvider>(context, listen: false).fetchProfileGiverModel();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceGiverProvider>(
      builder: (context, giverProvider, __) {
        return Scaffold(
          backgroundColor: CustomColors.loginBg,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: GiverCustomAppBar(
              profileStatus: giverProvider.profileStatus,
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
                    giverProvider.fetchProfileGiverModel();
                  },
                  child: SingleChildScrollView(
                    child: giverProvider.fetchProfile != null
                        ? Column(
                            children: [
                              // Top Container
                              Container(
                                height: 280,
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                                color: ServiceGiverColor.black,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Profile Image And Email With edit profile button
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 130,
                                      child: Row(
                                        children: [
                                          // Profile Image
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(08),
                                            child: CachedNetworkImage(
                                              width: 130,
                                              height: 110,
                                              alignment: Alignment.center,
                                              imageUrl: "${AppUrl.webStorageUrl}/${giverProvider.fetchProfile!.data!.avatar.toString()}",
                                              errorWidget: (context, url, error) {
                                                return const Icon(
                                                  Icons.info_rounded,
                                                  color: Colors.white,
                                                );
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          // Email With edit profile button
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    const Icon(
                                                      Icons.verified_outlined,
                                                      color: Colors.blue,
                                                    ),
                                                    Align(
                                                      alignment: Alignment.topRight,
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => ProfileGiverPendingEdit(
                                                                name: "${giverProvider.fetchProfile!.data!.firstName} ${giverProvider.fetchProfile!.data!.lastName}",
                                                                email: giverProvider.fetchProfile!.data!.email,
                                                                avatar: giverProvider.fetchProfile!.data!.avatar,
                                                                gender: giverProvider.fetchProfile!.data!.userdetail!.gender.toString(),
                                                                phoneNumber: giverProvider.fetchProfile!.data!.phone,
                                                                dob: giverProvider.fetchProfile!.data!.userdetail!.dob,
                                                                yoe: giverProvider.fetchProfile!.data!.userdetailprovider!.experience,
                                                                hourlyRate: giverProvider.fetchProfile!.data!.userdetailprovider!.hourlyRate,
                                                                userAddress: giverProvider.fetchProfile!.data!.userdetail!.address,
                                                                zipCode: giverProvider.fetchProfile!.data!.userdetail!.zip,
                                                                additionalService: giverProvider.fetchProfile!.data!.userdetailprovider!.additionalServices,
                                                                availability: giverProvider.fetchProfile!.data!.userdetailprovider!.availability,
                                                                userInfo: giverProvider.fetchProfile!.data!.userdetail!.userInfo,
                                                                serviceName: giverProvider.fetchProfile!.data!.userdetail!.service!.name,
                                                                area: giverProvider.fetchProfile!.data!.userdetail!.area,
                                                                educations: giverProvider.fetchProfile!.data!.educations!
                                                                    .map((e) => {
                                                                          "name": e.name.toString(),
                                                                          "major": e.major.toString(),
                                                                          "from": e.from.toString(),
                                                                          "current": e.current.toString(),
                                                                          "to": e.to.toString(),
                                                                        })
                                                                    .toList(),
                                                                workReference: giverProvider.fetchProfile!.data!.userdetailprovider!.workReference,
                                                                resume: giverProvider.fetchProfile!.data!.userdetailprovider!.resume,
                                                                validDriverLicenseVerify: giverProvider.fetchProfile!.data!.providerverification!.validDriverLicenseVerify == 1,
                                                                scarsAwarenessCertificationVerify: giverProvider.fetchProfile!.data!.providerverification!.scarsAwarenessCertificationVerify == 1,
                                                                policeBackgroundCheckVerify: giverProvider.fetchProfile!.data!.providerverification!.policeBackgroundCheckVerify == 1,
                                                                cprFirstAidCertificationVerify: giverProvider.fetchProfile!.data!.providerverification!.cprFirstAidCertificationVerify == 1,
                                                                governmentRegisteredCareProviderVerify: giverProvider.fetchProfile!.data!.providerverification!.governmentRegisteredCareProviderVerify == 1,
                                                                animalCareProviderCertificationVerify: giverProvider.fetchProfile!.data!.providerverification!.animalCareProviderCertificationVerify == 1,
                                                                animalFirstAidVerify: giverProvider.fetchProfile!.data!.providerverification!.animalFirstAidVerify == 1,
                                                                redCrossBabysittingCertificationVerify: giverProvider.fetchProfile!.data!.providerverification!.redCrossBabysittingCertificationVerify == 1,
                                                                chaildAndFamilyServicesAndAbuseVerify: giverProvider.fetchProfile!.data!.providerverification!.chaildAndFamilyServicesAndAbuseVerify == 1,
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
                                                  ],
                                                ),
                                                Text(
                                                  "${giverProvider.fetchProfile!.data!.firstName.toString()} ${giverProvider.fetchProfile!.data!.lastName.toString()}",
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(fontSize: 20, fontFamily: "Rubik", fontWeight: FontWeight.w700, color: CustomColors.white),
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  giverProvider.fetchProfile!.data!.email.toString(),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: "Rubik",
                                                    fontWeight: FontWeight.w400,
                                                    color: CustomColors.white,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                if (giverProvider.fetchProfile!.data!.avgRating != null) ...[
                                                  RatingBar(
                                                    ignoreGestures: true,
                                                    itemCount: 5,
                                                    itemSize: 20,
                                                    initialRating: giverProvider.fetchProfile!.data!.avgRating!['rating'] == null ? 0.0 : double.parse(giverProvider.fetchProfile!.data!.avgRating!['rating'].toString()),
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
                                    // Profile Phone Number and Address
                                    SizedBox(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        children: [
                                          // Profile Phone Number
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
                                                    giverProvider.fetchProfile!.data!.phone.toString(),
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
                                          // Profile Address
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
                                                  if (giverProvider.fetchProfile!.data!.userdetail!.address != null) ...[
                                                    Flexible(
                                                      child: Text(
                                                        giverProvider.fetchProfile!.data!.userdetail!.address.toString(),
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
                                    // Profile Complete Profile Percentage
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
                                                      "${giverProvider.profilePerentage}%",
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
                                                  value: giverProvider.profilePerentage != null && giverProvider.profilePerentage.isNotEmpty ? double.parse(giverProvider.profilePerentage) / 100 : 00,
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
                              if (giverProvider.badges != null) ...[
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
                                      children: List.generate(giverProvider.badges!.length, (index) {
                                        return ClipRRect(
                                          borderRadius: BorderRadius.circular(500),
                                          child: CachedNetworkImage(
                                            height: 50,
                                            imageUrl: "${AppUrl.webStorageUrl}/${giverProvider.badges![index]}",
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 20),
                              // Personal Information
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
                                    // Person Name
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
                                                "${giverProvider.fetchProfile!.data!.firstName} ${giverProvider.fetchProfile!.data!.lastName}",
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
                                              const SizedBox(height: 8),
                                              giverProvider.fetchProfile!.data!.userdetail!.gender.toString() != "null"
                                                  ? Text(
                                                      (giverProvider.fetchProfile!.data!.userdetail!.gender.toString() == "1")
                                                          ? "Male"
                                                          : (giverProvider.fetchProfile!.data!.userdetail!.gender.toString() == "2")
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
                                              const SizedBox(height: 8),
                                              if (giverProvider.fetchProfile!.data!.userdetail!.service != null) ...[
                                                Text(
                                                  giverProvider.fetchProfile!.data!.userdetail!.service!.name.toString() == "null" ? "Not Available" : giverProvider.fetchProfile!.data!.userdetail!.service!.name.toString(),
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
                                                  giverProvider.fetchProfile!.data!.userdetailprovider!.experience == null ? "Not Available" : "${giverProvider.fetchProfile!.data!.userdetailprovider!.experience.toString()} Years",
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
                                                giverProvider.fetchProfile!.data!.userdetailprovider!.hourlyRate.toString() != "null"
                                                    ? Text(
                                                        "\$ ${giverProvider.fetchProfile!.data!.userdetailprovider!.hourlyRate.toString()}",
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
                                              const SizedBox(height: 8),
                                              Text(
                                                giverProvider.fetchProfile!.data!.userdetail!.dob.toString(),
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
                                    // Postal Code
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
                                                "Postal Code",
                                                style: TextStyle(
                                                  color: ServiceGiverColor.black,
                                                  fontSize: 10,
                                                  fontFamily: "Rubik",
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              giverProvider.fetchProfile!.data!.userdetail!.zip.toString() == "null"
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
                                                      giverProvider.fetchProfile!.data!.userdetail!.zip.toString() == "null" ? "Required" : giverProvider.fetchProfile!.data!.userdetail!.zip.toString(),
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
                                              const SizedBox(height: 8),
                                              if (giverProvider.fetchProfile!.data!.userdetail!.area != null) ...[
                                                Wrap(
                                                  children: [
                                                    for (int i = 0; i < giverProvider.fetchProfile!.data!.userdetail!.area!.length; i++) ...[
                                                      if (giverProvider.fetchProfile!.data!.userdetail!.area![i].toString() == "0") ...[
                                                        Chip(
                                                          backgroundColor: Colors.grey.shade200,
                                                          deleteIconColor: Colors.black,
                                                          side: BorderSide.none,
                                                          label: const Text(
                                                            "East",
                                                            style: TextStyle(color: Colors.black),
                                                          ),
                                                        ),
                                                      ] else if (giverProvider.fetchProfile!.data!.userdetail!.area![i].toString() == "1") ...[
                                                        Chip(
                                                          backgroundColor: Colors.grey.shade200,
                                                          deleteIconColor: Colors.black,
                                                          side: BorderSide.none,
                                                          label: const Text(
                                                            "Central",
                                                            style: TextStyle(color: Colors.black),
                                                          ),
                                                        ),
                                                      ] else if (giverProvider.fetchProfile!.data!.userdetail!.area![i].toString() == "2") ...[
                                                        Chip(
                                                          backgroundColor: Colors.grey.shade200,
                                                          deleteIconColor: Colors.black,
                                                          side: BorderSide.none,
                                                          label: const Text(
                                                            "West",
                                                            style: TextStyle(color: Colors.black),
                                                          ),
                                                        ),
                                                      ],
                                                      const SizedBox(width: 05),
                                                    ],
                                                  ],
                                                ),
                                              ] else ...[
                                                Text(
                                                  "Not Available",
                                                  style: TextStyle(
                                                    color: CustomColors.hintText,
                                                    fontSize: 16,
                                                  ),
                                                )
                                              ],
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
                                                const SizedBox(height: 8),
                                                Wrap(
                                                  spacing: 8.0,
                                                  runSpacing: 0.0,
                                                  children: List.generate(giverProvider.fetchProfile!.data!.userdetailprovider!.additionalServices!.length, (index) {
                                                    var item = giverProvider.fetchProfile!.data!.userdetailprovider!.additionalServices![index];
                                                    return Chip(
                                                      backgroundColor: Colors.grey.shade200,
                                                      deleteIconColor: Colors.black,
                                                      side: BorderSide.none,
                                                      label: Text(
                                                        item,
                                                        style: const TextStyle(color: Colors.black),
                                                      ),
                                                    );
                                                  }),
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
                                                const SizedBox(height: 8),
                                                if (giverProvider.fetchProfile!.data!.educations!.isEmpty) ...[
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
                                                  itemCount: giverProvider.fetchProfile!.data!.educations!.length,
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
                                                            "Institue Name: ${giverProvider.fetchProfile!.data!.educations![index].name}",
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
                                                            "Major: ${giverProvider.fetchProfile!.data!.educations![index].major}",
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
                                                            "From: ${giverProvider.fetchProfile!.data!.educations![index].from}",
                                                            softWrap: true,
                                                            style: TextStyle(
                                                              color: CustomColors.hintText,
                                                              fontSize: 12,
                                                              fontFamily: "Rubik",
                                                              fontWeight: FontWeight.w200,
                                                            ),
                                                          ),
                                                          giverProvider.fetchProfile!.data!.educations![index].to == ""
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
                                                                  "To: ${giverProvider.fetchProfile!.data!.educations![index].to}",
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
                                                giverProvider.fetchProfile!.data!.userdetail!.userInfo.toString() == "null"
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
                                                        giverProvider.fetchProfile!.data!.userdetail!.userInfo.toString() == "null" ? "Required" : giverProvider.fetchProfile!.data!.userdetail!.userInfo.toString(),
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
                                                const SizedBox(height: 8),
                                                giverProvider.fetchProfile!.data!.userdetailprovider!.availability.toString() == "null"
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
                                                        giverProvider.fetchProfile!.data!.userdetailprovider!.availability.toString() == "null" ? "Required" : giverProvider.fetchProfile!.data!.userdetailprovider!.availability.toString(),
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
                                    Consumer<ServiceGiverProvider>(
                                      builder: (context, provider, child) {
                                        if (provider.providerIsVerified) {
                                          return DottedBorder(
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
                                                leading: SvgPicture.asset("assets/images/icons/account-verified.svg"),
                                                title: Text(
                                                  "Account Verified",
                                                  style: TextStyle(
                                                    color: CustomColors.primaryText,
                                                    fontSize: 12,
                                                    fontFamily: "Poppins",
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  "Thank you for verifying your account! Your profile is now verified, and you have earned the trust of care seekers. If you have any questions or need assistance, feel free to reach out.",
                                                  style: TextStyle(
                                                    color: CustomColors.primaryText,
                                                    fontSize: 10,
                                                    fontFamily: "Poppins",
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        } else {
                                          return DottedBorder(
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
                                          );
                                        }
                                      },
                                    ),
                                    // Work Refrence file
                                    const SizedBox(height: 10),
                                    GestureDetector(
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
                                                downloading ? "Work Reference $downloadProgress" : "Work Reference",
                                                maxLines: 2,
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
                                                  const SizedBox(width: 5),
                                                  if (giverProvider.fetchProfile!.data!.userdetailprovider!.workReference != null && giverProvider.fetchProfile!.data!.userdetailprovider!.workReference!.isNotEmpty) ...[
                                                    Text(
                                                      "File Available",
                                                      maxLines: 1,
                                                      textAlign: TextAlign.center,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        color: CustomColors.primaryText,
                                                      ),
                                                    ),
                                                  ] else ...[
                                                    Text(
                                                      "File Not Available",
                                                      maxLines: 1,
                                                      textAlign: TextAlign.center,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        color: CustomColors.primaryText,
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Resume file
                                    const SizedBox(height: 10),
                                    GestureDetector(
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
                                                downloading ? "Resume $downloadProgress" : "Resume",
                                                maxLines: 2,
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
                                                  const SizedBox(width: 5),
                                                  if (giverProvider.fetchProfile!.data!.userdetailprovider!.resume != null && giverProvider.fetchProfile!.data!.userdetailprovider!.resume!.isNotEmpty) ...[
                                                    Text(
                                                      "File Available",
                                                      maxLines: 1,
                                                      textAlign: TextAlign.center,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        color: CustomColors.primaryText,
                                                      ),
                                                    ),
                                                  ] else ...[
                                                    Text(
                                                      "File Not Available",
                                                      maxLines: 1,
                                                      textAlign: TextAlign.center,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        color: CustomColors.primaryText,
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // file type 1
                                    if (giverProvider.fetchProfile!.data!.providerverification!.validDriverLicense != null) ...[
                                      const SizedBox(height: 10),
                                      BasicDocumentDownloadList(
                                        onTap: () {
                                          doDownloadFile(giverProvider.fetchProfile!.data!.providerverification!.validDriverLicense);
                                        },
                                        fileStatus: giverProvider.fetchProfile!.data!.providerverification!.validDriverLicenseVerify.toString(),
                                        downloading: downloading,
                                        downloadProgress: downloadProgress,
                                        title: "Valid Driver's License",
                                      ),
                                    ],
                                    // file type 2
                                    if (giverProvider.fetchProfile!.data!.providerverification!.scarsAwarenessCertification != null) ...[
                                      const SizedBox(height: 10),
                                      BasicDocumentDownloadList(
                                        onTap: () {
                                          doDownloadFile(giverProvider.fetchProfile!.data!.providerverification!.scarsAwarenessCertification);
                                        },
                                        fileStatus: giverProvider.fetchProfile!.data!.providerverification!.scarsAwarenessCertificationVerify.toString(),
                                        downloading: downloading,
                                        downloadProgress: downloadProgress,
                                        title: "Scars Awareness Certification",
                                      ),
                                    ],
                                    // file type 8
                                    if (giverProvider.fetchProfile!.data!.providerverification!.policeBackgroundCheck != null) ...[
                                      const SizedBox(height: 10),
                                      BasicDocumentDownloadList(
                                        onTap: () {
                                          doDownloadFile(giverProvider.fetchProfile!.data!.providerverification!.policeBackgroundCheck);
                                        },
                                        fileStatus: giverProvider.fetchProfile!.data!.providerverification!.policeBackgroundCheckVerify.toString(),
                                        downloading: downloading,
                                        downloadProgress: downloadProgress,
                                        title: "Police Background Check",
                                      ),
                                    ],
                                    // file type 3
                                    if (giverProvider.fetchProfile!.data!.providerverification!.cprFirstAidCertification != null) ...[
                                      const SizedBox(height: 10),
                                      BasicDocumentDownloadList(
                                        onTap: () {
                                          doDownloadFile(giverProvider.fetchProfile!.data!.providerverification!.cprFirstAidCertification);
                                        },
                                        fileStatus: giverProvider.fetchProfile!.data!.providerverification!.cprFirstAidCertificationVerify.toString(),
                                        downloading: downloading,
                                        downloadProgress: downloadProgress,
                                        title: "CPR/First Aid Certificate",
                                      ),
                                    ],
                                    // file type 7
                                    if (giverProvider.fetchProfile!.data!.providerverification!.governmentRegisteredCareProvider != null) ...[
                                      const SizedBox(height: 10),
                                      BasicDocumentDownloadList(
                                        onTap: () {
                                          doDownloadFile(giverProvider.fetchProfile!.data!.providerverification!.governmentRegisteredCareProvider);
                                        },
                                        fileStatus: giverProvider.fetchProfile!.data!.providerverification!.governmentRegisteredCareProviderVerify.toString(),
                                        downloading: downloading,
                                        downloadProgress: downloadProgress,
                                        title: "Government Registered Care Provider",
                                      ),
                                    ],
                                    // file type 4
                                    if (giverProvider.fetchProfile!.data!.providerverification!.animalCareProviderCertification != null) ...[
                                      const SizedBox(height: 10),
                                      BasicDocumentDownloadList(
                                        onTap: () {
                                          doDownloadFile(giverProvider.fetchProfile!.data!.providerverification!.animalCareProviderCertification);
                                        },
                                        fileStatus: giverProvider.fetchProfile!.data!.providerverification!.animalCareProviderCertificationVerify.toString(),
                                        downloading: downloading,
                                        downloadProgress: downloadProgress,
                                        title: "Animal Care Provider Certificate",
                                      ),
                                    ],

                                    // file type 6
                                    if (giverProvider.fetchProfile!.data!.providerverification!.animalFirstAid != null) ...[
                                      const SizedBox(height: 10),
                                      BasicDocumentDownloadList(
                                        onTap: () {
                                          doDownloadFile(giverProvider.fetchProfile!.data!.providerverification!.animalFirstAid);
                                        },
                                        fileStatus: giverProvider.fetchProfile!.data!.providerverification!.animalFirstAidVerify.toString(),
                                        downloading: downloading,
                                        downloadProgress: downloadProgress,
                                        title: "Animal First Aid",
                                      ),
                                    ],
                                    // file type 3a

                                    if (giverProvider.fetchProfile!.data!.providerverification!.redCrossBabysittingCertification != null) ...[
                                      const SizedBox(height: 10),
                                      BasicDocumentDownloadList(
                                        onTap: () {
                                          doDownloadFile(giverProvider.fetchProfile!.data!.providerverification!.redCrossBabysittingCertification);
                                        },
                                        fileStatus: giverProvider.fetchProfile!.data!.providerverification!.redCrossBabysittingCertificationVerify.toString(),
                                        downloading: downloading,
                                        downloadProgress: downloadProgress,
                                        title: "Red Cross Babysitting Certification",
                                      ),
                                    ],

                                    // file type 5
                                    if (giverProvider.fetchProfile!.data!.providerverification!.chaildAndFamilyServicesAndAbuse != null) ...[
                                      const SizedBox(height: 10),
                                      BasicDocumentDownloadList(
                                        onTap: () {
                                          doDownloadFile(giverProvider.fetchProfile!.data!.providerverification!.chaildAndFamilyServicesAndAbuse);
                                        },
                                        fileStatus: giverProvider.fetchProfile!.data!.providerverification!.chaildAndFamilyServicesAndAbuseVerify.toString(),
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
        );
      },
    );
  }
}
