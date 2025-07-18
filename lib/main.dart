import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/transactions_screen.dart';
import 'screens/deposit_screen.dart';
import 'screens/transfer_screen.dart';
import 'screens/loan_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/exam_fee_screen.dart';
import 'screens/course_registration_fee_screen.dart';
import 'screens/admin_dashboard_screen.dart';
import 'screens/create_account_screen.dart';
import 'screens/withdraw_screen.dart';
import 'app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Banking App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: AppColors.accentColor,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/create-account': (context) => const CreateAccountScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/transactions': (context) => const TransactionsScreen(),
        '/deposit': (context) => const DepositScreen(),
        '/withdraw': (context) => const WithdrawScreen(),
        '/transfer': (context) => const TransferScreen(),
        '/loan': (context) => const LoanScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/exam-fee': (context) => const ExamFeeScreen(),
        '/course-registration': (context) => const CourseRegistrationFeeScreen(),
        '/admin-dashboard': (context) => const AdminDashboardScreen(),
      },
    );
  }
}