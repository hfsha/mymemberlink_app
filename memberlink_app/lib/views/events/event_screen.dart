import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memberlink_app/models/myevent.dart';
import 'package:memberlink_app/myconfig.dart';
import 'package:memberlink_app/views/events/edit_event.dart';
import 'package:memberlink_app/views/events/new_event.dart';
import 'package:memberlink_app/views/shared/mydrawer.dart';
import 'package:http/http.dart' as http;

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  List<MyEvent> eventsList = [];
  late double screenWidth, screenHeight;
  final DateFormat df = DateFormat('dd/MM/yyyy hh:mm a');
  String status = "Loading...";

  @override
  void initState() {
    super.initState();
    loadEventsData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Events",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 142, 28, 177),
                Colors.purpleAccent,
                Color.fromARGB(255, 245, 116, 174),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: loadEventsData,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 240, 211, 245),
              Color.fromARGB(255, 240, 211, 245),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: eventsList.isEmpty
            ? Center(
                child: Text(
                  status,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                children: List.generate(eventsList.length, (index) {
                  return Card(
                    child: InkWell(
                      splashColor: Colors.purpleAccent,
                      onLongPress: () => deleteDialog(index),
                      onTap: () => showEventDetailsDialog(index),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              eventsList[index].eventTitle.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              child: Image.network(
                                "${Myconfig.servername}/mymemberlink_backend/assets/events/${eventsList[index].eventFilename}",
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset(
                                  "assets/images/na.png",
                                  height: screenHeight / 6,
                                ),
                                width: screenWidth / 2,
                                height: screenHeight / 6,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              eventsList[index].eventType.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              df.format(DateTime.parse(
                                  eventsList[index].eventDate.toString())),
                            ),
                            Text(
                              truncateString(
                                eventsList[index].eventDescription.toString(),
                                45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
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
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Icon(Icons.add, color: Colors.purple),
      ),
    );
  }

  String truncateString(String str, int length) {
    return (str.length > length) ? "${str.substring(0, length)}..." : str;
  }

  void loadEventsData() {
    http
        .get(Uri.parse(
            "${Myconfig.servername}/mymemberlink_backend/load_events.php"))
        .then((response) {
      log(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          var result = data['data']['events'];
          eventsList.clear();
          for (var item in result) {
            eventsList.add(MyEvent.fromJson(item));
          }
          setState(() {});
        } else {
          setState(() => status = "No Data");
        }
      } else {
        setState(() => status = "Error loading data");
      }
    });
  }

  void showEventDetailsDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(eventsList[index].eventTitle.toString()),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Image.network(
                  "${Myconfig.servername}/mymemberlink_backend/assets/events/${eventsList[index].eventFilename}",
                  errorBuilder: (context, error, stackTrace) =>
                      Image.asset("assets/images/na.png"),
                  width: screenWidth,
                  height: screenHeight / 4,
                  fit: BoxFit.cover,
                ),
                Text(eventsList[index].eventType.toString()),
                Text(df.format(
                    DateTime.parse(eventsList[index].eventDate.toString()))),
                const SizedBox(height: 10),
                Text(
                  eventsList[index].eventDescription.toString(),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                MyEvent myevent = eventsList[index];
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (content) => EditEventScreen(myevent: myevent),
                  ),
                );
                loadEventsData();
              },
              child: const Text("Edit Event"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void deleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Delete \"${truncateString(eventsList[index].eventTitle.toString(), 20)}\"",
            style: const TextStyle(fontSize: 18),
          ),
          content: const Text("Are you sure you want to delete this event?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                deleteNews(index);
                Navigator.pop(context);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  void deleteNews(int index) {
    http.post(
      Uri.parse("${Myconfig.servername}/mymemberlink_backend/delete_event.php"),
      body: {"eventid": eventsList[index].eventId.toString()},
    ).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        log(data.toString());
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Success"),
            backgroundColor: Colors.green,
          ));
          loadEventsData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }
}
