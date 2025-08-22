import 'package:delivery_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDescriptionBox extends StatelessWidget {
  MyDescriptionBox({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),

      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange.shade500,
        // border: Border.all(color: Theme.of(context).colorScheme.secondary),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // delivery fee
          Column(
            children: [
              Text(
                "Delivery Fee",
                style: TextStyle(
                  color:
                      Provider.of<ThemeProvider>(context).isDarkMode
                          ? Colors.black
                          : const Color.fromARGB(255, 255, 255, 255),
                  fontSize: 15,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "₦2000",
                  style: TextStyle(
                    color:
                        Provider.of<ThemeProvider>(context).isDarkMode
                            ? Colors.black
                            : Colors.orange.shade500,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),

          // delivery time
          Column(
            children: [
              Text(
                "Delivery Time",
                style: TextStyle(
                  color:
                      Provider.of<ThemeProvider>(context).isDarkMode
                          ? Colors.black
                          : const Color.fromARGB(255, 255, 255, 255),
                  fontSize: 15,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "15 - 30mins",
                  style: TextStyle(
                    color:
                        Provider.of<ThemeProvider>(context).isDarkMode
                            ? Colors.black
                            : Colors.orange.shade500,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
