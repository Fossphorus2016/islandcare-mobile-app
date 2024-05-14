// ignore_for_file: prefer_typing_uninitialized_variables

// import 'package:http/http.dart' as http;
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:island_app/carereceiver/screens/chat_detail_screen.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/carereceiver/widgets/conversational_widget.dart';
import 'package:island_app/models/chatroom_model.dart';
import 'package:island_app/providers/user_provider.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/screens/notification.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  late Future<ChatRoomMessagesModel>? futureReceiverDashboard;

  Future<ChatRoomMessagesModel> fetchFindedReceiverDashboardModel() async {
    var token = RecieverUserProvider.userToken;
    final response = await Dio().get(
      ChatUrl.serviceReceiverChat,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      return ChatRoomMessagesModel.fromJson(response.data);
    } else {
      throw Exception(
        'Failed to load Service Chat Room',
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        body: SingleChildScrollView(
          child: RefreshIndicator(
            onRefresh: () async {
              Provider.of<RecieverChatProvider>(context, listen: false).getChats();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Messsages
                  Consumer<RecieverChatProvider>(
                    builder: (context, provider, child) {
                      if (provider.chatList.isNotEmpty) {
                        return ListView.builder(
                          itemCount: provider.chatList.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 16),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ConversationList(
                              chat: provider.chatList[index]['chat'],
                              name: "${provider.chatList[index]['userDate'].firstName} ${provider.chatList[index]['userDate'].firstName}",
                              messageText: provider.chatList[index]['lastMessage'],
                              imageUrl: "${AppUrl.webStorageUrl}/${provider.chatList[index]['userDate'].avatar}",
                              time: provider.chatList[index]['lastMessageTime'].toString(),
                              isMessageRead: provider.chatList[index]['lastMessagesCount'] == 0 ? false : true,
                            );
                          },
                        );
                      }
                      return const Center(child: Text("No chat found"));
                    },
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

class RecieverChatProvider extends ChangeNotifier {
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
    if (activeChat.isNotEmpty) {
      getSingleChatAndSetActive(activeChat['id']);
    } else {
      getChats();
    }
  }

  onSubscriptionSucceeded(dynamic data) {
    log("onSubscriptionSucceeded: channelName, data: ${data.toString()}");
  }

  onSubscriptionError(dynamic data) {
    log("onSubscriptionError: ${data.toString()} Exception: ${data.toString()}");
  }

  //   Pusher Connection End

  List<Map<String, dynamic>> chatList = [];
  List allChatRooms = [];
  getChats() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    var userToken = prefs.getString('userToken');
    var resp = await Dio().post(
      ChatUrl.serviceReceiverAllChats,
      options: Options(
        headers: {
          'Authorization': 'Bearer $userToken',
          'Accept': 'application/json',
        },
      ),
    );
    if (resp.statusCode == 200 && resp.data['flag'] == 1) {
      allChatRooms = resp.data['chats'];
      chatList = List.generate(
        resp.data['chats'].length,
        (index) {
          var getlastmessage;
          var lastmessagetime;
          if (resp.data['chats'][index]['chat_messages'] != null && resp.data['chats'][index]['chat_messages'].length > 0) {
            getlastmessage = resp.data['chats'][index]['chat_messages'].last;
            lastmessagetime = getlastmessage['created_at'] != null ? DateFormat.jm().format(DateTime.parse(getlastmessage['created_at']).toLocal()) : DateTime.now();
          }
          return {
            "roomId": resp.data['chats'][index]['id'],
            "chat": resp.data['chats'][index],
            "userDate": ChatroomUser.fromJson(resp.data['chats'][index]['receiver']),
            "lastMessage": getlastmessage != null ? getlastmessage['message'] : null,
            "lastMessagesCount": resp.data['chats'][index]["status"],
            "lastMessageTime": lastmessagetime,
          };
        },
      );
      // print(activeChat.isNotEmpty);
      // if (activeChat.isNotEmpty) {
      //   var getChatRoom = allChatRooms.firstWhere((element) => element["id"] == activeChat['id']);
      //   setActiveChat(getChatRoom);
      // }
    }
    notifyListeners();
  }

  getSingleChatAndSetActive(id) async {
    var userToken = RecieverUserProvider.userToken;
    var resp = await Dio().post(
      "${AppUrl.webBaseURL}/api/get-chat",
      data: {"chatId": id},
      options: Options(
        headers: {
          'Authorization': 'Bearer $userToken',
          'Accept': 'application/json',
        },
      ),
    );
    if (resp.statusCode == 200 && resp.data['message'].toString().contains("success")) {
      var chatRoom = resp.data['chat'];
      if (chatRoom != null) {
        activeChat = chatRoom;
      }
    }
    notifyListeners();
  }

  getSingleChat(BuildContext context, id) async {
    var userToken = RecieverUserProvider.userToken;
    // print(RecieverUserProvider.userToken);
    // print(id);
    var resp = await Dio().post(
      "${AppUrl.webBaseURL}/api/get-chat",
      data: {"chatId": id},
      options: Options(
        headers: {
          'Authorization': 'Bearer $userToken',
          'Accept': 'application/json',
        },
      ),
    );
    if (resp.statusCode == 200 && resp.data['message'].toString().contains("success")) {
      var chatRoom = resp.data['chat'];
      if (chatRoom != null) {
        setActiveChat(chatRoom);
        // ignore: use_build_context_synchronously
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatDetailPage()));
      }
    }
    // notifyListeners();
  }

  List activeChatMessages = [];
  Map activeChat = {};
  setActiveChat(Map chat) async {
    // if (id == "new") {
    //   if (chatList.isNotEmpty) {
    //     var isExits = allChatRooms.where((element) => element['receiver_id'] == receiver!['id']);
    //     if (isExits.isNotEmpty) {
    //       activeChat = isExits.first;
    //     } else {
    //       activeChat = {"receiver": receiver!, "receiver_id": receiver['id']};
    //     }
    //     notifyListeners();
    //   } else {
    //     activeChat = {"receiver": chat['receiver']!, "receiver_id": receiver['id']};
    //   }
    //   notifyListeners();
    //   getChats();
    // } else {
    // var getChatRoom = allChatRooms.firstWhere((element) => element["id"] == id);
    activeChat = chat;
    // print("get chat $getChatRoom");
    // print("set active chat $activeChat");
    notifyListeners();
    // }
  }

  disposeActiveChat() {
    activeChat = {};
    notifyListeners();
  }

  bool sendMessageReq = false;
  sendMessage(value) async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    var userToken = prefs.getString('userToken');
    var formData = FormData.fromMap({
      "provider_id": activeChat['receiver_id'],
      "message": value.toString(),
    });
    sendMessageReq = true;
    notifyListeners();
    var resp = await Dio().post(
      ChatUrl.serviceReceiverSendMessage,
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $userToken',
          'Accept': 'application/json',
        },
      ),
    );
    if (resp.statusCode == 200) {
      activeChat = resp.data['chat_room'];
      sendMessageReq = false;
      getChats();
      notifyListeners();
    }
  }

  setButtonValidation(bool value) {
    sendMessageReq = value;
    notifyListeners();
  }

  updateStatus() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    var userToken = prefs.getString('userToken');
    var resp = await Dio().post(
      ChatUrl.serviceReceiverChatMessageStatus,
      data: {"id": activeChat['id']},
      options: Options(
        headers: {
          'Authorization': 'Bearer $userToken',
          'Accept': 'application/json',
        },
      ),
    );
    if (resp.statusCode == 200) {
      getChats();
    }
  }
}
