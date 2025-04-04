import 'package:caps_book/features/presentation/ui/auth/login_screen.dart';
import 'package:caps_book/features/presentation/ui/home/home_screen.dart';
import 'package:caps_book/features/presentation/ui/introscreen/getstart_screen.dart';
import 'package:caps_book/features/presentation/ui/introscreen/splash_screen.dart';
import 'package:caps_book/features/presentation/widgets/Bottom_nav_screen.dart';
import 'package:flutter/material.dart';


class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/getStart':
        return MaterialPageRoute(builder: (_) => const GetStartScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/bottombar':
        return MaterialPageRoute(builder: (_) => BottomNavScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                  body: Center(child: Text('Page Not Found')),
                ));
    }
  }
}
