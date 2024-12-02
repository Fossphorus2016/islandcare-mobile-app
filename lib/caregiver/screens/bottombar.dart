// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:island_app/caregiver/screens/home_screen.dart';
import 'package:island_app/caregiver/screens/profile_screen.dart';
import 'package:island_app/caregiver/screens/provider_messages_screen.dart';
import 'package:island_app/caregiver/utils/profile_provider.dart';
import 'package:island_app/carereceiver/utils/bottom_navigation_provider.dart';
import 'package:island_app/screens/notification.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/utils/app_colors.dart';
import 'package:provider/provider.dart';

class BottomBarGiver extends StatefulWidget {
  final String? status;
  const BottomBarGiver({
    super.key,
    this.status,
  });

  @override
  State<BottomBarGiver> createState() => _BottomBarGiverState();
}

class _BottomBarGiverState extends State<BottomBarGiver> {
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  List<Widget> pages = [
    const HomeGiverScreen(),
    const ProviderMessagesScreen(),
    const ProfileGiver(),
  ];

  callUserData() async {
    var resp = await Provider.of<ServiceGiverProvider>(context, listen: false).fetchProfileGiverModel();
    // await Provider.of<ServiceGiverProvider>(context, listen: false).getProfilePercentage();
    if (resp) {
      await Provider.of<NotificationProvider>(context, listen: false).connectNotificationChannel(3);
      await Provider.of<ServiceProviderChat>(context, listen: false).connectChatChannel(3);
    }
  }

  @override
  void initState() {
    callUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavigationProvider>(
      builder: (context, bottomNavigationProvider, child) {
        return PopScope(
          canPop: bottomNavigationProvider.page == 0,
          onPopInvoked: (didPop) {
            if (bottomNavigationProvider.page == 1) {
              // int prePage = bottomNavigationProvider.page;
              bottomNavigationProvider.updatePage(0);
            } else if (bottomNavigationProvider.page == 2) {
              // int prePage = bottomNavigationProvider.page;
              bottomNavigationProvider.updatePage(1);
            }
          },
          child: Scaffold(
            backgroundColor: CustomColors.loginBg,
            body: pages[bottomNavigationProvider.page],
            bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(
                highlightColor: ServiceGiverColor.black,
                hoverColor: ServiceGiverColor.black,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(59, 0, 0, 0),
                        blurRadius: 8.0,
                        spreadRadius: 8.0,
                        offset: Offset(4.0, 4.0),
                      ),
                    ],
                  ),
                  child: widget.status == "0"
                      ? const Center(child: Text("data"))
                      : BottomNavigationBar(
                          currentIndex: bottomNavigationProvider.page,
                          selectedItemColor: CustomColors.primaryColor,
                          unselectedItemColor: CustomColors.white,
                          backgroundColor: CustomColors.white,
                          iconSize: 28,
                          onTap: (value) {
                            // int prePage = bottomNavigationProvider.page;
                            bottomNavigationProvider.updatePage(value);
                          },
                          type: BottomNavigationBarType.fixed,
                          showSelectedLabels: false,
                          showUnselectedLabels: false,
                          items: [
                            // HOME
                            BottomNavigationBarItem(
                              icon: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: bottomNavigationProvider.page == 0 ? ServiceGiverColor.black : Colors.transparent,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.home,
                                  color: bottomNavigationProvider.page == 0 ? CustomColors.white : ServiceGiverColor.black,
                                ),
                              ),
                              label: '',
                            ),
                            BottomNavigationBarItem(
                              icon: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: bottomNavigationProvider.page == 1 ? ServiceGiverColor.black : CustomColors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.textsms_rounded,
                                  color: bottomNavigationProvider.page == 1 ? CustomColors.white : ServiceGiverColor.black,
                                ),
                              ),
                              label: '',
                            ),
                            BottomNavigationBarItem(
                              icon: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: bottomNavigationProvider.page == 2 ? ServiceGiverColor.black : CustomColors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: bottomNavigationProvider.page == 2 ? CustomColors.white : ServiceGiverColor.black,
                                ),
                              ),
                              label: '',
                            ),
                          ],
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
