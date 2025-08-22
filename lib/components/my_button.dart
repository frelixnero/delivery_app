import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String buttonText;
  final Function()? onTap;
  MyButton({super.key, required this.buttonText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.inversePrimary,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(25),
        margin: EdgeInsets.symmetric(horizontal: 22),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
