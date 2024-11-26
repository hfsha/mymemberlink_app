import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:memberlink_app/myconfig.dart';
import 'package:memberlink_app/views/auth/forgotpass_screen.dart';
//import 'package:memberlink_app/views/events/event_screen.dart';
//import 'package:memberlink_app/views/main_screen.dart';
import 'package:memberlink_app/views/auth/register_screen.dart';
import 'package:memberlink_app/views/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  bool rememberme = false;
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Text(
                  "Welcome back!",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple),
                ),
                const Image(image: AssetImage('assets/images/loginpage.png')),
                TextField(
                  controller: emailcontroller,
                  style: const TextStyle(fontSize: 13),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: "Email",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                    prefixIcon:
                        Icon(Icons.email_outlined, color: Colors.purple),
                    contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: passwordcontroller,
                  obscureText: obscurePassword, // Controls password visibility
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: "Password",
                    hintStyle:
                        const TextStyle(color: Colors.grey, fontSize: 13),
                    prefixIcon: const Icon(Icons.lock, color: Colors.purple),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword =
                              !obscurePassword; // Toggle visibility
                        });
                      },
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                  ),
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: rememberme,
                          onChanged: (bool? value) {
                            setState(() {
                              String email = emailcontroller.text;
                              String pass = passwordcontroller.text;
                              if (value!) {
                                if (email.isNotEmpty && pass.isNotEmpty) {
                                  storeSharedPrefs(value, email, pass);
                                } else {
                                  rememberme = false;
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content:
                                        Text("Please enter your credentials"),
                                    backgroundColor: Colors.red,
                                  ));
                                  return;
                                }
                              } else {
                                email = "";
                                pass = "";
                                storeSharedPrefs(value, email, pass);
                              }
                              rememberme = value;
                              setState(() {});
                            });
                          },
                        ),
                        const Text("Remember me"),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (content) => const ForgotpassScreen()),
                        );
                      },
                      child: const Text(
                        "Forgot password?",
                        style: TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
                MaterialButton(
                    elevation: 10,
                    onPressed: () {
                      onLogin();
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
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (content) => const RegisterScreen()),
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validateEmail(String email) {
    RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool validatePassword(String password) {
    RegExp passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    return passwordRegex.hasMatch(password);
  }

  void onLogin() {
    String email = emailcontroller.text;
    String password = passwordcontroller.text;
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter email and password"),
      ));
      return;
    }
    http.post(
        Uri.parse("${Myconfig.servername}/mymemberlink_backend/login.php"),
        body: {"email": email, "password": password}).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Login Success"),
            backgroundColor: Colors.green,
          ));
          Navigator.push(context,
              MaterialPageRoute(builder: (content) => const MainScreen()));
          //MaterialPageRoute(builder: (content) => const EventScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Login Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }

  Future<void> storeSharedPrefs(bool value, String email, String pass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      prefs.setString("email", email);
      prefs.setString("password", pass);
      prefs.setBool("rememberme", value);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Preferences Stored"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ));
    } else {
      prefs.remove("email");
      prefs.remove("password");
      prefs.remove("rememberme");
      emailcontroller.clear();
      passwordcontroller.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Preferences Removed"),
        backgroundColor: Colors.red,
      ));
    }
  }
}
