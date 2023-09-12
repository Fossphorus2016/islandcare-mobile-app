// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/widgets/receiver_dashboard_detail_widget.dart';
import 'package:island_app/res/app_url.dart';
import 'package:island_app/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    var token = await getUserToken();
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
      customErrorSnackBar(context, e.toString());
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
      customErrorSnackBar(context, e.toString());
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
      customErrorSnackBar(context, e.toString());
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
      customErrorSnackBar(context, e.toString());
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
    // print(userToken);
    return userToken.toString();
  }

  @override
  void initState() {
    getUserToken();

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
                        // Download Enhanced File
                        GestureDetector(
                          onTap: () {
                            // doDownloadEnhancedFile();
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
                                    // doDownloadEnhancedFile();
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
                                        if (snapshot.data!.data![0].providerverification != null) ...[
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
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        // doDownloadBasicFile
                        GestureDetector(
                          onTap: () {
                            // doDownloadBasicFile();
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
                                    // doDownloadBasicFile();
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
                                        if (snapshot.data!.data![0].providerverification != null) ...[
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
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        // doDownloadFirstAidFile
                        GestureDetector(
                          onTap: () {
                            // doDownloadFirstAidFile();
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
                                    // doDownloadFirstAidFile();
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
                                        if (snapshot.data!.data![0].providerverification != null) ...[
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
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        // doDownloadVehicleFile
                        GestureDetector(
                          onTap: () {
                            // doDownloadVehicleFile();
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
                                    // doDownloadVehicleFile();
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
                                        if (snapshot.data!.data![0].providerverification != null) ...[
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
                    imgProviderPath: snapshot.data!.data![index].ratings!.isEmpty ? "https://img.icons8.com/material-rounded/256/question-mark.png" : "https://islandcare.bm/storage/${snapshot.data!.data![index].ratings![index].receiverRating!.avatar}",
                    providerName: snapshot.data!.data![index].ratings!.isEmpty ? "Not Available" : "${snapshot.data!.data![index].ratings![index].receiverRating!.firstName} ${snapshot.data!.data![index].ratings![index].receiverRating!.lastName}",
                    providerComment: snapshot.data!.data![index].ratings!.isEmpty ? "Not Available" : snapshot.data!.data![index].ratings![index].comment.toString(),
                    providerRating: snapshot.data!.data![index].ratings!.isEmpty ? 0.0 : snapshot.data!.data![index].ratings![index].rating!.toDouble(),
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
