import 'package:flutter/material.dart';
import 'package:memberlink_app/views/events/new_event.dart';
import 'package:memberlink_app/views/shared/mydrawer.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Events",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Ensure white color for the title
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Ensure white color for icons
        ),
        backgroundColor: Colors.transparent, // Transparent background
        elevation: 0, // No shadow for a cleaner look
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 142, 28, 177),
                Colors.purpleAccent,
                Color.fromARGB(255, 245, 116, 174),
              ],
              begin: Alignment.topLeft, // Starting point of the gradient
              end: Alignment.bottomRight, // Ending point of the gradient
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 240, 211, 245),
              Color.fromARGB(255, 240, 211, 245)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const Center(
          child: Text(
            "Events...",
            style: TextStyle(
              fontSize: 16,
              //fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
        ),
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (content) => const NewEventScreen()),
          );
        },
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(50), // Ensures the button is fully circular
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
