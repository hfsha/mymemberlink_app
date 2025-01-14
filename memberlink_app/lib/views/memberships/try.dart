import 'package:flutter/material.dart';
import 'package:memberlink_app/models/user.dart';

// class Try extends StatefulWidget {
//   // final User user; // The user object passed to this widget.

//   // const Try({super.key, required this.user});

//   final User? user; // Make user nullable

//   const Try({super.key, this.user});

//   @override
//   State<Try> createState() => _TryState();
// }

// class _TryState extends State<Try> {
//   @override
//   Widget build(BuildContext context) {
//     // Retrieve and validate the user's email
//     String userEmail =
//         (widget.user.email != null && widget.user.email!.isNotEmpty)
//             ? widget.user.email!
//             : "No email available"; // Default message for null or empty email

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Email Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Display the user's email or a default message
//             Text('User Email: $userEmail'),
//             const SizedBox(height: 20),
//             // Button to print the user's email to the console
//             ElevatedButton(
//               onPressed: () {
//                 // Print email to console for debugging
//                 debugPrint("User email: $userEmail");
//               },
//               child: const Text('Print Email'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class Try extends StatefulWidget {
  final User? user; // Make user nullable

  const Try({super.key, this.user});

  @override
  State<Try> createState() => _TryState();
}

class _TryState extends State<Try> {
  @override
  Widget build(BuildContext context) {
    String userEmail =
        widget.user?.email ?? "No email available"; // Handle null user

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Email Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('User Email: $userEmail'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                debugPrint("User email: $userEmail");
              },
              child: const Text('Print Email'),
            ),
          ],
        ),
      ),
    );
  }
}
