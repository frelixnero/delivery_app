import 'package:delivery_app/models/food.dart';
import 'package:flutter/material.dart';

class MyQuantitySelector extends StatelessWidget {
  final int quantity;
  final Food food;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  MyQuantitySelector({
    super.key,
    required this.food,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // decrease
          Container(
            margin: EdgeInsets.symmetric(horizontal: 0),
            decoration: BoxDecoration(
              color: Colors.orange.shade500,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: GestureDetector(
              onTap: onDecrement,
              child: Icon(
                Icons.remove,
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
            ),
          ),

          // quantity count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(child: Text(quantity.toString())),
          ),

          // increae
          Container(
            margin: EdgeInsets.symmetric(horizontal: 0),
            decoration: BoxDecoration(
              color: Colors.orange.shade500,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: GestureDetector(
              onTap: onIncrement,
              child: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
