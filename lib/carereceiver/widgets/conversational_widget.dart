// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:flutter/material.dart';
import 'package:island_app/carereceiver/screens/messages_screen.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:island_app/utils/navigation_service.dart';
import 'package:island_app/utils/routes_name.dart';
import 'package:provider/provider.dart';

class ConversationList extends StatefulWidget {
  dynamic chat;
  String? name;
  String? messageText;
  String? imageUrl;
  String? time;
  bool? isMessageRead;
  ConversationList({super.key, required this.chat, @required this.name, @required this.messageText, @required this.imageUrl, @required this.time, this.isMessageRead});
  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<RecieverChatProvider>(context, listen: false).setActiveChat(widget.chat);
        navigationService.push(RoutesName.recieverChatScreen);
      },
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  widget.imageUrl!.isEmpty
                      ? const CircleAvatar(
                          backgroundImage: AssetImage("assets/images/user.png"),
                          maxRadius: 30,
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(widget.imageUrl!),
                          maxRadius: 30,
                        ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.name!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: CustomColors.primaryText,
                              fontFamily: "Poppins",
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.messageText!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: CustomColors.borderLight,
                              fontWeight: widget.isMessageRead != null ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  widget.time!,
                  style: TextStyle(
                    fontSize: 12,
                    color: CustomColors.borderLight,
                    fontWeight: widget.isMessageRead != null ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 5),
                widget.isMessageRead != null && widget.isMessageRead == false
                    ? CircleAvatar(
                        backgroundColor: CustomColors.primaryColor,
                        radius: 05,
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
