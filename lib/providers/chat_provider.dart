// ignore_for_file: unused_local_variable, empty_catches

// import 'package:http/http.dart' as http;
// import 'package:pusher_client/pusher_client.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:island_app/res/app_url.dart';
import 'package:provider/provider.dart';

class ChatProvider with ChangeNotifier {
  final List<Message> _messages = [];

  List<Message> get messages => [..._messages];

  Future<void> fetchMessages() async {
    try {
      final response = await Dio().get(ChatUrl.serviceReceiverChat);
      // print(response.body);
      notifyListeners();
    } catch (error) {}
  }

  Future<void> sendMessage(String content) async {
    try {
      final response = await Dio().post(ChatUrl.serviceReceiverSendMessage, data: {'content': content});
      notifyListeners();
    } catch (error) {
      // Handle error
      // ...
    }
  }

  void subscribeToPusherChannel() {
    // final pusher = PusherClient(
    //   '9805223081ead5006cf0',
    //   PusherOptions(cluster: 'ap2'),
    //   enableLogging: true,
    // );

    // final channel = pusher.subscribe('receiver-chat-channel');
    // channel.bind('new-message', (event) {
    //   // Parse the event data and update _messages list accordingly
    //   // ...
    //   print("event== $event");
    //   notifyListeners();
    // });

    // pusher.connect();
  }
}

// chat_screen.dart

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.fetchMessages();
    chatProvider.subscribeToPusherChannel();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _sendMessage(BuildContext context) async {
    final content = _textController.text.trim();
    if (content.isNotEmpty) {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      await chatProvider.sendMessage(content);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = Provider.of<ChatProvider>(context).messages;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat App'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (ctx, index) => ListTile(
                title: Text(messages[index].content),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// message.dart

class Message {
  final String id;
  final String content;

  Message({required this.id, required this.content});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
    };
  }
}
