import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:memberlink_app/myconfig.dart';

class NewNewsScreen extends StatefulWidget {
  const NewNewsScreen({super.key});

  @override
  State<NewNewsScreen> createState() => _NewNewsScreenState();
}

class _NewNewsScreenState extends State<NewNewsScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  late double screenWidth, screenHeight;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "New Newsletter",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.purple,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Color.fromARGB(255, 81, 22, 92)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.email_outlined,
                    color: Colors.yellow.withOpacity(0.9), // Semi-transparent.
                    size: 50,
                  ),
                  const SizedBox(height: 8), // Adjust spacing if necessary.
                  const Text(
                    "Fill in the details below to create a new newsletter.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    textAlign:
                        TextAlign.center, // Center-align the text itself.
                  ),
                ],
              ),
              //const SizedBox(height: 10),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: "News Title",
                  hintStyle: const TextStyle(color: Colors.black54),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: screenHeight * 0.5,
                child: TextField(
                  controller: detailsController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "News Details",
                    hintStyle: const TextStyle(color: Colors.black54),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              MaterialButton(
                elevation: 10,
                onPressed: onInsertNewsDialog,
                minWidth: screenWidth,
                height: 50,
                color: const Color.fromARGB(255, 232, 215, 60),
                child: const Text(
                  "Insert Newsletter",
                  style: TextStyle(
                    color: Color.fromARGB(255, 57, 42, 59),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  void onInsertNewsDialog() {
    if (titleController.text.isEmpty || detailsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter both title and details"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Text("Insert this newsletter?"),
          content: const Text("Are you sure you want to add this news?"),
          actions: [
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(color: Colors.purple),
              ),
              onPressed: () {
                insertNews();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(color: Colors.purple),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void insertNews() {
    String title = titleController.text;
    String details = detailsController.text;

    http.post(
      Uri.parse("${Myconfig.servername}/mymemberlink_backend/insert_news.php"),
      body: {
        "title": title,
        "details": details,
      },
    ).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("News added successfully"),
            backgroundColor: Colors.green,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Failed to add news"),
            backgroundColor: Colors.red,
          ));
        }
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $error"),
          backgroundColor: Colors.red,
        ),
      );
    });
  }
}
