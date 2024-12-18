// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/screens/manage_cards.dart';
import 'package:island_app/carereceiver/utils/bottom_navigation_provider.dart';
import 'package:island_app/providers/subscription_provider.dart';
import 'package:island_app/providers/user_provider.dart';
import 'package:island_app/screens/loading_screen.dart';
import 'package:island_app/screens/notification.dart';
import 'package:island_app/utils/app_colors.dart';
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
    super.key,
    this.data,
  });

  @override
  State<BottomBar> createState() => BottomBarState();
}

class BottomBarState extends State<BottomBar> {
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  late List<Widget> pages;
  bool isLoading = true;
  callUserData() async {
    var resp = await Provider.of<RecieverUserProvider>(context, listen: false).fetchProfileReceiverModel();
    if (resp) {
      await Provider.of<NotificationProvider>(context, listen: false).connectNotificationChannel(4);
      await Provider.of<RecieverChatProvider>(context, listen: false).connectChatChannel(4);
      await Provider.of<SubscriptionProvider>(context, listen: false).getPackages();

      await Provider.of<CardProvider>(context, listen: false).fetchManageCardsModel(notify: false);
      setState(() {
        isLoading = false;
      });
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
    // int page = Provider.of<BottomNavigationProvider>(context).page;
    return Consumer<BottomNavigationProvider>(
      builder: (context, bottomNavigationProvider, child) {
        if (isLoading) {
          return const LoadingScreen();
        }
        return PopScope(
          canPop: bottomNavigationProvider.page == 0,
          onPopInvoked: (didPop) {
            if (bottomNavigationProvider.page == 1) {
              // int prePage = bottomNavigationProvider.page;
              bottomNavigationProvider.updatePage(0);
            } else if (bottomNavigationProvider.page == 2) {
              // int prePage = bottomNavigationProvider.page;
              bottomNavigationProvider.updatePage(1);
            } else if (bottomNavigationProvider.page == 3) {
              // int prePage = bottomNavigationProvider.page;
              bottomNavigationProvider.updatePage(2);
            }
          },
          child: Scaffold(
            key: homaPageKey,
            backgroundColor: CustomColors.loginBg,
            body: pages[bottomNavigationProvider.page],
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
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: bottomNavigationProvider.page == 0 ? ServiceRecieverColor.primaryColor : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.home,
                            color: bottomNavigationProvider.page == 0 ? CustomColors.white : ServiceRecieverColor.primaryColor,
                          ),
                        ),
                        label: '',
                      ),
                      // Favorite
                      BottomNavigationBarItem(
                        icon: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: bottomNavigationProvider.page == 1 ? ServiceRecieverColor.primaryColor : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.favorite,
                            color: bottomNavigationProvider.page == 1 ? CustomColors.white : ServiceRecieverColor.primaryColor,
                          ),
                        ),
                        label: '',
                      ),
                      // chat
                      BottomNavigationBarItem(
                        icon: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: bottomNavigationProvider.page == 2 ? ServiceRecieverColor.primaryColor : CustomColors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.textsms_rounded,
                            color: bottomNavigationProvider.page == 2 ? CustomColors.white : ServiceRecieverColor.primaryColor,
                          ),
                        ),
                        label: '',
                      ),
                      // profile
                      BottomNavigationBarItem(
                        icon: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: bottomNavigationProvider.page == 3 ? ServiceRecieverColor.primaryColor : CustomColors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person,
                            color: bottomNavigationProvider.page == 3 ? CustomColors.white : ServiceRecieverColor.primaryColor,
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
    // return isLoading
    //     ? const LoadingScreen()
    //     : Scaffold(
    //         key: homaPageKey,
    //         backgroundColor: CustomColors.loginBg,
    //         body: pages[Provider.of<BottomNavigationProvider>(context).page],
    //         bottomNavigationBar: Theme(
    //           data: Theme.of(context).copyWith(
    //             // splashColor: CustomColors.primaryColor,
    //             highlightColor: ServiceRecieverColor.primaryColor,
    //             hoverColor: ServiceRecieverColor.primaryColor,
    //           ),
    //           child: ClipRRect(
    //             borderRadius: const BorderRadius.only(
    //               topLeft: Radius.circular(30.0),
    //               topRight: Radius.circular(30.0),
    //             ),
    //             child: Container(
    //               decoration: const BoxDecoration(
    //                 color: Colors.transparent,
    //                 boxShadow: [
    //                   BoxShadow(
    //                     color: Color.fromARGB(59, 0, 0, 0),
    //                     blurRadius: 8.0,
    //                     spreadRadius: 8.0,
    //                     offset: Offset(4.0, 4.0),
    //                   ),
    //                 ],
    //               ),
    //               child: BottomNavigationBar(
    //                 currentIndex: page,
    //                 selectedItemColor: CustomColors.primaryColor,
    //                 unselectedItemColor: CustomColors.white,
    //                 backgroundColor: CustomColors.white,
    //                 iconSize: 28,
    //                 onTap: Provider.of<BottomNavigationProvider>(context, listen: false).updatePage,
    //                 type: BottomNavigationBarType.fixed,
    //                 showSelectedLabels: false,
    //                 showUnselectedLabels: false,
    //                 items: [
    //                   // HOME
    //                   BottomNavigationBarItem(
    //                     icon: Container(
    //                       height: 80,
    //                       width: 80,
    //                       decoration: BoxDecoration(
    //                         color: page == 0 ? ServiceRecieverColor.primaryColor : Colors.transparent,
    //                         shape: BoxShape.circle,
    //                       ),
    //                       child: Icon(
    //                         Icons.home,
    //                         color: page == 0 ? CustomColors.white : ServiceRecieverColor.primaryColor,
    //                       ),
    //                     ),
    //                     label: '',
    //                   ),
    //                   // Favorite
    //                   BottomNavigationBarItem(
    //                     icon: Container(
    //                       height: 80,
    //                       width: 80,
    //                       decoration: BoxDecoration(
    //                         color: page == 1 ? ServiceRecieverColor.primaryColor : Colors.transparent,
    //                         shape: BoxShape.circle,
    //                       ),
    //                       child: Icon(
    //                         Icons.favorite,
    //                         color: page == 1 ? CustomColors.white : ServiceRecieverColor.primaryColor,
    //                       ),
    //                     ),
    //                     label: '',
    //                   ),
    //                   // chat
    //                   BottomNavigationBarItem(
    //                     icon: Container(
    //                       height: 80,
    //                       width: 80,
    //                       decoration: BoxDecoration(
    //                         color: page == 2 ? ServiceRecieverColor.primaryColor : CustomColors.white,
    //                         shape: BoxShape.circle,
    //                       ),
    //                       child: Icon(
    //                         Icons.textsms_rounded,
    //                         color: page == 2 ? CustomColors.white : ServiceRecieverColor.primaryColor,
    //                       ),
    //                     ),
    //                     label: '',
    //                   ),
    //                   // profile
    //                   BottomNavigationBarItem(
    //                     icon: Container(
    //                       height: 80,
    //                       width: 80,
    //                       decoration: BoxDecoration(
    //                         color: page == 3 ? ServiceRecieverColor.primaryColor : CustomColors.white,
    //                         shape: BoxShape.circle,
    //                       ),
    //                       child: Icon(
    //                         Icons.person,
    //                         color: page == 3 ? CustomColors.white : ServiceRecieverColor.primaryColor,
    //                       ),
    //                     ),
    //                     label: '',
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //       );
  }
}
