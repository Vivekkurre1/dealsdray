// import 'package:dealsdray/screens/referral/referral_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/phone_input_screen.dart';
import 'screens/otp_verification_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/home/home_screen.dart';

void main() async {
  runApp(ProviderScope(child: DealsDrayApp()));
}

class DealsDrayApp extends StatelessWidget {
  const DealsDrayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DealsDray',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Montserrat', // or default
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/phone': (context) => PhoneInputScreen(),
        '/otp': (context) => OtpVerificationScreen(),
        '/register': (context) => RegistrationScreen(),
        '/home': (context) => HomeScreen(),
        // '/referral': (context) => ReferralScreen(),
      },
    );
  }
}
