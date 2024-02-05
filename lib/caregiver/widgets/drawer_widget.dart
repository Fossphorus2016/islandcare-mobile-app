// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:island_app/caregiver/models/profile_model.dart';
import 'package:island_app/caregiver/screens/bank_detail.dart';
import 'package:island_app/caregiver/screens/my_jobs_screen.dart';
import 'package:island_app/caregiver/screens/provider_reviews_given_screen.dart';
import 'package:island_app/caregiver/utils/profile_provider.dart';
import 'package:island_app/carereceiver/screens/account_settings.dart';
import 'package:island_app/carereceiver/utils/bottom_navigation_provider.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/res/app_url.dart';
import 'package:island_app/screens/notification.dart';
import 'package:island_app/utils/utils.dart';
import 'package:island_app/widgets/custom_text_field.dart';
import 'package:island_app/widgets/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class DrawerGiverWidget extends StatefulWidget {
  const DrawerGiverWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<DrawerGiverWidget> createState() => _DrawerGiverWidgetState();
}

class _DrawerGiverWidgetState extends State<DrawerGiverWidget> {
  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Log Out',
                  style: TextStyle(
                    color: CustomColors.primaryText,
                    fontSize: 26,
                    fontFamily: "Rubik",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Are you sure you want to logout?',
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
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                Provider.of<NotificationProvider>(context, listen: false).unSubscribeChannels(3);
                Provider.of<BottomNavigationProvider>(context, listen: false).page = 0;
                prefs.remove('userRole');
                prefs.remove('userToken');
                prefs.remove("userStatus");
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/', // Replace with the name of the new route you want to push
                  (Route<dynamic> route) => false, // This condition removes all routes
                );
              },
            ),
          ],
        );
      },
    );
  }

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cpasswordController = TextEditingController();
  // Show/Hide
  bool _showPassword1 = true;
  void _togglevisibility1() {
    setState(() {
      _showPassword1 = !_showPassword1;
    });
  }

  bool _showPassword2 = true;
  void _togglevisibility2() {
    setState(() {
      _showPassword2 = !_showPassword2;
    });
  }

  bool _showPassword3 = true;
  void _togglevisibility3() {
    setState(() {
      _showPassword3 = !_showPassword3;
    });
  }

  @override
  void dispose() {
    super.dispose();
    oldPasswordController.dispose();
    passwordController.dispose();
    cpasswordController.dispose();
  }

  final changePassKey = GlobalKey<FormState>();

  // Post Change Password Req
  ProgressDialog? pr;
  void showProgress(context) async {
    pr ??= ProgressDialog(context);
    await pr!.show();
  }

  void hideProgress() async {
    if (pr != null && pr!.isShowing()) {
      await pr!.hide();
    }
  }

  chnagePassword() async {
    var token = await getUserToken();
    var userId = await getUserId();
    var formData = FormData.fromMap(
      {"_method": "PUT", "old_password": oldPasswordController.text.toString(), "password": passwordController.text.toString(), "password_confirmation": cpasswordController.text.toString()},
    );
    Dio dio = Dio();
    try {
      var response = await dio.post(
        '${AppUrl.webBaseURL}/api/password-update/$userId',
        data: formData,
        options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
        ),
      );
      customSuccesSnackBar(
        context,
        "Password Updated Successfully",
      );
    } catch (e) {
      customErrorSnackBar(
        context,
        e.toString(),
      );
    }
  }

  // fetchPRofile
  late Future<ProfileGiverModel> fetchProfile;
  Future<ProfileGiverModel> fetchProfileGiverModel() async {
    var token = await getUserToken();
    Dio()
        .get(
      CareGiverUrl.serviceProviderProfile,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    )
        .then((response) {
      // print(response.data);
    });
    final response = await Dio().get(
      CareGiverUrl.serviceProviderProfile,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );
    if (response.statusCode == 200) {
      return ProfileGiverModel.fromJson(response.data);
    } else {
      throw Exception(
        customErrorSnackBar(
          context,
          'Failed to load Profile Model',
        ),
      );
    }
  }

  getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getString(
      'userId',
    );
    return userId.toString();
  }

  getUserToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userToken = preferences.getString(
      'userToken',
    );
    return userToken.toString();
  }

  @override
  void initState() {
    getUserId();
    getUserToken();
    super.initState();
    fetchProfile = fetchProfileGiverModel();
  }

  @override
  Widget build(BuildContext context) {
    bool profileStatus = Provider.of<ServiceGiverProvider>(context).profileStatus;
    return profileStatus
        ? SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    FutureBuilder<ProfileGiverModel>(
                      future: fetchProfile,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return InkWell(
                            onTap: () => Provider.of<BottomNavigationProvider>(context, listen: false).updatePage(2),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              padding: const EdgeInsets.only(top: 25, bottom: 60, left: 20, right: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 40,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child: CachedNetworkImage(
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          imageUrl: "${snapshot.data!.folderPath}/${snapshot.data!.data!.avatar}",
                                          placeholder: (context, url) => const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "${snapshot.data!.data!.firstName} ${snapshot.data!.data!.lastName}",
                                        overflow: TextOverflow.visible,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Rubik",
                                          color: CustomColors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        snapshot.data!.data!.phone.toString(),
                                        overflow: TextOverflow.visible,
                                        style: TextStyle(
                                          color: CustomColors.white,
                                          fontFamily: "Rubik",
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Shimmer.fromColors(
                            baseColor: CustomColors.primaryColor,
                            highlightColor: const Color.fromARGB(255, 95, 95, 95),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 25, bottom: 60),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: CustomColors.paraColor,
                                    radius: 40,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: 130,
                                        color: CustomColors.paraColor,
                                        child: Text(
                                          "",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Rubik",
                                            color: CustomColors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        width: 80,
                                        color: CustomColors.paraColor,
                                        child: Text(
                                          " ",
                                          style: TextStyle(
                                            color: CustomColors.white,
                                            fontFamily: "Rubik",
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: ListTile(
                        hoverColor: const Color.fromRGBO(255, 255, 255, 0.1),
                        selectedColor: const Color.fromRGBO(255, 255, 255, 0.1),
                        focusColor: const Color.fromRGBO(255, 255, 255, 0.1),
                        leading: SizedBox(
                          child: Image.asset("assets/images/icons/homeIcon.png"),
                        ),
                        title: Text(
                          'Dashboard',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: CustomColors.white,
                            fontFamily: "Rubik",
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: CustomColors.white,
                          size: 16,
                        ),
                        onTap: () {
                          if (Provider.of<BottomNavigationProvider>(context, listen: false).page == 0) {
                            Navigator.pop(context);
                          } else {
                            Provider.of<BottomNavigationProvider>(context, listen: false).updatePage(0);
                          }
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ServiceProviderJobs(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: ListTile(
                          hoverColor: const Color.fromRGBO(255, 255, 255, 0.1),
                          selectedColor: const Color.fromRGBO(255, 255, 255, 0.1),
                          focusColor: const Color.fromRGBO(255, 255, 255, 0.1),
                          leading: SizedBox(
                            child: Image.asset("assets/images/icons/payments.png"),
                          ),
                          title: Text(
                            'Jobs',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: CustomColors.white,
                              fontFamily: "Rubik",
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: CustomColors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProviderReviewsScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: ListTile(
                          hoverColor: const Color.fromRGBO(255, 255, 255, 0.1),
                          selectedColor: const Color.fromRGBO(255, 255, 255, 0.1),
                          focusColor: const Color.fromRGBO(255, 255, 255, 0.1),
                          leading: SizedBox(
                            child: Icon(
                              Icons.star_border_outlined,
                              color: CustomColors.white,
                            ),
                          ),
                          title: Text(
                            'Reviews Given',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: CustomColors.white,
                              fontFamily: "Rubik",
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: CustomColors.white,
                            size: 16,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProviderReviewsScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BankDetails(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: ListTile(
                          hoverColor: const Color.fromRGBO(255, 255, 255, 0.1),
                          selectedColor: const Color.fromRGBO(255, 255, 255, 0.1),
                          focusColor: const Color.fromRGBO(255, 255, 255, 0.1),
                          leading: SizedBox(
                            child: Icon(
                              Icons.card_membership,
                              color: CustomColors.white,
                            ),
                          ),
                          title: Text(
                            'Bank Details',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: CustomColors.white,
                              fontFamily: "Rubik",
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: CustomColors.white,
                            size: 16,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BankDetails(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AccountSettings(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: ListTile(
                          hoverColor: const Color.fromRGBO(255, 255, 255, 0.1),
                          selectedColor: const Color.fromRGBO(255, 255, 255, 0.1),
                          focusColor: const Color.fromRGBO(255, 255, 255, 0.1),
                          leading: SizedBox(
                            child: Image.asset("assets/images/icons/lock.png"),
                          ),
                          title: Text(
                            'Change Password',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: CustomColors.white,
                              fontFamily: "Rubik",
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: CustomColors.white,
                            size: 16,
                          ),
                          onTap: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0),
                                ),
                              ),
                              builder: (context) {
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
                                          const SizedBox(
                                            height: 20,
                                          ),
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
                                          const SizedBox(
                                            height: 40,
                                          ),
                                          Center(
                                            child: Text(
                                              "Change Password",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: CustomColors.black,
                                                fontFamily: "Rubik",
                                                fontStyle: FontStyle.normal,
                                                fontSize: 24,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Center(
                                            child: Text(
                                              "Set the new password for your account so you can login and access all the features.",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: CustomColors.primaryText,
                                                fontFamily: "Rubik",
                                                fontStyle: FontStyle.normal,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 40,
                                          ),
                                          Form(
                                            key: changePassKey,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                CustomTextFieldWidget(
                                                  borderColor: CustomColors.loginBorder,
                                                  textStyle: TextStyle(
                                                    fontSize: 15,
                                                    color: CustomColors.hintText,
                                                    fontFamily: "Calibri",
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  hintText: "Old Password",
                                                  controller: oldPasswordController,
                                                  obsecure: !_showPassword1,
                                                  sufIcon: GestureDetector(
                                                    onTap: () {
                                                      _togglevisibility1();
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 8.0),
                                                      child: Icon(
                                                        _showPassword1 ? Icons.visibility : Icons.visibility_off,
                                                        size: 20,
                                                        color: CustomColors.hintText,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                CustomTextFieldWidget(
                                                  borderColor: CustomColors.loginBorder,
                                                  textStyle: TextStyle(
                                                    fontSize: 15,
                                                    color: CustomColors.hintText,
                                                    fontFamily: "Calibri",
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  hintText: "New Password",
                                                  controller: passwordController,
                                                  obsecure: !_showPassword2,
                                                  sufIcon: GestureDetector(
                                                    onTap: () {
                                                      _togglevisibility2();
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 8.0),
                                                      child: Icon(
                                                        _showPassword2 ? Icons.visibility : Icons.visibility_off,
                                                        size: 20,
                                                        color: CustomColors.hintText,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                CustomTextFieldWidget(
                                                  borderColor: CustomColors.loginBorder,
                                                  textStyle: TextStyle(
                                                    fontSize: 15,
                                                    color: CustomColors.hintText,
                                                    fontFamily: "Calibri",
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  hintText: "Re-enter Password",
                                                  controller: cpasswordController,
                                                  obsecure: !_showPassword3,
                                                  sufIcon: GestureDetector(
                                                    onTap: () {
                                                      _togglevisibility3();
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 8.0),
                                                      child: Icon(
                                                        _showPassword3 ? Icons.visibility : Icons.visibility_off,
                                                        size: 20,
                                                        color: CustomColors.hintText,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                // OTP
                                                GestureDetector(
                                                  onTap: () {
                                                    if (oldPasswordController.text.isEmpty) {
                                                      customErrorSnackBar(
                                                        context,
                                                        "Please Enter Old Password",
                                                      );
                                                    } else if (passwordController.text.isEmpty) {
                                                      customErrorSnackBar(
                                                        context,
                                                        "Please Enter Password",
                                                      );
                                                    } else if (passwordController.text.length < 7) {
                                                      customErrorSnackBar(
                                                        context,
                                                        "Please Enter 3 digit Password",
                                                      );
                                                    } else if (passwordController != cpasswordController) {
                                                      customErrorSnackBar(
                                                        context,
                                                        "New Password Not Match",
                                                      );
                                                    } else {
                                                      if (changePassKey.currentState!.validate()) {
                                                        chnagePassword();
                                                        Navigator.pop(context);
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                    width: MediaQuery.of(context).size.width,
                                                    height: 54,
                                                    decoration: BoxDecoration(
                                                      color: CustomColors.primaryColor,
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "Continue",
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
                                                const SizedBox(
                                                  height: 30,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  onTap: () {
                    _showLogoutDialog();
                  },
                  leading: Image.asset("assets/images/icons/logout.png"),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: CustomColors.white,
                        fontFamily: "Rubik",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: FutureBuilder<ProfileGiverModel>(
                  future: fetchProfile,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return InkWell(
                        onTap: () => Provider.of<BottomNavigationProvider>(context, listen: false).updatePage(2),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 25, bottom: 60),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                radius: 40,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: CachedNetworkImage(
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      imageUrl: "${snapshot.data!.folderPath}/${snapshot.data!.data!.avatar}",
                                      placeholder: (context, url) => const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    child: Text(
                                      "${"${snapshot.data!.data!.firstName} ${snapshot.data!.data!.lastName}"} ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Rubik",
                                        color: CustomColors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    child: Text(
                                      snapshot.data!.data!.phone.toString(),
                                      style: TextStyle(
                                        color: CustomColors.white,
                                        fontFamily: "Rubik",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Shimmer.fromColors(
                        baseColor: CustomColors.primaryColor,
                        highlightColor: const Color.fromARGB(255, 95, 95, 95),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 25, bottom: 60),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: CustomColors.paraColor,
                                radius: 40,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 130,
                                    color: CustomColors.paraColor,
                                    child: Text(
                                      "",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Rubik",
                                        color: CustomColors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    width: 80,
                                    color: CustomColors.paraColor,
                                    child: Text(
                                      " ",
                                      style: TextStyle(
                                        color: CustomColors.white,
                                        fontFamily: "Rubik",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              Expanded(child: Container()),
              ListTile(
                onTap: () {
                  _showLogoutDialog();
                },
                leading: Image.asset("assets/images/icons/logout.png"),
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: CustomColors.white,
                      fontFamily: "Rubik",
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
