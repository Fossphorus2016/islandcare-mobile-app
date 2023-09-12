// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:flutter/material.dart';
import 'package:island_app/caregiver/screens/chat_provider_detail_screen.dart';
import 'package:island_app/caregiver/screens/provider_messages_screen.dart';
import 'package:island_app/carereceiver/utils/colors.dart';
import 'package:provider/provider.dart';

class ProviderConversationList extends StatefulWidget {
  int roomId;
  String? name;
  String? messageText;
  String? imageUrl;
  String? time;
  bool? isMessageRead;
  ProviderConversationList({super.key, required this.roomId, @required this.name, @required this.messageText, @required this.imageUrl, @required this.time, this.isMessageRead});
  @override
  _ProviderConversationListState createState() => _ProviderConversationListState();
}

class _ProviderConversationListState extends State<ProviderConversationList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<ServiceProviderChat>(context, listen: false).setActiveChat(widget.roomId);

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const ServiceProviderChatRoom();
        }));
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
