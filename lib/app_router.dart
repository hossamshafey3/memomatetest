import 'package:flutter/material.dart';
import 'package:gradproj/features/auth/presentation/screens/login_screen.dart';
import 'package:gradproj/features/auth/presentation/screens/role_selection_screen.dart';
import 'package:gradproj/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:gradproj/features/auth/presentation/screens/splash_screen.dart';
import 'package:gradproj/features/auth/presentation/screens/welcome_screen.dart';
import 'package:gradproj/features/doctor/presentation/screens/doctor_home_screen.dart';
import 'package:gradproj/features/doctor/data/models/doctor_model.dart';
import 'package:gradproj/features/doctor/presentation/screens/doctor_login_screen.dart';
import 'package:gradproj/features/doctor/presentation/screens/doctor_register_screen.dart';

class Routes {
  static const String splashScreen = '/';
  static const String roleSelectionScreen = '/roleSelectionScreen';
  static const String welcomeScreen = '/welcomeScreen';
  static const String loginScreen = '/loginScreen';
  static const String signUpScreen = '/signUpScreen';
  static const String doctorRegisterScreen = '/doctorRegisterScreen';
  static const String doctorLoginScreen = '/doctorLoginScreen';
  static const String doctorHomeScreen = '/doctorHomeScreen';
}

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.roleSelectionScreen:
        return MaterialPageRoute(builder: (_) => const RoleSelectionScreen());
      case Routes.welcomeScreen:
        final userType = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => WelcomeScreen(userType: userType),
        );
      case Routes.loginScreen:
        final userType = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => LoginScreen(userType: userType),
        );
      case Routes.signUpScreen:
        final userType = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => SignUpScreen(userType: userType),
        );
      case Routes.doctorRegisterScreen:
        return MaterialPageRoute(builder: (_) => const DoctorRegisterScreen());
      case Routes.doctorLoginScreen:
        return MaterialPageRoute(builder: (_) => const DoctorLoginScreen());
      case Routes.doctorHomeScreen:
        final profile = settings.arguments as DoctorProfile;
        return MaterialPageRoute(
          builder: (_) => DoctorHomeScreen(doctor: profile),
        );
      default:
        return null;
    }
  }
}
