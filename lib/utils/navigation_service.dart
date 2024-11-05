import 'package:flutter/material.dart';
import 'package:island_app/caregiver/screens/bank_detail.dart';
import 'package:island_app/caregiver/screens/chat_provider_detail_screen.dart';
import 'package:island_app/caregiver/screens/job_detail.dart';
import 'package:island_app/caregiver/screens/my_job_detail.dart';
import 'package:island_app/caregiver/screens/my_jobs_screen.dart';
import 'package:island_app/caregiver/widgets/bottombar.dart';
import 'package:island_app/carereceiver/screens/applicant_profile_detail.dart';
import 'package:island_app/carereceiver/screens/availability.dart';
import 'package:island_app/carereceiver/screens/bank_details.dart';
import 'package:island_app/carereceiver/screens/chat_detail_screen.dart';
import 'package:island_app/carereceiver/screens/edit_job_post.dart';
import 'package:island_app/carereceiver/screens/hired_candidates_screen.dart';
import 'package:island_app/carereceiver/screens/job_applicant.dart';
import 'package:island_app/carereceiver/screens/job_applicant_detail.dart';
import 'package:island_app/carereceiver/screens/job_detail.dart';
import 'package:island_app/carereceiver/screens/job_payment_screen.dart';
import 'package:island_app/carereceiver/screens/manage_cards.dart';
import 'package:island_app/carereceiver/screens/payment_package_screen.dart';
import 'package:island_app/carereceiver/screens/post_job.dart';
import 'package:island_app/carereceiver/screens/post_new_job.dart';
import 'package:island_app/carereceiver/screens/post_schedule.dart';
import 'package:island_app/carereceiver/screens/bottom_bar.dart';
import 'package:island_app/carereceiver/screens/provider_profile_detail_for_giver.dart';
import 'package:island_app/screens/login_screen.dart';
import 'package:island_app/screens/notification.dart';
import 'package:island_app/screens/onboard_screen.dart';
import 'package:island_app/screens/signup_main_screen.dart';
import 'package:island_app/screens/splash_screen.dart';
import 'package:island_app/screens/verify_email.dart';
import 'package:island_app/utils/routes_name.dart';

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
      case RoutesName.initalRoute:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case RoutesName.onBoard:
        return MaterialPageRoute(builder: (context) => const OnBoardScreen());

      case RoutesName.signUp:
        return MaterialPageRoute(builder: (context) => SignupScreen());
      case RoutesName.verifyEmail:
        return MaterialPageRoute(
          builder: (context) => VerifyEmail(
            token: args!["token"],
          ),
        );

      case RoutesName.login:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case RoutesName.notification:
        return MaterialPageRoute(builder: (context) => const NotificationScreen());

      case RoutesName.bottomBar:
        return MaterialPageRoute(builder: (context) => const BottomBar());

      case RoutesName.bottomBarGiver:
        return MaterialPageRoute(builder: (context) => const BottomBarGiver());

      case RoutesName.jobDetailGiver:
        return MaterialPageRoute(
          builder: (context) => JobDetailGiver(
            id: args!['id'].toString(),
            serviceId: args['serviceId'].toString(),
          ),
        );
      case RoutesName.myJobsGiver:
        return MaterialPageRoute(
          builder: (context) => const ServiceProviderJobs(),
        );
      case RoutesName.myJobDetailGiver:
        return MaterialPageRoute(
          builder: (context) => ServiceProviderJobsDetail(
            id: args!['id'].toString(),
            service: args['service'],
          ),
        );
      case RoutesName.giverBankDetails:
        return MaterialPageRoute(
          builder: (context) => const GiverBankDetails(),
        );
      case RoutesName.serviceRecieverBank:
        return MaterialPageRoute(
          builder: (context) => const ReceiverBankDetails(),
        );
      case RoutesName.serviceRecieverJobPost:
        return MaterialPageRoute(
          builder: (context) => const PostJobScreen(),
        );
      case RoutesName.serviceRecieverJobPostServiceSchedule:
        return MaterialPageRoute(
          builder: (context) => PostSchedule(serviceId: args!['serviceId'].toString()),
        );
      case RoutesName.serviceRecieverHireCandidates:
        return MaterialPageRoute(
          builder: (context) => const HiredCandidatesScreen(),
        );
      case RoutesName.serviceRecieverJobApplicant:
        return MaterialPageRoute(
          builder: (context) => JobApplicants(
            jobId: args != null && args['id'] != null ? args['id'] : null,
          ),
        );
      case RoutesName.serviceRecieverJobApplicantDetail:
        return MaterialPageRoute(
          builder: (context) => JobApplicantsDetail(
            jobId: args!['id'].toString(),
            name: args['name'],
          ),
        );
      case RoutesName.serviceRecieverJobDetail:
        return MaterialPageRoute(
          builder: (context) => ReceiverJobDetail(
            serviceId: args!['serviceId'].toString(),
            jobData: args['jobData'],
          ),
        );
      case RoutesName.recieverAvailability:
        return MaterialPageRoute(
          builder: (context) => const RecieverAvailabilityScreen(),
        );
      case RoutesName.recieverProviderDetail:
        return MaterialPageRoute(
          builder: (context) => ProviderProfileDetailForReceiver(
            id: args!["id"],
            rating: args["rating"],
          ),
        );
      case RoutesName.recieverProviderDetailApplicantProfileDetail:
        return MaterialPageRoute(
          builder: (context) => ApplicantProfileDetail(
            jobId: args!['jobId'],
            jobTitle: args['jobTitle'],
            profileId: args['profileId'],
          ),
        );
      case RoutesName.recieverPostNewJob:
        return MaterialPageRoute(
          builder: (context) => const PostNewJob(),
        );
      case RoutesName.recieverPaymentScreen:
        return MaterialPageRoute(
          builder: (context) => RecieverPaymentScreen(
            subsId: args!["subsId"],
          ),
        );
      case RoutesName.recieverJobPayment:
        return MaterialPageRoute(
          builder: (context) => RecieverJobPaymentsScreen(
            jobId: args!['jobId'],
            jobName: args["jobName"],
            amount: args["amount"],
          ),
        );
      case RoutesName.recieverPackagePayment:
        return MaterialPageRoute(
          builder: (context) => const PackagePaymentScreen(),
        );
      case RoutesName.recieverManageCard:
        return MaterialPageRoute(
          builder: (context) => const ManageCards(),
        );
      case RoutesName.serviceRecieverEditJobPost:
        return MaterialPageRoute(
          builder: (context) => EditPostSchedule(
            serviceId: args!["serviceId"],
            jobData: args["jobData"],
          ),
        );
      case RoutesName.giverChatRoom:
        return MaterialPageRoute(builder: (context) => const ServiceProviderChatRoom());
      case RoutesName.recieverChatScreen:
        return MaterialPageRoute(builder: (context) => const RecieverChatScreen());
      default:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
    }
  }
}

final navigationService = NavigationService();
