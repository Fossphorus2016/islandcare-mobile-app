// import 'dart:async';
// import 'package:pusher_client/pusher_client.dart';

// class PusherService {
//   static final PusherService _instance = PusherService._internal();
//   static PusherService get instance => _instance;
//   PusherClient? _pusher;
//   StreamController<dynamic> _pushNotificationController = StreamController<dynamic>.broadcast();
//   Stream<dynamic> get pushNotificationStream => _pushNotificationController.stream;

//   PusherService._internal();

//   void initialize() {
//     PusherOptions options = PusherOptions( 
//       cluster: 'ap2',
//       encrypted: true, // Set to false if your server does not use HTTPS
//     );

//     _pusher = PusherClient('9805223081ead5006cf0', options);
//     _pusher!.connect();
//   }

//   void subscribe(String channelName, String eventName) {
//     Channel channel = _pusher!.subscribe(channelName);
//     channel.bind(eventName, (event) {
//       _pushNotificationController.add(event?.data);
//     });
//   }

//   void dispose() {
//     _pushNotificationController.close();
//   }
// }

// class PusherService { 
//     PusherClient? pusher;
//     Channel channel;
//    pusher = PusherClient("1528379", PusherOptions(cluster: "ap2"));

//       channel = pusher!.subscribe("admin-notification-channel");
//       channel.bind("admin-notification-event", (PusherEvent? event) {
//         print("Received event: ${event?.toJson()}");
//         // Handle your notification logic here
//       });

//       pusher?.connect();
// }