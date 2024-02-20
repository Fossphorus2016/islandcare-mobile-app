// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:island_app/caregiver/models/service_provider_job_board_model.dart';
import 'package:island_app/caregiver/screens/my_job_detail.dart';
import 'package:island_app/caregiver/utils/profile_provider.dart';
import 'package:island_app/utils/utils.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/carereceiver/widgets/job_cart_widget.dart';
import 'package:island_app/res/app_url.dart';
import 'package:provider/provider.dart';

class ServiceProviderJobs extends StatefulWidget {
  const ServiceProviderJobs({super.key});

  @override
  State<ServiceProviderJobs> createState() => _ServiceProviderJobsState();
}

class _ServiceProviderJobsState extends State<ServiceProviderJobs> {
  String? dropdownValue = 'All Relevance';
  Future<void> _showDeleteDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Deleted',
                  style: TextStyle(
                    color: CustomColors.primaryText,
                    fontSize: 26,
                    fontFamily: "Rubik",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Are you sure you want to Delete?',
                  style: TextStyle(
                    color: CustomColors.hintText,
                    fontSize: 16,
                    fontFamily: "Rubik",
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: CustomColors.primaryColor,
                  fontSize: 16,
                  fontFamily: "Rubik",
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Ok',
                style: TextStyle(
                  color: CustomColors.primaryColor,
                  fontSize: 16,
                  fontFamily: "Rubik",
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List? allJobs = [];
  // Get all jobs
  late Future<ServiceProviderJobBoardModel> fetchJobBoard;
  Future<ServiceProviderJobBoardModel> fetchServiceProviderJobBoardModel() async {
    var token = await Provider.of<ServiceGiverProvider>(context, listen: false).getUserToken();
    final response = await Dio().get(
      CareGiverUrl.serviceProviderAllJob,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );
    if (response.statusCode == 200) {
      return ServiceProviderJobBoardModel.fromJson(response.data);
    } else {
      throw Exception(
        customErrorSnackBar(
          context,
          'Failed to load Profile Model',
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchJobBoard = fetchServiceProviderJobBoardModel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
            "My Jobs",
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              fontFamily: "Rubik",
              color: CustomColors.primaryText,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                // Listing
                FutureBuilder<ServiceProviderJobBoardModel>(
                  future: fetchJobBoard,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.job!.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(
                          top: 16,
                        ),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return snapshot.data!.job!.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: JobBoardCartWidget(
                                    jobTitle: snapshot.data!.job![index].jobTitle.toString(),
                                    jobType: snapshot.data!.job![index].service!.name.toString(),
                                    delete: () {
                                      _showDeleteDialog();
                                    },
                                    detail: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ServiceProviderJobsDetail(
                                            id: snapshot.data!.job![index].id.toString(),
                                            service: snapshot.data!.job![index].service!.name.toString(),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(20),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromRGBO(26, 41, 96, 0.05999999865889549),
                                        offset: Offset(0, 4),
                                        blurRadius: 45,
                                      )
                                    ],
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                  ),
                                  child: const Text("0 Jobs Found"));
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
