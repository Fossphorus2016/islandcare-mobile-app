// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:island_app/res/app_url.dart';
import 'package:island_app/utils/utils.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:island_app/carereceiver/models/applicant_profile_detail-model.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/carereceiver/widgets/job_applicant_profile_widget.dart';

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
  // double calculateAverage(List<int> data) {
  //   if (data.isEmpty) return 0;
  //   int sum = data.reduce((a, b) => a + b);
  //   return sum / data.length;
  // }

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
      // print('Average: ${average.toString()}');
      setState(() {
        // print('Average: ${average.toString()}');
        ratings = average;
        id = id;
        isHiredd = hired;
        // print("sumRating $sumRating");
        // print("hired $isHiredd");
        // print("jobtit ${widget.jobTitle}");
        // print("jobId ${widget.jobId}");
        // print("jobpro ${widget.profileId}");
      });
      return ApplicantDetailProfileModel.fromJson(response.data);
    } else {
      throw Exception(
        'Failed to load Applicant Profile Details',
      );
    }
  }

  // AcceptApplicant
  // Future<http.Response> AcceptApplicant(url) async {
  //   var requestBody = {
  //     '_method': 'put',
  //   };
  //   var token = await getUserToken();
  //   var url = 'http://192.168.0.244:9999/api/service-receiver-my-application-applicant-details-approve/$id/${widget.profileId}';
  //   var response = await http.post(
  //     Uri.parse(url),
  //     headers: {
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //     body: requestBody,
  //   );
  //   if (response.statusCode == 200) {
  //     // customSuccesSnackBar("Added To Favourite", context);
  //     if (kDebugMode) {
  //       print("AcceptApplicant = ${response.body}");
  //     }
  //   } else {
  //     if (kDebugMode) {
  //       print("AcceptApplicant = ${response.body}");
  //     }
  //   }
  //   return response;
  // }
  acceptApplicant() async {
    // print("call");
    var token = await getUserToken();
    var formData = FormData.fromMap(
      {
        "_method": "put",
      },
    );
    Dio dio = Dio();
    // print(
    //   '${CareReceiverURl.serviceReceiverApplicantionApplicantsAccept}/${widget.profileId}/${widget.jobId}',
    // );
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
      // print(response.data);
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
      // print(response.toString());
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
      // print(e.toString());
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

  Future downloadEnhancedFile(String downloadDirectory) async {
    Dio dio = Dio();
    var downloadingPdfPath = '$downloadDirectory/enhanced.pdf';

    try {
      await dio.download(
        hostPath + '/' + pdfEnhancePath!,
        downloadingPdfPath,
        onReceiveProgress: (rec, total) {
          // print("REC: $rec , TOTAL: $total");
          setState(() {
            downloading = true;
            downloadProgress = "${((rec / total) * 100).toStringAsFixed(0)}%";
          });
        },
      );
    } catch (e) {
      customErrorSnackBar(
        context,
        e.toString(),
      );
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
          // print("REC: $rec , TOTAL: $total");
          setState(() {
            downloading = true;
            downloadProgress = "${((rec / total) * 100).toStringAsFixed(0)}%";
          });
        },
      );
    } catch (e) {
      customErrorSnackBar(
        context,
        e.toString(),
      );
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
          // print("REC: $rec , TOTAL: $total");
          setState(() {
            downloading = true;
            downloadProgress = "${((rec / total) * 100).toStringAsFixed(0)}%";
          });
        },
      );
    } catch (e) {
      customErrorSnackBar(
        context,
        e.toString(),
      );
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
          // print("REC: $rec , TOTAL: $total");
          setState(() {
            downloading = true;
            downloadProgress = "${((rec / total) * 100).toStringAsFixed(0)}%";
          });
        },
      );
    } catch (e) {
      customErrorSnackBar(
        context,
        e.toString(),
      );
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

  getUserToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userToken = preferences.getString(
      'userToken',
    );
    if (kDebugMode) {
      print(userToken);
    }
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
    // print("isCompletedProfile $completedProfile $isCompletedProfile");

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
                    // itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      return JobApplicantProfileWidget(
                          dataMap:snapshot.data!.data![0].toJson(),
                          id:snapshot.data!.data![0].id.toString(),
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
                          // firstAdd: snapshot.data!.data![0].providerverification!.firstAid.toString(),
                          documentsSection: Column(
                            children: [
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
                                                (snapshot.data!.data![0].providerverification!.enhancedCriminalVerify.toString() == "0")
                                                    ? "Pending"
                                                    : (snapshot.data!.data![0].providerverification!.enhancedCriminalVerify.toString() == "1")
                                                        ? "Approved"
                                                        : (snapshot.data!.data![0].providerverification!.enhancedCriminalVerify.toString() == "2")
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
                                                (snapshot.data!.data![0].providerverification!.basicCriminalVerify.toString() == "0")
                                                    ? "Pending"
                                                    : (snapshot.data!.data![0].providerverification!.basicCriminalVerify.toString() == "1")
                                                        ? "Approved"
                                                        : (snapshot.data!.data![0].providerverification!.basicCriminalVerify.toString() == "2")
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
                                                (snapshot.data!.data![0].providerverification!.firstAidVerify.toString() == "0")
                                                    ? "Pending"
                                                    : (snapshot.data!.data![0].providerverification!.firstAidVerify.toString() == "1")
                                                        ? "Approved"
                                                        : (snapshot.data!.data![0].providerverification!.firstAidVerify.toString() == "2")
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
                              // doDownloadVehicleFile
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
                                              const SizedBox(width: 5),
                                              Text(
                                                (snapshot.data!.data![0].providerverification!.vehicleRecordVerify.toString() == "0")
                                                    ? "Pending"
                                                    : (snapshot.data!.data![0].providerverification!.vehicleRecordVerify.toString() == "1")
                                                        ? "Approved"
                                                        : (snapshot.data!.data![0].providerverification!.vehicleRecordVerify.toString() == "2")
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
                          review: null,
                          acceptBtnFunc: () {
                            // if (isHiredd == 0) {
                            acceptApplicant();
                            // if (isHiredd == 0) {
                            setState(() {
                              isHiredd = 1;
                            });
                            // }
                            // else if (isHiredd == 1) {
                            //   setState(() {
                            //     isHiredd = 0;
                            //   });
                            // }
                            // }
                          },
                          acceptBtnColor: isHiredd == 0 ? CustomColors.green : CustomColors.red,
                          declineApplicant:
                              // isHiredd == 1
                              //     ?
                              () {
                            declineApplicant();
                            // if (isHiredd == 0) {
                            setState(() {
                              isHiredd = 1;
                            });
                            // }
                            // else if (isHiredd == 1) {
                            //   setState(() {
                            //     isHiredd = 0;
                            //   });
                            // }
                          }
                          // : n.ull,
                          );
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
