// ignore_for_file: unused_element, unused_local_variable, use_build_context_synchronously

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:island_app/caregiver/screens/provider_messages_screen.dart';
import 'package:island_app/carereceiver/screens/messages_screen.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/providers/user_provider.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/functions.dart';
import 'package:island_app/utils/http_handlers.dart';
import 'package:island_app/utils/navigation_service.dart';
import 'package:island_app/utils/storage_service.dart';
import 'package:provider/provider.dart';
import 'dart:core';

import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isLoading = false;
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

    getReceiverJobData(id) async {
      setState(() {
        isLoading = false;
      });
      var token = await Provider.of<RecieverUserProvider>(context, listen: false).getUserToken();
      final response = await getRequesthandler(
        url: '${CareReceiverURl.serviceReceiverJobBoardDetail}/$id',
        token: token,
      );
      if (response.statusCode == 200) {
        var data = response.data['job'][0];
        navigationService.push('/service-reciever-job-detail', arguments: {
          "serviceId": data['service_id'].toString(),
          "jobData": data,
        });
      } else {
        throw Exception(
          'Failed to load Service Provider Dashboard',
        );
      }
    }

    gotoScreen(String? type, String? actionId) {
      if (kDebugMode) {
        print(type);
      }
      if (type != null && actionId != null) {
        setState(() {
          isLoading = true;
        });
        switch (type) {
          case "job-apply":
            setState(() {
              isLoading = false;
            });
            navigationService.push('/service-reciever-job-applicant', arguments: {"id": actionId});
            break;
          case "admin-approved":
            getReceiverJobData(actionId);
            break;
          case "job-approved":
            setState(() {
              isLoading = false;
            });
            navigationService.push('/my-job-detail-giver', arguments: {
              "id": actionId,
            });
            break;
          case "job-reject":
            setState(() {
              isLoading = false;
            });
            navigationService.push('/my-job-detail-giver', arguments: {
              "id": actionId,
            });
            break;
          case "job-completed":
            break;
          case "review-given":
            break;
          case "receiver-job-create":
            setState(() {
              isLoading = false;
            });
            navigationService.push('/job-detail-giver', arguments: {
              "id": actionId,
            });
            break;
          case "receiver-subscription":
            break;
          case "receiver-chat":
            setState(() {
              isLoading = false;
            });
            Provider.of<RecieverChatProvider>(context, listen: false).getSingleChat(context, actionId);
            break;
          case "admin-chat":
            break;
          case "provider-chat":
            setState(() {
              isLoading = false;
            });
            Provider.of<ServiceProviderChat>(context, listen: false).getSingleChat(context, actionId);
            break;
          case "job-applied":
            break;
          default:
        }
      }
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(30, 0, 0, 0),
                      offset: Offset(2, 2),
                      spreadRadius: 1,
                      blurRadius: 7,
                    ),
                  ],
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
                      var userToken = await storageService.readSecureStorage('userToken');

                      var resp = await getRequesthandler(
                        url: "${AppUrl.webBaseURL}/api/mark-notifications-as-read",
                        token: userToken,
                      );
                      if (resp.statusCode == 200) {
                        Provider.of<NotificationProvider>(context, listen: false).getNotifications();
                      }
                    } catch (error) {
                      showErrorToast("something went wrong please try again later");
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
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
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
                                  return Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: InkWell(
                                      onTap: () {
                                        // print(provider.allNotifications[index]);
                                        gotoScreen(provider.allNotifications[index]['type'], provider.allNotifications[index]['action_id']);
                                      },
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
                                                        // height: 50,
                                                        // color: CustomColors.primaryColor,
                                                        // child: Center(
                                                        //   child: Text(
                                                        //     "${provider.allNotifications[index]['users']['first_name'][0].toString().toUpperCase()} ${provider.allNotifications[index]['users']['last_name'][0].toString().toUpperCase()}",
                                                        //     style: const TextStyle(
                                                        //       fontSize: 20,
                                                        //       color: Colors.white,
                                                        //     ),
                                                        //   ),
                                                        // ),
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
                                    ),
                                  );
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
      var userToken = await storageService.readSecureStorage('userToken');

      var resp = await getRequesthandler(
        url: AppUrl.getNotification,
        token: userToken,
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
