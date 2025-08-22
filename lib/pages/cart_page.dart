import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:delivery_app/components/diagoonal_painter.dart';
import 'package:delivery_app/components/my_button.dart';
import 'package:delivery_app/components/my_cart_tile.dart';
import 'package:delivery_app/location/my_current_loactio.dart';
import 'package:delivery_app/models/resturant.dart';
import 'package:delivery_app/pages/payment_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';

class CartPage extends StatefulWidget {
  CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Future<void> checkForAddress() async {
    // check if address exist
    print("checking address");
    Resturant resturant = Provider.of<Resturant>(context, listen: false);
    String address = resturant.deliveryAddress;
    if (address.isEmpty) {
      await MyCurrentLoaction().getAddress(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Resturant resturant = Provider.of<Resturant>(context, listen: false);
    String address = resturant.deliveryAddress;
    return Consumer<Resturant>(
      builder: (context, resturant, child) {
        // cart
        final userCart = resturant.cart;

        // scaffold ui
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primary,
          appBar: AppBar(
            title: Text("Cart Page"),
            centerTitle: true,
            backgroundColor: Colors.orange.shade500,
            actions: [
              //  clear cart button
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text('Are you sure you want clear all items'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 107, 107, 107),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                resturant.clearCart();
                              },
                              child: const Text(
                                "Clear",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 107, 107, 107),
                                ),
                              ),
                            ),
                          ],
                        ),
                  );
                },
                icon: Icon(Icons.delete_rounded),
              ),
            ],
          ),
          body: DiagonalBackground(
            context: context,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      userCart.isEmpty
                          ? Center(
                            child: Text(
                              "Your Cart is Empty",
                              style: TextStyle(
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.inversePrimary,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                          : Expanded(
                            child: ListView.builder(
                              itemCount: userCart.length,
                              itemBuilder: (context, index) {
                                // get indvidual car item
                                final cartItem = userCart[index];

                                return MyCartTile(cartItem: cartItem);
                              },
                            ),
                          ),
                    ],
                  ),
                ),

                // pay button
                MyButton(
                  buttonText: "Make Payment",
                  onTap:
                      userCart.isEmpty
                          ? () {
                            DelightToastBar(
                              builder: (context) {
                                return ToastCard(
                                  title: Text("Add Some Items To Your Cart"),
                                );
                              },
                              autoDismiss: true,
                              position: DelightSnackbarPosition.top,
                              snackbarDuration: Duration(seconds: 1),
                            ).show(context);
                            setState(() {}); // Use the current context here
                          }
                          : address.isEmpty
                          ? () async {
                            await checkForAddress();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentPage(),
                              ),
                            );
                          }
                          : () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentPage(),
                            ),
                          ),
                ),

                SizedBox(height: 25),
              ],
            ),
          ),
        );
      },
    );
  }
}
