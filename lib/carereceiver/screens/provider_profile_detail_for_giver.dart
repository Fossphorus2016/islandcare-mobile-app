// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:dio/dio.dart';
// import 'package:dotted_border/dotted_border.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/widgets/receiver_dashboard_detail_widget.dart';
import 'package:island_app/providers/user_provider.dart';
import 'package:island_app/res/app_url.dart';
import 'package:island_app/utils/utils.dart';
import 'package:island_app/widgets/document_download_list.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:island_app/carereceiver/models/service_receiver_dashboard_detail_model.dart';
import 'package:island_app/carereceiver/utils/colors.dart';

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
  late Future<ServiceReceiverDashboardDetailModel>? futureReceiverDashboardDetail;
  Future<ServiceReceiverDashboardDetailModel> fetchReceiverDashboardDetailModel() async {
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
      return ServiceReceiverDashboardDetailModel.fromJson(response.data);
    } else {
      throw Exception(
        'Failed to load Service Receiver Dashboard Details',
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

  @override
  void initState() {
    super.initState();
    futureReceiverDashboardDetail = fetchReceiverDashboardDetailModel();
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
      body: SingleChildScrollView(
        child: FutureBuilder<ServiceReceiverDashboardDetailModel>(
          future: futureReceiverDashboardDetail,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return ReceiverDashboardDetailWidget(
                    imgPath: snapshot.data!.data![0].avatar != null ? ("https://islandcare.bm/storage/${snapshot.data!.data![0].avatar}") : "https://img.icons8.com/material-rounded/256/question-mark.png",
                    title: "${snapshot.data!.data![0].firstName} ${snapshot.data!.data![0].lastName}",
                    services: snapshot.data!.data![0].userdetail!.service!.name.toString(),
                    desc: snapshot.data!.data![0].userdetail!.userInfo.toString() == "null" ? "Not Available" : snapshot.data!.data![0].userdetail!.userInfo.toString(),
                    experience: snapshot.data!.data![0].userdetailprovider != null
                        ? snapshot.data!.data![0].userdetailprovider!.experience.toString() == "null"
                            ? "0"
                            : snapshot.data!.data![0].userdetailprovider!.experience.toString()
                        : "",
                    address: snapshot.data!.data![0].userdetail!.address.toString() == "null" ? "Not Available" : snapshot.data!.data![0].userdetail!.address.toString(),
                    initialRating: widget.rating,
                    instituteName: snapshot.data!.data![0].educations!.isEmpty ? "Not Available" : snapshot.data!.data![0].educations![index].name.toString(),
                    major: snapshot.data!.data![0].educations!.isEmpty ? "Not Available" : snapshot.data!.data![0].educations![index].major.toString(),
                    from: snapshot.data!.data![0].educations!.isEmpty ? "Not Available" : snapshot.data!.data![0].educations![index].from.toString(),
                    to: snapshot.data!.data![0].educations!.isEmpty ? "Not Available" : snapshot.data!.data![0].educations![index].to.toString(),
                    hour: snapshot.data!.data![0].userdetailprovider != null
                        ? snapshot.data!.data![0].userdetailprovider!.hourlyRate.toString() == "null"
                            ? "0"
                            : snapshot.data!.data![0].userdetailprovider!.hourlyRate.toString()
                        : '',
                    zip: snapshot.data!.data![0].userdetail!.zip.toString() == "null" ? "Not Available" : snapshot.data!.data![0].userdetail!.zip.toString(),
                    documentsSection: Column(
                      children: [
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
                      ],
                    ),
                    imgProviderPath: snapshot.data!.data![index].ratings!.isEmpty ? "https://img.icons8.com/material-rounded/256/question-mark.png" : "https://islandcare.bm/storage/${snapshot.data!.data![index].ratings![index].receiverRating!.avatar}",
                    // providerName: snapshot.data!.data![index].ratings!.isEmpty ? "Not Available" : "${snapshot.data!.data![index].ratings![index].receiverRating!.firstName} ${snapshot.data!.data![index].ratings![index].receiverRating!.lastName}",
                    // providerComment: snapshot.data!.data![index].ratings!.isEmpty ? "Not Available" : snapshot.data!.data![index].ratings![index].comment.toString(),
                    // providerRating: snapshot.data!.data![index].ratings!.isEmpty ? 0.0 : snapshot.data!.data![index].ratings![index].rating!.toDouble(),
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
      ),
    );
  }
}
