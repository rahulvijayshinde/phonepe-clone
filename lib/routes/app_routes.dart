import 'package:flutter/material.dart';
import '../presentation/pin_setup_screen/pin_setup_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/transaction_history/transaction_history.dart';
import '../presentation/profile_settings/profile_settings.dart';
import '../presentation/qr_code_scanner/qr_code_scanner.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String pinSetup = '/pin-setup-screen';
  static const String splash = '/splash-screen';
  static const String homeDashboard = '/home-dashboard';
  static const String transactionHistory = '/transaction-history';
  static const String profileSettings = '/profile-settings';
  static const String qrCodeScanner = '/qr-code-scanner';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    pinSetup: (context) => const PinSetupScreen(),
    splash: (context) => const SplashScreen(),
    homeDashboard: (context) => const HomeDashboard(),
    transactionHistory: (context) => const TransactionHistory(),
    profileSettings: (context) => const ProfileSettings(),
    qrCodeScanner: (context) => const QrCodeScanner(),
    // TODO: Add your other routes here
  };
}
