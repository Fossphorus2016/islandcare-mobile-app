// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:island_app/caregiver/screens/my_jobs_screen.dart';
import 'package:island_app/caregiver/screens/provider_messages_screen.dart';
import 'package:island_app/caregiver/screens/provider_reviews_given_screen.dart';
import 'package:island_app/caregiver/utils/profile_provider.dart';
import 'package:island_app/carereceiver/utils/bottom_navigation_provider.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/utils/app_colors.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/screens/notification.dart';
import 'package:island_app/utils/functions.dart';
import 'package:island_app/utils/http_handlers.dart';
import 'package:island_app/utils/navigation_service.dart';
import 'package:island_app/utils/routes_name.dart';
import 'package:island_app/utils/storage_service.dart';
import 'package:island_app/widgets/custom_text_field.dart';
import 'package:island_app/widgets/loading_button.dart';
import 'package:provider/provider.dart';

class DrawerGiverWidget extends StatefulWidget {
  const DrawerGiverWidget({
    super.key,
  });

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
            LoadingButton(
              title: 'Ok',
              width: 50,
              height: 50,
              loadingColor: CustomColors.primaryColor,
              textStyle: TextStyle(
                color: CustomColors.primaryColor,
                fontSize: 16,
                fontFamily: "Rubik",
                fontWeight: FontWeight.w600,
              ),
              onPressed: () async {
                Provider.of<NotificationProvider>(context, listen: false).unSubscribeChannels(3);
                Provider.of<BottomNavigationProvider>(context, listen: false).page = 0;
                await storageService.deleteSecureStorage('userRole');
                await storageService.deleteSecureStorage('userToken');
                await storageService.deleteSecureStorage("userStatus");
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/', // Replace with the name of the new route you want to push
                  (Route<dynamic> route) => false, // This condition removes all routes
                );
                Provider.of<ServiceGiverProvider>(context, listen: false).setDefault();
                Provider.of<GiverMyJobsProvider>(context, listen: false).setDefault();
                Provider.of<GiverReviewsProvider>(context, listen: false).setDefault();
                Provider.of<NotificationProvider>(context, listen: false).setDefault();
                Provider.of<ServiceProviderChat>(context, listen: false).setDefault();
                return true;
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
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<ServiceGiverProvider, BottomNavigationProvider, NotificationProvider>(
      builder: (context, giverProvider, bottomNavigationProvider, notificationProvider, __) {
        return giverProvider.profileStatus
            ? Drawer(
                backgroundColor: ServiceGiverColor.black,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              // int prePage = bottomNavigationProvider.page;
                              bottomNavigationProvider.updatePage(2);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 140,
                              padding: const EdgeInsets.only(top: 25, left: 20, right: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                          imageUrl: "${giverProvider.fetchProfile!.folderPath}/${giverProvider.fetchProfile!.data!.avatar}",
                                          placeholder: (context, url) => const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "${giverProvider.fetchProfile!.data!.firstName} ${giverProvider.fetchProfile!.data!.lastName}",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Rubik",
                                            color: CustomColors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          giverProvider.fetchProfile!.data!.phone.toString(),
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
                                  ),
                                ],
                              ),
                            ),
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
                                if (bottomNavigationProvider.page == 0) {
                                  Navigator.pop(context);
                                } else {
                                  // int prePage = bottomNavigationProvider.page;
                                  bottomNavigationProvider.updatePage(0);
                                }
                              },
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              navigationService.push(RoutesName.myJobsGiver);
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
                              navigationService.push(RoutesName.providerReviews);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
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
                                  navigationService.push(RoutesName.providerReviews);
                                },
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              navigationService.push(RoutesName.giverBankDetails);
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
                                  navigationService.push(RoutesName.giverBankDetails);
                                },
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
                            child: ListTile(
                              hoverColor: const Color.fromRGBO(255, 255, 255, 0.1),
                              selectedColor: const Color.fromRGBO(255, 255, 255, 0.1),
                              focusColor: const Color.fromRGBO(255, 255, 255, 0.1),
                              leading: SizedBox(child: Image.asset("assets/images/icons/lock.png")),
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
                                    return const ChangePasswordWidget();
                                  },
                                );
                              },
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
                ),
              )
            : Drawer(
                backgroundColor: ServiceGiverColor.black,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: InkWell(
                        onTap: () {
                          // int prePage = bottomNavigationProvider.page;
                          bottomNavigationProvider.updatePage(2);
                        },
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
                                      imageUrl: "${giverProvider.fetchProfile!.folderPath}/${giverProvider.fetchProfile!.data!.avatar}",
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
                                      "${"${giverProvider.fetchProfile!.data!.firstName} ${giverProvider.fetchProfile!.data!.lastName}"} ",
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
                                      giverProvider.fetchProfile!.data!.phone.toString(),
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
                ),
              );
      },
    );
  }
}

class ChangePasswordWidget extends StatefulWidget {
  const ChangePasswordWidget({super.key});

  @override
  State<ChangePasswordWidget> createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cpasswordController = TextEditingController();
  // Show/Hide
  bool _showPassword1 = false;
  void _togglevisibility1() {
    setState(() {
      _showPassword1 = !_showPassword1;
    });
  }

  bool _showPassword2 = false;
  void _togglevisibility2() {
    setState(() {
      _showPassword2 = !_showPassword2;
    });
  }

  bool _showPassword3 = false;
  void _togglevisibility3() {
    setState(() {
      _showPassword3 = !_showPassword3;
    });
  }

  Future<void> chnagePassword() async {
    var token = await getToken();
    var userId = await Provider.of<ServiceGiverProvider>(context, listen: false).getUserId();

    var formData = FormData.fromMap(
      {"_method": "PUT", "old_password": oldPasswordController.text.toString(), "password": passwordController.text.toString(), "password_confirmation": cpasswordController.text.toString()},
    );

    try {
      var response = await postRequesthandler(
        url: '${SessionUrl.updatePassword}/$userId',
        formData: formData,
        token: token,
      );

      Navigator.pop(context);
      if (response != null && response.data['success']) {
        showSuccessToast("Password Updated Successfully");
      } else {
        if (response != null && response.data != null && response.data["message"] != null) {
          showErrorToast(response.data['message'].toString());
        } else {
          showErrorToast("something went wrong");
        }
      }
    } catch (e) {
      Navigator.pop(context);
      showErrorToast(e.toString());
    }
  }

  final changePassKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    oldPasswordController.dispose();
    passwordController.dispose();
    cpasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(height: 40),
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
              const SizedBox(height: 10),
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
              const SizedBox(height: 40),
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
                      validation: (p0) {
                        if (p0 == null || p0.isEmpty) {
                          return "Please Enter Old Password";
                        } else if (p0.length < 8) {
                          return "The password field must be at least 8 characters";
                        } else if (!p0.contains(RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)"))) {
                          return 'please enter Capital letter, Special Character and Number';
                        }
                        return null;
                      },
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
                    const SizedBox(height: 10),
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
                      validation: (p0) {
                        if (p0 == null || p0.isEmpty) {
                          return "Please Enter New Password";
                        } else if (p0.length < 8) {
                          return "The password field must be at least 8 characters";
                        } else if (!p0.contains(RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)"))) {
                          return 'please enter Capital letter, Special Character and Number';
                        }
                        return null;
                      },
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
                    const SizedBox(height: 10),
                    CustomTextFieldWidget(
                      borderColor: CustomColors.loginBorder,
                      hintText: "Re-enter Password",
                      controller: cpasswordController,
                      obsecure: !_showPassword3,
                      textStyle: TextStyle(
                        fontSize: 15,
                        color: CustomColors.hintText,
                        fontFamily: "Calibri",
                        fontWeight: FontWeight.w400,
                      ),
                      validation: (p0) {
                        if (p0 == null || p0.isEmpty) {
                          return "Please Re-enter New Password";
                        } else if (p0 != passwordController.text) {
                          return "Password did not Match";
                        }
                        return null;
                      },
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
                    const SizedBox(height: 20),
                    // OTP
                    LoadingButton(
                      title: "Continue",
                      height: 54,
                      backgroundColor: ServiceGiverColor.black,
                      textStyle: TextStyle(
                        color: CustomColors.white,
                        fontFamily: "Rubik",
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                      onPressed: () async {
                        if (changePassKey.currentState!.validate()) {
                          await chnagePassword();
                        }
                        return false;
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
