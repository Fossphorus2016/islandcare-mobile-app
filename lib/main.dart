// ignore_for_file: await_only_futures, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:island_app/caregiver/screens/my_jobs_screen.dart';
import 'package:island_app/caregiver/screens/provider_reviews_given_screen.dart';
import 'package:island_app/caregiver/utils/profile_provider.dart';
import 'package:island_app/caregiver/screens/provider_messages_screen.dart';
import 'package:island_app/carereceiver/screens/hired_candidates_screen.dart';
import 'package:island_app/carereceiver/screens/job_applicant.dart';
import 'package:island_app/carereceiver/screens/manage_cards.dart';
import 'package:island_app/carereceiver/screens/messages_screen.dart';
import 'package:island_app/carereceiver/screens/post_job.dart';
import 'package:island_app/carereceiver/screens/receiver_reviews_given_screen.dart';
import 'package:island_app/carereceiver/screens/refund_screen.dart';
import 'package:island_app/carereceiver/utils/bottom_navigation_provider.dart';
import 'package:island_app/carereceiver/utils/home_pagination.dart';
import 'package:island_app/providers/subscription_provider.dart';
import 'package:island_app/screens/notification.dart';
import 'package:island_app/providers/user_provider.dart';
import 'package:island_app/utils/navigation_service.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

/*
  Senior Care Service Id 1 
  Pet Care Service Id 2
  House Keeping Service Id 3
  School Support Service Id 4
  Child Care Service Id 5
*/

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RecieverUserProvider()),
        ChangeNotifierProvider(create: (context) => ServiceGiverProvider()),
        ChangeNotifierProvider(create: (context) => GiverMyJobsProvider()),
        ChangeNotifierProvider(create: (context) => GiverReviewsProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
        ChangeNotifierProvider(create: (context) => ServiceProviderChat()),
        ChangeNotifierProvider(create: (context) => SubscriptionProvider()),
        ChangeNotifierProvider(create: (context) => RecieverChatProvider()),
        ChangeNotifierProvider(create: (context) => CardProvider()),
        ChangeNotifierProvider(create: (context) => BottomNavigationProvider()),
        ChangeNotifierProvider(create: (context) => ReceiverReviewsProvider()),
        ChangeNotifierProvider(create: (context) => JobApplicantsProvider()),
        ChangeNotifierProvider(create: (context) => HomePaginationProvider()),
        ChangeNotifierProvider(create: (context) => HiredCandidatesProvider()),
        ChangeNotifierProvider(create: (context) => RefundsProvider()),
        ChangeNotifierProvider(create: (context) => PostedJobsProvider())
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
  @override
  void initState() {
    IslandPusher().initPusher();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Island Care',
      theme: ThemeData(appBarTheme: const AppBarTheme(iconTheme: IconThemeData(color: Colors.white))),
      onGenerateRoute: RouteGenerator.generateRoutes,
      initialRoute: '/',
      navigatorKey: NavigationService().navigatorKey,
      navigatorObservers: [NavigationService()],
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 665, name: MOBILE),
          const Breakpoint(start: 665, end: 1024, name: TABLET),
          const Breakpoint(start: 1024, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
    );
  }
}
