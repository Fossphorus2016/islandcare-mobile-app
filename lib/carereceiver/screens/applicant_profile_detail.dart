// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:island_app/res/app_url.dart';
import 'package:island_app/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:island_app/carereceiver/models/applicant_profile_detail-model.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/carereceiver/widgets/job_applicant_profile_widget.dart';
import 'package:island_app/caregiver/screens/profile_screen.dart';

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
  int? ratings;
  late Future<ApplicantDetailProfileModel>? futureapplicantProfileDetail;
  var id;
  var isHiredd;

  Future<ApplicantDetailProfileModel> fetchApplicantProfileDetailModel() async {
    var token = await getUserToken();

    final response = await Dio().get(
      "${CareReceiverURl.serviceReceiverApplicantDetails}/${widget.jobTitle}/${widget.profileId}/${widget.jobId}",
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> map = response.data;
      var ratingList = map['data'][0]["ratings"];
      var jobname = map["job_title"];
      var id = map['data'][0]["id"];
      var hired = map['is_hired'];
      var sumRating = map['data'][0]['ratings'];
      double sum = 0;
      for (int i = 0; i < sumRating.length; i++) {
        sum += sumRating[i]['rating'];
      }
      int average = sum ~/ sumRating.length;
      setState(() {
        ratings = average;
        id = id;
        isHiredd = hired;
      });
      return ApplicantDetailProfileModel.fromJson(response.data);
    } else {
      throw Exception(
        'Failed to load Applicant Profile Details',
      );
    }
  }

  acceptApplicant() async {
    var token = await getUserToken();
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
    var token = await getUserToken();
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

  getUserToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userToken = preferences.getString(
      'userToken',
    );
    // if (kDebugMode) {
    //   print(userToken);
    // }
    return userToken.toString();
  }

  var isCompletedProfile;
  getCompletedProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var completedProfile = preferences.getString(
      'isProfileCompleted',
    );
    setState(() {
      isCompletedProfile = completedProfile;
    });

    return isCompletedProfile.toString();
  }

  @override
  void initState() {
    getUserToken();
    getCompletedProfile();
    super.initState();
    futureapplicantProfileDetail = fetchApplicantProfileDetailModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<ApplicantDetailProfileModel>(
              future: futureapplicantProfileDetail,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return JobApplicantProfileWidget(
                          dataMap: snapshot.data!.data![0].toJson(),
                          id: snapshot.data!.data![0].id.toString(),
                          imgPath: "${AppUrl.webStorageUrl}/${snapshot.data!.data![0].avatar}",
                          title: "${snapshot.data!.data![0].firstName} ${snapshot.data!.data![0].lastName}",
                          services: snapshot.data!.data![0].userdetail!.service!.name.toString(),
                          desc: snapshot.data!.data![0].userdetail!.userInfo.toString() == "null" ? "Not Available" : snapshot.data!.data![0].userdetail!.userInfo.toString(),
                          experience: snapshot.data!.data![0].userdetailprovider!.experience.toString() == "null" ? "0" : snapshot.data!.data![0].userdetailprovider!.experience.toString(),
                          address: snapshot.data!.data![0].userdetail!.address.toString() == "null" ? "Not Available" : snapshot.data!.data![0].userdetail!.address.toString(),
                          initialRating: double.parse(ratings.toString()),
                          instituteName: snapshot.data!.data![0].educations!.isEmpty ? "Not Available" : snapshot.data!.data![0].educations![index].name.toString(),
                          major: snapshot.data!.data![0].educations!.isEmpty ? "Not Available" : snapshot.data!.data![0].educations![index].major.toString(),
                          from: snapshot.data!.data![0].educations!.isEmpty ? "Not Available" : snapshot.data!.data![0].educations![index].from.toString(),
                          to: snapshot.data!.data![0].educations!.isEmpty ? "Not Available" : snapshot.data!.data![0].educations![index].to.toString(),
                          hour: snapshot.data!.data![0].userdetailprovider!.hourlyRate.toString() == "null" ? "0" : snapshot.data!.data![0].userdetailprovider!.hourlyRate.toString(),
                          zip: snapshot.data!.data![0].userdetail!.zip.toString() == "null" ? " " : snapshot.data!.data![0].userdetail!.zip.toString(),
                          documentsSection: Column(
                            children: [
                              BasicDocumentDownloadList(
                                onTap: () {
                                  if (snapshot.data!.data![0].providerverification!.enhancedCriminal!.isNotEmpty) {
                                    doDownloadFile(snapshot.data!.data![0].providerverification!.enhancedCriminal);
                                  }
                                },
                                fileStatus: snapshot.data!.data![0].providerverification!.enhancedCriminalVerify.toString(),
                                downloading: downloading,
                                downloadProgress: downloadProgress,
                                title: "Download Enhanced Criminal Document",
                              ),

                              const SizedBox(height: 15),
                              BasicDocumentDownloadList(
                                onTap: () {
                                  if (snapshot.data!.data![0].providerverification!.basicCriminal!.isNotEmpty) {
                                    doDownloadFile(snapshot.data!.data![0].providerverification!.basicCriminal);
                                  }
                                },
                                fileStatus: snapshot.data!.data![0].providerverification!.basicCriminalVerify.toString(),
                                downloading: downloading,
                                downloadProgress: downloadProgress,
                                title: "Download Basic Criminal Document",
                              ),
                              const SizedBox(height: 15),
                              BasicDocumentDownloadList(
                                onTap: () {
                                  if (snapshot.data!.data![0].providerverification!.firstAid.isNotEmpty) {
                                    doDownloadFile(snapshot.data!.data![0].providerverification!.firstAid);
                                  }
                                },
                                fileStatus: snapshot.data!.data![0].providerverification!.firstAidVerify.toString(),
                                downloading: downloading,
                                downloadProgress: downloadProgress,
                                title: "Download First Aid Document",
                              ),

                              const SizedBox(height: 15),
                              BasicDocumentDownloadList(
                                onTap: () {
                                  if (snapshot.data!.data![0].providerverification!.vehicleRecord.isNotEmpty) {
                                    doDownloadFile(snapshot.data!.data![0].providerverification!.vehicleRecord);
                                  }
                                },
                                fileStatus: snapshot.data!.data![0].providerverification!.vehicleRecordVerify.toString(),
                                downloading: downloading,
                                downloadProgress: downloadProgress,
                                title: "Download Vehicle Record Document",
                              ),
                              // // Download Enhanced File
                              // GestureDetector(
                              //   onTap: () {
                              //     doDownloadEnhancedFile();
                              //   },
                              //   child: Container(
                              //     padding: const EdgeInsets.all(5),
                              //     decoration: BoxDecoration(
                              //       color: CustomColors.white,
                              //       borderRadius: BorderRadius.circular(12),
                              //     ),
                              //     child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //       children: [
                              //         TextButton.icon(
                              //           onPressed: () {
                              //             doDownloadEnhancedFile();
                              //           },
                              //           icon: Icon(
                              //             Icons.picture_as_pdf_rounded,
                              //             color: CustomColors.red,
                              //           ),
                              //           label: Text(
                              //             downloading ? "Download Enhanced Criminal Document $downloadProgress" : "Download Enhanced Criminal Document",
                              //             style: TextStyle(fontSize: 10, color: CustomColors.primaryText),
                              //           ),
                              //         ),
                              //         GestureDetector(
                              //           onTap: () async {},
                              //           child: DottedBorder(
                              //             padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 5),
                              //             radius: const Radius.circular(4),
                              //             borderType: BorderType.RRect,
                              //             color: CustomColors.primaryColor,
                              //             child: Row(
                              //               children: [
                              //                 Icon(
                              //                   Icons.picture_as_pdf_rounded,
                              //                   color: CustomColors.red,
                              //                   size: 16,
                              //                 ),
                              //                 const SizedBox(
                              //                   width: 5,
                              //                 ),
                              //                 Text(
                              //                   (snapshot.data!.data![0].providerverification!.enhancedCriminalVerify.toString() == "0")
                              //                       ? "Pending"
                              //                       : (snapshot.data!.data![0].providerverification!.enhancedCriminalVerify.toString() == "1")
                              //                           ? "Approved"
                              //                           : (snapshot.data!.data![0].providerverification!.enhancedCriminalVerify.toString() == "2")
                              //                               ? "Rejected"
                              //                               : "File Not Available Enhanced Criminal Document",
                              //                   style: TextStyle(
                              //                     fontSize: 11,
                              //                     color: CustomColors.primaryText,
                              //                   ),
                              //                 ),
                              //               ],
                              //             ),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              // const SizedBox(height: 15),
                              // // doDownloadBasicFile
                              // GestureDetector(
                              //   onTap: () {
                              //     doDownloadBasicFile();
                              //   },
                              //   child: Container(
                              //     padding: const EdgeInsets.all(5),
                              //     decoration: BoxDecoration(
                              //       color: CustomColors.white,
                              //       borderRadius: BorderRadius.circular(12),
                              //     ),
                              //     child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //       children: [
                              //         TextButton.icon(
                              //           onPressed: () {
                              //             doDownloadBasicFile();
                              //           },
                              //           icon: Icon(
                              //             Icons.picture_as_pdf_rounded,
                              //             color: CustomColors.red,
                              //           ),
                              //           label: Text(
                              //             downloading ? "Download Basic Criminal Document $downloadProgress" : "Download Basic Criminal Document",
                              //             style: TextStyle(fontSize: 10, color: CustomColors.primaryText),
                              //           ),
                              //         ),
                              //         GestureDetector(
                              //           onTap: () async {
                              //             // getEnhancedPdfFile();
                              //           },
                              //           child: DottedBorder(
                              //             padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 5),
                              //             radius: const Radius.circular(4),
                              //             borderType: BorderType.RRect,
                              //             color: CustomColors.primaryColor,
                              //             child: Row(
                              //               children: [
                              //                 Icon(
                              //                   Icons.picture_as_pdf_rounded,
                              //                   color: CustomColors.red,
                              //                   size: 16,
                              //                 ),
                              //                 const SizedBox(
                              //                   width: 5,
                              //                 ),
                              //                 Text(
                              //                   (snapshot.data!.data![0].providerverification!.basicCriminalVerify.toString() == "0")
                              //                       ? "Pending"
                              //                       : (snapshot.data!.data![0].providerverification!.basicCriminalVerify.toString() == "1")
                              //                           ? "Approved"
                              //                           : (snapshot.data!.data![0].providerverification!.basicCriminalVerify.toString() == "2")
                              //                               ? "Rejected"
                              //                               : "File Not Available Basic Criminal Document",
                              //                   style: TextStyle(
                              //                     fontSize: 11,
                              //                     color: CustomColors.primaryText,
                              //                   ),
                              //                 ),
                              //               ],
                              //             ),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              // const SizedBox(height: 15),
                              // // doDownloadFirstAidFile
                              // GestureDetector(
                              //   onTap: () {
                              //     doDownloadFirstAidFile();
                              //   },
                              //   child: Container(
                              //     padding: const EdgeInsets.all(5),
                              //     decoration: BoxDecoration(
                              //       color: CustomColors.white,
                              //       borderRadius: BorderRadius.circular(12),
                              //     ),
                              //     child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //       children: [
                              //         TextButton.icon(
                              //           onPressed: () {
                              //             doDownloadFirstAidFile();
                              //           },
                              //           icon: Icon(
                              //             Icons.picture_as_pdf_rounded,
                              //             color: CustomColors.red,
                              //           ),
                              //           label: Text(
                              //             "Download First Aid Document",
                              //             style: TextStyle(fontSize: 10, color: CustomColors.primaryText),
                              //           ),
                              //         ),
                              //         GestureDetector(
                              //           onTap: () async {
                              //             // getEnhancedPdfFile();
                              //           },
                              //           child: DottedBorder(
                              //             padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 5),
                              //             radius: const Radius.circular(4),
                              //             borderType: BorderType.RRect,
                              //             color: CustomColors.primaryColor,
                              //             child: Row(
                              //               children: [
                              //                 Icon(
                              //                   Icons.picture_as_pdf_rounded,
                              //                   color: CustomColors.red,
                              //                   size: 16,
                              //                 ),
                              //                 const SizedBox(
                              //                   width: 5,
                              //                 ),
                              //                 Text(
                              //                   (snapshot.data!.data![0].providerverification!.firstAidVerify.toString() == "0")
                              //                       ? "Pending"
                              //                       : (snapshot.data!.data![0].providerverification!.firstAidVerify.toString() == "1")
                              //                           ? "Approved"
                              //                           : (snapshot.data!.data![0].providerverification!.firstAidVerify.toString() == "2")
                              //                               ? "Rejected"
                              //                               : "File Not Available First Aid Document",
                              //                   style: TextStyle(
                              //                     fontSize: 11,
                              //                     color: CustomColors.primaryText,
                              //                   ),
                              //                 ),
                              //               ],
                              //             ),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              // const SizedBox(height: 15),
                              // // doDownloadVehicleFile
                              // GestureDetector(
                              //   onTap: () {
                              //     doDownloadVehicleFile();
                              //   },
                              //   child: Container(
                              //     padding: const EdgeInsets.all(5),
                              //     decoration: BoxDecoration(
                              //       color: CustomColors.white,
                              //       borderRadius: BorderRadius.circular(12),
                              //     ),
                              //     child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //       children: [
                              //         TextButton.icon(
                              //           onPressed: () {
                              //             doDownloadVehicleFile();
                              //           },
                              //           icon: Icon(
                              //             Icons.picture_as_pdf_rounded,
                              //             color: CustomColors.red,
                              //           ),
                              //           label: Text(
                              //             "Download Vehicle Record Document",
                              //             style: TextStyle(fontSize: 10, color: CustomColors.primaryText),
                              //           ),
                              //         ),
                              //         GestureDetector(
                              //           onTap: () async {
                              //             // getEnhancedPdfFile();
                              //           },
                              //           child: DottedBorder(
                              //             padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 5),
                              //             radius: const Radius.circular(4),
                              //             borderType: BorderType.RRect,
                              //             color: CustomColors.primaryColor,
                              //             child: Row(
                              //               children: [
                              //                 Icon(
                              //                   Icons.picture_as_pdf_rounded,
                              //                   color: CustomColors.red,
                              //                   size: 16,
                              //                 ),
                              //                 const SizedBox(width: 5),
                              //                 Text(
                              //                   (snapshot.data!.data![0].providerverification!.vehicleRecordVerify.toString() == "0")
                              //                       ? "Pending"
                              //                       : (snapshot.data!.data![0].providerverification!.vehicleRecordVerify.toString() == "1")
                              //                           ? "Approved"
                              //                           : (snapshot.data!.data![0].providerverification!.vehicleRecordVerify.toString() == "2")
                              //                               ? "Rejected"
                              //                               : "File Not Available Vehicle Record  Document",
                              //                   style: TextStyle(
                              //                     fontSize: 11,
                              //                     color: CustomColors.primaryText,
                              //                   ),
                              //                 ),
                              //               ],
                              //             ),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          review: null,
                          acceptBtnFunc: () {
                            acceptApplicant();
                            setState(() {
                              isHiredd = 1;
                            });
                          },
                          acceptBtnColor: isHiredd == 0 ? CustomColors.green : CustomColors.red,
                          declineApplicant: () {
                            declineApplicant();
                            setState(() {
                              isHiredd = 1;
                            });
                          });
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
