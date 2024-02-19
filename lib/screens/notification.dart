// ignore_for_file: unused_element, unused_local_variable, use_build_context_synchronously

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/res/app_url.dart';
import 'package:island_app/utils/utils.dart';
import 'package:provider/provider.dart';
import 'dart:core';

import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
      super.initState();
      Provider.of<NotificationProvider>(context, listen: false).getNotifications();
    }

    @override
    void dispose() {
      super.dispose();
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.all(4.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: CustomColors.loginBg,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: CustomColors.primaryColor,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
          title: Text(
            "Notifications",
            style: TextStyle(
              color: CustomColors.primaryText,
              fontSize: 22,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 05),
              child: PopupMenuButton(
                position: PopupMenuPosition.under,
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: Colors.black,
                ),
                onSelected: (value) async {
                  if (value == 1) {
                    try {
                      SharedPreferences? prefs = await SharedPreferences.getInstance();
                      await prefs.reload();
                      var userToken = prefs.getString('userToken');

                      var resp = await Dio().get(
                        "${AppUrl.webBaseURL}/api/mark-notifications-as-read",
                        options: Options(headers: {
                          "Authorization": "Bearer $userToken",
                          "Accept": "application/json",
                        }),
                      );
                      if (resp.statusCode == 200) {
                        Provider.of<NotificationProvider>(context, listen: false).getNotifications();
                      }
                    } catch (error) {
                      customErrorSnackBar(context, "something went wrong please try again later");
                    }
                  } else if (value == 2) {
                    var allNotification = Provider.of<NotificationProvider>(context, listen: false).allNotifications;

                    List allRead = allNotification.where((item) => item['is_read'] == 1).toList();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllReadNotificationScreen(
                          readNotification: allRead,
                        ),
                      ),
                    );
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    value: 1,
                    onTap: () async {},
                    child: const Text('Mark All Read'),
                  ),
                  PopupMenuItem(
                    value: 2,
                    onTap: () {},
                    child: const Text('See All Read'),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              Provider.of<NotificationProvider>(context, listen: false).getNotifications();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Expanded(
                    child: Consumer<NotificationProvider>(
                      builder: (context, provider, child) {
                        return ListView.builder(
                          itemCount: provider.allNotifications.length,
                          itemBuilder: (context, index) {
                            if (provider.allNotifications[index]['is_read'] == 0) {
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  height: 70,
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey.shade200,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(50),
                                          child: provider.allNotifications[index]['users']['avatar'] == null
                                              ? Container(
                                                  width: 50,
                                                  height: 50,
                                                  color: CustomColors.primaryColor,
                                                  child: Center(
                                                    child: Text(
                                                      "${provider.allNotifications[index]['users']['first_name'][0].toString().toUpperCase()} ${provider.allNotifications[index]['users']['last_name'][0].toString().toUpperCase()}",
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : CachedNetworkImage(
                                                  height: 50,
                                                  width: 50,
                                                  fit: BoxFit.cover,
                                                  alignment: Alignment.topCenter,
                                                  imageUrl: "${AppUrl.webStorageUrl}/${provider.allNotifications[index]['users']['avatar']}",
                                                  placeholder: (context, url) => const CircularProgressIndicator(),
                                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                                ),
                                        ),
                                      ),
                                      const SizedBox(width: 05),
                                      Expanded(
                                        child: Text(
                                          provider.allNotifications[index]['message'].toString(),
                                          maxLines: 3,
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return null;
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AllReadNotificationScreen extends StatelessWidget {
  final List readNotification;
  const AllReadNotificationScreen({super.key, required this.readNotification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: readNotification.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                height: 70,
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 1,
                    color: Colors.grey.shade200,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: readNotification[index]['users']['avatar'] == null
                            ? Container(
                                width: 50,
                                height: 50,
                                color: CustomColors.primaryColor,
                                child: Center(
                                  child: Text(
                                    "${readNotification[index]['users']['first_name'][0].toString().toUpperCase()} ${readNotification[index]['users']['last_name'][0].toString().toUpperCase()}",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            : CachedNetworkImage(
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                                imageUrl: "${AppUrl.webStorageUrl}/${readNotification[index]['users']['avatar']}",
                                placeholder: (context, url) => const CircularProgressIndicator(),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                      ),
                    ),
                    const SizedBox(width: 05),
                    Expanded(
                      child: Text(
                        readNotification[index]['message'].toString(),
                        maxLines: 3,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class NotificationProvider extends ChangeNotifier {
  List allNotifications = [];

  connectNotificationChannel(userRole) async {
    var channelName = IslandPusher().getPusherNotificationChannel(userRole);
    var eventname = IslandPusher().getPusherNotificationEvent(userRole);

    IslandPusher.pusher.subscribe(
      channelName: channelName,
      onEvent: onEvent,
      onSubscriptionError: onSubscriptionError,
      onSubscriptionSucceeded: onSubscriptionSucceeded,
    );
  }

  onEvent(event) {
    log("onEventxsxsxsXS: ${event.toString()}");
    getNotifications();
  }

  onSubscriptionSucceeded(dynamic data) {
    log("onSubscriptionSucceeded: ${data.toString()} data: ${data.toString()}");
  }

  onSubscriptionError(dynamic data) {
    log("onSubscriptionError: ${data.toString()} Exception: ${data.toString()}");
  }

  getNotifications() async {
    try {
      SharedPreferences? prefs = await SharedPreferences.getInstance();
      await prefs.reload();
      var userToken = prefs.getString('userToken');

      var resp = await Dio().get(
        AppUrl.getNotification,
        options: Options(headers: {
          "Authorization": "Bearer $userToken",
          "Accept": "application/json",
        }),
      );
      if (resp.statusCode == 200) {
        var data = resp.data;

        allNotifications = data;

        notifyListeners();
      }
    } catch (error) {
      // print("error on notifiacation get $error");
    }
  }

  unSubscribeChannels(userRole) async {
    var notiChannelName = IslandPusher().getPusherNotificationChannel(userRole);
    var notiEventname = IslandPusher().getPusherNotificationEvent(userRole);
    var chatChannelName = IslandPusher().getPusherChatsChannel(userRole);
    var chatEventname = IslandPusher().getPusherChatsEvent(userRole);
    await IslandPusher.pusher.unsubscribe(channelName: notiChannelName);
    await IslandPusher.pusher.unsubscribe(channelName: chatChannelName);
  }
}

class IslandPusher {
  String apiKey = "9805223081ead5006cf0";
  String cluster = "ap2";
  static PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  initPusher() async {
    try {
      await pusher.init(apiKey: apiKey, cluster: cluster);
      await pusher.connect();
    } catch (e) {
      log("ERROR: $e");
    }
  }

  getPusherNotificationChannel(role) {
    switch (role) {
      case 3:
        return "provider-notification-channel";
      case 4:
        return "receiver-notification-channel";
    }
  }

  getPusherNotificationEvent(role) {
    switch (role) {
      case 3:
        return "provider-notification-event";
      case 4:
        return "receiver-notification-event";
    }
  }

  getPusherChatsChannel(role) {
    switch (role) {
      case 3:
        return "provider-chat-channel";
      case 4:
        return "receiver-chat-channel";
    }
  }

  getPusherChatsEvent(role) {
    switch (role) {
      case 3:
        return "provider-chat-event";
      case 4:
        return "receiver-chat-event";
    }
  }
}
