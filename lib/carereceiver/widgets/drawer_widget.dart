// ignore_for_file: use_build_context_synchronously, unused_local_variable, prefer_typing_uninitialized_variables, deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:island_app/carereceiver/models/profile_model.dart';
import 'package:island_app/carereceiver/screens/hired_candidates_screen.dart';
import 'package:island_app/carereceiver/screens/job_applicant.dart';
import 'package:island_app/carereceiver/screens/manage_cards.dart';
import 'package:island_app/carereceiver/screens/messages_screen.dart';
import 'package:island_app/carereceiver/screens/post_job.dart';
import 'package:island_app/carereceiver/screens/receiver_reviews_given_screen.dart';
import 'package:island_app/carereceiver/utils/bottom_navigation_provider.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/carereceiver/utils/home_pagination.dart';
import 'package:island_app/providers/subscription_provider.dart';
import 'package:island_app/providers/user_provider.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/screens/notification.dart';
import 'package:island_app/utils/functions.dart';
import 'package:island_app/utils/http_handlers.dart';
import 'package:island_app/utils/navigation_service.dart';
import 'package:island_app/utils/routes_name.dart';
import 'package:island_app/utils/storage_service.dart';
import 'package:island_app/widgets/loading_button.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:island_app/widgets/custom_text_field.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({
    super.key,
    required this.type,
  });
  final String type;
  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  void dispose() {
    super.dispose();
  }

  final changePassKey = GlobalKey<FormState>();
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
                const SizedBox(
                  height: 10,
                ),
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
              title: "Ok",
              width: 50,
              height: 50,
              textStyle: TextStyle(
                color: CustomColors.primaryColor,
                fontSize: 16,
                fontFamily: "Rubik",
                fontWeight: FontWeight.w600,
              ),
              onPressed: () async {
                Provider.of<NotificationProvider>(context, listen: false).unSubscribeChannels(4);
                await storageService.deleteSecureStorage('userRole');
                await storageService.deleteSecureStorage('userToken');
                await storageService.deleteSecureStorage("userStatus");
                Provider.of<BottomNavigationProvider>(context, listen: false).page = 0;
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
                Provider.of<NotificationProvider>(context, listen: false).setDefault();
                Provider.of<SubscriptionProvider>(context, listen: false).setDefault();
                Provider.of<RecieverChatProvider>(context, listen: false).setDefault();
                Provider.of<CardProvider>(context, listen: false).setDefault();
                Provider.of<ReceiverReviewsProvider>(context, listen: false).setDefault();
                Provider.of<JobApplicantsProvider>(context, listen: false).setDefault();
                Provider.of<HomePaginationProvider>(context, listen: false).setDefault();
                Provider.of<HiredCandidatesProvider>(context, listen: false).setDefault();
                Provider.of<PostedJobsProvider>(context, listen: false).setDefault();
                return true;
              },
            ),
          ],
        );
      },
    );
  }

  var avatar;
  getUserAvatar() async {
    var userAvatar = await storageService.readSecureStorage('userAvatar');
    setState(() {
      avatar = userAvatar;
    });
    return avatar.toString();
  }

  @override
  void initState() {
    getUserAvatar();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<RecieverUserProvider, BottomNavigationProvider>(builder: (context, recieverProvider, bottomProvider, __) {
      return SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                children: [
                  Column(
                    children: [
                      FutureBuilder<ProfileReceiverModel?>(
                        future: recieverProvider.userProfile,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return InkWell(
                              onTap: () {
                                // int prePage = bottomProvider.page;
                                bottomProvider.updatePage(3);
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
                                    const SizedBox(
                                      width: 10,
                                    ),
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
                                        const SizedBox(
                                          height: 10,
                                        ),
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
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
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
                            if (widget.type == "home") {
                              Navigator.pop(context);
                            } else {
                              // int prePage = bottomProvider.page;
                              bottomProvider.updatePage(0);
                            }
                          },
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          navigationService.push(RoutesName.serviceRecieverJobPost);
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
                            leading: const SvgPicture(
                              SvgAssetLoader("assets/images/icons/jobPost.svg"),
                              height: 20,
                            ),
                            title: Text(
                              'Post a Job',
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
                              navigationService.push(RoutesName.serviceRecieverJobPost);
                            },
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: ListTile(
                            hoverColor: const Color.fromRGBO(255, 255, 255, 0.1),
                            selectedColor: const Color.fromRGBO(255, 255, 255, 0.1),
                            focusColor: const Color.fromRGBO(255, 255, 255, 0.1),
                            leading: const SvgPicture(
                              SvgAssetLoader("assets/images/icons/bookings.svg"),
                              height: 20,
                            ),
                            title: Text(
                              'Job Applicants',
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
                              navigationService.push(RoutesName.serviceRecieverJobApplicant);
                            },
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          navigationService.push(RoutesName.serviceRecieverHireCandidates);
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
                            leading: const SvgPicture(
                              SvgAssetLoader("assets/images/icons/hired-candidate.svg"),
                              height: 20,
                            ),
                            title: Text(
                              'Hired Candidates',
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
                              navigationService.push(RoutesName.serviceRecieverHireCandidates);
                            },
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          navigationService.push(RoutesName.recieverPackagePayment);
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
                              'Payment Center',
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
                              navigationService.push(RoutesName.recieverPackagePayment);
                            },
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          navigationService.push(RoutesName.recieverPackagePayment);
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
                            leading: const SizedBox(
                              child: SvgPicture(SvgAssetLoader("assets/images/icons/refund-icon.svg")),
                              // Image.asset("assets/images/icons/payments.png")
                            ),
                            title: Text(
                              'Refund Center',
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
                              navigationService.push(RoutesName.recieverRefund);
                            },
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          navigationService.push(RoutesName.receiverReviews);
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
                              navigationService.push(RoutesName.receiverReviews);
                            },
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          navigationService.push(RoutesName.recieverManageCard);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
                          child: ListTile(
                            hoverColor: const Color.fromRGBO(255, 255, 255, 0.1),
                            selectedColor: const Color.fromRGBO(255, 255, 255, 0.1),
                            focusColor: const Color.fromRGBO(255, 255, 255, 0.1),
                            leading: const SvgPicture(
                              SvgAssetLoader("assets/images/icons/manage-card.svg"),
                              height: 20,
                            ),
                            title: Text(
                              'Manage Cards',
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
                              navigationService.push(RoutesName.recieverManageCard);
                            },
                          ),
                        ),
                      ),

                      // GestureDetector(
                      //   onTap: () {
                      //     navigationService.push(RoutesName.serviceRecieverBank);
                      //   },
                      //   child: Container(
                      //     padding: const EdgeInsets.symmetric(vertical: 6),
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(6),
                      //     ),
                      //     child: ListTile(
                      //       hoverColor: const Color.fromRGBO(255, 255, 255, 0.1),
                      //       selectedColor: const Color.fromRGBO(255, 255, 255, 0.1),
                      //       focusColor: const Color.fromRGBO(255, 255, 255, 0.1),
                      //       leading: const SvgPicture(
                      //         SvgAssetLoader("assets/images/icons/bank-detail.svg"),
                      //         height: 20,
                      //       ),
                      //       title: Text(
                      //         'Bank Details',
                      //         style: TextStyle(
                      //           fontSize: 16,
                      //           fontWeight: FontWeight.w500,
                      //           color: CustomColors.white,
                      //           fontFamily: "Rubik",
                      //         ),
                      //       ),
                      //       trailing: Icon(
                      //         Icons.arrow_forward_ios,
                      //         color: CustomColors.white,
                      //         size: 16,
                      //       ),
                      //       onTap: () {
                      //         navigationService.push(RoutesName.serviceRecieverBank);
                      //       },
                      //     ),
                      //   ),
                      // ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
                        child: ListTile(
                          hoverColor: const Color.fromRGBO(255, 255, 255, 0.1),
                          selectedColor: const Color.fromRGBO(255, 255, 255, 0.1),
                          focusColor: const Color.fromRGBO(255, 255, 255, 0.1),
                          leading: SizedBox(child: Image.asset("assets/images/icons/lock.png")),
                          title: Text('Change Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: CustomColors.white, fontFamily: "Rubik")),
                          trailing: Icon(Icons.arrow_forward_ios, color: CustomColors.white, size: 16),
                          onTap: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (BuildContext context, StateSetter setState) {
                                    return const ChangePasswordWidget();
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
                        child: ListTile(
                          onTap: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (BuildContext context, StateSetter setState) {
                                    return const DeactivateAccountWidget();
                                  },
                                );
                              },
                            );
                          },
                          leading: const SvgPicture(
                            SvgAssetLoader("assets/images/icons/deactivate_account.svg"),
                            height: 20,
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: CustomColors.white,
                            size: 16,
                          ),
                          title: Text(
                            'Close Account',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: CustomColors.white, fontFamily: "Rubik"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      _showLogoutDialog();
                    },
                    child: SizedBox(
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ListTile(
                            onTap: () {
                              _showLogoutDialog();
                            },
                            leading: const Icon(
                              Icons.logout_outlined,
                              color: Colors.white,
                            ),
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
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class DeactivateAccountWidget extends StatefulWidget {
  const DeactivateAccountWidget({super.key});

  @override
  State<DeactivateAccountWidget> createState() => _DeactivateAccountWidgetState();
}

class _DeactivateAccountWidgetState extends State<DeactivateAccountWidget> {
  TextEditingController passwordController = TextEditingController();
  bool showPassword = false;
  void togglevisibility1() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  Future<void> sendRequest() async {
    var token = await getToken();
    var userId = await Provider.of<RecieverUserProvider>(context, listen: false).getUserId();

    var formData = FormData.fromMap({"password": passwordController.text.toString()});

    try {
      var response = await postRequesthandler(
        url: '${SessionUrl.accountDeactivate}/$userId',
        formData: formData,
        token: token,
      );

      // Navigator.pop(context);
      if (response != null && response.statusCode == 200 && response.data != null && response.data["message"] != null && response.data["message"] == "Account Deactivated Successfully") {
        showSuccessToast("Account Deactivated Successfully");
        Provider.of<NotificationProvider>(context, listen: false).unSubscribeChannels(4);
        await storageService.deleteSecureStorage('userRole');
        await storageService.deleteSecureStorage('userToken');
        await storageService.deleteSecureStorage("userStatus");
        Provider.of<BottomNavigationProvider>(context, listen: false).page = 0;
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/',
          (route) => false,
        );
        Provider.of<NotificationProvider>(context, listen: false).setDefault();
        Provider.of<SubscriptionProvider>(context, listen: false).setDefault();
        Provider.of<RecieverChatProvider>(context, listen: false).setDefault();
        Provider.of<CardProvider>(context, listen: false).setDefault();
        Provider.of<ReceiverReviewsProvider>(context, listen: false).setDefault();
        Provider.of<JobApplicantsProvider>(context, listen: false).setDefault();
        Provider.of<HomePaginationProvider>(context, listen: false).setDefault();
        Provider.of<HiredCandidatesProvider>(context, listen: false).setDefault();
        Provider.of<PostedJobsProvider>(context, listen: false).setDefault();
      } else if (response != null && response.data != null && response.data["message"] != null && response.data["message"] == "Password doesn't match") {
        setState(() {
          showIncorrectPasswordError = true;
          showEmptyPasswordError = false;
        });
        showErrorToast(response.data['message'].toString());
      } else {
        showErrorToast("something went wrong");
      }
    } catch (e) {
      // Navigator.pop(context);
      showErrorToast(e.toString());
    }
  }

  final formKey = GlobalKey<FormState>();
  bool showIncorrectPasswordError = false;
  bool showEmptyPasswordError = false;
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
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "Deactivated Account",
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
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "Do You want to deactivated your account?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: CustomColors.black,
                    fontFamily: "Rubik",
                    fontStyle: FontStyle.normal,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "Are you sure you want to delete your account? This action cannot be undone and your user name cannot be registered again! After your account is deleted, you will be logged out and all other active sessions will be terminated.",
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
              CustomTextFieldWidget(
                borderColor: CustomColors.loginBorder,
                textStyle: TextStyle(
                  fontSize: 15,
                  color: CustomColors.hintText,
                  fontFamily: "Calibri",
                  fontWeight: FontWeight.w400,
                ),
                hintText: "Password",
                controller: passwordController,
                obsecure: !showPassword,
                sufIcon: GestureDetector(
                  onTap: () {
                    togglevisibility1();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      showPassword ? Icons.visibility : Icons.visibility_off,
                      size: 20,
                      color: CustomColors.hintText,
                    ),
                  ),
                ),
              ),
              if (showEmptyPasswordError) ...[
                const Text(
                  "Password is Required",
                  style: TextStyle(color: Colors.red),
                ),
              ] else if (showIncorrectPasswordError) ...[
                const Text(
                  "Password is Incorrect",
                  style: TextStyle(color: Colors.red),
                ),
              ],
              const SizedBox(height: 20),
              LoadingButton(
                title: "Continue",
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
                  if (passwordController.text.trim().isEmpty) {
                    setState(() {
                      showIncorrectPasswordError = false;
                      showEmptyPasswordError = true;
                    });
                    return false;
                  }
                  await sendRequest();

                  return false;
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
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
  bool showPassword1 = false;
  void togglevisibility1() {
    setState(() {
      showPassword1 = !showPassword1;
    });
  }

  bool showPassword2 = false;
  void togglevisibility2() {
    setState(() {
      showPassword2 = !showPassword2;
    });
  }

  bool showPassword3 = false;
  void togglevisibility3() {
    setState(() {
      showPassword3 = !showPassword3;
    });
  }

  Future<void> chnagePassword() async {
    var token = await getToken();
    var userId = await Provider.of<RecieverUserProvider>(context, listen: false).getUserId();

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
                      obsecure: !showPassword1,
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
                          togglevisibility1();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(
                            showPassword1 ? Icons.visibility : Icons.visibility_off,
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
                      obsecure: !showPassword2,
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
                          togglevisibility2();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(
                            showPassword2 ? Icons.visibility : Icons.visibility_off,
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
                      obsecure: !showPassword3,
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
                          togglevisibility3();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(
                            showPassword3 ? Icons.visibility : Icons.visibility_off,
                            size: 20,
                            color: CustomColors.hintText,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    LoadingButton(
                      title: "Continue",
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
