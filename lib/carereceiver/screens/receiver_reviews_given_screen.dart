// // ignore_for_file: use_build_context_synchronously, await_only_futures

// import 'package:dio/dio.dart';
// // import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:island_app/carereceiver/models/receiver_reviews_given.dart';
// import 'package:island_app/carereceiver/utils/colors.dart';
// import 'package:island_app/carereceiver/widgets/reviews_given_widget.dart';
// import 'package:island_app/providers/user_provider.dart';
// import 'package:island_app/res/app_url.dart';
// import 'package:island_app/utils/utils.dart';
// import 'package:provider/provider.dart';

// class ReceiverReviewsScreen extends StatefulWidget {
//   const ReceiverReviewsScreen({super.key});

//   @override
//   State<ReceiverReviewsScreen> createState() => _ReceiverReviewsScreenState();
// }

// class _ReceiverReviewsScreenState extends State<ReceiverReviewsScreen> {
//   List? allJobs = [];
//   // Get all jobs
//   late Future<ReceiverReviewsModel> futurereviews;
//   Future<ReceiverReviewsModel> fetchReviewsModel() async {
//     var token = await Provider.of<RecieverUserProvider>(context, listen: false).getUserToken();
//     final response = await Dio().get(
//       CareReceiverURl.serviceReceiverRating,
//       options: Options(
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json',
//         },
//       ),
//     );
//     if (response.statusCode == 200) {
//       var data = response.data;
//       if (data.isNotEmpty) {
//         return ReceiverReviewsModel.fromJson(data);
//       } else {
//         return ReceiverReviewsModel.fromJson({});
//       }
//     } else {
//       throw Exception(
//         customErrorSnackBar(
//           context,
//           'Failed to load Reviews Model',
//         ),
//       );
//     }
//   }

//   // getUserToken() async {
//   //   SharedPreferences preferences = await SharedPreferences.getInstance();
//   //   var userToken = await preferences.getString(
//   //     'userToken',
//   //   );
//   //   // if (kDebugMode) {
//   //   //   print(userToken);
//   //   // }
//   //   return userToken.toString();
//   // }

//   @override
//   void initState() {
//     // getUserToken();
//     super.initState();
//     futurereviews = fetchReviewsModel();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           elevation: 0,
//           backgroundColor: Colors.transparent,
//           automaticallyImplyLeading: false,
//           leading: GestureDetector(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(13.0),
//               child: Container(
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   color: const Color(0xffffffff),
//                   borderRadius: BorderRadius.circular(10),
//                   boxShadow: const [
//                     BoxShadow(
//                       color: Color.fromARGB(30, 0, 0, 0),
//                       offset: Offset(2, 2),
//                       spreadRadius: 1,
//                       blurRadius: 7,
//                     ),
//                   ],
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 4.0),
//                   child: Icon(
//                     Icons.arrow_back_ios,
//                     color: CustomColors.primaryColor,
//                     size: 18,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           title: Text(
//             "Reviews",
//             style: TextStyle(
//               fontSize: 19,
//               fontWeight: FontWeight.w600,
//               fontFamily: "Rubik",
//               color: CustomColors.primaryText,
//             ),
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             child: Column(
//               children: [
//                 const SizedBox(
//                   height: 20,
//                 ),

//                 // Listing
//                 Container(
//                   padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//                   decoration: BoxDecoration(
//                     color: CustomColors.blackLight,
//                     border: Border(
//                       bottom: BorderSide(
//                         color: CustomColors.borderLight,
//                         width: 0.1,
//                       ),
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Name",
//                         style: TextStyle(
//                           color: CustomColors.black,
//                           fontSize: 12,
//                           fontFamily: "Poppins",
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       Text(
//                         "Ratings",
//                         style: TextStyle(
//                           color: CustomColors.black,
//                           fontSize: 12,
//                           fontFamily: "Poppins",
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       Text(
//                         "Comment",
//                         style: TextStyle(
//                           color: CustomColors.black,
//                           fontSize: 12,
//                           fontFamily: "Poppins",
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 FutureBuilder<ReceiverReviewsModel>(
//                   future: futurereviews,
//                   builder: (context, snapshot) {
//                     if (snapshot.hasData) {
//                       return ListView.builder(
//                         itemCount: snapshot.data!.ratings!.length,
//                         shrinkWrap: true,
//                         padding: const EdgeInsets.only(top: 16),
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemBuilder: (context, index) {
//                           return ReviewsGivenWidget(
//                             name: '${snapshot.data!.ratings![index].provider!.firstName} ${snapshot.data!.ratings![index].provider!.lastName}',
//                             email: snapshot.data!.ratings![index].provider!.email.toString(),
//                             rating: snapshot.data!.ratings![index].rating!.toDouble(),
//                             comment: snapshot.data!.ratings![index].comment.toString() == "null" ? "Not Available" : snapshot.data!.ratings![index].comment.toString(),
//                           );
//                         },
//                       );
//                     } else {
//                       return const Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:island_app/caregiver/models/provider_reviews_model.dart';
import 'package:island_app/caregiver/utils/profile_provider.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/utils/app_colors.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/http_handlers.dart';
import 'package:island_app/widgets/custom_pagination.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ReceiverReviewsScreen extends StatefulWidget {
  const ReceiverReviewsScreen({super.key});

  @override
  State<ReceiverReviewsScreen> createState() => _ReceiverReviewsScreenState();
}

class _ReceiverReviewsScreenState extends State<ReceiverReviewsScreen> {
  List? allJobs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<ReceiverReviewsProvider>(context, listen: false).fetchReviewsModel(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReceiverReviewsProvider>(builder: (context, provider, __) {
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
            title: Text(
              "My Reviews",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w600,
                fontFamily: "Rubik",
                color: CustomColors.primaryText,
              ),
            ),
          ),
          body: provider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () => provider.fetchReviewsModel(context),
                          child: CustomScrollView(
                            slivers: [
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                        itemCount: provider.filterDataList.length,
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.only(top: 16),
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          if (provider.allReviews!.isEmpty) {
                                            return Container(
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
                                          }
                                          var review = provider.filterDataList[index];
                                          return Container(
                                            height: 60,
                                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 08),
                                            margin: const EdgeInsets.only(bottom: 10),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: ServiceGiverColor.black),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                if (ResponsiveBreakpoints.of(context).isMobile) ...[
                                                  Expanded(
                                                    child: Text(
                                                      '${review.receiverRating!.firstName} ${review.receiverRating!.lastName}',
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ] else ...[
                                                  Text(
                                                    '${review.receiverRating!.firstName} ${review.receiverRating!.lastName}',
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                                if (ResponsiveBreakpoints.of(context).isTablet || ResponsiveBreakpoints.of(context).isDesktop) ...[
                                                  RatingBar.builder(
                                                    initialRating: review.rating!.toDouble(),
                                                    minRating: 1,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    ignoreGestures: false,
                                                    itemSize: 15,
                                                    itemCount: 5,
                                                    itemBuilder: (context, _) => const Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                    onRatingUpdate: (rating) {},
                                                  ),
                                                ],
                                                InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                        title: Center(child: Text('${review.receiverRating!.firstName} ${review.receiverRating!.lastName}')),
                                                        alignment: Alignment.center,
                                                        content: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            RatingBar.builder(
                                                              initialRating: review.rating!.toDouble(),
                                                              minRating: 1,
                                                              direction: Axis.horizontal,
                                                              allowHalfRating: true,
                                                              ignoreGestures: false,
                                                              itemSize: 24,
                                                              itemCount: 5,
                                                              itemBuilder: (context, _) => const Icon(
                                                                Icons.star,
                                                                color: Colors.amber,
                                                              ),
                                                              onRatingUpdate: (rating) {},
                                                            ),
                                                            Text(
                                                              review.comment.toString() == "null" ? "Not Available" : review.comment.toString(),
                                                              maxLines: 20,
                                                              softWrap: true,
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontFamily: "Poppins",
                                                                fontWeight: FontWeight.w400,
                                                                color: CustomColors.primaryText,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Icon(
                                                    Icons.arrow_circle_right_outlined,
                                                    color: ServiceGiverColor.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: CustomPagination(
                          nextPage: (provider.currentPageIndex) < provider.totalRowsCount
                              ? () {
                                  provider.handlePageChange(provider.currentPageIndex + 1);
                                }
                              : null,
                          previousPage: provider.currentPageIndex > 0 ? () => provider.handlePageChange(provider.currentPageIndex - 1) : null,
                          gotoPage: provider.handlePageChange,
                          gotoFirstPage: provider.currentPageIndex > 0 ? () => provider.handlePageChange(0) : null,
                          gotoLastPage: (provider.currentPageIndex) < provider.totalRowsCount ? () => provider.handlePageChange(provider.totalRowsCount) : null,
                          currentPageIndex: provider.currentPageIndex,
                          totalRowsCount: provider.totalRowsCount,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      );
    });
  }
}

class ReceiverReviewsProvider extends ChangeNotifier {
  bool isLoading = true;
  List? allReviews = [];

  ProviderReviewsModel? futurereviews;
  fetchReviewsModel(BuildContext context) async {
    var token = await Provider.of<ServiceGiverProvider>(context, listen: false).getUserToken();
    final response = await getRequesthandler(
      url: CareGiverUrl.serviceProviderProfileReviews,
      token: token,
    );
    isLoading = false;
    notifyListeners();
    // print(response.data);
    if (response.statusCode == 200 && response.data['data'] != null) {
      // setState(() {
      futurereviews = ProviderReviewsModel.fromJson(response.data);
      allReviews = futurereviews!.data;
      setPaginationList(allReviews);
      notifyListeners();
      // });
    }
  }

  List filterDataList = [];
  int currentPageIndex = 0;
  int rowsPerPage = 10;
  int startIndex = 0;
  int endIndex = 0;
  int totalRowsCount = 0;

  setPaginationList(List? data) async {
    try {
      // if (data != null && data.isNotEmpty) {
      // hiredCandidates = data;
      startIndex = currentPageIndex * rowsPerPage;
      endIndex = min(startIndex + rowsPerPage, data!.length);

      filterDataList = data.sublist(startIndex, endIndex).toList();
      totalRowsCount = (data.length / 10).floor();
      notifyListeners();
      // }
    } catch (error) {
      //
    }
  }

  setFilter(String searchText) {
    var filterData = allReviews!.where((element) {
      if (element.jobTitle.toString().toLowerCase().contains(searchText.toLowerCase()) || element.address.toString().toLowerCase().contains(searchText.toLowerCase())) {
        return true;
      } else {
        return false;
      }
    }).toList();

    setPaginationList(filterData);

    notifyListeners();
  }

  clearFilter() {
    setPaginationList(allReviews!);
    notifyListeners();
  }

  setFilterByTime(DateTime startTime, DateTime endTime) {
    var filterData = allReviews!.where((element) {
      var docTime = element.updatedAt;
      if (startTime.isBefore(DateTime.parse(docTime!)) && endTime.isAfter(DateTime.parse(docTime))) {
        return true;
      } else {
        return false;
      }
    }).toList();
    setPaginationList(filterData);
    notifyListeners();
  }

  // Generate List per page
  getCurrentPageData() {
    startIndex = currentPageIndex * rowsPerPage;
    endIndex = min(startIndex + rowsPerPage, allReviews!.length);
    filterDataList = allReviews!.sublist(startIndex, endIndex).toList();
    notifyListeners();
  }

  // handle page change function
  void handlePageChange(int pageIndex) {
    currentPageIndex = pageIndex;
    getCurrentPageData();
    notifyListeners();
  }

  // handle row change function
  void handleRowsPerPageChange(int rowsperPage) {
    rowsPerPage = rowsperPage;
    getCurrentPageData();
    notifyListeners();
  }
}
