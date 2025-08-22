import 'package:delivery_app/components/my_receipt.dart';
import 'package:delivery_app/models/resturant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../navigator_key/navigator.dart';
import '../services/database/hive_firestore.dart'; // Make sure this is correctly implemented

class DeliveryProgressPage extends StatefulWidget {
  const DeliveryProgressPage({super.key});

  @override
  State<DeliveryProgressPage> createState() => _DeliveryProgressPageState();
}

class _DeliveryProgressPageState extends State<DeliveryProgressPage> {
  // clear after payment
  void clearCartAfterPayment() {
    Provider.of<Resturant>(context, listen: false).clearCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      // bottomNavigationBar: _buildBottomNavBar(context),
      appBar: AppBar(
        title: Text("Delivery in Progress"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
          onPressed: () async {
            showDialog(
              context: context,
              builder: (context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
            try {
              await createOrder(context);
              // Registration successful: Dismiss the loading dialog
              NavigationService.navigatorKey.currentState!.pop();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Order placed successfully!')),
              );
              Navigator.pushReplacementNamed(context, "/auth_gate");
              clearCartAfterPayment();

              clearCartAfterPayment();
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to place order: $e')),
              );
            }
          },
          icon: Icon(Icons.book_sharp),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              MyReceipt(
                receiptHeader: "Thank you for your order",
                fontFamily: "Italics",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
