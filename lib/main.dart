// ignore_for_file: await_only_futures, prefer_typing_uninitialized_variables, avoid_print

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:island_app/caregiver/screens/provider_messages_screen.dart';
import 'package:island_app/caregiver/widgets/bottombar.dart';
import 'package:island_app/carereceiver/screens/messages_screen.dart';
import 'package:island_app/screens/notification.dart';
import 'package:island_app/carereceiver/widgets/bottom_bar.dart';
import 'package:island_app/providers/user_provider.dart';
import 'package:island_app/screens/login_screen.dart';
import 'package:island_app/screens/signup_main_screen.dart';
import 'package:island_app/screens/splash_screen.dart';
import 'package:island_app/widgets/custom_page_route.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // PusherService.instance.initialize();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => NotificationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ServiceProviderChat(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var token;
  Future getUserToken() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    var userToken = await prefs.getString('userToken');
    setState(() {
      token = userToken;
    });
    print("token == $token");
    return userToken.toString();
  }

  var name;
  Future getUserName() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    var userName = await prefs.getString('userName');
    setState(() {
      name = userName;
    });
    if (kDebugMode) {
      print("Name == $name");
    }
    return userName.toString();
  }

  @override
  void initState() {
    getUserToken();
    getUserName();
    IslandPusher().initPusher();
    super.initState();

    // initPusher();
  }

  Route? onGenerateRoute(RouteSettings settings) {
    Route? page;
    switch (settings.name) {
      case '/':
        page = CustomPageRoute(child: const SplashScreen(), direction: AxisDirection.left);
        break;
      case 'sign-up':
        page = CustomPageRoute(child: SignupScreen(), direction: AxisDirection.left);
        break;
      case 'login':
        page = CustomPageRoute(child: const LoginScreen(), direction: AxisDirection.left);
        break;
      case 'bottom-bar':
        page = CustomPageRoute(child: const BottomBar(), direction: AxisDirection.left);
        break;
      case 'bottom-bar-giver':
        page = CustomPageRoute(child: const BottomBarGiver(), direction: AxisDirection.left);
        break;
      case 'bottom-bar-giver-2':
        page = CustomPageRoute(child: const BottomBarGiver2(), direction: AxisDirection.left);
        break;
      case 'bottom-bar-2':
        page = CustomPageRoute(child: const BottomBar2(), direction: AxisDirection.left);
        break;
    }
    return page!;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'APP',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      onGenerateRoute: onGenerateRoute,
    );
  }
}
