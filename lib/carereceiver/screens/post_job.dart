// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/models/profile_model.dart';
import 'package:island_app/carereceiver/screens/post_schedule.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/models/service_model.dart';
import 'package:island_app/providers/user_provider.dart';
import 'package:island_app/res/app_url.dart';
import 'package:island_app/utils/utils.dart';
import 'package:provider/provider.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  int? selectedJob;
  // fetchJobPost
  late Future<ServicesModel>? futureJobPost;
  Future<ServicesModel> fetchJobPost() async {
    final response = await Dio().get(
      AppUrl.services,
    );
    if (response.statusCode == 200) {
      return ServicesModel.fromJson(response.data);
    } else {
      throw Exception(
        customErrorSnackBar(
          context,
          'Failed to load Job Post',
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    futureJobPost = fetchJobPost();
  }

  @override
  Widget build(BuildContext context) {
    UserSubscriptionDetail? subscriptionDetail = context.watch<RecieverUserProvider>().gWAUserProfile!.data!.userSubscriptionDetail;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
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
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Post Job",
                    style: TextStyle(
                      color: CustomColors.primaryTextLight,
                      fontSize: 22,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                FutureBuilder<ServicesModel>(
                  future: futureJobPost,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.services!.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 3,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedJob = index;
                              });

                              if (subscriptionDetail != null && subscriptionDetail.isActive != 0) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PostSchedule(
                                      serviceId: snapshot.data!.services![index].id.toString(),
                                    ),
                                  ),
                                );
                              } else {
                                customErrorSnackBar(context, "Please subscribe package first");
                              }
                            },
                            child: Center(
                              child: Container(
                                margin: const EdgeInsets.all(4),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: selectedJob == index ? CustomColors.primaryColor : CustomColors.white,
                                  borderRadius: BorderRadius.circular(9),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromARGB(30, 0, 0, 0),
                                      offset: Offset(2, 2),
                                      spreadRadius: 1,
                                      blurRadius: 7,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: CachedNetworkImage(
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.contain,
                                        imageUrl: "${snapshot.data!.folderPath}/${snapshot.data!.services![index].image}",
                                        placeholder: (context, url) => const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      snapshot.data!.services![index].name.toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Poppins",
                                        color: selectedJob == index ? CustomColors.white : CustomColors.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
