import 'package:flutter/material.dart';
import 'package:island_app/caregiver/screens/job_detail.dart';
import 'package:island_app/caregiver/screens/my_job_detail.dart';
import 'package:island_app/caregiver/widgets/bottombar.dart';
import 'package:island_app/carereceiver/screens/bank_details.dart';
import 'package:island_app/carereceiver/screens/hired_candidates_screen.dart';
import 'package:island_app/carereceiver/screens/job_applicant.dart';
import 'package:island_app/carereceiver/screens/job_applicant_detail.dart';
import 'package:island_app/carereceiver/screens/job_detail.dart';
import 'package:island_app/carereceiver/screens/post_job.dart';
import 'package:island_app/carereceiver/screens/post_schedule.dart';
import 'package:island_app/carereceiver/widgets/bottom_bar.dart';
import 'package:island_app/screens/login_screen.dart';
import 'package:island_app/screens/signup_main_screen.dart';
import 'package:island_app/screens/splash_screen.dart';

class NavigationService extends NavigatorObserver {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final NavigationService _instance = NavigationService._internal();
  NavigationService._internal();

  factory NavigationService() => _instance;

  List history = [];

  dynamic push(String route, {dynamic arguments}) {
    history.add(route);

    return navigatorKey.currentState?.pushNamed(route, arguments: arguments);
  }

  dynamic pushReplacement(String route, {dynamic arguments}) {
    return navigatorKey.currentState?.pushReplacementNamed(route, arguments: arguments);
  }

  dynamic popUntils(bool Function(Route<dynamic>) route, {dynamic arguments}) {
    return navigatorKey.currentState?.popUntil(route);
  }

  dynamic pushNamedAndRemoveUntil(String route) {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(
      route,
      ModalRoute.withName('/'),
    );
  }

  dynamic pop() {
    return navigatorKey.currentState?.pop();
  }
}

class RouteGenerator {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    final Map? args = settings.arguments as Map?;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const SplashScreen());

      case '/sign-up':
        return MaterialPageRoute(builder: (context) => SignupScreen());

      case '/login':
        return MaterialPageRoute(builder: (context) => const LoginScreen());

      case '/bottom-bar':
        return MaterialPageRoute(builder: (context) => const BottomBar());

      case '/bottom-bar-giver':
        return MaterialPageRoute(builder: (context) => const BottomBarGiver());
      case '/job-detail-giver':
        return MaterialPageRoute(
          builder: (context) => JobDetailGiver(
            id: args!['id'].toString(),
            serviceId: args['serviceId'].toString(),
          ),
        );
      case '/my-job-detail-giver':
        return MaterialPageRoute(
          builder: (context) => ServiceProviderJobsDetail(
            id: args!['id'].toString(),
          ),
        );
      case '/service-reciever-bank':
        return MaterialPageRoute(
          builder: (context) => const ReceiverBankDetails(),
        );
      case '/service-reciever-job-post':
        return MaterialPageRoute(
          builder: (context) => const PostJobScreen(),
        );
      case '/service-reciever-job-post-service-schedule':
        return MaterialPageRoute(
          builder: (context) => PostSchedule(serviceId: args!['serviceId'].toString()),
        );
      case '/service-reciever-hire-candidates':
        return MaterialPageRoute(
          builder: (context) => const HiredCandidatesScreen(),
        );
      case '/service-reciever-job-applicant':
        return MaterialPageRoute(
          builder: (context) => JobApplicants(
            jobId: args!['id'].toString(),
          ),
        );
      case '/service-reciever-job-applicant-detail':
        return MaterialPageRoute(
          builder: (context) => JobApplicantsDetail(
            jobId: args!['id'].toString(),
            name: args['name'],
          ),
        );
      case '/service-reciever-job-detail':
        return MaterialPageRoute(
          builder: (context) => ReceiverJobDetail(
            serviceId: args!['serviceId'].toString(),
            jobData: args['jobData'],
          ),
        );
      default:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
    }
  }
}

final navigationService = NavigationService();
