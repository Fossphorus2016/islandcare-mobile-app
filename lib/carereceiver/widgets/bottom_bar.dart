// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/screens/manage_cards.dart';
import 'package:island_app/carereceiver/utils/bottom_navigation_provider.dart';
import 'package:island_app/providers/subscription_provider.dart';
import 'package:island_app/providers/user_provider.dart';
import 'package:island_app/screens/notification.dart';
import 'package:island_app/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:island_app/carereceiver/screens/home_screen.dart';
import 'package:island_app/carereceiver/screens/messages_screen.dart';
import 'package:island_app/carereceiver/screens/profile_screen.dart';
import 'package:island_app/carereceiver/screens/wishlist_screen.dart';
import 'package:island_app/carereceiver/utils/colors.dart';

class BottomBar extends StatefulWidget {
  final String? data;
  static const String routeName = '/actual-home';
  const BottomBar({
    Key? key,
    this.data,
  }) : super(key: key);

  @override
  State<BottomBar> createState() => BottomBarState();
}

class BottomBarState extends State<BottomBar> {
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  late List<Widget> pages;

  callUserData() async {
    await Provider.of<RecieverUserProvider>(context, listen: false).getUserToken();
    await Provider.of<RecieverUserProvider>(context, listen: false).fetchProfileReceiverModel();

    //
    await Provider.of<NotificationProvider>(context, listen: false).connectNotificationChannel(4);
    await Provider.of<RecieverChatProvider>(context, listen: false).connectChatChannel(4);
    await Provider.of<SubscriptionProvider>(context, listen: false).getPackages();

    var resp = await Provider.of<CardProvider>(context, listen: false).fetchManageCardsModel();
    if (resp['status'] == false) {
      customErrorSnackBar(context, resp['message']);
    }
  }

  @override
  void initState() {
    pages = [
      const HomeScreen(),
      const WishlistScreen(),
      const MessagesScreen(),
      const ProfileReceiverScreen(),
    ];
    callUserData();
    super.initState();
  }

  final GlobalKey<ScaffoldState> homaPageKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    int page = Provider.of<BottomNavigationProvider>(context).page;
    return Scaffold(
      key: homaPageKey,
      backgroundColor: CustomColors.loginBg,
      body: pages[Provider.of<BottomNavigationProvider>(context).page],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          // splashColor: CustomColors.primaryColor,
          highlightColor: ServiceRecieverColor.primaryColor,
          hoverColor: ServiceRecieverColor.primaryColor,
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
                      color: page == 0 ? ServiceRecieverColor.primaryColor : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.home,
                      color: page == 0 ? CustomColors.white : ServiceRecieverColor.primaryColor,
                    ),
                  ),
                  label: '',
                ),
                // Favorite
                BottomNavigationBarItem(
                  icon: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: page == 1 ? ServiceRecieverColor.primaryColor : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite,
                      color: page == 1 ? CustomColors.white : ServiceRecieverColor.primaryColor,
                    ),
                  ),
                  label: '',
                ),
                // chat
                BottomNavigationBarItem(
                  icon: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: page == 2 ? ServiceRecieverColor.primaryColor : CustomColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.textsms_rounded,
                      color: page == 2 ? CustomColors.white : ServiceRecieverColor.primaryColor,
                    ),
                  ),
                  label: '',
                ),
                // profile
                BottomNavigationBarItem(
                  icon: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: page == 3 ? ServiceRecieverColor.primaryColor : CustomColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      color: page == 3 ? CustomColors.white : ServiceRecieverColor.primaryColor,
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
