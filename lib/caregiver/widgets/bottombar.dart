import 'package:flutter/material.dart';

import 'package:island_app/caregiver/screens/home_screen.dart';
import 'package:island_app/caregiver/screens/profile_screen.dart';
import 'package:island_app/caregiver/screens/provider_messages_screen.dart';
import 'package:island_app/screens/notification.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomBarGiver extends StatefulWidget {
  final String? status;
  const BottomBarGiver({
    Key? key,
    this.status,
  }) : super(key: key);

  @override
  State<BottomBarGiver> createState() => _BottomBarGiverState();
}

class _BottomBarGiverState extends State<BottomBarGiver> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  List<Widget> pages = [
    const HomeGiverScreen(),
    const ProviderMessagesScreen(),
    const ProfileGiver(),
  ];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
    setState(() {
      getUserToken();
    });
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
    setState(() {
      getUserToken();
    });
    Provider.of<NotificationProvider>(context, listen: false).connectNotificationChannel(3);
    Provider.of<ServiceProviderChat>(context, listen: false).connectChatChannel(3);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.loginBg,
      body: pages[_page],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: CustomColors.primaryColor,
          highlightColor: CustomColors.primaryColor,
          hoverColor: CustomColors.primaryColor,
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
                ? const Center(
                    child: Text("data"),
                  )
                : BottomNavigationBar(
                    currentIndex: _page,
                    selectedItemColor: CustomColors.primaryColor,
                    unselectedItemColor: CustomColors.white,
                    backgroundColor: CustomColors.white,
                    iconSize: 28,
                    onTap: updatePage,
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
                            color: _page == 0 ? CustomColors.primaryColor : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.home,
                            color: _page == 0 ? CustomColors.white : CustomColors.primaryColor,
                          ),
                        ),
                        label: '',
                      ),

                      BottomNavigationBarItem(
                        icon: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: _page == 1 ? CustomColors.primaryColor : CustomColors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.textsms_rounded,
                            color: _page == 1 ? CustomColors.white : CustomColors.primaryColor,
                          ),
                        ),
                        label: '',
                      ),
                      BottomNavigationBarItem(
                        icon: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: _page == 2 ? CustomColors.primaryColor : CustomColors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person,
                            color: _page == 2 ? CustomColors.white : CustomColors.primaryColor,
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

// Fake

class BottomBarGiver2 extends StatefulWidget {
  const BottomBarGiver2({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomBarGiver2> createState() => _BottomBarGiver2State();
}

class _BottomBarGiver2State extends State<BottomBarGiver2> {
  @override
  void initState() {
    super.initState();
    Provider.of<NotificationProvider>(context, listen: false).connectNotificationChannel(3);
    Provider.of<ServiceProviderChat>(context, listen: false).connectChatChannel(3);
  }

  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  List<Widget> pages = [
    const Scaffold(
      body: Center(
        child: Text("Your profile is pending"),
      ),
    ),
    const Scaffold(
      body: Center(
        child: Text("Your profile is pending"),
      ),
    ),
    const ProfileGiverPending()
  ];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.loginBg,
      body: pages[_page],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: CustomColors.primaryColor,
          highlightColor: CustomColors.primaryColor,
          hoverColor: CustomColors.primaryColor,
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
            child: BottomNavigationBar(
              currentIndex: _page,
              selectedItemColor: CustomColors.primaryColor,
              unselectedItemColor: CustomColors.white,
              backgroundColor: CustomColors.white,
              iconSize: 28,
              onTap: updatePage,
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
                      color: _page == 0 ? CustomColors.primaryColor : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.home,
                      color: _page == 0 ? CustomColors.white : CustomColors.primaryColor,
                    ),
                  ),
                  label: '',
                ),
                // Favorite
                // BottomNavigationBarItem(
                //   icon: Container(
                //     height: 50,
                //     width: 50,
                //     decoration: BoxDecoration(
                //       color: _page == 1 ? CustomColors.primaryColor : Colors.transparent,
                //       shape: BoxShape.circle,
                //     ),
                //     child: Icon(
                //       Icons.favorite,
                //       color: _page == 1 ? CustomColors.white : CustomColors.primaryColor,
                //     ),
                //   ),
                //   label: '',
                // ),
                BottomNavigationBarItem(
                  icon: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: _page == 1 ? CustomColors.primaryColor : CustomColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.textsms_rounded,
                      color: _page == 1 ? CustomColors.white : CustomColors.primaryColor,
                    ),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: _page == 2 ? CustomColors.primaryColor : CustomColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      color: _page == 2 ? CustomColors.white : CustomColors.primaryColor,
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
