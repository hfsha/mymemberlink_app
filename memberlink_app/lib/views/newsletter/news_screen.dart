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
  DateTime? startDate;
  DateTime? endDate;

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
      backgroundColor: const Color.fromARGB(255, 240, 211, 245),
      appBar: AppBar(
        title: const Text(
          "Newsletter",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors
            .transparent, // Set to transparent to let the gradient show through
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 142, 28, 177),
                Colors.purpleAccent,
                Color.fromARGB(255, 245, 116, 174)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Reset filters and pagination
              resetFilters(); // Ensure filters are reset
              loadNewsData(); // Reload the news with default settings
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
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color.fromARGB(255, 40, 39, 39),
                          ),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize
                                .min, // Ensures the icons don't expand too much
                            children: [
                              if (searchQuery.isNotEmpty)
                                IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: Color.fromARGB(255, 40, 39, 39)),
                                  onPressed: () {
                                    searchController.clear();
                                    searchQuery = "";
                                    loadNewsData();
                                  },
                                ),
                              IconButton(
                                icon: const Icon(Icons.filter_list,
                                    color: Color.fromARGB(255, 40, 39, 39)),
                                onPressed: () {
                                  showDateRangePickerDialog();
                                },
                              ),
                            ],
                          ),
                          hintText: "Search news by title...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                    ),

                    Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 240, 211, 245),
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
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 142, 28, 177),
                            Colors.purpleAccent,
                            Color.fromARGB(255, 245, 116, 174)
                          ], // Set your gradient colors here
                          begin:
                              Alignment.topLeft, // Gradient starting position
                          end:
                              Alignment.bottomRight, // Gradient ending position
                        ),
                      ),
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
                                      loadNewsDataWithDateRange(page: curpage);
                                    });
                                  }
                                : null,
                          ),
                          // Page Numbers
                          Row(
                            children: List.generate(
                              // Calculate the total number of pages to display (max 3 pages at a time)
                              (numofpage <= 3)
                                  ? numofpage
                                  : 4, // Ensure we show a maximum of 3 pages
                              (index) {
                                // Page number calculation: Always show 3 pages centered around the current page
                                int pageNumber = curpage - 1 + index;

                                // Adjust the visible pages if we're near the start or end
                                if (curpage == 1) {
                                  pageNumber = index +
                                      1; // Show 1, 2, 3 if we're at the beginning
                                } else if (curpage == numofpage) {
                                  pageNumber = numofpage -
                                      2 +
                                      index; // Show last 3 pages if we're at the end
                                }

                                // Ensure the page number is within valid bounds
                                if (pageNumber > 0 && pageNumber <= numofpage) {
                                  return TextButton(
                                    onPressed: () {
                                      setState(() {
                                        curpage = pageNumber;
                                        loadNewsDataWithDateRange(
                                            page:
                                                curpage); // Reload data on page change
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
                                  );
                                }
                                return const SizedBox
                                    .shrink(); // Return an empty widget if the page number is invalid
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
                                      loadNewsDataWithDateRange(page: curpage);
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
          setState(() {
            newsList.clear();
            for (var item in result) {
              News news = News.fromJson(item);
              newsList.add(news);
            }
            numofpage = int.parse(data['numofpage'].toString());
            numofresult = int.parse(data['numberofresult'].toString());
          });
        }
      }
    });
  }

  void loadNewsDataWithDateRange({int page = 1}) {
    final url = Uri.parse(
        "${Myconfig.servername}/mymemberlink_backend/load_news.php?pageno=$page&search=$searchQuery"
        "&start_date=${startDate != null ? DateFormat('yyyy-MM-dd').format(startDate!) : ''}"
        "&end_date=${endDate != null ? DateFormat('yyyy-MM-dd').format(endDate!) : ''}");

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
            curpage = page; // Ensure current page is correctly updated
          });
        }
      }
    });
  }

  void showDateRangePickerDialog() async {
    // Open the date picker for the start date
    DateTime? selectedStartDate = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedStartDate != null) {
      // If a start date is selected, set it
      setState(() {
        startDate = selectedStartDate;
      });

      // Open the date picker for the end date
      DateTime? selectedEndDate = await showDatePicker(
        context: context,
        initialDate: endDate ?? DateTime.now(),
        firstDate: selectedStartDate, // Ensure end date is after start date
        lastDate: DateTime(2101),
      );

      if (selectedEndDate != null) {
        // If an end date is selected, set it
        setState(() {
          endDate = selectedEndDate;
        });

        // Reload news data with the selected date range filter
        loadNewsDataWithDateRange();
      }
    }
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

  void resetFilters() {
    setState(() {
      searchController.clear();
      searchQuery = "";
      startDate = null;
      endDate = null;
      curpage = 1; // Reset page to the first page
    });
    loadNewsData();
  }
}
