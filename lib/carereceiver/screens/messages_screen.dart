// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/carereceiver/widgets/conversational_widget.dart';
import 'package:island_app/models/chatroom_model.dart';
import 'package:island_app/screens/notification.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/functions.dart';
import 'package:island_app/utils/http_handlers.dart';
import 'package:island_app/utils/navigation_service.dart';
import 'package:island_app/utils/routes_name.dart';
import 'package:provider/provider.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  late Future<ChatRoomMessagesModel>? futureReceiverDashboard;

  Future<ChatRoomMessagesModel> fetchFindedReceiverDashboardModel() async {
    var token = await getToken();
    final response = await getRequesthandler(
      url: ChatUrl.serviceReceiverChat,
      token: token,
    );

    if (response != null && response.statusCode == 200) {
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
            "Chat Room",
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
                            // print(provider.chatList[index]['userDate']);
                            if (provider.chatList[index]['userDate'] == null || provider.chatList[index]['userDate'].firstName == null) {
                              return null;
                            }
                            return ConversationList(
                              chat: provider.chatList[index]['chat'],
                              name: "${provider.chatList[index]['userDate'].firstName} ${provider.chatList[index]['userDate'].lastName}",
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
    // log("onEvent in receiver messages: ${event.toString()}");
    if (activeChat.isNotEmpty) {
      getSingleChatAndSetActive(activeChat['id']);
    } else {
      getChats();
    }
  }

  onSubscriptionSucceeded(dynamic data) {
    // log("onSubscriptionSucceeded: channelName, data: ${data.toString()}");
  }

  onSubscriptionError(dynamic data) {
    // log("onSubscriptionError: ${data.toString()} Exception: ${data.toString()}");
  }

  //   Pusher Connection End
  setDefault() {
    chatList = [];
    allChatRooms = [];
    activeChatMessages = [];
    activeChat = {};
    sendMessageReq = false;
  }

  List<Map<String, dynamic>> chatList = [];
  List allChatRooms = [];
  getChats() async {
    var userToken = await getToken();
    var resp = await postRequesthandler(
      url: ChatUrl.serviceReceiverAllChats,
      token: userToken,
    );
    if (resp != null && resp.statusCode == 200 && resp.data['flag'] == 1) {
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
            "userDate": resp.data['chats'][index] != null && resp.data['chats'][index]['receiver'] != null ? ChatroomUser.fromJson(resp.data['chats'][index]['receiver']) : null,
            "lastMessage": getlastmessage != null ? getlastmessage['message'] : null,
            "lastMessagesCount": resp.data['chats'][index]["status"],
            "lastMessageTime": lastmessagetime,
          };
        },
      );
    }
    notifyListeners();
  }

  getSingleChatAndSetActive(id) async {
    var token = await getToken();
    var resp = await postRequesthandler(
      url: ChatUrl.getChat,
      formData: FormData.fromMap({"chatId": id}),
      token: token,
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
    var token = await getToken();

    var resp = await postRequesthandler(
      url: ChatUrl.getChat,
      formData: FormData.fromMap({"chatId": id}),
      token: token,
    );
    if (resp != null && resp.statusCode == 200 && resp.data['message'].toString().contains("success")) {
      var chatRoom = resp.data['chat'];
      if (chatRoom != null) {
        setActiveChat(chatRoom);
        navigationService.push(RoutesName.recieverChatScreen);
      }
    }
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
    notifyListeners();
    // }
  }

  disposeActiveChat() {
    activeChat = {};
    notifyListeners();
  }

  bool sendMessageReq = false;
  sendMessage(value) async {
    var userToken = await getToken();
    var formData = FormData.fromMap({
      "provider_id": activeChat['receiver_id'],
      "message": value.toString(),
    });
    sendMessageReq = true;
    notifyListeners();
    var resp = await postRequesthandler(
      url: ChatUrl.serviceReceiverSendMessage,
      formData: formData,
      token: userToken,
    );
    if (resp != null && resp.statusCode == 200) {
      activeChat = resp.data['chat_room'];
      sendMessageReq = false;
      getChats();
      notifyListeners();
    } else {
      sendMessageReq = false;
      notifyListeners();
      getChats();
    }
  }

  setButtonValidation(bool value) {
    sendMessageReq = value;
    notifyListeners();
  }

  updateStatus() async {
    var userToken = await getToken();
    var resp = await postRequesthandler(
      url: ChatUrl.serviceReceiverChatMessageStatus,
      formData: FormData.fromMap({"id": activeChat['id']}),
      token: userToken,
    );
    if (resp != null && resp.statusCode == 200) {
      getChats();
    }
  }
}

// class RecieverUserChatModel {
//   final String firstName;
//   final String? lastName;
//   final String? avatar;
//   final int id;
//   RecieverUserChatModel({
//     required this.id,
//     required this.firstName,
//     this.lastName,
//     this.avatar,
//   });

//   RecieverUserChatModel fromJson(Map json) {
//     return RecieverUserChatModel(id: json["id"], firstName: json["first_name"], lastName: json["last_name"], avatar: json["avatar"]);
//   }
// }
