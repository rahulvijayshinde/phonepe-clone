import 'package:flutter/material.dart';
import '../presentation/pin_setup_screen/pin_setup_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/transaction_history/transaction_history.dart';
import '../presentation/profile_settings/profile_settings.dart';
import '../presentation/qr_code_scanner/qr_code_scanner.dart';
import '../presentation/common/coming_soon_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String pinSetup = '/pin-setup-screen';
  static const String splash = '/splash-screen';
  static const String homeDashboard = '/home-dashboard';
  static const String transactionHistory = '/transaction-history';
  static const String profileSettings = '/profile-settings';
  static const String qrCodeScanner = '/qr-code-scanner';
  static const String sendMoney = '/send-money';
  static const String payBills = '/pay-bills';
  static const String recharge = '/recharge';
  static const String travelBooking = '/travel-booking';
  static const String insurance = '/insurance';
  static const String investments = '/investments';
  static const String loans = '/loans';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    pinSetup: (context) => const PinSetupScreen(),
    splash: (context) => const SplashScreen(),
    homeDashboard: (context) => const HomeDashboard(),
    transactionHistory: (context) => const TransactionHistory(),
    profileSettings: (context) => const ProfileSettings(),
    qrCodeScanner: (context) => const QrCodeScanner(),
    // Placeholder routes
    sendMoney: (context) => const ComingSoonScreen(title: 'Send Money'),
    payBills: (context) => const ComingSoonScreen(title: 'Pay Bills'),
    recharge: (context) => const ComingSoonScreen(title: 'Recharge'),
    travelBooking: (context) => const ComingSoonScreen(title: 'Travel'),
    insurance: (context) => const ComingSoonScreen(title: 'Insurance'),
    investments: (context) => const ComingSoonScreen(title: 'Investments'),
    loans: (context) => const ComingSoonScreen(title: 'Loans'),
  };
}
