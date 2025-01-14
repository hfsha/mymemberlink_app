import 'package:flutter/material.dart';
import 'package:memberlink_app/models/membership.dart';
import 'package:memberlink_app/models/user.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'membership_history_screen.dart'; // Import your history screen

class PaymentMembership extends StatefulWidget {
  final Membership membership;
  final User user;

  const PaymentMembership({
    super.key,
    required this.membership,
    required this.user,
  });

  @override
  State<PaymentMembership> createState() => _PaymentMembershipState();
}

class _PaymentMembershipState extends State<PaymentMembership> {
  late WebViewController _controller;
  late double _progress;

  @override
  void initState() {
    super.initState();

    // Fetching and safely unwrapping user and membership details
    String email = widget.user.email ?? '';
    String phone = widget.user.phone ?? '';
    String fullname = widget.user.fullName ?? '';
    String userid = widget.user.userId?.toString() ?? '0';
    String amount = widget.membership.price?.toString() ?? '0';
    String membershipId = widget.membership.membershipId?.toString() ?? '0';

    // Logging the values for debugging
    print("User email: $email");
    print("User phone: $phone");
    print("User full name: $fullname");
    print("User ID: $userid");
    print("Membership ID: $membershipId");
    print("Membership amount: $amount");

    // Validating required fields
    if (email.isEmpty ||
        phone.isEmpty ||
        fullname.isEmpty ||
        userid.isEmpty ||
        membershipId.isEmpty ||
        amount.isEmpty) {
      print("Error: One or more parameters are missing!");
      return;
    }

    // Constructing the payment URL
    final Uri url = Uri.https(
      'humancc.site',
      '/shahidatulhidayah/mymemberlink_backend/payment.php',
      {
        'email': email,
        'phone': phone,
        'fullname': fullname,
        'membershipid': membershipId,
        'usersid': userid,
        'amount_paid': amount,
      },
    );

    print("Constructed URL: ${url.toString()}");

    // Initializing the WebViewController and setting up navigation
    _progress = 0;
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _progress = progress / 100;
            });
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            print('Error loading page: ${error.description}');
          },
        ),
      )
      ..loadRequest(url);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate to the membership history screen instead of going back
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MembershipHistoryScreen(
                    user:
                        widget.user), // Replace with your actual screen widget
              ),
            );
          },
        ),
        title: Text('Payment Membership'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6.0),
          child: LinearProgressIndicator(
            backgroundColor: theme.colorScheme.onPrimary,
            valueColor:
                AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            value: _progress,
          ),
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
