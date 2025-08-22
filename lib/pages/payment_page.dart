import 'package:delivery_app/models/resturant.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart'; // Import Flutterwave
import 'package:url_launcher/url_launcher.dart';
import '../../components/my_button.dart';
import '../../pages/delivery_progress_page.dart';
import '../components/my_receipt.dart';
import '../navigator_key/navigator.dart';
import '../services/auth/auth_service.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentPage extends StatefulWidget {
  final String? reference; // Add reference parameter

  PaymentPage({super.key, this.reference}); // Make reference optional

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final String userId = AuthService().getCurrentUser()!.uid;
  final String? useremail = AuthService().getCurrentUser()!.email;

  // initialize
  @override
  void initState() {
    super.initState();
    if (widget.reference != null) {
      //Verify payment if reference is passed.
      verifyPayment(context, widget.reference ?? "");
    }
  }

  String generateOrderId() {
    String orderRef = "${userId}_${DateTime.now().millisecondsSinceEpoch}";
    return orderRef;
  }

  int _formatPrice() {
    Resturant? resturantProvider = Provider.of<Resturant>(
      context,
      listen: false,
    );

    double price = resturantProvider.getTotalPrice();
    int formattedPrice = ((price)).toInt();
    return formattedPrice;
  }

  // get total items
  String getTotalItems() {
    String totalItems =
        Provider.of<Resturant>(context, listen: false).displayCartReceipt();
    return totalItems;
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000//paystack/verify/8r2988273'),
      ); // Replace with your URL
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void userTapped() async {
    print(
      'Sending R E Q U E S T to: http://192.168.96.153:8000/paystack/initialize/',
    );
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
    if (userId == AuthService().getCurrentUser()!.uid) {
      final dynamic url;
      url = Uri.parse('http://192.168.96.153:8080/paystack/initialize/');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": useremail!, "amount": _formatPrice()}),
      );
      print('Request headers: ${response.request?.headers}');
      print(
        'Request body: ${jsonEncode({"email": useremail!, "amount": _formatPrice()})}',
      );
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final Uri checkoutUri = Uri.parse(data["data"]["authorization_url"]);

        try {
          if (await canLaunchUrl(checkoutUri)) {
            await launchUrl(checkoutUri, mode: LaunchMode.externalApplication);
            // Registration successful: Dismiss the loading dialog
            NavigationService.navigatorKey.currentState!.pop();
          } else {
            throw 'Could not launch $checkoutUri';
          }
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Error launching URL: $e")));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment initialization failed")),
        );
      }
    }
  }

  Future<void> verifyPayment(BuildContext context, String reference) async {
    print(
      "Starting payment verification for reference: $reference",
    ); // Log the start

    final url = Uri.parse(
      'http://192.168.96.153:8080/paystack/verify/$reference',
    );

    print("Verification URL: $url"); // Log the URL

    try {
      final response = await http.get(url);

      print(
        "Verification response status code: ${response.statusCode}",
      ); // Log status code

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == "success") {
          // Change this line
          // Payment was successful
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Payment successful!")));

          // Navigate to a success page or update UI

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DeliveryProgressPage()),
          );

          // clear cart after payment
        } else {
          // Payment failed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Payment failed! Please try again.")),
          );
          print("Payment verification failed: ${data["message"]}");
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Payment verification failed! Status code: ${response.statusCode}",
            ),
          ),
        );
        print(
          "Payment verification API call failed with status code: ${response.statusCode}",
        );
      }
    } catch (e) {
      print("Error during payment verification: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Payment verification failed! An error occurred."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout"), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MyReceipt(
                    receiptHeader:
                        "Scroll to Confirm Your order details before proceeding",
                    fontFamily: "fake",
                  ),
                ],
              ),
            ),
            MyButton(buttonText: "Pay Now", onTap: () => userTapped()),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
