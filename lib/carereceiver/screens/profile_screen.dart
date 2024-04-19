// import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:island_app/providers/user_provider.dart';
import 'package:island_app/res/app_url.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:island_app/carereceiver/models/profile_model.dart';
import 'package:island_app/screens/notification.dart';
import 'package:island_app/carereceiver/screens/profile_edit.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/carereceiver/widgets/drawer_widget.dart';

class ProfileReceiverScreen extends StatefulWidget {
  const ProfileReceiverScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileReceiverScreen> createState() => _ProfileReceiverScreenState();
}

class _ProfileReceiverScreenState extends State<ProfileReceiverScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userProfile = Provider.of<RecieverUserProvider>(context).gWAUserProfile;
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColors.loginBg,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: CustomColors.primaryColor,
          centerTitle: true,
          title: Text(
            "Profile",
            style: TextStyle(
              fontSize: 20,
              color: CustomColors.white,
              fontWeight: FontWeight.w600,
              fontFamily: "Rubik",
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Badge(
                  child: Icon(
                    Icons.message,
                    size: 26,
                  ),
                ),
              ),
            ),
          ],
        ),
        drawer: Drawer(
          backgroundColor: CustomColors.primaryColor,
          child: const DrawerWidget(type: "profile"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              if (Provider.of<RecieverUserProvider>(context).profileIsLoading) ...[
                const CircularProgressIndicator(
                  color: Colors.amber,
                ),
              ] else ...[
                Container(
                  height: 260,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  color: CustomColors.primaryColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 110,
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(08),
                              child: CachedNetworkImage(
                                width: 130,
                                height: 110,
                                alignment: Alignment.center,
                                imageUrl: "${AppUrl.webStorageUrl}/${userProfile!.data!.avatar.toString()}",
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ProfileReceiverEdit(
                                              name: userProfile.data!.userdetail!.service!.name,
                                              dob: userProfile.data!.userdetail!.dob,
                                              male: userProfile.data!.userdetail!.gender,
                                              phoneNumber: userProfile.data!.phone,
                                              service: userProfile.data!.userdetail!.service!.name,
                                              zipCode: userProfile.data!.userdetail!.zip,
                                              userInfo: userProfile.data!.userdetail!.userInfo,
                                              userAddress: userProfile.data!.userdetail!.address,
                                              profileImage: userProfile.data!.avatar,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Icon(Icons.edit, color: Colors.white),
                                    ),
                                  ),
                                  Text(
                                    "${userProfile.data!.firstName.toString()} ${userProfile.data!.lastName.toString()}",
                                    style: TextStyle(fontSize: 20, fontFamily: "Rubik", fontWeight: FontWeight.w700, color: CustomColors.white),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    userProfile.data!.email.toString(),
                                    style: TextStyle(fontSize: 12, fontFamily: "Rubik", fontWeight: FontWeight.w400, color: CustomColors.white),
                                  ),
                                  const SizedBox(width: 10),
                                  // RatingBar(
                                  //   ignoreGestures: true,
                                  //   itemCount: 5,
                                  //   itemSize: 20,
                                  //   initialRating: userProfile.data!.avgRating!['rating'] == null ? 0.0 : double.parse(userProfile.data!.avgRating!['rating'].toString()),
                                  //   minRating: 0,
                                  //   ratingWidget: RatingWidget(
                                  //     full: const Icon(
                                  //       Icons.star_rounded,
                                  //       color: Colors.amber,
                                  //     ),
                                  //     half: const Icon(
                                  //       Icons.star_rounded,
                                  //       color: Colors.amber,
                                  //     ),
                                  //     empty: const Icon(
                                  //       Icons.star_rounded,
                                  //       color: Colors.grey,
                                  //     ),
                                  //   ),
                                  //   onRatingUpdate: (rating) {
                                  //     // print(rating);
                                  //   },
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
                              width: 130,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.phone_outlined,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  Expanded(
                                    child: Text(
                                      userProfile.data!.phone.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 05),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
                                child: Flex(
                                  direction: Axis.horizontal,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    if (userProfile.data!.userdetail!.address != null) ...[
                                      Flexible(
                                        child: Text(
                                          userProfile.data!.userdetail!.address.toString(),
                                          maxLines: 6,
                                          overflow: TextOverflow.visible,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ] else ...[
                                      const Text(
                                        "Not Available",
                                        maxLines: 6,
                                        overflow: TextOverflow.visible,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
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
                      const SizedBox(height: 5),
                      SizedBox(
                        height: 40,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Profile Completion",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Rubik",
                                          fontWeight: FontWeight.w400,
                                          color: CustomColors.white,
                                        ),
                                      ),
                                      Text(
                                        "${Provider.of<RecieverUserProvider>(context).profilePerentage}%",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Rubik",
                                          fontWeight: FontWeight.w400,
                                          color: CustomColors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 05),
                                  LinearProgressIndicator(
                                    minHeight: 08,
                                    borderRadius: BorderRadius.circular(08),
                                    value: Provider.of<RecieverUserProvider>(context).profilePerentage != null ? (Provider.of<RecieverUserProvider>(context).profilePerentage! / 100) : 00,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.pink.shade400),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(
                      //   height: 50,
                      //   child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: [
                      //       Container(
                      //         padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
                      //         decoration: const BoxDecoration(
                      //           color: Colors.white,
                      //           boxShadow: [
                      //             BoxShadow(
                      //               color: Color.fromARGB(13, 0, 0, 0),
                      //               blurRadius: 4.0,
                      //               spreadRadius: 2.0,
                      //               offset: Offset(2.0, 2.0),
                      //             ),
                      //           ],
                      //           borderRadius: BorderRadius.only(
                      //             bottomLeft: Radius.circular(6),
                      //             bottomRight: Radius.circular(6),
                      //             topLeft: Radius.circular(6),
                      //             topRight: Radius.circular(6),
                      //           ),
                      //         ),
                      //         child: RichText(
                      //           text: TextSpan(
                      //             children: [
                      //               WidgetSpan(
                      //                 child: Padding(
                      //                   padding: const EdgeInsets.only(left: 1, right: 5),
                      //                   child: Icon(
                      //                     Icons.phone_outlined,
                      //                     size: 14,
                      //                     color: CustomColors.primaryTextLight,
                      //                   ),
                      //                 ),
                      //               ),
                      //               TextSpan(
                      //                 text: userProfile.data!.phone,
                      //                 style: TextStyle(
                      //                   fontSize: 12,
                      //                   fontWeight: FontWeight.w400,
                      //                   color: CustomColors.primaryTextLight,
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //       const SizedBox(width: 15),
                      //       Expanded(
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.center,
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: [
                      //             Row(
                      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //               children: [
                      //                 Text(
                      //                   "Profile Completion",
                      //                   style: TextStyle(
                      //                     fontSize: 14,
                      //                     fontFamily: "Rubik",
                      //                     fontWeight: FontWeight.w400,
                      //                     color: CustomColors.white,
                      //                   ),
                      //                 ),
                      //                 Text(
                      //                   "53%",
                      //                   style: TextStyle(
                      //                     fontSize: 14,
                      //                     fontFamily: "Rubik",
                      //                     fontWeight: FontWeight.w400,
                      //                     color: CustomColors.white,
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //             const SizedBox(height: 05),
                      //             LinearProgressIndicator(
                      //               minHeight: 08,
                      //               borderRadius: BorderRadius.circular(08),
                      //               value: 0.53,
                      //               valueColor: AlwaysStoppedAnimation<Color>(Colors.red.shade300),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // const SizedBox(height: 5),
                      // Container(
                      //   padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
                      //   decoration: const BoxDecoration(
                      //     color: Colors.white,
                      //     boxShadow: [
                      //       BoxShadow(
                      //         color: Color.fromARGB(13, 0, 0, 0),
                      //         blurRadius: 4.0,
                      //         spreadRadius: 2.0,
                      //         offset: Offset(2.0, 2.0),
                      //       ),
                      //     ],
                      //     borderRadius: BorderRadius.only(
                      //       bottomLeft: Radius.circular(6),
                      //       bottomRight: Radius.circular(6),
                      //       topLeft: Radius.circular(6),
                      //       topRight: Radius.circular(6),
                      //     ),
                      //   ),
                      //   child: RichText(
                      //     text: TextSpan(
                      //       children: [
                      //         WidgetSpan(
                      //           child: Padding(
                      //             padding: const EdgeInsets.only(left: 3, right: 5),
                      //             child: Icon(
                      //               Icons.location_on_outlined,
                      //               size: 14,
                      //               color: CustomColors.primaryTextLight,
                      //             ),
                      //           ),
                      //         ),
                      //         userProfile.data!.userdetail!.address.toString() != "null"
                      //             ? TextSpan(
                      //                 text: userProfile.data!.userdetail!.address.toString(),
                      //                 style: TextStyle(
                      //                   fontSize: 12,
                      //                   fontWeight: FontWeight.w400,
                      //                   color: CustomColors.primaryTextLight,
                      //                 ),
                      //               )
                      //             : TextSpan(
                      //                 text: "Not Available",
                      //                 style: TextStyle(
                      //                   fontSize: 12,
                      //                   fontWeight: FontWeight.w400,
                      //                   color: CustomColors.hintText,
                      //                 ),
                      //               ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Personal Information",
                        style: TextStyle(
                          color: CustomColors.primaryText,
                          fontFamily: "Rubik",
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: CustomColors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Full Name",
                                  style: TextStyle(
                                    color: CustomColors.primaryColor,
                                    fontSize: 14,
                                    fontFamily: "Rubik",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "${userProfile.data!.firstName} ${userProfile.data!.lastName}",
                                  style: TextStyle(
                                    color: CustomColors.hintText,
                                    fontSize: 16,
                                    fontFamily: "Rubik",
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (userProfile.data!.email != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                          margin: const EdgeInsets.only(bottom: 15),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: CustomColors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Email ID",
                                style: TextStyle(
                                  color: CustomColors.primaryColor,
                                  fontSize: 14,
                                  fontFamily: "Rubik",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                userProfile.data!.email.toString(),
                                style: TextStyle(
                                  color: CustomColors.hintText,
                                  fontSize: 16,
                                  fontFamily: "Rubik",
                                  fontWeight: FontWeight.w200,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                      if (userProfile.data!.phone != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                          margin: const EdgeInsets.only(bottom: 15),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: CustomColors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Contact Number",
                                style: TextStyle(
                                  color: CustomColors.primaryColor,
                                  fontSize: 14,
                                  fontFamily: "Rubik",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                userProfile.data!.phone.toString(),
                                style: TextStyle(
                                  color: CustomColors.hintText,
                                  fontSize: 16,
                                  fontFamily: "Rubik",
                                  fontWeight: FontWeight.w200,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                      if (userProfile.data!.userdetail!.zip != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                          margin: const EdgeInsets.only(bottom: 15),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: CustomColors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Postal Code",
                                style: TextStyle(
                                  color: CustomColors.primaryColor,
                                  fontSize: 14,
                                  fontFamily: "Rubik",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                userProfile.data!.userdetail!.zip.toString() == "null" ? "Not Available" : userProfile.data!.userdetail!.zip.toString(),
                                style: TextStyle(
                                  color: CustomColors.hintText,
                                  fontSize: 16,
                                  fontFamily: "Rubik",
                                  fontWeight: FontWeight.w200,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                      if (userProfile.data!.userdetail!.gender != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                          margin: const EdgeInsets.only(bottom: 15),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: CustomColors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Gender",
                                style: TextStyle(
                                  color: CustomColors.primaryColor,
                                  fontSize: 14,
                                  fontFamily: "Rubik",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                (userProfile.data!.userdetail!.gender.toString() == "1")
                                    ? "Male"
                                    : (userProfile.data!.userdetail!.gender.toString() == "2")
                                        ? "Female"
                                        : "Not Available",
                                style: TextStyle(
                                  color: CustomColors.hintText,
                                  fontSize: 16,
                                  fontFamily: "Rubik",
                                  fontWeight: FontWeight.w200,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                      if (userProfile.data!.userdetail!.dob != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                          margin: const EdgeInsets.only(bottom: 15),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: CustomColors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Date Of Birth",
                                style: TextStyle(
                                  color: CustomColors.primaryColor,
                                  fontSize: 14,
                                  fontFamily: "Rubik",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                userProfile.data!.userdetail!.dob.toString() == "null" ? "Not Available" : userProfile.data!.userdetail!.dob.toString(),
                                style: TextStyle(
                                  color: CustomColors.hintText,
                                  fontSize: 16,
                                  fontFamily: "Rubik",
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (userProfile.data!.userdetail!.dob != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                          margin: const EdgeInsets.only(bottom: 15),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: CustomColors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Looking For",
                                style: TextStyle(
                                  color: CustomColors.primaryColor,
                                  fontSize: 14,
                                  fontFamily: "Rubik",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                userProfile.data!.userdetail!.service!.name.toString() == "null" ? "Not Available" : userProfile.data!.userdetail!.service!.name.toString(),
                                style: TextStyle(
                                  color: CustomColors.hintText,
                                  fontSize: 16,
                                  fontFamily: "Rubik",
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (userProfile.data!.userdetail!.userInfo != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: CustomColors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Bio",
                                      style: TextStyle(
                                        color: CustomColors.primaryColor,
                                        fontSize: 14,
                                        fontFamily: "Rubik",
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      userProfile.data!.userdetail!.userInfo.toString() == "null" ? "Not Available" : userProfile.data!.userdetail!.userInfo.toString(),
                                      softWrap: true,
                                      style: TextStyle(
                                        color: CustomColors.hintText,
                                        fontSize: 16,
                                        fontFamily: "Rubik",
                                        fontWeight: FontWeight.w200,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Service Receiver For Pending
class ProfileReceiverPendingScreen extends StatefulWidget {
  const ProfileReceiverPendingScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileReceiverPendingScreen> createState() => _ProfileReceiverPendingScreenState();
}

class _ProfileReceiverPendingScreenState extends State<ProfileReceiverPendingScreen> {
  // fetchPRofile
  late Future<ProfileReceiverModel> fetchProfile;
  Future<ProfileReceiverModel> fetchProfileReceiverModel() async {
    var token = await userTokenProfile();
    final response = await Dio().get(
      CareReceiverURl.serviceReceiverProfile,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );
    if (response.statusCode == 200) {
      return ProfileReceiverModel.fromJson(response.data);
    } else {
      throw Exception(
        'Failed to load Profile Model',
      );
    }
  }

  userTokenProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userToken = preferences.getString(
      'userToken',
    );
    // print(userToken);
    return userToken.toString();
  }

  @override
  void initState() {
    userTokenProfile();
    super.initState();
    fetchProfile = fetchProfileReceiverModel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColors.loginBg,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: CustomColors.primaryColor,
          centerTitle: true,
          title: Text(
            "Profile",
            style: TextStyle(
              fontSize: 20,
              color: CustomColors.white,
              fontWeight: FontWeight.w600,
              fontFamily: "Rubik",
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(),
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(12.0),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: FutureBuilder<ProfileReceiverModel>(
            future: fetchProfile,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          alignment: Alignment.centerRight,
                          width: MediaQuery.of(context).size.width,
                          height: 250,
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
                              color: CustomColors.primaryColor,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                            alignment: Alignment.centerLeft,
                            width: MediaQuery.of(context).size.width,
                            height: 150,
                          ),
                        ),
                        Positioned(
                          top: 35,
                          bottom: 5,
                          right: 8,
                          left: 8,
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.all(7),
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                  "assets/images/profileBackground.png",
                                ),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  snapshot.data!.data!.firstName.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: "Rubik",
                                    fontWeight: FontWeight.w700,
                                    color: CustomColors.white,
                                  ),
                                ),
                                Text(
                                  snapshot.data!.data!.email.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "Rubik",
                                    fontWeight: FontWeight.w400,
                                    color: CustomColors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromARGB(13, 0, 0, 0),
                                            blurRadius: 4.0,
                                            spreadRadius: 2.0,
                                            offset: Offset(2.0, 2.0),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(6),
                                          bottomRight: Radius.circular(6),
                                          topLeft: Radius.circular(6),
                                          topRight: Radius.circular(6),
                                        ),
                                      ),
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            WidgetSpan(
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 1, right: 5),
                                                child: Icon(
                                                  Icons.phone_outlined,
                                                  size: 14,
                                                  color: CustomColors.primaryTextLight,
                                                ),
                                              ),
                                            ),
                                            TextSpan(
                                              text: snapshot.data!.data!.phone.toString() == "null" ? "Not Available" : snapshot.data!.data!.phone.toString(),
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: CustomColors.primaryTextLight,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromARGB(13, 0, 0, 0),
                                            blurRadius: 4.0,
                                            spreadRadius: 2.0,
                                            offset: Offset(2.0, 2.0),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(6),
                                          bottomRight: Radius.circular(6),
                                          topLeft: Radius.circular(6),
                                          topRight: Radius.circular(6),
                                        ),
                                      ),
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            WidgetSpan(
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 1, right: 5),
                                                child: Icon(
                                                  Icons.location_on_outlined,
                                                  size: 14,
                                                  color: CustomColors.primaryTextLight,
                                                ),
                                              ),
                                            ),
                                            snapshot.data!.data!.userdetail!.address.toString() == "null"
                                                ? TextSpan(
                                                    text: snapshot.data!.data!.userdetail!.address.toString() == "null" ? "Not Available" : snapshot.data!.data!.userdetail!.address.toString(),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400,
                                                      color: CustomColors.red,
                                                    ),
                                                  )
                                                : TextSpan(
                                                    text: snapshot.data!.data!.userdetail!.address.toString() == "null" ? "Not Available" : snapshot.data!.data!.userdetail!.address.toString(),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400,
                                                      color: CustomColors.primaryTextLight,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          left: 100,
                          right: 100,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(50),
                                bottomRight: Radius.circular(50),
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50),
                              ),
                            ),
                            alignment: Alignment.center,
                            width: 84,
                            height: 84,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(13, 0, 0, 0),
                                    blurRadius: 4.0,
                                    spreadRadius: 2.0,
                                    offset: Offset(2.0, 2.0),
                                  ),
                                ],
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(50),
                                  bottomRight: Radius.circular(50),
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50),
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileReceiverEdit(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Personal Information",
                            style: TextStyle(
                              color: CustomColors.primaryText,
                              fontFamily: "Rubik",
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              color: CustomColors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Name",
                                      style: TextStyle(
                                        color: CustomColors.primaryColor,
                                        fontSize: 10,
                                        fontFamily: "Rubik",
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "${snapshot.data!.data!.firstName} ${snapshot.data!.data!.lastName}",
                                      style: TextStyle(
                                        color: CustomColors.hintText,
                                        fontSize: 16,
                                        fontFamily: "Rubik",
                                        fontWeight: FontWeight.w200,
                                      ),
                                    ),
                                  ],
                                ),
                                const Column(),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              color: CustomColors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Gender",
                                      style: TextStyle(
                                        color: CustomColors.primaryColor,
                                        fontSize: 10,
                                        fontFamily: "Rubik",
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    snapshot.data!.data!.userdetail!.gender.toString() != "null"
                                        ? Text(
                                            (snapshot.data!.data!.userdetail!.gender.toString() == "1")
                                                ? "Male"
                                                : (snapshot.data!.data!.userdetail!.gender.toString() == "2")
                                                    ? "Female"
                                                    : "Not Available",
                                            style: TextStyle(
                                              color: CustomColors.hintText,
                                              fontSize: 16,
                                              fontFamily: "Rubik",
                                              fontWeight: FontWeight.w200,
                                            ),
                                          )
                                        : Text(
                                            (snapshot.data!.data!.userdetail!.gender.toString() == "1")
                                                ? "Male"
                                                : (snapshot.data!.data!.userdetail!.gender.toString() == "2")
                                                    ? "Female"
                                                    : "Not Available",
                                            style: TextStyle(
                                              color: CustomColors.red,
                                              fontSize: 16,
                                              fontFamily: "Rubik",
                                              fontWeight: FontWeight.w200,
                                            ),
                                          ),
                                  ],
                                ),
                                const Column(),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              color: CustomColors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Date Of Birth",
                                      style: TextStyle(
                                        color: CustomColors.primaryColor,
                                        fontSize: 10,
                                        fontFamily: "Rubik",
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      snapshot.data!.data!.userdetail!.dob.toString() == "null" ? "Not Available" : snapshot.data!.data!.userdetail!.dob.toString(),
                                      style: TextStyle(
                                        color: CustomColors.hintText,
                                        fontSize: 16,
                                        fontFamily: "Rubik",
                                        fontWeight: FontWeight.w200,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              color: CustomColors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Service",
                                      style: TextStyle(
                                        color: CustomColors.primaryColor,
                                        fontSize: 10,
                                        fontFamily: "Rubik",
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      snapshot.data!.data!.userdetail!.service!.name.toString() == "null" ? "Not Available" : snapshot.data!.data!.userdetail!.service!.name.toString(),
                                      style: TextStyle(
                                        color: CustomColors.hintText,
                                        fontSize: 16,
                                        fontFamily: "Rubik",
                                        fontWeight: FontWeight.w200,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              color: CustomColors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Zip Code",
                                      style: TextStyle(
                                        color: CustomColors.primaryColor,
                                        fontSize: 10,
                                        fontFamily: "Rubik",
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    snapshot.data!.data!.userdetail!.zip.toString() == "null"
                                        ? Text(
                                            snapshot.data!.data!.userdetail!.zip.toString() == "null" ? "Not Available" : snapshot.data!.data!.userdetail!.zip.toString(),
                                            style: TextStyle(
                                              color: CustomColors.red,
                                              fontSize: 16,
                                              fontFamily: "Rubik",
                                              fontWeight: FontWeight.w200,
                                            ),
                                          )
                                        : Text(
                                            snapshot.data!.data!.userdetail!.zip.toString() == "null" ? "Not Available" : snapshot.data!.data!.userdetail!.zip.toString(),
                                            style: TextStyle(
                                              color: CustomColors.hintText,
                                              fontSize: 16,
                                              fontFamily: "Rubik",
                                              fontWeight: FontWeight.w200,
                                            ),
                                          ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              color: CustomColors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "User Info",
                                        style: TextStyle(
                                          color: CustomColors.primaryColor,
                                          fontSize: 10,
                                          fontFamily: "Rubik",
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      snapshot.data!.data!.userdetail!.userInfo.toString() == "null"
                                          ? Text(
                                              snapshot.data!.data!.userdetail!.userInfo.toString() == "null" ? "Not Available" : snapshot.data!.data!.userdetail!.userInfo.toString(),
                                              softWrap: true,
                                              style: TextStyle(
                                                color: CustomColors.red,
                                                fontSize: 16,
                                                fontFamily: "Rubik",
                                                fontWeight: FontWeight.w200,
                                              ),
                                            )
                                          : Text(
                                              snapshot.data!.data!.userdetail!.userInfo.toString() == "null" ? "Not Available" : snapshot.data!.data!.userdetail!.userInfo.toString(),
                                              softWrap: true,
                                              style: TextStyle(
                                                color: CustomColors.hintText,
                                                fontSize: 16,
                                                fontFamily: "Rubik",
                                                fontWeight: FontWeight.w200,
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
