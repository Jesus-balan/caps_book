import 'package:caps_book/features/presentation/ui/Details/emergency_details.dart';
import 'package:caps_book/features/presentation/ui/Details/maintenance_details.dart';
import 'package:caps_book/features/presentation/ui/auth/changePassword/change_password.dart';
import 'package:caps_book/features/presentation/ui/auth/login/login_screen.dart';
import 'package:caps_book/features/presentation/ui/Details/betta_history.dart';
import 'package:caps_book/features/presentation/ui/Details/expense_history.dart';
import 'package:caps_book/features/presentation/ui/Details/customer_profile.dart';
import 'package:caps_book/features/presentation/ui/home/home_screen.dart';
import 'package:caps_book/features/presentation/ui/introscreen/getstart_screen.dart';
import 'package:caps_book/features/presentation/ui/introscreen/splash_screen.dart';
import 'package:caps_book/features/presentation/widgets/Bottom_nav_screen.dart';
import 'package:flutter/material.dart';


class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    late final Widget page;

    switch (settings.name) {
      case '/':
        page = const SplashScreen();
        break;
      case '/getStart':
        page = const GetStartScreen();
        break;
      case '/login':
        page = const LoginScreen();
        break;
      case '/bottombar':
        page = BottomNavScreen();
        break;
      case '/home':
        page = const HomeScreen();
        break;
        case '/resetPass':
        page =  ResetPasswordPage();
        break;
        case '/maintenance':
        page =  MaintenanceDetailsScreen();
        break;
        case '/emergency':
        page =  EmergencyServiceDetails();
        break;
         case '/expenselist':
        page =  ExpenseListScreen();
        break;
         case '/bettalist':
        page =  BettaListScreen();
        break;
        case '/profile':
        page = ProfilePage();
        break;
      default:
        page = const Scaffold(
          body: Center(child: Text('Page Not Found')),
        );
    }

    return _buildPageRoute(page);
  }

  static PageRouteBuilder _buildPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offsetTween = Tween<Offset>(
          begin: const Offset(0, 0.1), // Slight slide from bottom
          end: Offset.zero,
        );

        final fadeTween = Tween<double>(begin: 0.0, end: 1.0);

        return SlideTransition(
          position: offsetTween.animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          )),
          child: FadeTransition(
            opacity: fadeTween.animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeIn,
            )),
            child: child,
          ),
        );
      },
    );
  }
}
