// ignore_for_file: unused_local_variable, prefer_typing_uninitialized_variables, use_build_context_synchronously, prefer_interpolation_to_compose_strings, library_private_types_in_public_api

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:island_app/carereceiver/models/profile_model.dart';
import 'package:island_app/carereceiver/utils/bottom_navigation_provider.dart';
import 'package:island_app/carereceiver/utils/home_pagination.dart';
import 'package:island_app/providers/user_provider.dart';
import 'package:island_app/utils/app_colors.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/navigation_service.dart';
import 'package:island_app/utils/routes_name.dart';
import 'package:island_app/widgets/custom_pagination.dart';
import 'package:island_app/widgets/loading_button.dart';
import 'package:island_app/widgets/loading_with_icon_button.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shimmer/shimmer.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/carereceiver/widgets/drawer_widget.dart';
import 'package:island_app/carereceiver/widgets/recommendation_widget.dart';

String? token1;

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List providerList = [];

  @override
  void initState() {
    super.initState();
    Provider.of<HomePaginationProvider>(context, listen: false).fetchReceiverDashboardModelInInitCall();
  }

  int? age;
  calculateAge(int? age) {
    DateTime birthday = DateTime(age!);
  }

  String isAdult(String enteredAge) {
    var birthDate = DateFormat('yyyy-mm-dd').parse(enteredAge);
    var today = DateTime.now();

    final difference = today.difference(birthDate).inDays;
    final year = difference / 365;
    return year.toStringAsFixed(0);
  }

  mybirth(birthdayy) {
    final birthday = DateTime(birthdayy);
    final date2 = DateTime.now();
    final difference = date2.difference(birthday).inDays;
    return difference;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<HomePaginationProvider, RecieverUserProvider, BottomNavigationProvider>(
      builder: (context, provider, recieverUserProvider, bottomNavigationProvider, child) {
        return Scaffold(
          backgroundColor: CustomColors.loginBg,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: ServiceRecieverColor.primaryColor,
            actions: [
              GestureDetector(
                onTap: () {
                  navigationService.push(RoutesName.notification);
                },
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Badge(
                    child: Icon(
                      Icons.message,
                      size: 30,
                    ),
                  ),
                ),
              ),
              FutureBuilder<ProfileReceiverModel?>(
                future: recieverUserProvider.userProfile,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return InkWell(
                      onTap: () {
                        // int prePage = bottomNavigationProvider.page;
                        bottomNavigationProvider.updatePage(3);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffFFFFFF),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(15, 0, 0, 0),
                                blurRadius: 4,
                                spreadRadius: 4,
                                offset: Offset(2, 2), // Shadow position
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 20,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CachedNetworkImage(
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  imageUrl: "${AppUrl.localStorageUrl}/${snapshot.data!.data!.avatar}",
                                  placeholder: (context, url) => const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Shimmer.fromColors(
                      baseColor: ServiceRecieverColor.primaryColor,
                      highlightColor: const Color.fromARGB(255, 95, 95, 95),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffFFFFFF),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(15, 0, 0, 0),
                                blurRadius: 4,
                                spreadRadius: 4,
                                offset: Offset(2, 2), // Shadow position
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: CustomColors.paraColor,
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          drawer: Drawer(
            backgroundColor: ServiceRecieverColor.primaryColor,
            child: const DrawerWidget(type: "home"),
          ),
          body: SafeArea(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - // total height
                  kToolbarHeight - // top AppBar height
                  MediaQuery.of(context).padding.top - // top padding
                  kBottomNavigationBarHeight -
                  10,
              child: recieverUserProvider.profileIsApprove()
                  ? Column(
                      children: [
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              await provider.fetchReceiverDashboardModelInInitCall();
                            },
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
                                              "Find Your Caregiver",
                                              style: TextStyle(
                                                fontSize: ResponsiveBreakpoints.of(context).isTablet ? 28 : 20,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: "Rubik",
                                                color: CustomColors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 5,
                                          right: 20,
                                          left: 20,
                                          child: Container(
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
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context).size.width,
                                            height: 50,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: TextFormField(
                                                    readOnly: true,
                                                    onTap: () {
                                                      String? findSelected;
                                                      String? findArea;
                                                      String? findRate;
                                                      String? serviceId = '';
                                                      showBottomSheet(
                                                        // isScrollControlled: true,
                                                        shape: const RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.only(
                                                              topLeft: Radius.circular(30.0),
                                                              topRight: Radius.circular(30.0)),
                                                        ),
                                                        context: context,
                                                        backgroundColor: Colors.white,
                                                        builder: (BuildContext context) {
                                                          return StatefulBuilder(
                                                            builder: (BuildContext context, StateSetter setState) {
                                                              return SingleChildScrollView(
                                                                child: Padding(
                                                                  padding: EdgeInsets.only(
                                                                      bottom: MediaQuery.of(context).viewInsets.bottom,
                                                                      left: 25,
                                                                      right: 25),
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
                                                                                  borderRadius:
                                                                                      BorderRadius.circular(6)))),
                                                                      const SizedBox(height: 10),
                                                                      Column(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Center(
                                                                              child: Text("Apply Filter",
                                                                                  style: TextStyle(
                                                                                      fontSize: 18,
                                                                                      color: CustomColors.primaryText,
                                                                                      fontFamily: "Poppins",
                                                                                      fontWeight: FontWeight.w600))),
                                                                          const SizedBox(height: 40),
                                                                          Container(
                                                                            decoration: BoxDecoration(
                                                                                borderRadius: const BorderRadius.only(
                                                                                    topLeft: Radius.circular(6),
                                                                                    bottomLeft: Radius.circular(6),
                                                                                    bottomRight: Radius.circular(6),
                                                                                    topRight: Radius.circular(6)),
                                                                                color: CustomColors.white,
                                                                                boxShadow: const [
                                                                                  BoxShadow(
                                                                                      color:
                                                                                          Color.fromARGB(13, 0, 0, 0),
                                                                                      blurRadius: 4.0,
                                                                                      spreadRadius: 2.0,
                                                                                      offset: Offset(2.0, 2.0))
                                                                                ]),
                                                                            alignment: Alignment.center,
                                                                            width: MediaQuery.of(context).size.width,
                                                                            height: 50,
                                                                            child: TextFormField(
                                                                              style: const TextStyle(
                                                                                  fontSize: 16,
                                                                                  fontFamily: "Rubik",
                                                                                  fontWeight: FontWeight.w400),
                                                                              textAlignVertical:
                                                                                  TextAlignVertical.bottom,
                                                                              maxLines: 1,
                                                                              onChanged: (value) {
                                                                                setState(() {
                                                                                  serviceId = value;
                                                                                });
                                                                              },
                                                                              decoration: InputDecoration(
                                                                                prefixIcon: Icon(Icons.search,
                                                                                    size: 17,
                                                                                    color: CustomColors.hintText),
                                                                                hintText: "Search...",
                                                                                fillColor: CustomColors.white,
                                                                                focusColor: CustomColors.white,
                                                                                hoverColor: CustomColors.white,
                                                                                filled: true,
                                                                                border: OutlineInputBorder(
                                                                                    borderRadius:
                                                                                        BorderRadius.circular(4)),
                                                                                focusedBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                        color: CustomColors.white,
                                                                                        width: 2.0),
                                                                                    borderRadius:
                                                                                        BorderRadius.circular(4.0)),
                                                                                enabledBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                        color: CustomColors.white,
                                                                                        width: 2.0),
                                                                                    borderRadius:
                                                                                        BorderRadius.circular(4.0)),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(height: 20),
                                                                          Text("Filter by Service",
                                                                              style: TextStyle(
                                                                                  fontSize: 15,
                                                                                  fontFamily: "Rubik",
                                                                                  fontWeight: FontWeight.w600,
                                                                                  color: CustomColors.primaryText)),
                                                                          const SizedBox(height: 5),
                                                                          DecoratedBox(
                                                                            decoration: BoxDecoration(
                                                                                borderRadius: const BorderRadius.only(
                                                                                    topLeft: Radius.circular(6),
                                                                                    bottomLeft: Radius.circular(6),
                                                                                    bottomRight: Radius.circular(6),
                                                                                    topRight: Radius.circular(6)),
                                                                                color: CustomColors.white,
                                                                                boxShadow: const [
                                                                                  BoxShadow(
                                                                                      color:
                                                                                          Color.fromARGB(13, 0, 0, 0),
                                                                                      blurRadius: 4.0,
                                                                                      spreadRadius: 2.0,
                                                                                      offset: Offset(2.0, 2.0))
                                                                                ]),
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.symmetric(
                                                                                  horizontal: 7, vertical: 1),
                                                                              child: DropdownButtonHideUnderline(
                                                                                child: DropdownButton(
                                                                                  // hint: const Text("Select Service"),
                                                                                  isExpanded: true,
                                                                                  value: findSelected,
                                                                                  style: const TextStyle(
                                                                                      color: Colors.black),
                                                                                  items: provider.data!.map((item) {
                                                                                    // print(item['id'].runtimeType);
                                                                                    return DropdownMenuItem(
                                                                                      value: item['id'].toString(),
                                                                                      child: Text(item['name']),
                                                                                    );
                                                                                  }).toList(),
                                                                                  onChanged: (newVal) {
                                                                                    setState(() {
                                                                                      findSelected = newVal;
                                                                                    });
                                                                                    // print(findSelected.runtimeType);
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(height: 20),
                                                                          Text("Filter by Location",
                                                                              style: TextStyle(
                                                                                  fontSize: 15,
                                                                                  fontFamily: "Rubik",
                                                                                  fontWeight: FontWeight.w600,
                                                                                  color: CustomColors.primaryText)),
                                                                          const SizedBox(height: 5),
                                                                          DecoratedBox(
                                                                            decoration: BoxDecoration(
                                                                                borderRadius: const BorderRadius.only(
                                                                                    topLeft: Radius.circular(6),
                                                                                    bottomLeft: Radius.circular(6),
                                                                                    bottomRight: Radius.circular(6),
                                                                                    topRight: Radius.circular(6)),
                                                                                color: CustomColors.white,
                                                                                boxShadow: const [
                                                                                  BoxShadow(
                                                                                      color:
                                                                                          Color.fromARGB(13, 0, 0, 0),
                                                                                      blurRadius: 4.0,
                                                                                      spreadRadius: 2.0,
                                                                                      offset: Offset(2.0, 2.0))
                                                                                ]),
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.symmetric(
                                                                                  horizontal: 7, vertical: 1),
                                                                              child: DropdownButtonHideUnderline(
                                                                                child: DropdownButton(
                                                                                  hint: const Text("Select Area"),
                                                                                  isExpanded: true,
                                                                                  items: provider.area!.map((item) {
                                                                                    return DropdownMenuItem(
                                                                                      value: item['id'].toString(),
                                                                                      child: Text(item['name']),
                                                                                    );
                                                                                  }).toList(),
                                                                                  onChanged: (newVal) {
                                                                                    setState(() {
                                                                                      findArea = newVal;
                                                                                    });
                                                                                  },
                                                                                  value: findArea,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(height: 20),
                                                                          Text("Rate",
                                                                              style: TextStyle(
                                                                                  fontSize: 15,
                                                                                  fontFamily: "Rubik",
                                                                                  fontWeight: FontWeight.w600,
                                                                                  color: CustomColors.primaryText)),
                                                                          const SizedBox(height: 5),
                                                                          DecoratedBox(
                                                                            decoration: BoxDecoration(
                                                                                borderRadius: const BorderRadius.only(
                                                                                    topLeft: Radius.circular(6),
                                                                                    bottomLeft: Radius.circular(6),
                                                                                    bottomRight: Radius.circular(6),
                                                                                    topRight: Radius.circular(6)),
                                                                                color: CustomColors.white,
                                                                                boxShadow: const [
                                                                                  BoxShadow(
                                                                                      color:
                                                                                          Color.fromARGB(13, 0, 0, 0),
                                                                                      blurRadius: 4.0,
                                                                                      spreadRadius: 2.0,
                                                                                      offset: Offset(2.0, 2.0))
                                                                                ]),
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.symmetric(
                                                                                  horizontal: 7, vertical: 1),
                                                                              child: DropdownButtonHideUnderline(
                                                                                child: DropdownButton(
                                                                                  hint: const Text("Select Rate"),
                                                                                  isExpanded: true,
                                                                                  items: provider.rate!.map((item) {
                                                                                    return DropdownMenuItem(
                                                                                      value: item['id'].toString(),
                                                                                      child: Text(item['name']),
                                                                                    );
                                                                                  }).toList(),
                                                                                  onChanged: (newVal) {
                                                                                    setState(() {
                                                                                      findRate = newVal;
                                                                                    });
                                                                                  },
                                                                                  value: findRate,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(height: 20),
                                                                          LoadingButton(
                                                                            title: "Search",
                                                                            backgroundColor:
                                                                                ServiceRecieverColor.primaryColor,
                                                                            height: 54,
                                                                            textStyle: TextStyle(
                                                                                color: CustomColors.white,
                                                                                fontFamily: "Rubik",
                                                                                fontStyle: FontStyle.normal,
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 18),
                                                                            onPressed: () async {
                                                                              await provider
                                                                                  .fetchReceiverDashboardModel(
                                                                                name: serviceId,
                                                                                serviceType: findSelected,
                                                                                location: findArea,
                                                                                rate: findRate,
                                                                              );
                                                                              Navigator.pop(context);
                                                                              return false;
                                                                            },
                                                                          ),
                                                                          const SizedBox(height: 30),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                      );
                                                    },
                                                    maxLines: 1,
                                                    textAlignVertical: TextAlignVertical.bottom,
                                                    style: const TextStyle(
                                                        fontSize: 16, fontFamily: "Rubik", fontWeight: FontWeight.w400),
                                                    decoration: InputDecoration(
                                                      prefixIcon:
                                                          Icon(Icons.search, size: 17, color: CustomColors.hintText),
                                                      hintText: "Search...",
                                                      fillColor: CustomColors.white,
                                                      focusColor: CustomColors.white,
                                                      hoverColor: CustomColors.white,
                                                      filled: true,
                                                      border:
                                                          OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: CustomColors.white, width: 2.0),
                                                          borderRadius: BorderRadius.circular(4.0)),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: CustomColors.white, width: 2.0),
                                                          borderRadius: BorderRadius.circular(4.0)),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                LoadingButton(
                                                  title: "Reset",
                                                  textStyle: const TextStyle(color: Colors.red, fontSize: 18),
                                                  width: 80,
                                                  height: 50,
                                                  backgroundColor: Colors.white,
                                                  loadingColor: CustomColors.primaryColor,
                                                  onPressed: () async {
                                                    await provider.fetchReceiverDashboardModelInInitCall();
                                                    return true;
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
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    child: Column(
                                      children: [
                                        if (provider.showFoundText) ...[
                                          Text(
                                            "${provider.filterDataList.length} ${provider.searchServiceName} Service Providers Found",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                        if (provider.filterDataList.isNotEmpty) ...[
                                          ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemCount: provider.filterDataList.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              var item = provider.filterDataList[index];
                                              return RecommendationReceiverWidget(
                                                imgPath: "${AppUrl.webStorageUrl}" '/' + item.avatar.toString(),
                                                title: "${item.firstName} ${item.lastName}",
                                                // service: ,
                                                experience: item.userdetailprovider.experience == null
                                                    ? "0"
                                                    : item.userdetailprovider.experience.toString(),
                                                hourly: item.userdetailprovider.hourlyRate.toString() == "null"
                                                    ? "0"
                                                    : item.userdetailprovider.hourlyRate.toString(),
                                                price: item.userdetailprovider.hourlyRate.toString() == "null"
                                                    ? "0"
                                                    : item.userdetailprovider.hourlyRate.toString(),
                                                dob: isAdult(item.userdetail.dob != null
                                                        ? "${item.userdetail.dob}"
                                                        : "00-00-0000")
                                                    .toString(),
                                                ratingCount: double.parse(
                                                    "${item.avgRating!.isEmpty ? "0.0" : item.avgRating![0].rating}"),
                                                isFavouriteIcon: LoadingButtonWithIcon(
                                                  onPressed: () async {
                                                    await provider.favourited(item.id);
                                                    return false;
                                                  },
                                                  icon: provider.favouriteList.contains(item.id)
                                                      ? Icon(
                                                          Icons.favorite,
                                                          color: CustomColors.red,
                                                          size: ResponsiveBreakpoints.of(context).isTablet ? 36 : 24,
                                                        )
                                                      : Icon(
                                                          Icons.favorite_outline,
                                                          color: CustomColors.darkGreyRecommended,
                                                          size: ResponsiveBreakpoints.of(context).isTablet ? 36 : 24,
                                                        ),
                                                ),
                                                onTap: () {
                                                  navigationService.push(
                                                    RoutesName.recieverProviderDetail,
                                                    arguments: {
                                                      "id": item.id.toString(),
                                                      "rating": double.parse(
                                                          "${item.avgRating!.isEmpty ? "0.0" : item.avgRating![0].rating}"),
                                                    },
                                                  );
                                                },
                                              );
                                            },
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
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: CustomPagination(
                            nextPage: (provider.currentPageIndex) < provider.totalRowsCount - 1
                                ? () {
                                    provider.handlePageChange(provider.currentPageIndex + 1);
                                  }
                                : null,
                            previousPage: provider.currentPageIndex > 0
                                ? () => provider.handlePageChange(provider.currentPageIndex - 1)
                                : null,
                            gotoPage: provider.handlePageChange,
                            gotoFirstPage: provider.currentPageIndex > 0 ? () => provider.handlePageChange(0) : null,
                            gotoLastPage: (provider.currentPageIndex) < provider.totalRowsCount - 1
                                ? () => provider.handlePageChange(provider.totalRowsCount - 1)
                                : null,
                            currentPageIndex: provider.currentPageIndex,
                            totalRowsCount: provider.totalRowsCount,
                          ),
                        ),
                      ],
                    )
                  : Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Text(
                        "Your profile is not approve",
                        style: TextStyle(
                          fontSize: ResponsiveBreakpoints.of(context).isTablet ? 28 : 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
