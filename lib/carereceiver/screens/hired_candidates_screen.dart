// ignore_for_file: prefer_typing_uninitialized_variables, await_only_futures, use_build_context_synchronously

import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:island_app/carereceiver/models/hired_candidate_model.dart';
import 'package:island_app/carereceiver/models/manage_cards_model.dart';
import 'package:island_app/carereceiver/screens/manage_cards.dart';
import 'package:island_app/carereceiver/screens/payment_package_screen.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/utils/app_colors.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/functions.dart';
import 'package:island_app/utils/http_handlers.dart';
import 'package:island_app/widgets/custom_pagination.dart';
import 'package:island_app/widgets/loading_button.dart';
import 'package:provider/provider.dart';

class HiredCandidatesScreen extends StatefulWidget {
  const HiredCandidatesScreen({super.key});

  @override
  State<HiredCandidatesScreen> createState() => _HiredCandidatesScreenState();
}

class _HiredCandidatesScreenState extends State<HiredCandidatesScreen> {
  TextEditingController commentController = TextEditingController();
  String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  var providerId;
  var rating = 1;
  var jobId;
  jobCompleted() async {
    var url = '${CareReceiverURl.serviceReceiverJobCompleted}?provider_id=$providerId&rating=$rating&comment=${commentController.text}&job_id=$jobId';
    var token = await getToken();
    var response = await postRequesthandler(
      url: url,
      token: token,
    );
    if (response != null && response.statusCode == 200) {
      showSuccessToast("Added To Favourite");
      commentController.clear();
      setState(
        () {
          rating = 0;
        },
      );

      Navigator.pop(context);
    } else {
      if (kDebugMode) {
        print("jobCompleted = ${response!.data}");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Provider.of<HiredCandidatesProvider>(context, listen: false).fetchHiredCandidateModel();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HiredCandidatesProvider>(builder: (context, provider, __) {
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
              "Hired Candidates",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w600,
                fontFamily: "Rubik",
                color: CustomColors.primaryText,
              ),
            ),
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => provider.fetchHiredCandidateModel(),
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
                                      "Find Your Candidates",
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
                                            child: TextFormField(
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
                                                  borderRadius: BorderRadius.circular(4.0),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: CustomColors.white, width: 2.0),
                                                  borderRadius: BorderRadius.circular(4.0),
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
                                                                              var tt = await showDatePicker(
                                                                                context: context,
                                                                                initialEntryMode: DatePickerEntryMode.calendarOnly,
                                                                                firstDate: DateTime(2020, 1, 1),
                                                                                lastDate: DateTime.now(),
                                                                              );

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
                                                                              var tt = await showDatePicker(
                                                                                context: context,
                                                                                initialEntryMode: DatePickerEntryMode.calendarOnly,
                                                                                firstDate: DateTime(2020, 1, 1),
                                                                                lastDate: DateTime.now(),
                                                                              );
                                                                              if (tt != null) {
                                                                                setState(() {
                                                                                  endTime = DateFormat('yyyy-MM-dd').format(tt);
                                                                                });
                                                                              }
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
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: provider.filterDataList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    var item = provider.filterDataList[index];
                                    return Container(
                                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                      height: 90,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: CustomColors.borderLight,
                                            width: 0.1,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "${item.users.firstName} ${item.users.lastName}",
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: CustomColors.primaryText,
                                                    fontFamily: "Poppins",
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Text(
                                                  item.jobs.jobTitle.toString(),
                                                  style: TextStyle(
                                                    color: CustomColors.hintText,
                                                    fontFamily: "Poppins",
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              providerId = item.providerId;
                                              jobId = item.jobId;
                                              // print(item.status);
                                              // if (item.status == 3) {
                                              var scaffoldContext = context;
                                              showModalBottomSheet(
                                                isScrollControlled: true,
                                                context: scaffoldContext,
                                                backgroundColor: Colors.white,
                                                shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(30.0),
                                                    topRight: Radius.circular(30.0),
                                                  ),
                                                ),
                                                builder: (BuildContext scaffoldContext) {
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
                                                            Center(
                                                              child: Text(
                                                                "Candidate Rating",
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  color: CustomColors.black,
                                                                  fontFamily: "Rubik",
                                                                  fontStyle: FontStyle.normal,
                                                                  fontSize: 22,
                                                                  fontWeight: FontWeight.w600,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(height: 40),
                                                            Container(
                                                              alignment: Alignment.center,
                                                              child: RatingBar.builder(
                                                                initialRating: 1,
                                                                minRating: 1,
                                                                direction: Axis.horizontal,
                                                                itemSize: 24,
                                                                itemCount: 5,
                                                                itemBuilder: (context, _) => const Icon(
                                                                  Icons.star,
                                                                  color: Colors.amber,
                                                                ),
                                                                onRatingUpdate: (ratingValue) {
                                                                  setState(() {
                                                                    rating = ratingValue.ceil();
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                            const SizedBox(height: 15),
                                                            Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                SizedBox(
                                                                  width: MediaQuery.of(context).size.width,
                                                                  height: 100,
                                                                  child: TextFormField(
                                                                    controller: commentController,
                                                                    expands: true,
                                                                    maxLines: null,
                                                                    minLines: null,
                                                                    textAlignVertical: TextAlignVertical.top,
                                                                    decoration: InputDecoration(
                                                                      fillColor: Colors.white,
                                                                      hintText: "Comment",
                                                                      hintStyle: TextStyle(
                                                                        fontSize: 15,
                                                                        color: CustomColors.hintText,
                                                                        fontFamily: "Calibri",
                                                                        fontWeight: FontWeight.w400,
                                                                      ),
                                                                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                                      border: OutlineInputBorder(
                                                                        borderRadius: BorderRadius.circular(12),
                                                                        borderSide: const BorderSide(
                                                                          width: 0.5,
                                                                        ),
                                                                      ),
                                                                      enabledBorder: OutlineInputBorder(
                                                                        borderRadius: BorderRadius.circular(12),
                                                                        borderSide: const BorderSide(
                                                                          width: 0.5,
                                                                        ),
                                                                      ),
                                                                      focusedBorder: OutlineInputBorder(
                                                                        borderRadius: BorderRadius.circular(12),
                                                                        borderSide: const BorderSide(
                                                                          width: 0.5,
                                                                        ),
                                                                      ),
                                                                      errorBorder: OutlineInputBorder(
                                                                        borderRadius: BorderRadius.circular(12),
                                                                        borderSide: const BorderSide(
                                                                          color: Color.fromARGB(255, 194, 0, 0),
                                                                          width: 0.5,
                                                                        ),
                                                                      ),
                                                                      focusedErrorBorder: OutlineInputBorder(
                                                                        borderRadius: BorderRadius.circular(12),
                                                                        borderSide: const BorderSide(
                                                                          color: Color.fromARGB(255, 194, 0, 0),
                                                                          width: 0.5,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(height: 20),
                                                                LoadingButton(
                                                                  title: "Rate Now",
                                                                  height: 54,
                                                                  backgroundColor: CustomColors.primaryColor,
                                                                  textStyle: TextStyle(
                                                                    color: CustomColors.white,
                                                                    fontFamily: "Rubik",
                                                                    fontStyle: FontStyle.normal,
                                                                    fontWeight: FontWeight.w500,
                                                                    fontSize: 18,
                                                                  ),
                                                                  onPressed: () async {
                                                                    if (commentController.text.isEmpty) {
                                                                      showErrorToast("Comment field is required");
                                                                      return true;
                                                                    }
                                                                    var url = '${CareReceiverURl.serviceReceiverJobCompleted}?provider_id=$providerId&rating=$rating&comment=${commentController.text}&job_id=$jobId';
                                                                    var token = await getToken();
                                                                    var response = await postRequesthandler(
                                                                      url: url,
                                                                      token: token,
                                                                    );

                                                                    if (response != null && response.statusCode == 200) {
                                                                      showSuccessToast(response.data['message'].toString());
                                                                      commentController.clear();
                                                                      setState(
                                                                        () {
                                                                          rating = 0;
                                                                        },
                                                                      );
                                                                      provider.fetchHiredCandidateModel();
                                                                    }
                                                                    Navigator.pop(context);
                                                                    return false;
                                                                  },
                                                                ),
                                                                const SizedBox(height: 15),
                                                                TextButton(
                                                                  onPressed: () {
                                                                    if (commentController.text.isEmpty) {
                                                                      showErrorToast("Comment field is required");
                                                                      return;
                                                                    }
                                                                    Navigator.pop(context);
                                                                    showModalBottomSheet(
                                                                      context: scaffoldContext,
                                                                      builder: (context) {
                                                                        return showPaymentDailog(context: scaffoldContext);
                                                                      },
                                                                    );
                                                                  },
                                                                  style: ButtonStyle(
                                                                    backgroundColor: WidgetStatePropertyAll(CustomColors.primaryColor),
                                                                  ),
                                                                  child: Text(
                                                                    "Add Tip",
                                                                    style: TextStyle(
                                                                      color: CustomColors.white,
                                                                      fontFamily: "Rubik",
                                                                      fontStyle: FontStyle.normal,
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: 18,
                                                                    ),
                                                                  ),
                                                                ),
                                                                // LoadingButton(
                                                                //   title: "Add Tip",
                                                                //   height: 54,
                                                                //   backgroundColor: CustomColors.primaryColor,
                                                                //   textStyle: TextStyle(
                                                                //     color: CustomColors.white,
                                                                //     fontFamily: "Rubik",
                                                                //     fontStyle: FontStyle.normal,
                                                                //     fontWeight: FontWeight.w500,
                                                                //     fontSize: 18,
                                                                //   ),
                                                                //   onPressed: () async {
                                                                //     if (commentController.text.isEmpty) {
                                                                //       showErrorToast("Comment field is required");
                                                                //       return true;
                                                                //     }
                                                                //     await showBottomSheet(
                                                                //       context: context,
                                                                //       builder: (context) {
                                                                //         return showPaymentDailog(context);
                                                                //       },
                                                                //     );
                                                                //     // navigationService.push(
                                                                //     //   RoutesName.recieverTipPayment,
                                                                //     //   arguments: {
                                                                //     //     "jobId": jobId.toString(),
                                                                //     //     "comment": commentController.text.trim(),
                                                                //     //     "rating": rating,
                                                                //     //     "providerId": providerId.toString(),
                                                                //     //   },
                                                                //     // );
                                                                //     return false;
                                                                //   },
                                                                // ),
                                                                const SizedBox(height: 15),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                              // }
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                              height: 50,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(2),
                                                color: item.status == 3 ? CustomColors.primaryLight : CustomColors.primaryColor,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  item.status == 3 ? "Job Completed" : "Mark As Complete",
                                                  style: TextStyle(
                                                    color: CustomColors.white,
                                                    fontSize: 14,
                                                    fontFamily: "Poppins",
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
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

  bool newCard = false;
  final newPaymentForm = GlobalKey<FormState>();
  TextEditingController cardHolderNameController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cardExpiryDateController = TextEditingController();
  TextEditingController cardCvvController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController tipAmountController = TextEditingController();
  CreditCard? selectedCard;
  final RegExp _dateRegex = RegExp(r'^(0[1-9]|1[0-2])-\d{4}$');
  bool saveFrom = false;
  Widget showPaymentDailog({required BuildContext context}) {
    return StatefulBuilder(
      builder: (context, setState) => Container(
        height: 500,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Consumer<CardProvider>(builder: (context, provider, __) {
            return Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        newCard = true;
                        selectedCard = null;
                        tipAmountController.clear();
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(ServiceRecieverColor.redButton),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(05))),
                    ),
                    child: const Text(
                      "Add New Card",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                if (provider.allCards != null) ...[
                  for (int j = 0; j < provider.allCards!.length; j++) ...[
                    InkWell(
                      onTap: () {
                        setState(() {
                          newCard = false;
                          selectedCard = provider.allCards![j];
                          tipAmountController.clear();
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selectedCard != null && selectedCard!.id == provider.allCards![j].id ? ServiceRecieverColor.primaryColor : ServiceRecieverColor.redButton,
                            width: selectedCard != null && selectedCard!.id == provider.allCards![j].id ? 2 : 0.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Card Name: ${provider.allCards![j].nameOnCard}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(color: Colors.black),
                            ),
                            Text(
                              "Card Number: ${provider.allCards![j].cardNumber}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (selectedCard != null) ...[
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: TextFormField(
                        controller: tipAmountController,
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {},
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          hintText: "Add Tip Amount",
                          hintStyle: const TextStyle(fontWeight: FontWeight.w600),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Submit Button
                    LoadingButton(
                      title: "Pay Now",
                      backgroundColor: ServiceRecieverColor.redButton,
                      height: 50,
                      loadingColor: Colors.green,
                      textStyle: TextStyle(
                        color: CustomColors.white,
                        fontFamily: "Poppins",
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      onPressed: () async {
                        if (tipAmountController.text.isEmpty) {
                          showErrorToast("Tip amount is required");
                          return false;
                        }
                        try {
                          var token = await getToken();
                          var response = await postRequesthandler(
                            url: CareReceiverURl.serviceReceiverJobCompleted,
                            formData: FormData.fromMap({
                              "job_id": jobId.toString(),
                              "tip_amount": tipAmountController.text,
                              "comment": commentController.text.trim(),
                              "rating": rating,
                              "card_data": selectedCard!.id.toString(),
                              "save_card": false,
                              "name_on_card": selectedCard!.nameOnCard.toString(),
                              "card_number": selectedCard!.cardNumber.toString(),
                              "card_expiration_month": selectedCard!.cardExpirationMonth.toString(),
                              "card_expiration_year": selectedCard!.cardExpirationYear.toString(),
                              "cvv": selectedCard!.cvv.toString(),
                            }),
                            token: token,
                          );
                          if (response != null && response.statusCode == 200 && response.data['status'] == true) {
                            showSuccessToast(response.data['message']);
                            Provider.of<HiredCandidatesProvider>(context, listen: false).fetchHiredCandidateModel();
                            Navigator.pop(context);
                            // navigationService.push(RoutesName.serviceRecieverHireCandidates);
                          } else {
                            // if (response != null && response.data['error'].toString().contains("Job Already Funded")) {
                            //   showSuccessToast("Job Already Funded");
                            // } else
                            if (response != null && response.data != null && response.data['error'] != null) {
                              throw response.data['error']['original'][0];
                            } else {
                              throw "something went wrong";
                            }
                          }
                          return true;
                        } catch (e) {
                          showErrorToast(e.toString());
                          return false;
                        }
                      },
                    ),
                  ],
                ],
                if (newCard == true && selectedCard == null) ...[
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Add New Card",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Form(
                    key: newPaymentForm,
                    child: Column(
                      children: [
                        // Card Holder Name
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Card Holder Name",
                            style: TextStyle(
                              color: CustomColors.primaryColor,
                              fontFamily: "Rubik",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(6),
                              bottomLeft: Radius.circular(6),
                              bottomRight: Radius.circular(6),
                              topRight: Radius.circular(6),
                            ),
                            color: CustomColors.white,
                          ),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          child: TextFormField(
                            controller: cardHolderNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Enter Card Holder Name";
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: "Rubik",
                              fontWeight: FontWeight.w400,
                            ),
                            textAlignVertical: TextAlignVertical.bottom,
                            maxLines: 1,
                            decoration: InputDecoration(
                              hintText: "Name",
                              fillColor: CustomColors.white,
                              focusColor: CustomColors.white,
                              hoverColor: CustomColors.white,
                              hintStyle: TextStyle(
                                color: CustomColors.paymentHint,
                                fontFamily: "Poppins",
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: ServiceRecieverColor.primaryColor, width: 0.7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: ServiceRecieverColor.primaryColor, width: 0.7),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: ServiceRecieverColor.primaryColor, width: 0.7),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Card Number
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Card Number",
                            style: TextStyle(
                              color: ServiceRecieverColor.primaryColor,
                              fontFamily: "Rubik",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: EdgeInsets.zero,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(6),
                              bottomLeft: Radius.circular(6),
                              bottomRight: Radius.circular(6),
                              topRight: Radius.circular(6),
                            ),
                            color: CustomColors.white,
                          ),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          child: TextFormField(
                            controller: cardNumberController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter(RegExp('[0-9]'), allow: true),
                              LengthLimitingTextInputFormatter(16),
                            ],
                            validator: (value) {
                              if (value == null) {
                                return "Please Enter Card Number";
                              } else if (value.length != 16) {
                                return "Please Enter Correct Card Number";
                              }
                              return null;
                            },
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: "Rubik",
                              fontWeight: FontWeight.w400,
                            ),
                            textAlignVertical: TextAlignVertical.bottom,
                            maxLines: 1,
                            decoration: InputDecoration(
                              hintText: "XXXXXX-XXXXXX-X",
                              fillColor: CustomColors.white,
                              focusColor: CustomColors.white,
                              hoverColor: CustomColors.white,
                              hintStyle: TextStyle(
                                color: CustomColors.paymentHint,
                                fontFamily: "Poppins",
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: ServiceRecieverColor.primaryColor, width: 0.7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: ServiceRecieverColor.primaryColor, width: 0.7),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: ServiceRecieverColor.primaryColor, width: 0.7),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Card Expiry Date
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Expiry Date",
                            style: TextStyle(
                              color: CustomColors.primaryColor,
                              fontFamily: "Rubik",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: EdgeInsets.zero,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(6),
                              bottomLeft: Radius.circular(6),
                              bottomRight: Radius.circular(6),
                              topRight: Radius.circular(6),
                            ),
                            color: CustomColors.white,
                          ),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          child: TextFormField(
                            controller: cardExpiryDateController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.datetime,
                            textAlignVertical: TextAlignVertical.bottom,
                            inputFormatters: [
                              DateTextFormatter(),
                              LengthLimitingTextInputFormatter(7),
                            ],
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a date';
                              }
                              if (!_dateRegex.hasMatch(value)) {
                                return 'Invalid date format (MM-YYYY)';
                              }
                              // You can add additional validation here if needed.
                              return null;
                            },
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: "Rubik",
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: InputDecoration(
                              hintText: "MM-YYYY",
                              counterText: "",
                              fillColor: CustomColors.white,
                              focusColor: CustomColors.white,
                              hoverColor: CustomColors.white,
                              hintStyle: TextStyle(
                                color: CustomColors.paymentHint,
                                fontFamily: "Poppins",
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: ServiceRecieverColor.primaryColor, width: 0.7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: ServiceRecieverColor.primaryColor, width: 0.7),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: ServiceRecieverColor.primaryColor, width: 0.7),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Card CVV
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "CVV",
                            style: TextStyle(
                              color: CustomColors.primaryColor,
                              fontFamily: "Rubik",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(6),
                              bottomLeft: Radius.circular(6),
                              bottomRight: Radius.circular(6),
                              topRight: Radius.circular(6),
                            ),
                            color: CustomColors.white,
                          ),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          child: TextFormField(
                            controller: cardCvvController,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null) {
                                return "Please Enter Card CVV/CVC Number";
                              } else if (value.length != 3) {
                                return "Please Enter Correct Card CVV/CVC Number Length";
                              }
                              return null;
                            },
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: "Rubik",
                              fontWeight: FontWeight.w400,
                            ),
                            textAlignVertical: TextAlignVertical.bottom,
                            maxLines: 1,
                            decoration: InputDecoration(
                              hintText: "XXXX",
                              fillColor: CustomColors.white,
                              focusColor: CustomColors.white,
                              hoverColor: CustomColors.white,
                              hintStyle: TextStyle(
                                color: CustomColors.paymentHint,
                                fontFamily: "Poppins",
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: ServiceRecieverColor.primaryColor, width: 0.7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: ServiceRecieverColor.primaryColor, width: 0.7),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: ServiceRecieverColor.primaryColor, width: 0.7),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Save For futher
                        CheckboxListTile(
                          value: saveFrom,
                          activeColor: ServiceRecieverColor.primaryColor,
                          onChanged: (value) {
                            setState(() {
                              saveFrom = !saveFrom;
                            });
                          },
                          title: Text(
                            "Save For Future Use",
                            style: TextStyle(
                              color: ServiceRecieverColor.primaryColor,
                              fontFamily: "Rubik",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                        const SizedBox(height: 10),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Tip Amount",
                            style: TextStyle(
                              color: CustomColors.primaryColor,
                              fontFamily: "Rubik",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          // padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            controller: tipAmountController,
                            keyboardType: TextInputType.phone,
                            onChanged: (value) {},
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              hintText: "XXXX",
                              fillColor: CustomColors.white,
                              focusColor: CustomColors.white,
                              hoverColor: CustomColors.white,
                              hintStyle: TextStyle(
                                color: CustomColors.paymentHint,
                                fontFamily: "Poppins",
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: ServiceRecieverColor.primaryColor),
                                borderRadius: BorderRadius.circular(05),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: ServiceRecieverColor.primaryColor),
                                borderRadius: BorderRadius.circular(05),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // BTN
                        LoadingButton(
                          title: "Pay Now",
                          backgroundColor: ServiceRecieverColor.redButton,
                          height: 60,
                          loadingColor: Colors.white,
                          textStyle: TextStyle(
                            color: CustomColors.white,
                            fontFamily: "Poppins",
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          onPressed: () async {
                            if (newPaymentForm.currentState!.validate()) {
                              if (tipAmountController.text.isEmpty) {
                                showErrorToast("Tip amount is required");
                                return false;
                              }
                              try {
                                var token = await getToken();
                                var response = await postRequesthandler(
                                  url: CareReceiverURl.serviceReceiverJobCompleted,
                                  formData: FormData.fromMap({
                                    "job_id": jobId,
                                    "tip_amount": tipAmountController.text,
                                    "comment": commentController.text.trim(),
                                    "rating": rating,
                                    "card_data": "card-form",
                                    "save_card": saveFrom,
                                    "name_on_card": cardHolderNameController.text.toString(),
                                    "card_number": cardNumberController.text.toString(),
                                    "card_expiration_month": cardExpiryDateController.text.toString().substring(0, 2),
                                    "card_expiration_year": cardExpiryDateController.text.toString().substring(3, 7),
                                    "cvv": cardCvvController.text.toString(),
                                  }),
                                  token: token,
                                );

                                if (response != null && response.statusCode == 200 && response.data['status'] == true) {
                                  showSuccessToast(response.data['message']);
                                  Provider.of<HiredCandidatesProvider>(context, listen: false).fetchHiredCandidateModel();
                                  Navigator.pop(context);
                                  // navigationService.push(RoutesName.serviceRecieverHireCandidates);
                                } else {
                                  // if (response != null && response.data != null && response.data["error"] != null ) {
                                  //   showSuccessToast("Job Already Funded");
                                  // } else
                                  if (response != null && response.data != null && response.data['error'] != null) {
                                    throw response.data['error'];
                                  } else {
                                    throw "something went wrong";
                                  }
                                }
                                return true;
                              } catch (e) {
                                showErrorToast(e.toString());
                                return false;
                              }
                            }
                            return true;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ]
              ],
            );
          }),
        ),
      ),
    );
  }
}

class HiredCandidatesProvider extends ChangeNotifier {
  setDefault() {
    hiredCandidates = [];
    isLoading = true;
    filterDataList = [];
    currentPageIndex = 0;
    rowsPerPage = 10;
    startIndex = 0;
    endIndex = 0;
    totalRowsCount = 0;
  }

  List<HiredCandidateData> hiredCandidates = [];
  // Get all jobs

  bool isLoading = true;
  Future<void> fetchHiredCandidateModel() async {
    var token = await getToken();

    final response = await getRequesthandler(
      url: '${CareReceiverURl.serviceReceiverHireCandicate}?start_date=2022-01-01&end_date=${DateTime.now()}',
      token: token,
    );
    if (response != null && response.statusCode == 200) {
      var json = response.data as Map;

      if (json['data'].isNotEmpty) {
        var data = HiredCandidateModel.fromJson(response.data);
        hiredCandidates = data.data!;
        isLoading = false;
        notifyListeners();
        setPaginationList(data.data);
      }
    } else {
      throw Exception('Failed to load Hired Candidates');
    }
  }

  // Pagination List

  List filterDataList = [];
  int currentPageIndex = 0;
  int rowsPerPage = 10;
  int startIndex = 0;
  int endIndex = 0;
  int totalRowsCount = 0;

  setPaginationList(List? data) async {
    try {
      startIndex = currentPageIndex * rowsPerPage;
      endIndex = min(startIndex + rowsPerPage, data!.length);

      filterDataList = data.sublist(startIndex, endIndex).toList();
      totalRowsCount = (data.length / 10).floor();
      notifyListeners();
    } catch (error) {
      //
    }
  }

  setFilter(String searchText) {
    var filterData = hiredCandidates.where((element) {
      if (element.jobs!.jobTitle.toString().toLowerCase().contains(searchText.toLowerCase()) || element.users!.firstName.toString().toLowerCase().contains(searchText.toLowerCase()) || element.users!.lastName.toString().toLowerCase().contains(searchText.toLowerCase()) || element.jobs!.address.toString().toLowerCase().contains(searchText.toLowerCase())) {
        // print(element);
        return true;
      } else {
        return false;
      }
    }).toList();
    setPaginationList(filterData);
    notifyListeners();
  }

  clearFilter() {
    setPaginationList(hiredCandidates);
    notifyListeners();
  }

  setFilterByTime(DateTime startTime, DateTime endTime) {
    var filterData = hiredCandidates.where((element) {
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
    endIndex = min(startIndex + rowsPerPage, hiredCandidates.length);
    filterDataList = hiredCandidates.sublist(startIndex, endIndex).toList();
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
