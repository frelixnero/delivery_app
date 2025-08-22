import 'package:delivery_app/models/food.dart';
import 'package:flutter/material.dart';

class MyFoodTile extends StatelessWidget {
  final Food food;
  final void Function()? onTap;

  MyFoodTile({super.key, required this.food, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                // food details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food.name,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        food.description,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 11),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.orange.shade500,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          "₦${food.price.toString()}",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // food image
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(12),
                //   child: Image.asset(food.imagePath, height: 120),
                // ),
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.orange.shade500,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(food.imagePath, height: 120),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(color: Theme.of(context).colorScheme.primary),
      ],
    );
  }
}
