// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:island_app/carereceiver/models/job_applicant_model.dart';
import 'package:island_app/carereceiver/screens/job_payment_screen.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/carereceiver/widgets/job_applicants_widget.dart';
import 'package:island_app/providers/user_provider.dart';
import 'package:island_app/utils/app_colors.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/http_handlers.dart';
import 'package:island_app/utils/navigation_service.dart';
import 'package:island_app/widgets/custom_pagination.dart';
import 'package:provider/provider.dart';

class JobApplicants extends StatefulWidget {
  const JobApplicants({super.key, this.jobId});
  final String? jobId;
  @override
  State<JobApplicants> createState() => JobApplicantsState();
}

class JobApplicantsState extends State<JobApplicants> {
  String? dropdownValue = 'All Relevance';
  Future<void> showDeleteDialog() async {
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

  @override
  void initState() {
    super.initState();
    if (widget.jobId != null) {
      Provider.of<JobApplicantsProvider>(context, listen: false).fetchJobApplicantModelCheckById(context, widget.jobId);
    } else {
      Provider.of<JobApplicantsProvider>(context, listen: false).fetchJobApplicantModel();
    }
  }

  final jobrefreshKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<JobApplicantsProvider>(builder: (context, provider, index) {
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
              "Job Applicants",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w600,
                fontFamily: "Rubik",
                color: CustomColors.primaryText,
              ),
            ),
          ),
          body: provider.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: ServiceRecieverColor.primaryColor,
                  ),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height - // total height
                      kToolbarHeight - // top AppBar height
                      MediaQuery.of(context).padding.top - // top padding
                      kBottomNavigationBarHeight -
                      10,
                  child: Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () => provider.fetchJobApplicantModel(),
                          child: CustomScrollView(
                            slivers: [
                              SliverToBoxAdapter(
                                child: SizedBox(
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(color: Colors.transparent),
                                        alignment: Alignment.centerRight,
                                        width: MediaQuery.of(context).size.width,
                                        height: 100,
                                        child: const RotatedBox(
                                          quarterTurns: 1,
                                          child: Text(
                                            'Container 1',
                                            style: TextStyle(fontSize: 18.0, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: -25,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          decoration: BoxDecoration(
                                            color: ServiceRecieverColor.primaryColor,
                                            borderRadius: const BorderRadius.only(
                                              bottomLeft: Radius.circular(12),
                                              bottomRight: Radius.circular(12),
                                            ),
                                          ),
                                          alignment: Alignment.centerLeft,
                                          width: MediaQuery.of(context).size.width,
                                          height: 100,
                                          child: Text(
                                            "Find Your Job Applicant",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: "Rubik",
                                              color: CustomColors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        right: 20,
                                        left: 20,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(6),
                                              bottomLeft: Radius.circular(6),
                                              bottomRight: Radius.circular(6),
                                              topRight: Radius.circular(6),
                                            ),
                                            // color: CustomColors.white,
                                          ),
                                          alignment: Alignment.center,
                                          width: MediaQuery.of(context).size.width,
                                          height: 40,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: DecoratedBox(
                                                  decoration: const BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color.fromARGB(13, 0, 0, 0),
                                                        blurRadius: 4.0,
                                                        spreadRadius: 2.0,
                                                        offset: Offset(2.0, 2.0),
                                                      ),
                                                    ],
                                                  ),
                                                  child: TextField(
                                                    onChanged: (value) {
                                                      if (value.isEmpty) {
                                                        provider.clearFilter();
                                                        return;
                                                      }
                                                      provider.setFilter(value);
                                                    },
                                                    maxLines: 1,
                                                    textAlignVertical: TextAlignVertical.bottom,
                                                    style: const TextStyle(fontSize: 16, fontFamily: "Rubik", fontWeight: FontWeight.w400),
                                                    decoration: InputDecoration(
                                                      hintText: "Search...",
                                                      fillColor: CustomColors.white,
                                                      focusColor: CustomColors.white,
                                                      hoverColor: CustomColors.white,
                                                      filled: true,
                                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(color: CustomColors.white, width: 2.0),
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(color: CustomColors.white, width: 2.0),
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              TextButton(
                                                onPressed: () {
                                                  showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    shape: const RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
                                                    ),
                                                    context: context,
                                                    backgroundColor: Colors.white,
                                                    builder: (BuildContext context) {
                                                      var startTime;
                                                      var endTime;
                                                      return StatefulBuilder(
                                                        builder: (BuildContext context, StateSetter setState) {
                                                          return SingleChildScrollView(
                                                            child: Padding(
                                                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                              child: Container(
                                                                padding: const EdgeInsets.symmetric(horizontal: 25),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    const SizedBox(height: 20),
                                                                    Center(
                                                                      child: Container(
                                                                        width: 130,
                                                                        height: 5,
                                                                        decoration: BoxDecoration(
                                                                          color: const Color(0xffC4C4C4),
                                                                          borderRadius: BorderRadius.circular(6),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    const SizedBox(height: 10),
                                                                    Column(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Center(
                                                                          child: Text(
                                                                            "Apply Filter",
                                                                            style: TextStyle(
                                                                              fontSize: 18,
                                                                              color: CustomColors.primaryText,
                                                                              fontFamily: "Poppins",
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(height: 20),
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              "Start Date",
                                                                              style: TextStyle(
                                                                                // fontSize: 16,
                                                                                fontFamily: "Rubik",
                                                                                fontWeight: FontWeight.w600,
                                                                                color: CustomColors.primaryText,
                                                                              ),
                                                                            ),
                                                                            const SizedBox(height: 5),
                                                                            DecoratedBox(
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: const BorderRadius.only(
                                                                                  topLeft: Radius.circular(6),
                                                                                  bottomLeft: Radius.circular(6),
                                                                                  bottomRight: Radius.circular(6),
                                                                                  topRight: Radius.circular(6),
                                                                                ),
                                                                                color: CustomColors.white,
                                                                                boxShadow: const [
                                                                                  BoxShadow(
                                                                                    color: Color.fromARGB(13, 0, 0, 0),
                                                                                    blurRadius: 4.0,
                                                                                    spreadRadius: 2.0,
                                                                                    offset: Offset(2.0, 2.0),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.symmetric(
                                                                                  horizontal: 7,
                                                                                  vertical: 1,
                                                                                ),
                                                                                child: InkWell(
                                                                                  onTap: () async {
                                                                                    var tt = await showDatePicker(context: context, firstDate: DateTime(2020, 1, 1), lastDate: DateTime.now());

                                                                                    if (tt != null) {
                                                                                      setState(() {
                                                                                        startTime = DateFormat('yyyy-MM-dd').format(tt);
                                                                                      });
                                                                                    }
                                                                                  },
                                                                                  child: Container(
                                                                                    height: 50,
                                                                                    width: double.infinity,
                                                                                    alignment: Alignment.centerLeft,
                                                                                    child: Text(
                                                                                      startTime != null ? startTime.toString() : "Start Date",
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        const SizedBox(height: 20),
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              "End Date",
                                                                              style: TextStyle(
                                                                                // fontSize: 16,
                                                                                fontFamily: "Rubik",
                                                                                fontWeight: FontWeight.w600,
                                                                                color: CustomColors.primaryText,
                                                                              ),
                                                                            ),
                                                                            const SizedBox(height: 5),
                                                                            DecoratedBox(
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: const BorderRadius.only(
                                                                                  topLeft: Radius.circular(6),
                                                                                  bottomLeft: Radius.circular(6),
                                                                                  bottomRight: Radius.circular(6),
                                                                                  topRight: Radius.circular(6),
                                                                                ),
                                                                                color: CustomColors.white,
                                                                                boxShadow: const [
                                                                                  BoxShadow(
                                                                                    color: Color.fromARGB(13, 0, 0, 0),
                                                                                    blurRadius: 4.0,
                                                                                    spreadRadius: 2.0,
                                                                                    offset: Offset(2.0, 2.0),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.symmetric(
                                                                                  horizontal: 7,
                                                                                  vertical: 1,
                                                                                ),
                                                                                child: InkWell(
                                                                                  onTap: () async {
                                                                                    var tt = await showDatePicker(context: context, firstDate: DateTime(2020, 1, 1), lastDate: DateTime.now());
                                                                                    if (tt != null) {
                                                                                      setState(() {
                                                                                        endTime = DateFormat('yyyy-MM-dd').format(tt);
                                                                                      });
                                                                                    }
                                                                                    // print(endTime.runtimeType);
                                                                                  },
                                                                                  child: Container(
                                                                                    height: 50,
                                                                                    width: double.infinity,
                                                                                    decoration: const BoxDecoration(color: Colors.white),
                                                                                    alignment: Alignment.centerLeft,
                                                                                    child: Text(
                                                                                      endTime != null ? endTime.toString() : "End Date",
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        const SizedBox(height: 30),
                                                                        GestureDetector(
                                                                          onTap: () {
                                                                            if (startTime != null && endTime != null) {
                                                                              provider.setFilterByTime(DateTime.parse(startTime), DateTime.parse(endTime));
                                                                              Navigator.pop(context);
                                                                            }
                                                                            provider.clearFilter();
                                                                            return;
                                                                          },
                                                                          child: Container(
                                                                            width: MediaQuery.of(context).size.width,
                                                                            height: 54,
                                                                            decoration: BoxDecoration(
                                                                              color: ServiceRecieverColor.primaryColor,
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            child: Center(
                                                                              child: Text(
                                                                                "Search",
                                                                                style: TextStyle(
                                                                                  color: CustomColors.white,
                                                                                  fontFamily: "Rubik",
                                                                                  fontStyle: FontStyle.normal,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: 18,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(height: 15),
                                                                        GestureDetector(
                                                                          onTap: () {
                                                                            provider.clearFilter();
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child: Container(
                                                                            width: MediaQuery.of(context).size.width,
                                                                            height: 54,
                                                                            decoration: BoxDecoration(
                                                                              color: ServiceRecieverColor.redButton,
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            child: Center(
                                                                              child: Text(
                                                                                "Clear",
                                                                                style: TextStyle(
                                                                                  color: CustomColors.white,
                                                                                  fontFamily: "Rubik",
                                                                                  fontStyle: FontStyle.normal,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: 18,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(height: 30),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                  );
                                                },
                                                style: ButtonStyle(
                                                  shape: WidgetStateProperty.resolveWith(
                                                    (states) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(08)),
                                                  ),
                                                  backgroundColor: WidgetStateProperty.resolveWith(
                                                    (states) => ServiceRecieverColor.redButton,
                                                  ),
                                                ),
                                                child: const Row(
                                                  children: [
                                                    Icon(
                                                      Icons.calendar_month,
                                                      color: Colors.white,
                                                      size: 20,
                                                    ),
                                                    SizedBox(width: 05),
                                                    Text(
                                                      "Filter",
                                                      style: TextStyle(color: Colors.white, fontSize: 18),
                                                    ),
                                                  ],
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
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                        itemCount: provider.filterDataList.length,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        cacheExtent: 10,
                                        itemBuilder: (context, index) {
                                          var jobData = provider.filterDataList[index];
                                          return JobApplicantsWidget(
                                            name: jobData.jobTitle.toString(),
                                            jobType: jobData.service.name.toString(),
                                            count: provider.futureJobApplicantModel!.applicationCounts![index].count.toString(),
                                            onTap: () {
                                              provider.checkApplicationDetail(context, jobData, provider.futureJobApplicantModel!.applicationCounts![index].count);
                                            },
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
          // provider.isLoading
          //      Center(
          //         child: CircularProgressIndicator(color: ServiceRecieverColor.primaryColor),
          //       )
          //     : RefreshIndicator(
          //         key: jobrefreshKey,
          //         onRefresh: () => provider.fetchJobApplicantModel(),
          //         child: SingleChildScrollView(
          //           child: Padding(
          //             padding: const EdgeInsets.symmetric(horizontal: 12),
          //             child: Column(
          //               children: [
          //                 const SizedBox(height: 20),
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
          //                         "Job Title & Type",
          //                         style: TextStyle(
          //                           color: CustomColors.black,
          //                           fontSize: 12,
          //                           fontFamily: "Poppins",
          //                           fontWeight: FontWeight.w600,
          //                         ),
          //                       ),
          //                       Text(
          //                         "Application Count",
          //                         style: TextStyle(
          //                           color: CustomColors.black,
          //                           fontSize: 12,
          //                           fontFamily: "Poppins",
          //                           fontWeight: FontWeight.w600,
          //                         ),
          //                       ),
          //                       Text(
          //                         "Details",
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
          //                 if (provider.futureJobApplicantModel != null && provider.futureJobApplicantModel!.data != null) ...[
          //                   ListView.builder(
          //                     itemCount: provider.futureJobApplicantModel!.data!.length,
          //                     shrinkWrap: true,
          //                     padding: const EdgeInsets.only(top: 16),
          //                     physics: const NeverScrollableScrollPhysics(),
          //                     cacheExtent: 10,
          //                     itemBuilder: (context, index) {
          //                       var jobData = provider.futureJobApplicantModel!.data![index];
          //                       return JobApplicantsWidget(
          //                         name: jobData.jobTitle.toString(),
          //                         jobType: (jobData.serviceId.toString() == "1")
          //                             ? "Senior Care"
          //                             : (jobData.serviceId.toString() == "2")
          //                                 ? "Pet Care"
          //                                 : (jobData.serviceId.toString() == "3")
          //                                     ? "House Keeping"
          //                                     : (jobData.serviceId.toString() == "4")
          //                                         ? "School Support"
          //                                         : "Child Care",
          //                         count: provider.futureJobApplicantModel!.applicationCounts![index].count.toString(),
          //                         onTap: () {
          //                           if (jobData.isFunded == 1) {
          //                             Navigator.push(
          //                               context,
          //                               MaterialPageRoute(
          //                                 builder: (context) => JobApplicantsDetail(
          //                                   name: jobData.jobTitle.toString(),
          //                                   jobId: jobData.id.toString(),
          //                                 ),
          //                               ),
          //                             );
          //                           } else if (provider.futureJobApplicantModel!.applicationCounts![index].count != null && provider.futureJobApplicantModel!.applicationCounts![index].count! < 1) {
          //                             showDialog(
          //                               context: context,
          //                               builder: (context) => const AlertDialog(
          //                                 content: Text(
          //                                   "No applications available for this job.",
          //                                   style: TextStyle(
          //                                     fontWeight: FontWeight.w600,
          //                                   ),
          //                                 ),
          //                               ),
          //                             );
          //                           } else {
          //                             var percentage = 7.5;
          //                             var amonut = double.parse(jobData.totalAmount.toString());
          //                             //  (() / 100 * 7.5) + (double.parse(jobData.totalAmount.toString()));
          //                             var totalamount = ((amonut / 100 * percentage) + amonut);
          //                             showDialog(
          //                               context: context,
          //                               builder: (context) => AlertDialog(
          //                                 content: Column(
          //                                   mainAxisSize: MainAxisSize.min,
          //                                   crossAxisAlignment: CrossAxisAlignment.center,
          //                                   children: [
          //                                     Text(
          //                                       "Total Applications Available : ${provider.futureJobApplicantModel!.applicationCounts![index].count.toString()}",
          //                                       style: const TextStyle(
          //                                         fontWeight: FontWeight.w600,
          //                                       ),
          //                                     ),
          //                                     const SizedBox(height: 10),
          //                                     Text(
          //                                       "Fund The Job Amount \$${jobData.totalAmount}  With Service Charges of 7.5%",
          //                                       textAlign: TextAlign.center,
          //                                       style: const TextStyle(
          //                                         fontWeight: FontWeight.w600,
          //                                       ),
          //                                     ),
          //                                     const SizedBox(height: 10),
          //                                     Text(
          //                                       "Total Amount To Be Paid \$$totalamount  To View Applicant",
          //                                       textAlign: TextAlign.center,
          //                                       style: const TextStyle(
          //                                         fontWeight: FontWeight.w600,
          //                                       ),
          //                                     ),
          //                                   ],
          //                                 ),
          //                                 actions: [
          //                                   TextButton(
          //                                     style: ButtonStyle(
          //                                       shape: MaterialStateProperty.resolveWith(
          //                                         (states) => RoundedRectangleBorder(
          //                                           borderRadius: BorderRadius.circular(08),
          //                                         ),
          //                                       ),
          //                                       backgroundColor: MaterialStateProperty.resolveWith(
          //                                         (states) => ServiceRecieverColor.primaryColor,
          //                                       ),
          //                                     ),
          //                                     onPressed: () {
          //                                       Navigator.pop(context);
          //                                       Navigator.push(
          //                                         context,
          //                                         MaterialPageRoute(
          //                                           builder: (context) => JobPaymentsScreen(
          //                                             jobId: jobData.id.toString(),
          //                                             jobName: jobData.jobTitle.toString(),
          //                                             amount: totalamount.toString(),
          //                                           ),
          //                                         ),
          //                                       );
          //                                     },
          //                                     child: const Text(
          //                                       "Payment Now",
          //                                       style: TextStyle(color: Colors.white),
          //                                     ),
          //                                   ),
          //                                   TextButton(
          //                                     style: ButtonStyle(
          //                                       shape: MaterialStateProperty.resolveWith(
          //                                         (states) => RoundedRectangleBorder(
          //                                           borderRadius: BorderRadius.circular(08),
          //                                         ),
          //                                       ),
          //                                       backgroundColor: MaterialStateProperty.resolveWith(
          //                                         (states) => ServiceRecieverColor.redButtonLigth,
          //                                       ),
          //                                     ),
          //                                     onPressed: () {
          //                                       Navigator.pop(context);
          //                                     },
          //                                     child: const Text(
          //                                       "Close",
          //                                       style: TextStyle(color: Colors.white),
          //                                     ),
          //                                   ),
          //                                 ],
          //                               ),
          //                             );
          //                           }
          //                         },
          //                       );
          //                     },
          //                   ),
          //                 ] else ...[
          //                   const Center(
          //                     child: Text("No Data Found"),
          //                   )
          //                 ],
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
        );
      }),
    );
  }
}

class JobApplicantsProvider extends ChangeNotifier {
  List allJobs = [];
  // Get all jobs
  ServiceReceiverJobApplicantModel? futureJobApplicantModel;
  bool isLoading = true;
  fetchJobApplicantModel() async {
    try {
      var token = RecieverUserProvider.userToken;
      final response = await getRequesthandler(
        url: CareReceiverURl.serviceReceiverApplication,
        token: token,
      );
      if (response.statusCode == 200) {
        var data = response.data;
        if (data['data'] != "No Job Found!") {
          futureJobApplicantModel = ServiceReceiverJobApplicantModel.fromJson(response.data);
          setDataList(futureJobApplicantModel!.data);
          isLoading = false;
          notifyListeners();
        } else {
          isLoading = false;
          futureJobApplicantModel = null;
          notifyListeners();
        }
      } else {
        throw 'Failed to load Job Applicant Model';
        //  Exception(
        //   customErrorSnackBar(
        //     context,
        //     'Failed to load Job Applicant Model',
        //   ),
        // );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  // check job is funded
  checkApplicationDetail(BuildContext context, data, count) {
    if (data.isFunded == 1) {
      navigationService.push('/service-reciever-job-applicant-detail', arguments: {
        'name': data.jobTitle.toString(),
        'id': data.id.toString(),
      });

      // provider.futureJobApplicantModel!.applicationCounts![index].count && provider.futureJobApplicantModel!.applicationCounts![index].count!
    } else if (count != null && count < 1) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          content: Text(
            "No applications available for this job.",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    } else {
      var percentage = 7.5;
      var amonut = double.parse(data.totalAmount.toString());
      var totalamount = ((amonut / 100 * percentage) + amonut);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // provider.futureJobApplicantModel!.applicationCounts![index].
              Text(
                "Total Applications Available : ${count.toString()}",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Fund The Job Amount \$${data.totalAmount}  With Service Charges of 7.5%",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Total Amount To Be Paid \$$totalamount  To View Applicant",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                shape: WidgetStateProperty.resolveWith(
                  (states) => RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(08),
                  ),
                ),
                backgroundColor: WidgetStateProperty.resolveWith(
                  (states) => ServiceRecieverColor.primaryColor,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobPaymentsScreen(
                      jobId: data.id.toString(),
                      jobName: data.jobTitle.toString(),
                      amount: totalamount.toString(),
                    ),
                  ),
                );
              },
              child: const Text(
                "Payment Now",
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                shape: WidgetStateProperty.resolveWith(
                  (states) => RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(08),
                  ),
                ),
                backgroundColor: WidgetStateProperty.resolveWith(
                  (states) => ServiceRecieverColor.redButtonLigth,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Close",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }
  }

  //  fetchJobApplicantModel and check job by id and call checkApplicationDetail function

  fetchJobApplicantModelCheckById(BuildContext context, id) async {
    isLoading = true;

    await fetchJobApplicantModel();
    isLoading = false;
    notifyListeners();
    if (futureJobApplicantModel != null && futureJobApplicantModel!.data!.isNotEmpty) {
      var getIndex = futureJobApplicantModel!.data!.indexWhere((element) => element.id.toString() == id);
      var applicationCount = futureJobApplicantModel!.applicationCounts![getIndex];
      var getSingleJob = futureJobApplicantModel!.data!.firstWhere((element) => element.id.toString() == id);
      // print(getSingleJob);
      // ignore: unnecessary_null_comparison
      if (getSingleJob != null) {
        checkApplicationDetail(context, getSingleJob, applicationCount.count);
      }
    }
  }

  // Pagination List
  List filterDataList = [];
  int currentPageIndex = 0;
  int rowsPerPage = 10;
  int startIndex = 0;
  int endIndex = 0;
  int totalRowsCount = 0;
  setDataList(List? data) {
    allJobs = data!;
    notifyListeners();
    setPaginationList(allJobs);
  }

  setPaginationList(List? data) async {
    try {
      // if (data != null && data.isNotEmpty) {

      startIndex = currentPageIndex * rowsPerPage;
      endIndex = min(startIndex + rowsPerPage, data!.length);

      filterDataList = data.sublist(startIndex, endIndex).toList();
      totalRowsCount = (data.length / 10).floor();
      notifyListeners();
      // }
    } catch (error) {
      isLoading = false;
      notifyListeners();
    }
  }

  setFilter(String searchText) {
    var filterData = allJobs.where((element) {
      if (element.jobTitle.toString().toLowerCase().contains(searchText.toLowerCase()) || element.address.toString().toLowerCase().contains(searchText.toLowerCase()) || element.location.toString().toLowerCase().contains(searchText.toLowerCase()) || element.updatedAt.toString().toLowerCase().contains(searchText.toLowerCase())) {
        return true;
      } else {
        return false;
      }
    }).toList();

    setPaginationList(filterData);

    notifyListeners();
  }

  clearFilter() {
    setPaginationList(allJobs);
    notifyListeners();
  }

  setFilterByTime(DateTime startTime, DateTime endTime) {
    var filterData = allJobs.where((element) {
      var docTime = element.updatedAt;
      if (startTime.isBefore(DateTime.parse(docTime)) && endTime.isAfter(DateTime.parse(docTime))) {
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
    endIndex = min(startIndex + rowsPerPage, allJobs.length);
    filterDataList = allJobs.sublist(startIndex, endIndex).toList();
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
