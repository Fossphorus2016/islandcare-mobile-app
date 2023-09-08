// ignore_for_file: prefer_typing_uninitialized_variables

// import 'package:http/http.dart' as http;
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/carereceiver/widgets/conversational_widget.dart';
import 'package:island_app/models/chatroom_model.dart';
import 'package:island_app/res/app_url.dart';
import 'package:island_app/screens/notification.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  // List<ChatUsers>? chatUsers = [
  //   ChatUsers(
  //     name: "Shakeel Provider",
  //     messageText: "Provider",
  //     imageURL: "",
  //     time: "Now",
  //   ),
  //   ChatUsers(
  //     name: "Shakeel Receiver",
  //     messageText: "Receiver",
  //     imageURL: "",
  //     time: "Now",
  //   ),
  // ];

  late Future<ChatRoomMessagesModel>? futureReceiverDashboard;

  Future<ChatRoomMessagesModel> fetchFindedReceiverDashboardModel() async {
    var token = await getUserToken();
    final response = await Dio().get(
      ChatUrl.serviceReceiverChat,
      options: Options(
        headers: {
          // 'Authorization': 'Bearer 41|Zh4DLWxwzRgRmL45hvaWQLiePq6koaIUxOcVR8Sx',
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      // var json = jsonDecode(response.body) as Map;
      // var listOfProviders = json['data'] as List;
      return ChatRoomMessagesModel.fromJson(response.data);
    } else {
      throw Exception(
        'Failed to load Service Chat Room',
      );
    }
  }

  var token;
  Future getUserToken() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    var userToken = prefs.getString('userToken');
    setState(() {
      token = userToken;
    });
    // print("token == $token");
    return userToken.toString();
  }

  @override
  void initState() {
    getUserToken();
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
          // automaticallyImplyLeading: false,
          // leading: GestureDetector(
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          //   child: Padding(
          //     padding: const EdgeInsets.all(13.0),
          //     child: Container(
          //       alignment: Alignment.center,
          //       decoration: BoxDecoration(
          //         color: const Color(0xffffffff),
          //         borderRadius: BorderRadius.circular(10),
          //         boxShadow: const [
          //           BoxShadow(
          //             color: Color.fromARGB(30, 0, 0, 0),
          //             offset: Offset(2, 2),
          //             spreadRadius: 1,
          //             blurRadius: 7,
          //           ),
          //         ],
          //       ),
          //       child: Padding(
          //         padding: const EdgeInsets.only(left: 4.0),
          //         child: Icon(
          //           Icons.arrow_back_ios,
          //           color: CustomColors.primaryColor,
          //           size: 18,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
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
              Provider.of<ChatProvider>(context, listen: false).getChats();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     borderRadius: const BorderRadius.only(
                  //       topLeft: Radius.circular(6),
                  //       bottomLeft: Radius.circular(6),
                  //       bottomRight: Radius.circular(6),
                  //       topRight: Radius.circular(6),
                  //     ),
                  //     color: CustomColors.white,
                  //     boxShadow: const [
                  //       BoxShadow(
                  //         color: Color.fromARGB(13, 0, 0, 0),
                  //         blurRadius: 4.0,
                  //         spreadRadius: 2.0,
                  //         offset: Offset(2.0, 2.0),
                  //       ),
                  //     ],
                  //   ),
                  //   alignment: Alignment.center,
                  //   width: MediaQuery.of(context).size.width,
                  //   height: 50,
                  //   child: TextFormField(
                  //     style: const TextStyle(
                  //       fontSize: 16,
                  //       fontFamily: "Rubik",
                  //       fontWeight: FontWeight.w400,
                  //     ),
                  //     textAlignVertical: TextAlignVertical.bottom,
                  //     maxLines: 1,
                  //     decoration: InputDecoration(
                  //       prefixIcon: Icon(
                  //         Icons.search,
                  //         size: 17,
                  //         color: CustomColors.hintText,
                  //       ),
                  //       hintText: "Search Messages...",
                  //       fillColor: CustomColors.white,
                  //       focusColor: CustomColors.white,
                  //       hoverColor: CustomColors.white,
                  //       filled: true,
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(4),
                  //       ),
                  //       focusedBorder: OutlineInputBorder(
                  //         borderSide: BorderSide(color: CustomColors.white, width: 2.0),
                  //         borderRadius: BorderRadius.circular(4.0),
                  //       ),
                  //       enabledBorder: OutlineInputBorder(
                  //         borderSide: BorderSide(color: CustomColors.white, width: 2.0),
                  //         borderRadius: BorderRadius.circular(4.0),
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  // Messsages
                  Consumer<ChatProvider>(
                    builder: (context, provider, child) {
                      if (provider.chatList.isNotEmpty) {
                        return ListView.builder(
                          itemCount: provider.chatList.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 16),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ConversationList(
                              roomId: provider.chatList[index]["roomId"],
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

class ChatProvider extends ChangeNotifier {
  //   Pusher Connection
  connectChatChannel(userRole) async {
    var channelName = IslandPusher().getPusherChatsChannel(userRole);
    // var eventname = IslandPusher().getPusherChatsEvent(userRole);

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
    //   // final me = pusher.getChannel(channelName)?.me;
    //   // log("Me: $data");
    // print(data);
  }

  onSubscriptionError(dynamic data) {
    // print(data);
    // log("onSubscriptionError: ${message.toString()} Exception: ${e.toString()}");
  }

  //   Pusher Connection End

  List<Map<String, dynamic>> chatList = [];
  List allChatRooms = [];
  getChats() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    var userToken = prefs.getString('userToken');
    var resp = await Dio().get(
      ChatUrl.serviceReceiverChat,
      options: Options(
        headers: {
          'Authorization': 'Bearer $userToken',
          'Accept': 'application/json',
        },
      ),
    );
    if (resp.statusCode == 200 && resp.data['flag'] == 1) {
      // if(){
      allChatRooms = resp.data['chat_room'];
      chatList = List.generate(
        resp.data['chat_room'].length,
        (index) {
          // where((item) => item['updated_at'] == resp.data['chat_room'][index]['updated_at']);

          var getlastmessage = resp.data['chat_room'][index]['chat_messages'].last;
          var lastmessagetime = DateFormat.jm().format(DateTime.parse(getlastmessage['updated_at']).toLocal());
          return {
            "roomId": resp.data['chat_room'][index]['id'],
            "userDate": ChatroomUser.fromJson(
              resp.data['chat_room'][index]['receiver'],
            ),
            "lastMessage": getlastmessage['message'],
            "lastMessagesCount": resp.data['chat_room'][index]["status"],
            "lastMessageTime": lastmessagetime,
          };
        },
      );
      if (activeChat.isNotEmpty) {
        setActiveChat(activeChat['id'], null);
      }
      // }
    }
    notifyListeners();
  }

  List activeChatMessages = [];
  Map activeChat = {};
  setActiveChat(id, Map? receiver) async {
    // print(id);
    if (id == "new") {
      if (chatList.isNotEmpty) {
        var isExits = allChatRooms.where((element) => element['receiver_id'] == receiver!['id']);
        // print(isExits);
        if (isExits.isNotEmpty) {
          activeChat = isExits.first;
        } else {
          activeChat = {"receiver": receiver!, "receiver_id": receiver['id']};
        }
        notifyListeners();
      } else {
        activeChat = {"receiver": receiver!, "receiver_id": receiver['id']};
      }
      notifyListeners();
      getChats();
    } else {
      var getChatRoom = allChatRooms.firstWhere((element) => element["id"] == id);
      activeChat = getChatRoom;
      // print(activeChat);
      notifyListeners();
    }
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
      activeChat = resp.data['chat_room'][0];
      sendMessageReq = false;
      getChats();
      notifyListeners();
    }
  }


  updateStatus() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    var userToken = prefs.getString('userToken');
    var resp = await Dio().post(
      "${AppUrl.webBaseURL}/api/message-status",
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
