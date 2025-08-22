import 'package:delivery_app/components/reflex_button.dart';
import 'package:delivery_app/models/food.dart';
import 'package:delivery_app/models/resturant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../navigator_key/navigator.dart';
import 'cart_page.dart';

class FoodPage extends StatefulWidget {
  final Food food;
  final Map<Addons, bool> selectedAddon = {};

  FoodPage({super.key, required this.food}) {
    // inittialize aadon
    for (Addons addon in food.availabelAddons) {
      selectedAddon[addon] = false;
    }
  }

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  // method to add to cart
  void addToCart(Food food, Map<Addons, bool> selectedAddons) {
    // format current adons
    List<Addons> currentlySelectedAddons = [];
    for (Addons addon in widget.food.availabelAddons) {
      if (widget.selectedAddon[addon] == true) {
        currentlySelectedAddons.add(addon);
      }
    }
    context.read<Resturant>().addToCart(food, currentlySelectedAddons);
    ScaffoldMessenger.of(
      NavigationService.navigatorKey.currentState!.context,
    ).showSnackBar(
      const SnackBar(
        content: Text("Added To Cart"),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: [
        // scaffold ui
        Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                // image
                Image.asset(widget.food.imagePath),

                SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // food name
                      Text(
                        widget.food.name,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "₦${widget.food.price.toString()}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 10),

                      // decription
                      Text(
                        widget.food.description,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 10),
                      Divider(color: Theme.of(context).colorScheme.secondary),

                      Text(
                        "Choose your Add-ons",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // addons
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 2.25,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: widget.food.availabelAddons.length,
                          itemBuilder: (context, index) {
                            // get individual addon
                            Addons addon = widget.food.availabelAddons[index];

                            // get checkbox tile
                            return CheckboxListTile(
                              activeColor: Colors.orange.shade500,
                              title: Text(addon.name),
                              subtitle: Text("₦${addon.price.toString()}"),
                              value: widget.selectedAddon[addon],
                              onChanged: (bool? value) {
                                setState(() {
                                  widget.selectedAddon[addon] = value!;
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10),

                // add to cart button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Add to cart () => addToCart(widget.food, widget.selectedAddon)
                    // GestureDetector(
                    //   onTap: () => addToCart(widget.food, widget.selectedAddon),
                    //   child: Container(
                    //     margin: EdgeInsets.only(left: 10),
                    //     padding: EdgeInsets.all(10),
                    //     decoration: BoxDecoration(
                    //       border: Border.all(
                    //         color: Colors.orange.shade500,
                    //         width: 1,
                    //       ),
                    //       borderRadius: BorderRadius.circular(25),
                    //     ),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Icon(
                    //           Icons.shopping_cart,
                    //           color: Colors.orange.shade500,
                    //         ),
                    //         Text(
                    //           "Add to cart",
                    //           style: TextStyle(
                    //             color: Colors.orange.shade500,
                    //             fontSize: 18,
                    //             fontWeight: FontWeight.bold,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    ReflexButton(
                      onTap: () => addToCart(widget.food, widget.selectedAddon),
                      title: "Add to Cart",
                      btnIcon: Icons.shopping_cart,
                    ),

                    // go to check out
                    // GestureDetector(
                    //   onTap:
                    //       () => Navigator.push(
                    //         context,
                    //         MaterialPageRoute(builder: (context) => CartPage()),
                    //       ),
                    //   child: Container(
                    //     margin: EdgeInsets.only(left: 10),
                    //     padding: EdgeInsets.symmetric(
                    //       horizontal: 30,
                    //       vertical: 10,
                    //     ),
                    //     decoration: BoxDecoration(
                    //       border: Border.all(
                    //         color: Colors.orange.shade500,
                    //         width: 1.5,
                    //       ),
                    //       borderRadius: BorderRadius.circular(25),
                    //       color: Colors.orange.shade500,
                    //     ),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Text(
                    //           "Checkout",
                    //           style: TextStyle(
                    //             color:
                    //                 Theme.of(
                    //                   context,
                    //                 ).colorScheme.primaryContainer,
                    //             fontSize: 18,
                    //             fontWeight: FontWeight.bold,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    ReflexButton(
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CartPage()),
                          ),
                      title: "Checkout",
                      btnIcon: Icons.add_business,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // back button
        SafeArea(
          child: Opacity(
            opacity: 0.7,
            child: Container(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.orange.shade500,
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_left_rounded,
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
