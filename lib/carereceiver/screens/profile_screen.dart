// import 'package:badges/badges.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:island_app/res/app_url.dart';
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
  // fetchPRofile
  late Future<ProfileReceiverModel> fetchProfile;
  Future<ProfileReceiverModel> fetchProfileReceiverModel() async {
    var token = await getUserToken();
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
      // print(jsonDecode(response.body));
      return ProfileReceiverModel.fromJson(response.data);
    } else {
      throw Exception(
        'Failed to load Profile Model',
      );
    }
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
                child: Badge(
                  // elevation: 0,
                  // badgeContent: const Text(""),
                  // badgeColor: CustomColors.red,
                  // position: BadgePosition.topStart(start: 18),
                  child: Icon(
                    Icons.notifications_none,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
        drawer: Drawer(
          backgroundColor: CustomColors.primaryColor,
          child: const DrawerWidget(),
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
                            decoration: BoxDecoration(color: CustomColors.primaryColor, borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12))),
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
                            // height: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  snapshot.data!.data![0].firstName.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: "Rubik",
                                    fontWeight: FontWeight.w700,
                                    color: CustomColors.white,
                                  ),
                                ),
                                Text(
                                  snapshot.data!.data![0].email.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "Rubik",
                                    fontWeight: FontWeight.w400,
                                    color: CustomColors.white,
                                  ),
                                ),
                                const SizedBox(height: 20),
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
                                              text: snapshot.data!.data![0].phone.toString() == "null" ? "Not Available" : snapshot.data!.data![0].phone.toString(),
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
                                    const SizedBox(height: 5),
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
                                            snapshot.data!.data![0].userdetail!.address.toString() == "null"
                                                ? TextSpan(
                                                    text: snapshot.data!.data![0].userdetail!.address.toString() == "null" ? "Required" : snapshot.data!.data![0].userdetail!.address.toString(),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400,
                                                      color: CustomColors.red,
                                                    ),
                                                  )
                                                : TextSpan(
                                                    text: snapshot.data!.data![0].userdetail!.address.toString() == "null" ? "Required" : snapshot.data!.data![0].userdetail!.address.toString(),
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
                            decoration: const BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50), topLeft: Radius.circular(50), topRight: Radius.circular(50))),
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
                                      builder: (context) => ProfileReceiverEdit(
                                        name: snapshot.data!.data![0].userdetail!.service!.name.toString(),
                                        dob: snapshot.data!.data![0].userdetail!.dob.toString(),
                                        male: snapshot.data!.data![0].userdetail!.gender.toString(),
                                        phoneNumber: snapshot.data!.data![0].phone.toString(),
                                        service: snapshot.data!.data![0].userdetail!.service!.name.toString(),
                                        zipCode: snapshot.data!.data![0].userdetail!.zip.toString(),
                                        userInfo: snapshot.data!.data![0].userdetail!.userInfo.toString(),
                                        userAddress: snapshot.data!.data![0].userdetail!.address.toString(),
                                      ),
                                    ),
                                  );
                                },
                                //   child: Badge(
                                //     elevation: 0,
                                //     badgeContent: Icon(
                                //       Icons.edit_outlined,
                                //       size: 12,
                                //       color: CustomColors.primaryColor,
                                //     ),
                                //     // padding: EdgeInsets.all(10),
                                //     badgeColor: CustomColors.white,
                                //     position: BadgePosition.bottomEnd(end: 6, bottom: 0),
                                //     child: CircleAvatar(
                                //       radius: 42,
                                //       backgroundColor: Color.fromARGB(255, 70, 168, 109),
                                //       child: CircleAvatar(
                                //         radius: 40,
                                //         child: ClipRRect(
                                //           borderRadius: BorderRadius.circular(40),
                                //           child: ClipRRect(
                                //             borderRadius: BorderRadius.circular(100),
                                //             child: CachedNetworkImage(
                                //               width: 100,
                                //               height: 100,
                                //               fit: BoxFit.cover,
                                //               imageUrl: snapshot.data!.folderPath.toString() + "/" + snapshot.data!.data![0].avatar.toString(),
                                //               placeholder: (context, url) => const CircularProgressIndicator(),
                                //               errorWidget: (context, url, error) => const Icon(Icons.error),
                                //             ),
                                //           ),
                                //         ),
                                //         // backgroundImage: NetworkImage(
                                //         //     snapshot.data!.folderPath.toString() + "/" + snapshot.data!.data![0].avatar .toString()),
                                //       ),
                                //     ),
                                //   ),
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
                                    const SizedBox(height: 8),
                                    Text(
                                      "${snapshot.data!.data![0].firstName} ${snapshot.data!.data![0].lastName}",
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
                                    const SizedBox(height: 8),
                                    snapshot.data!.data![0].userdetail!.gender.toString() != "null"
                                        ? Text(
                                            (snapshot.data!.data![0].userdetail!.gender.toString() == "1")
                                                ? "Male"
                                                : (snapshot.data!.data![0].userdetail!.gender.toString() == "2")
                                                    ? "Female"
                                                    : "Required",
                                            //  == "1" ? "Male" : "Female",
                                            style: TextStyle(
                                              color: CustomColors.hintText,
                                              fontSize: 16,
                                              fontFamily: "Rubik",
                                              fontWeight: FontWeight.w200,
                                            ),
                                          )
                                        : Text(
                                            (snapshot.data!.data![0].userdetail!.gender.toString() == "1")
                                                ? "Male"
                                                : (snapshot.data!.data![0].userdetail!.gender.toString() == "2")
                                                    ? "Female"
                                                    : "Required",
                                            //  == "1" ? "Male" : "Female",
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
                                    const SizedBox(height: 8),
                                    Text(
                                      snapshot.data!.data![0].userdetail!.dob.toString() == "null" ? "Not Available" : snapshot.data!.data![0].userdetail!.dob.toString(),
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
                                    const SizedBox(height: 8),
                                    Text(
                                      snapshot.data!.data![0].userdetail!.service!.name.toString() == "null" ? "Not Available" : snapshot.data!.data![0].userdetail!.service!.name.toString(),
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
                            // height: 60,
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
                                    const SizedBox(height: 8),
                                    snapshot.data!.data![0].userdetail!.zip.toString() == "null"
                                        ? Text(
                                            snapshot.data!.data![0].userdetail!.zip.toString() == "null" ? "Required" : snapshot.data!.data![0].userdetail!.zip.toString(),
                                            style: TextStyle(
                                              color: CustomColors.red,
                                              fontSize: 16,
                                              fontFamily: "Rubik",
                                              fontWeight: FontWeight.w200,
                                            ),
                                          )
                                        : Text(
                                            snapshot.data!.data![0].userdetail!.zip.toString() == "null" ? "Required" : snapshot.data!.data![0].userdetail!.zip.toString(),
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
                            // height: 60,
                            // width: MediaQuery.of(context).size.width,
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
                                      const SizedBox(height: 8),
                                      snapshot.data!.data![0].userdetail!.userInfo.toString() == "null"
                                          ? Text(
                                              snapshot.data!.data![0].userdetail!.userInfo.toString() == "null" ? "Required" : snapshot.data!.data![0].userdetail!.userInfo.toString(),
                                              // maxLines: 1,
                                              softWrap: true,
                                              style: TextStyle(
                                                color: CustomColors.red,
                                                fontSize: 16,
                                                // overflow: TextOverflow.ellipsis,
                                                fontFamily: "Rubik",
                                                fontWeight: FontWeight.w200,
                                              ),
                                            )
                                          : Text(
                                              snapshot.data!.data![0].userdetail!.userInfo.toString() == "null" ? "Required" : snapshot.data!.data![0].userdetail!.userInfo.toString(),
                                              // maxLines: 1,
                                              softWrap: true,
                                              style: TextStyle(
                                                color: CustomColors.hintText,
                                                fontSize: 16,
                                                // overflow: TextOverflow.ellipsis,
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
      // print(jsonDecode(response.body));
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
      'userTokenProfile',
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
                // child: Badge(
                //   elevation: 0,
                //   badgeContent: const Text(""),
                //   badgeColor: CustomColors.red,
                //   position: BadgePosition.topStart(start: 18),
                //   child: const Icon(
                //     Icons.notifications_none,
                //     size: 30,
                //   ),
                // ),
              ),
            )
          ],
        ),
        // drawer: Drawer(
        //   backgroundColor: CustomColors.primaryColor,
        //   child: const DrawerWidget(),
        // ),
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
                            // height: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  snapshot.data!.data![0].firstName.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: "Rubik",
                                    fontWeight: FontWeight.w700,
                                    color: CustomColors.white,
                                  ),
                                ),
                                Text(
                                  snapshot.data!.data![0].email.toString(),
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
                                              text: snapshot.data!.data![0].phone.toString() == "null" ? "Not Available" : snapshot.data!.data![0].phone.toString(),
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
                                            snapshot.data!.data![0].userdetail!.address.toString() == "null"
                                                ? TextSpan(
                                                    text: snapshot.data!.data![0].userdetail!.address.toString() == "null" ? "Required" : snapshot.data!.data![0].userdetail!.address.toString(),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400,
                                                      color: CustomColors.red,
                                                    ),
                                                  )
                                                : TextSpan(
                                                    text: snapshot.data!.data![0].userdetail!.address.toString() == "null" ? "Required" : snapshot.data!.data![0].userdetail!.address.toString(),
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
                                // child: Badge(
                                //   elevation: 0,
                                //   badgeContent: Icon(
                                //     Icons.edit_outlined,
                                //     size: 12,
                                //     color: CustomColors.primaryColor,
                                //   ),
                                //   // padding: EdgeInsets.all(10),
                                //   badgeColor: CustomColors.white,
                                //   position: BadgePosition.bottomEnd(end: 6, bottom: 0),
                                //   child: CircleAvatar(
                                //     radius: 42,
                                //     backgroundColor: Color.fromARGB(255, 70, 168, 109),
                                //     child: CircleAvatar(
                                //       radius: 40,
                                //       child: ClipRRect(
                                //         borderRadius: BorderRadius.circular(40),
                                //         child: ClipRRect(
                                //           borderRadius: BorderRadius.circular(100),
                                //           child: CachedNetworkImage(
                                //             width: 100,
                                //             height: 100,
                                //             fit: BoxFit.cover,
                                //             imageUrl: snapshot.data!.folderPath.toString() + "/" + snapshot.data!.data![0].avatar.toString(),
                                //             placeholder: (context, url) => const CircularProgressIndicator(),
                                //             errorWidget: (context, url, error) => const Icon(Icons.error),
                                //           ),
                                //         ),
                                //       ),
                                //       // backgroundImage: NetworkImage(
                                //       //     snapshot.data!.folderPath.toString() + "/" + snapshot.data!.data![0].avatar .toString()),
                                //     ),
                                //   ),
                                // ),
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
                                      "${snapshot.data!.data![0].firstName} ${snapshot.data!.data![0].lastName}",
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
                                    snapshot.data!.data![0].userdetail!.gender.toString() != "null"
                                        ? Text(
                                            (snapshot.data!.data![0].userdetail!.gender.toString() == "1")
                                                ? "Male"
                                                : (snapshot.data!.data![0].userdetail!.gender.toString() == "2")
                                                    ? "Female"
                                                    : "Required",
                                            //  == "1" ? "Male" : "Female",
                                            style: TextStyle(
                                              color: CustomColors.hintText,
                                              fontSize: 16,
                                              fontFamily: "Rubik",
                                              fontWeight: FontWeight.w200,
                                            ),
                                          )
                                        : Text(
                                            (snapshot.data!.data![0].userdetail!.gender.toString() == "1")
                                                ? "Male"
                                                : (snapshot.data!.data![0].userdetail!.gender.toString() == "2")
                                                    ? "Female"
                                                    : "Required",
                                            //  == "1" ? "Male" : "Female",
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
                                      snapshot.data!.data![0].userdetail!.dob.toString() == "null" ? "Not Available" : snapshot.data!.data![0].userdetail!.dob.toString(),
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
                                      snapshot.data!.data![0].userdetail!.service!.name.toString() == "null" ? "Not Available" : snapshot.data!.data![0].userdetail!.service!.name.toString(),
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
                            // height: 60,
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
                                    snapshot.data!.data![0].userdetail!.zip.toString() == "null"
                                        ? Text(
                                            snapshot.data!.data![0].userdetail!.zip.toString() == "null" ? "Required" : snapshot.data!.data![0].userdetail!.zip.toString(),
                                            style: TextStyle(
                                              color: CustomColors.red,
                                              fontSize: 16,
                                              fontFamily: "Rubik",
                                              fontWeight: FontWeight.w200,
                                            ),
                                          )
                                        : Text(
                                            snapshot.data!.data![0].userdetail!.zip.toString() == "null" ? "Required" : snapshot.data!.data![0].userdetail!.zip.toString(),
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
                            // height: 60,
                            // width: MediaQuery.of(context).size.width,
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
                                      snapshot.data!.data![0].userdetail!.userInfo.toString() == "null"
                                          ? Text(
                                              snapshot.data!.data![0].userdetail!.userInfo.toString() == "null" ? "Required" : snapshot.data!.data![0].userdetail!.userInfo.toString(),
                                              // maxLines: 1,
                                              softWrap: true,
                                              style: TextStyle(
                                                color: CustomColors.red,
                                                fontSize: 16,
                                                // overflow: TextOverflow.ellipsis,
                                                fontFamily: "Rubik",
                                                fontWeight: FontWeight.w200,
                                              ),
                                            )
                                          : Text(
                                              snapshot.data!.data![0].userdetail!.userInfo.toString() == "null" ? "Required" : snapshot.data!.data![0].userdetail!.userInfo.toString(),
                                              // maxLines: 1,
                                              softWrap: true,
                                              style: TextStyle(
                                                color: CustomColors.hintText,
                                                fontSize: 16,
                                                // overflow: TextOverflow.ellipsis,
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
