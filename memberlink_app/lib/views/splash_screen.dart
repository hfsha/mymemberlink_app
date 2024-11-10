import 'package:flutter/material.dart';
import 'package:memberlink_app/views/login_screen.dart';
import 'package:memberlink_app/views/register_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            SizedBox(
              height: 150,
            ),
            const Image(image: AssetImage('assets/images/logo.png')),
            MaterialButton(
                elevation: 10,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => const LoginScreen()));
                },
                minWidth: 400,
                height: 50,
                color: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text("Login",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold))),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
                elevation: 10,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => const RegisterScreen()));
                },
                minWidth: 400,
                height: 50,
                color: const Color.fromARGB(255, 231, 145, 247),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text("Sign Up",
                    style: TextStyle(
                        color: Color.fromARGB(255, 54, 48, 48),
                        fontSize: 17,
                        fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    ));
  }
}
