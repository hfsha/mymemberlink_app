import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:memberlink_app/views/splash_screen.dart';
// import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  EmailOTP.config(
    appName: 'MyMemberLink',
    otpType: OTPType.numeric,
    emailTheme: EmailTheme.v2,
    otpLength: 4,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
