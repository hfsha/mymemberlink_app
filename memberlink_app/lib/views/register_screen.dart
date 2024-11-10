import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:memberlink_app/myconfig.dart';
import 'package:memberlink_app/views/login_screen.dart';
// import 'package:memberlink_app/views/main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController fullnamecontroller = TextEditingController();
  TextEditingController confirmPasswordcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Let's register!",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple),
                ),
                const Image(
                  image: AssetImage('assets/images/signup.png'),
                  height: 160,
                ),
                // SizedBox(10),
                TextField(
                  controller: fullnamecontroller,
                  style: const TextStyle(fontSize: 13),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: "Full name",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.purple,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: phonecontroller,
                  style: const TextStyle(fontSize: 13),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: "Phone number",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Colors.purple,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: emailcontroller,
                  style: const TextStyle(fontSize: 13),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: "Email",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.purple,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: passwordcontroller,
                  obscureText: obscurePassword,
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
                        color: Colors.purple,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: confirmPasswordcontroller,
                  obscureText: obscureConfirmPassword,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: "Confirmation Password",
                    hintStyle:
                        const TextStyle(color: Colors.grey, fontSize: 13),
                    prefixIcon: const Icon(Icons.lock, color: Colors.purple),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.purple,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureConfirmPassword = !obscureConfirmPassword;
                        });
                      },
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                CheckboxListTile(
                  title: const Text(
                    "I agree to the Terms and Conditions",
                    style: TextStyle(fontSize: 12),
                  ),
                  value: agreedToTerms,
                  onChanged: (bool? value) {
                    setState(() {
                      agreedToTerms = value ?? false;
                    });
                  },
                ),
                MaterialButton(
                  elevation: 10,
                  onPressed: () async {
                    if (!agreedToTerms) {
                      // Show a SnackBar if the terms and conditions checkbox is not ticked
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            "Please agree to the Terms and Conditions to register."),
                        backgroundColor: Colors.red,
                      ));
                      return;
                    }

                    // Proceed with the registration if the checkbox is ticked
                    bool registrationSuccessful = await onRegisterDialog();
                    if (registrationSuccessful) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    }
                  },
                  minWidth: 400,
                  height: 50,
                  color: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already Have An Account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (content) => const LoginScreen()));
                      },
                      child: const Text(
                        "Login",
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

  Future<bool> onRegisterDialog() async {
    String fullname = fullnamecontroller.text;
    String email = emailcontroller.text;
    String password = passwordcontroller.text;
    String phone = phonecontroller.text;
    String confirmationPassword = passwordcontroller.text;

    if (email.isEmpty ||
        password.isEmpty ||
        fullname.isEmpty ||
        phone.isEmpty ||
        confirmationPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter all required information."),
      ));
      return false;
    }

    if (fullname.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Full Name must be at least 3 characters long."),
        backgroundColor: Colors.red,
      ));
      return false;
    }

    RegExp phoneRegex = RegExp(r'^(01)[0-9]{8,10}$');
    if (!phoneRegex.hasMatch(phonecontroller.text)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter a valid Malaysian phone number."),
        backgroundColor: Colors.red,
      ));
      return false;
    }

    RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter a valid email address."),
        backgroundColor: Colors.red,
      ));
      return false;
    }

    RegExp passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    if (!passwordRegex.hasMatch(password)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            "Password must be at least 8 characters long and include letters and numbers."),
        backgroundColor: Colors.red,
      ));
      return false;
    }

    if (password != confirmationPassword) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Passwords do not match."),
        backgroundColor: Colors.red,
      ));
      return false;
    }

    // Show confirmation dialog
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text("Register new account?"),
          content: const Text("Are you sure?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return false;
    }

    bool success = await userRegistration();
    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      return true;
    }
    return false;
  }

  Future<bool> userRegistration() async {
    String email = emailcontroller.text;
    String password = passwordcontroller.text;
    String fullname = fullnamecontroller.text;
    String phone = phonecontroller.text;

    final response = await http.post(
      Uri.parse("${Myconfig.servername}/mymemberlink_backend/register.php"),
      body: {
        "fullname": fullname,
        "phone": phone,
        "email": email,
        "password": password,
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Registration Success"),
          backgroundColor: Color.fromARGB(255, 12, 12, 12),
        ));
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Registration Failed"),
          backgroundColor: Colors.red,
        ));
        return false;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error connecting to server."),
        backgroundColor: Colors.red,
      ));
      return false;
    }
  }
}
