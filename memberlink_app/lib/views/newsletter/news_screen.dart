import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memberlink_app/models/news.dart';
import 'package:memberlink_app/myconfig.dart';
import 'package:memberlink_app/views/newsletter/edit_news.dart';
import 'package:memberlink_app/views/newsletter/new_news.dart';
import 'package:memberlink_app/views/shared/mydrawer.dart';
import 'package:http/http.dart' as http;

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<News> newsList = [];
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  int numofpage = 1;
  int curpage = 1;
  int numofresult = 0;
  String searchQuery = "";
  final TextEditingController searchController = TextEditingController();
  late double screenWidth, screenHeight;

  @override
  void initState() {
    super.initState();
    loadNewsData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Newsletter",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            onPressed: () {
              loadNewsData();
            },
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: newsList.isEmpty
          ? const Center(
              child: Text("Loading...", style: TextStyle(color: Colors.grey)),
            )
          : Stack(
              children: [
                Column(
                  children: [
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          searchQuery = value;
                          curpage = 1; // Reset to the first page for search
                          loadNewsData(); // Reload with search query
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search,
                              color: Color.fromARGB(255, 110, 26, 125)),
                          suffixIcon: searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: Colors.purple),
                                  onPressed: () {
                                    searchController.clear();
                                    searchQuery = "";
                                    loadNewsData();
                                  },
                                )
                              : null,
                          hintText: "Search news by title...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.purple),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.purple),
                          ),
                        ),
                      ),
                    ),
                    Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 238, 223, 241),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(0.2), // Shadow color
                              offset: const Offset(
                                  2, 4), // Horizontal and vertical offset
                              blurRadius: 6, // Blur radius for the shadow
                            ),
                          ],
                          borderRadius: BorderRadius.circular(
                              0), // Optional: Adds rounded corners
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        alignment: Alignment.center,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: "Page: ",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 118, 29, 134),
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: "$curpage",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              const TextSpan(
                                text: "    |    Results: ",
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 118, 29, 134),
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: "$numofresult",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            ],
                          ),
                        )),

                    Expanded(
                      child: ListView.builder(
                        itemCount: newsList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8.0),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              onLongPress: () {
                                deleteDialog(index);
                              },
                              contentPadding: const EdgeInsets.all(12.0),
                              leading: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.purple.shade100,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(
                                          0.5), // Dark shadow for inset effect
                                      offset: const Offset(-2,
                                          -2), // Negative offset for inward shadow
                                      blurRadius:
                                          6, // Soft blur to create an inset effect
                                      spreadRadius:
                                          -6, // Negative spread radius to push shadow inside
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.purple
                                      .shade100, // Light purple background
                                  radius: 22, // Size of the avatar
                                  child: const Icon(
                                    Icons.email_outlined, // The email icon
                                    color: Colors.purple,
                                    size: 24, // Icon size
                                  ),
                                ),
                              ),
                              title: Text(
                                truncateString(
                                    newsList[index].newsTitle.toString(), 30),
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 110, 38, 123),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(
                                    top:
                                        4.0), // Space between title and subtitle
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      df.format(DateTime.parse(
                                          newsList[index].newsDate.toString())),
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                    const SizedBox(
                                        height:
                                            6), // Space between date and details
                                    Text(
                                      truncateString(
                                          newsList[index]
                                              .newsDetails
                                              .toString(),
                                          100),
                                      style: const TextStyle(fontSize: 14),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ],
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18,
                                  color: Colors.purple,
                                ),
                                onPressed: () {
                                  showNewsDetailsDialog(index);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    Container(
                      color: Colors.purple,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Previous Button
                          IconButton(
                            icon: const Icon(Icons.arrow_left,
                                color: Colors.white),
                            onPressed: (curpage > 1)
                                ? () {
                                    setState(() {
                                      curpage--;
                                      loadNewsData();
                                    });
                                  }
                                : null,
                          ),
                          // Page Numbers
                          Row(
                            children: List.generate(
                              (numofpage <= 4) ? numofpage : 4,
                              (index) {
                                int pageNumber = (curpage <= 2)
                                    ? index + 1
                                    : curpage + index - 2;

                                if (curpage > numofpage - 2) {
                                  pageNumber = numofpage - 3 + index;
                                }

                                return pageNumber > 0 && pageNumber <= numofpage
                                    ? TextButton(
                                        onPressed: () {
                                          setState(() {
                                            curpage = pageNumber;
                                            loadNewsData();
                                          });
                                        },
                                        child: Text(
                                          '$pageNumber',
                                          style: TextStyle(
                                            color: curpage == pageNumber
                                                ? Colors.white
                                                : Colors.white70,
                                            fontWeight: curpage == pageNumber
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink();
                              },
                            ),
                          ),
                          // Next Button
                          IconButton(
                            icon: const Icon(Icons.arrow_right,
                                color: Colors.white),
                            onPressed: (curpage < numofpage)
                                ? () {
                                    setState(() {
                                      curpage++;
                                      loadNewsData();
                                    });
                                  }
                                : null,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                // Floating Action Button positioned above pagination bar
                Positioned(
                  bottom: 50,
                  left: screenWidth / 2 - 30,
                  child: FloatingActionButton(
                    backgroundColor: const Color.fromARGB(255, 247, 244, 244),
                    onPressed: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (content) => const NewNewsScreen()));
                      loadNewsData();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.purple,
                    ),
                  ),
                ),
              ],
            ),
      drawer: const MyDrawer(),
    );
  }

  String truncateString(String str, int length) {
    if (str.length > length) {
      return "${str.substring(0, length)}...";
    }
    return str;
  }

  void loadNewsData() {
    final url = Uri.parse(
        "${Myconfig.servername}/mymemberlink_backend/load_news.php?pageno=$curpage&search=$searchQuery");
    http.get(url).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          var result = data['data']['news'];
          newsList.clear();
          for (var item in result) {
            News news = News.fromJson(item);
            newsList.add(news);
          }
          setState(() {
            numofpage = int.parse(data['numofpage'].toString());
            numofresult = int.parse(data['numberofresult'].toString());
          });
        }
      }
    });
  }

  void showNewsDetailsDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(newsList[index].newsTitle.toString(),
              style: const TextStyle(color: Colors.purple)),
          content: Text(newsList[index].newsDetails.toString(),
              textAlign: TextAlign.justify),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) =>
                          EditNewsScreen(news: newsList[index])),
                );
                loadNewsData();
              },
              child: const Text("Edit",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.purple,
                      fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Close",
                  style: TextStyle(fontSize: 16, color: Colors.purple)),
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
          title: const Text("Delete News"),
          content: const Text("Are you sure you want to delete this news?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  const Text("Cancel", style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                deleteNews(index);
              },
              child: const Text("Delete",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void deleteNews(int index) {
    final url = Uri.parse(
        "${Myconfig.servername}/mymemberlink_backend/delete_news.php");
    http.post(url, body: {"newsid": newsList[index].newsId}).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          setState(() {
            loadNewsData();
          });
        }
      }
    });
  }
}
