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
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            onPressed: () {
              // loadNewsData();
            },
            icon: const Icon(
              Icons.refresh,
              color: Colors.white, // Set the color to white
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text("Events..."),
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (content) => const NewEventScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
