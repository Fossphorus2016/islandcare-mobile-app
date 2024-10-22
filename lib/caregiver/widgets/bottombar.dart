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
  // int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  List<Widget> pages = [
    const HomeGiverScreen(),
    const ProviderMessagesScreen(),
    const ProfileGiver(),
  ];

  callUserData() async {
    await Provider.of<ServiceGiverProvider>(context, listen: false).getUserToken();
    await Provider.of<ServiceGiverProvider>(context, listen: false).fetchProfileGiverModel();
    await Provider.of<ServiceGiverProvider>(context, listen: false).getProfilePercentage();
    await Provider.of<NotificationProvider>(context, listen: false).connectNotificationChannel(3);
    await Provider.of<ServiceProviderChat>(context, listen: false).connectChatChannel(3);
  }

  @override
  void initState() {
    callUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int page = Provider.of<BottomNavigationProvider>(context).page;
    return Scaffold(
      backgroundColor: CustomColors.loginBg,
      body: pages[page],
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
                    currentIndex: page,
                    selectedItemColor: CustomColors.primaryColor,
                    unselectedItemColor: CustomColors.white,
                    backgroundColor: CustomColors.white,
                    iconSize: 28,
                    onTap: Provider.of<BottomNavigationProvider>(context, listen: false).updatePage,
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
                            color: page == 0 ? ServiceGiverColor.black : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.home,
                            color: page == 0 ? CustomColors.white : ServiceGiverColor.black,
                          ),
                        ),
                        label: '',
                      ),
                      BottomNavigationBarItem(
                        icon: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: page == 1 ? ServiceGiverColor.black : CustomColors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.textsms_rounded,
                            color: page == 1 ? CustomColors.white : ServiceGiverColor.black,
                          ),
                        ),
                        label: '',
                      ),
                      BottomNavigationBarItem(
                        icon: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: page == 2 ? ServiceGiverColor.black : CustomColors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person,
                            color: page == 2 ? CustomColors.white : ServiceGiverColor.black,
                          ),
                        ),
                        label: '',
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
