import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:island_app/caregiver/screens/provider_messages_screen.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/utils/app_colors.dart';
import 'package:island_app/utils/app_url.dart';
import 'package:island_app/utils/functions.dart';
import 'package:provider/provider.dart';

class ServiceProviderChatRoom extends StatefulWidget {
  const ServiceProviderChatRoom({super.key});

  @override
  ServiceProviderChatRoomState createState() => ServiceProviderChatRoomState();
}

class ServiceProviderChatRoomState extends State<ServiceProviderChatRoom> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<ServiceProviderChat>(context, listen: false).updateStatus();
  }

  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceProviderChat>(builder: (context, chatProvider, __) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ServiceGiverColor.black,
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
                  color: CustomColors.white,
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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(70),
                    child: Center(
                      child: chatProvider.activeChat['sender']['avatar'] != null
                          ? Image(
                              height: 60,
                              width: 60,
                              image: NetworkImage("${AppUrl.webStorageUrl}/${chatProvider.activeChat['sender']['avatar']}"),
                            )
                          : const Image(
                              height: 60,
                              width: 60,
                              image: AssetImage("assets/images/category.png"),
                            ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${chatProvider.activeChat['sender']['first_name']} ${chatProvider.activeChat['sender']['last_name']}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: CustomColors.white,
                          fontFamily: "Rubik",
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Padding(
                        padding: EdgeInsets.only(left: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                dragStartBehavior: DragStartBehavior.down,
                reverse: true,
                child: Column(
                  children: [
                    for (final message in chatProvider.activeChat['chat_messages']) ...[
                      if (message['sender_id'] == chatProvider.activeChat['receiver_id']) ...[
                        senderMassage(message),
                        const SizedBox(height: 20),
                      ] else ...[
                        receiverMessage(message),
                        const SizedBox(height: 20),
                      ]
                    ],
                  ],
                ),
              ),
            ),

            // TextField
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: const EdgeInsets.only(left: 8, bottom: 3, top: 3, right: 8),
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          color: CustomColors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(0, 0, 0, 0),
                              blurRadius: 4.0,
                              spreadRadius: 1.0,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        child: TextField(
                          controller: messageController,
                          onChanged: (value) {
                            if (value.trim().isNotEmpty) {
                              chatProvider.setButtonValidation(true);
                            } else {
                              chatProvider.setButtonValidation(false);
                            }
                          },
                          textAlignVertical: TextAlignVertical.bottom,
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: "Rubik",
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: InputDecoration(
                            hintText: "Write a message...",
                            fillColor: CustomColors.blackLight,
                            focusColor: CustomColors.blackLight,
                            hoverColor: CustomColors.blackLight,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: CustomColors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: CustomColors.white, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    IconButton(
                      onPressed: chatProvider.sendMessageReq
                          ? () {
                              if (messageController.text.isEmpty) {
                                showErrorToast("please write a message");
                                return;
                              }
                              Provider.of<ServiceProviderChat>(context, listen: false).sendMessage(messageController.text);
                              messageController.clear();
                            }
                          : null,
                      icon: Icon(
                        Icons.send_outlined,
                        color: chatProvider.sendMessageReq ? ServiceGiverColor.redButton : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  senderMassage(message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 300,
          ),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(0),
            ),
            color: ServiceGiverColor.black,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                message['message'],
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: "Rubik",
                  color: CustomColors.white,
                ),
              ),
              const SizedBox(height: 05),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    message['created_at'] != null ? DateFormat("dd-MM-yyyy hh:mm a").format(DateTime.parse(message['created_at']).toLocal()) : DateTime.now().toString(),
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: "Rubik",
                      color: CustomColors.white,
                    ),
                  ),
                  if (message['sender_read'] == 1) ...[
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Icon(
                          Icons.done_all_rounded,
                          size: 18,
                          color: CustomColors.white,
                        ),
                      ),
                    ),
                  ] else ...[
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Icon(
                          Icons.done_rounded,
                          size: 18,
                          color: CustomColors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  receiverMessage(message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 300,
          ),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(10),
            ),
            color: ServiceGiverColor.green,
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message["message"],
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: "Rubik",
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 05),
              Text(
                message['created_at'] != null ? DateFormat("dd-MM-yyyy hh:mm a").format(DateTime.parse(message['created_at']).toLocal()) : DateTime.now().toString(),
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: "Rubik",
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
