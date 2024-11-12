// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:island_app/caregiver/utils/profile_provider.dart';
import 'package:island_app/caregiver/widgets/provider_conversational_widget.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/models/chatroom_model.dart';
import 'package:island_app/screens/notification.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/functions.dart';
import 'package:island_app/utils/http_handlers.dart';
import 'package:island_app/utils/navigation_service.dart';
import 'package:island_app/utils/routes_name.dart';
import 'package:island_app/widgets/profile_complete_widget.dart';
import 'package:provider/provider.dart';

class ProviderMessagesScreen extends StatefulWidget {
  const ProviderMessagesScreen({super.key});

  @override
  State<ProviderMessagesScreen> createState() => _ProviderMessagesScreenState();
}

class _ProviderMessagesScreenState extends State<ProviderMessagesScreen> {
  @override
  void initState() {
    super.initState();
  }

  bool adminChatExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Consumer2<ServiceProviderChat, ServiceGiverProvider>(builder: (context, providerChat, giverProvider, child) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              "Messages",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: "Rubik",
                color: CustomColors.primaryText,
              ),
            ),
          ),
          body: giverProvider.profileStatus
              ? RefreshIndicator(
                  onRefresh: () async {
                    providerChat.getChats();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // Messsages

                        if (providerChat.chatList.isNotEmpty) ...[
                          Expanded(
                            child: ListView.builder(
                              itemCount: providerChat.chatList.length,
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(top: 16),
                              itemBuilder: (context, index) {
                                return ProviderConversationList(
                                  roomId: providerChat.chatList[index]["roomId"],
                                  name: "${providerChat.chatList[index]['userDate'].firstName} ${providerChat.chatList[index]['userDate'].lastName}",
                                  messageText: providerChat.chatList[index]['lastMessage'],
                                  imageUrl: "${AppUrl.webStorageUrl}/${providerChat.chatList[index]['userDate'].avatar}",
                                  time: providerChat.chatList[index]['lastMessageTime'].toString(),
                                  isMessageRead: providerChat.chatList[index]['lastMessagesCount'] == 0 ? false : true,
                                );
                              },
                            ),
                          ),
                        ] else ...[
                          const Center(child: Text("No chat found")),
                        ]
                      ],
                    ),
                  ),
                )
              : const ProfileCompletContainer(),
        ),
      );
    });
  }
}

class ServiceProviderChat extends ChangeNotifier {
  //   Pusher Connection
  connectChatChannel(userRole) async {
    var channelName = IslandPusher().getPusherChatsChannel(userRole);

    IslandPusher.pusher.subscribe(
      channelName: channelName,
      onEvent: onEvent,
      onSubscriptionError: onSubscriptionError,
      onSubscriptionSucceeded: onSubscriptionSucceeded,
    );
  }

  onEvent(event) {
    log("onEventxsxsxsXS: ${event.toString()}");
    getChats();
  }

  onSubscriptionSucceeded(dynamic data) {
    log("onSubscriptionSucceeded: channelName, data: ${data.toString()}");
  }

  onSubscriptionError(dynamic data) {
    log("onSubscriptionError: ${data.toString()} Exception: ${data.toString()}");
  }

  //   Pusher Connection End

  setDefault() {
    chatList = [];
    allChatRooms = [];
    activeChat = {};
    sendMessageReq = false;
  }

  List<Map<String, dynamic>> chatList = [];
  List allChatRooms = [];
  getChats() async {
    var token = await getToken();
    var resp = await getRequesthandler(
      url: ChatUrl.serviceProviderChats,
      token: token,
    );
    if (resp != null && resp.statusCode == 200 && resp.data['flag'] == 1) {
      allChatRooms = resp.data['chats'];
      chatList = List.generate(
        resp.data['chats'].length,
        (index) {
          var getlastmessage = resp.data['chats'][index]['chat_messages'].last;
          var lastmessagetime = DateFormat.jm().format(DateTime.parse(getlastmessage['updated_at']).toLocal());
          return {
            "roomId": resp.data['chats'][index]['id'],
            "userDate": ChatroomUser.fromJson(
              resp.data['chats'][index]['sender'],
            ),
            "lastMessage": getlastmessage['message'],
            "lastMessagesCount": resp.data['chats'][index]["status"],
            "lastMessageTime": lastmessagetime,
          };
        },
      );
      if (activeChat.isNotEmpty) {
        setActiveChat(activeChat['id']);
      }
    }
    notifyListeners();
  }

  getSingleChatAndSetActive(id) async {
    var userToken = await getToken();
    var resp = await postRequesthandler(
      url: ChatUrl.getChat,
      token: userToken,
      formData: FormData.fromMap({"chatId": id}),
    );
    if (resp != null && resp.statusCode == 200 && resp.data['message'].toString().contains("success")) {
      var chatRoom = resp.data['chat'];
      if (chatRoom != null) {
        activeChat = chatRoom;
      }
    }
    notifyListeners();
  }

  getSingleChat(BuildContext context, id) async {
    var userToken = await getToken();

    var resp = await postRequesthandler(
      url: ChatUrl.getChat,
      token: userToken,
      formData: FormData.fromMap({"chatId": id}),
    );
    if (resp != null && resp.statusCode == 200 && resp.data['message'].toString().contains("success")) {
      var chatRoom = resp.data['chat'];
      if (chatRoom != null) {
        setActiveChat(chatRoom['id']);
        navigationService.push(RoutesName.giverChatRoom);
      }
    }
  }

  Map activeChat = {};
  setActiveChat(id) async {
    var getChatRoom = allChatRooms.firstWhere((element) => element["id"] == id);
    activeChat = getChatRoom;
    notifyListeners();
  }

  updateStatus() async {
    var token = await getToken();
    var resp = await postRequesthandler(
      url: ChatUrl.serviceProviderChatMessageStatus,
      formData: FormData.fromMap({"id": activeChat['id']}),
      token: token,
    );
    if (resp != null && resp.statusCode == 200) {
      getChats();
    }
  }

  disposeActiveChat() {
    activeChat = {};
    notifyListeners();
  }

  bool sendMessageReq = false;
  setButtonValidation(bool value) {
    sendMessageReq = value;
    notifyListeners();
  }

  sendMessage(value) async {
    var userToken = await getToken();
    var formData = FormData.fromMap({
      "receiver_id": activeChat['sender_id'],
      "message": value.toString(),
    });
    sendMessageReq = true;
    notifyListeners();
    var resp = await postRequesthandler(
      url: ChatUrl.serviceProviderSendMessage,
      formData: formData,
      token: userToken,
    );
    if (resp != null && resp.statusCode == 200) {
      activeChat = resp.data['chat_room'];
      sendMessageReq = false;
      getChats();
      notifyListeners();
    }
  }
}
