import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:memberlink_app/models/news.dart';
import 'package:memberlink_app/models/user.dart';
import 'package:memberlink_app/views/auth/login_screen.dart';
import 'package:memberlink_app/views/events/event_screen.dart';
import 'package:memberlink_app/views/memberships/membership_screen.dart';
import 'package:memberlink_app/views/newsletter/news_screen.dart';
import 'package:memberlink_app/views/products/product_screen.dart';
import 'package:memberlink_app/views/shared/mydrawer.dart';
import 'package:memberlink_app/myconfig.dart';
import 'package:http/http.dart' as http;
//import 'news_screen.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});
  // const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<News> newsList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadNewsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: MyDrawer(user: widget.user),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(),
            const SizedBox(height: 20),
            _buildMainButtonsGrid(context),
            const SizedBox(height: 20),
            _buildNewsSection(),
          ],
        ),
      ),
    );
  }

  // App Bar
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        "Home",
        style: TextStyle(color: Colors.white),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              // Color.fromARGB(255, 142, 28, 177),
              Colors.purpleAccent,
              // Colors.purple[800]!,
              // Colors.purple[400]!,
              const Color.fromARGB(255, 122, 47, 169)!,
              Colors.purple[800]!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          onPressed: () {
            _logout(context);
          },
        ),
      ],
    );
  }

// Welcome Section
  Widget _buildWelcomeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Text(
              'Welcome ${widget.user.fullName ?? "to MemberLink"}!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Image.asset(
              'assets/images/changepass.png',
              height: 200,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.image_not_supported,
                  size: 200,
                  color: Colors.grey,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainButtonsGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Quick Access",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 142, 28, 177),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildGridView(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Colors.white,
              Color.fromARGB(255, 238, 223, 241),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 4),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Newsletter",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 10),
            _buildNewsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView(BuildContext context) {
    final List<Map<String, dynamic>> buttons = [
      {
        'label': 'Newsletter',
        'icon': Icons.mail_outline,
        'screen': NewsScreen(user: widget.user)
      },
      {
        'label': 'Event',
        'icon': Icons.event,
        'screen': EventScreen(user: widget.user)
      },
      {
        'label': 'Product',
        'icon': Icons.shopping_bag_outlined,
        'screen': ProductScreen(user: widget.user)
      },
      {
        'label': 'Membership',
        'icon': Icons.card_membership,
        'screen': MembershipScreen(user: widget.user)
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 25,
        mainAxisSpacing: 20,
        childAspectRatio: 1.0,
      ),
      itemCount: buttons.length,
      itemBuilder: (context, index) {
        return _buildGridButton(
          context,
          buttons[index]['label'],
          buttons[index]['icon'],
          buttons[index]['screen'],
        );
      },
    );
  }

  Widget _buildGridButton(
      BuildContext context, String label, IconData icon, Widget screen) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.black.withOpacity(0.2),
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(0),
      ),
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.purpleAccent, Colors.deepPurple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 36),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsList() {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: newsList.take(5).map((news) {
              return _buildNewsItem(
                title: news.newsTitle ?? '',
                date: news.newsDate ?? '',
                details: news.newsDetails ?? '',
              );
            }).toList(),
          );
  }

  Widget _buildNewsItem(
      {required String title, required String date, required String details}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: Colors.purple.shade100,
          child: const Icon(Icons.email_outlined, color: Colors.purple),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              details,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  void loadNewsData() {
    final url = Uri.parse(
        "${Myconfig.servername}/mymemberlink_backend/load_news.php?pageno=1");
    http.get(url).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          var result = data['data']['news'];
          setState(() {
            newsList = result.map<News>((item) => News.fromJson(item)).toList();
            isLoading = false;
          });
        }
      }
    });
  }

  // Logout Dialog
  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
            ),
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
