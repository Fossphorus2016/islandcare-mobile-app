// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:island_app/providers/user_provider.dart';
import 'package:island_app/res/app_url.dart';
import 'package:island_app/utils/utils.dart';
import 'package:island_app/widgets/document_download_list.dart';
// import 'package:island_app/widgets/document_download_list.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
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

  Future<ApplicantDetailProfileModel> fetchApplicantProfileDetailModel() async {
    var token = await Provider.of<RecieverUserProvider>(context, listen: false).getUserToken();

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

  bool downloading = false;
  String downloadProgress = '';
  String downloadPdfPath = '';
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

  // getUserToken() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   var userToken = preferences.getString(
  //     'userToken',
  //   );
  //   // if (kDebugMode) {
  //   //   print(userToken);
  //   // }
  //   return userToken.toString();
  // }

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
                              if (snapshot.data!.data![0].providerverification != null) ...[
                                // file type 1
                                if (snapshot.data!.data![0].providerverification!.validDriverLicense != null) ...[
                                  const SizedBox(height: 10),
                                  BasicDocumentDownloadList(
                                    onTap: () {
                                      doDownloadFile(snapshot.data!.data![0].providerverification!.validDriverLicense);
                                    },
                                    fileStatus: snapshot.data!.data![0].providerverification!.validDriverLicenseVerify.toString(),
                                    downloading: downloading,
                                    downloadProgress: downloadProgress,
                                    title: "Valid Driver's License",
                                  ),
                                ],
                                // file type 2
                                if (snapshot.data!.data![0].providerverification!.scarsAwarenessCertification != null) ...[
                                  const SizedBox(height: 10),
                                  BasicDocumentDownloadList(
                                    onTap: () {
                                      doDownloadFile(snapshot.data!.data![0].providerverification!.scarsAwarenessCertification);
                                    },
                                    fileStatus: snapshot.data!.data![0].providerverification!.scarsAwarenessCertificationVerify.toString(),
                                    downloading: downloading,
                                    downloadProgress: downloadProgress,
                                    title: "Scars Awareness Certification",
                                  ),
                                ],
                                // file type 8
                                if (snapshot.data!.data![0].providerverification!.policeBackgroundCheck != null) ...[
                                  const SizedBox(height: 10),
                                  BasicDocumentDownloadList(
                                    onTap: () {
                                      doDownloadFile(snapshot.data!.data![0].providerverification!.policeBackgroundCheck);
                                    },
                                    fileStatus: snapshot.data!.data![0].providerverification!.policeBackgroundCheckVerify.toString(),
                                    downloading: downloading,
                                    downloadProgress: downloadProgress,
                                    title: "Police Background Check",
                                  ),
                                ],
                                // file type 3
                                if (snapshot.data!.data![0].providerverification!.cprFirstAidCertification != null) ...[
                                  const SizedBox(height: 10),
                                  BasicDocumentDownloadList(
                                    onTap: () {
                                      doDownloadFile(snapshot.data!.data![0].providerverification!.cprFirstAidCertification);
                                    },
                                    fileStatus: snapshot.data!.data![0].providerverification!.cprFirstAidCertificationVerify.toString(),
                                    downloading: downloading,
                                    downloadProgress: downloadProgress,
                                    title: "CPR/First Aid Certificate",
                                  ),
                                ],
                                // file type 7
                                if (snapshot.data!.data![0].providerverification!.governmentRegisteredCareProvider != null) ...[
                                  const SizedBox(height: 10),
                                  BasicDocumentDownloadList(
                                    onTap: () {
                                      doDownloadFile(snapshot.data!.data![0].providerverification!.governmentRegisteredCareProvider);
                                    },
                                    fileStatus: snapshot.data!.data![0].providerverification!.governmentRegisteredCareProviderVerify.toString(),
                                    downloading: downloading,
                                    downloadProgress: downloadProgress,
                                    title: "Government Registered Care Provider",
                                  ),
                                ],
                                // file type 4
                                if (snapshot.data!.data![0].providerverification!.animalCareProviderCertification != null) ...[
                                  const SizedBox(height: 10),
                                  BasicDocumentDownloadList(
                                    onTap: () {
                                      doDownloadFile(snapshot.data!.data![0].providerverification!.animalCareProviderCertification);
                                    },
                                    fileStatus: snapshot.data!.data![0].providerverification!.animalCareProviderCertificationVerify.toString(),
                                    downloading: downloading,
                                    downloadProgress: downloadProgress,
                                    title: "Animal Care Provider Certificate",
                                  ),
                                ],
                                // file type 6
                                if (snapshot.data!.data![0].providerverification!.animailFirstAid != null) ...[
                                  const SizedBox(height: 10),
                                  BasicDocumentDownloadList(
                                    onTap: () {
                                      doDownloadFile(snapshot.data!.data![0].providerverification!.animailFirstAid);
                                    },
                                    fileStatus: snapshot.data!.data![0].providerverification!.animailFirstAidVerify.toString(),
                                    downloading: downloading,
                                    downloadProgress: downloadProgress,
                                    title: "Animal First Aid",
                                  ),
                                ],
                                // file type 3a
                                if (snapshot.data!.data![0].providerverification!.redCrossBabysittingCertification != null) ...[
                                  const SizedBox(height: 10),
                                  BasicDocumentDownloadList(
                                    onTap: () {
                                      doDownloadFile(snapshot.data!.data![0].providerverification!.redCrossBabysittingCertification);
                                    },
                                    fileStatus: snapshot.data!.data![0].providerverification!.redCrossBabysittingCertificationVerify.toString(),
                                    downloading: downloading,
                                    downloadProgress: downloadProgress,
                                    title: "Red Cross Babysitting Certification",
                                  ),
                                ],
                                // file type 5
                                if (snapshot.data!.data![0].providerverification!.chaildAndFamilyServicesAndAbuse != null) ...[
                                  const SizedBox(height: 10),
                                  BasicDocumentDownloadList(
                                    onTap: () {
                                      doDownloadFile(snapshot.data!.data![0].providerverification!.chaildAndFamilyServicesAndAbuse);
                                    },
                                    fileStatus: snapshot.data!.data![0].providerverification!.chaildAndFamilyServicesAndAbuseVerify.toString(),
                                    downloading: downloading,
                                    downloadProgress: downloadProgress,
                                    title: "Dept Child and Family Services Child Abuse Check",
                                  ),
                                ],
                              ]
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
