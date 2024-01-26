import 'package:flutter/material.dart';
import 'package:island_app/caregiver/screens/home_screen.dart';
import 'package:island_app/caregiver/widgets/bottombar.dart';
import 'package:island_app/carereceiver/screens/home_screen.dart';
import 'package:island_app/carereceiver/widgets/bottom_bar.dart';
import 'package:island_app/screens/login_screen.dart';
import 'package:island_app/screens/signup_main_screen.dart';
import 'package:island_app/screens/splash_screen.dart';
import 'package:island_app/utils/routes/routes_name.dart';
import 'package:island_app/widgets/custom_page_route.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return CustomPageRoute(child: const SplashScreen(), direction: AxisDirection.left);

      case RoutesName.homeGiver:
        return CustomPageRoute(child: const HomeGiverScreen(), direction: AxisDirection.left);
      case RoutesName.homeReceiver:
        return CustomPageRoute(child: const HomeScreen(), direction: AxisDirection.left);
      case RoutesName.login:
        return CustomPageRoute(child: const LoginScreen(), direction: AxisDirection.left);
      case RoutesName.signUp:
        return CustomPageRoute(child: SignupScreen(), direction: AxisDirection.left);
      case RoutesName.bottomBar:
        return CustomPageRoute(child: const BottomBar(), direction: AxisDirection.left);
      case RoutesName.bottomBarGiver:
        return CustomPageRoute(child: const BottomBarGiver(), direction: AxisDirection.left);
      // case RoutesName.bottomBar2:
      //   return CustomPageRoute(child: const BottomBar2(), direction: AxisDirection.left);
      // case RoutesName.bottomBarGiver2:
      //   return CustomPageRoute(child: const BottomBarGiver2(), direction: AxisDirection.left);

      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No route defined'),
            ),
          );
        });
    }
  }
}
