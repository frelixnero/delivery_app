import 'package:delivery_app/components/my_quantity_selector.dart';
import 'package:delivery_app/models/cart_item.dart';
import 'package:delivery_app/models/resturant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyCartTile extends StatelessWidget {
  final CartItem cartItem;

  MyCartTile({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Consumer<Resturant>(
      builder:
          (context, resturant, child) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.inversePrimary,
                width: 2,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              children: [
                // Main Cart Item Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Food Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        cartItem.food.imagePath,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Food Name & Price
                    Expanded(
                      // Wrap the Column with Expanded
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cartItem.food.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            "₦${cartItem.food.price.toString()}0",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    // Quantity Selector
                    MyQuantitySelector(
                      food: cartItem.food,
                      quantity: cartItem.quantity,
                      onIncrement: () {
                        resturant.addToCart(
                          cartItem.food,
                          cartItem.selectedAddons,
                        );
                      },
                      onDecrement: () {
                        resturant.removeFromCart(cartItem);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Selected Addons
                if (cartItem.selectedAddons.isNotEmpty)
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: cartItem.selectedAddons.length,
                      itemBuilder: (context, index) {
                        final addon = cartItem.selectedAddons[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: FilterChip(
                            side: BorderSide(color: Colors.orange.shade500),
                            label: Row(
                              children: [
                                Text(addon.name),
                                Text("  (₦${addon.price.toString()})"),
                              ],
                            ),
                            shape: StadiumBorder(
                              side: BorderSide(
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.inversePrimary,
                              ),
                            ),
                            onSelected: (value) {},
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            labelStyle: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
    );
  }
}
