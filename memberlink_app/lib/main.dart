import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:memberlink_app/views/splash_screen.dart';
import 'package:memberlink_app/provider/cart_provider.dart'; // Import CartProvider
import 'package:provider/provider.dart'; // Import provider

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  EmailOTP.config(
    appName: 'MyMemberLink',
    otpType: OTPType.numeric,
    emailTheme: EmailTheme.v2,
    otpLength: 4,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(), // Provide CartProvider at the root
      child: const MainApp(),
    ),
  );
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
