import 'package:flutter/material.dart';

class SpecialIconButton extends StatelessWidget {
  final String buttonText;
  final Function()? onTap;
  final IconData? icon;
  const SpecialIconButton({
    super.key,
    required this.buttonText,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                buttonText,

                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
              ),
              SizedBox(width: 30),
              Icon(icon, color: Theme.of(context).colorScheme.primaryContainer),
            ],
          ),
        ),
      ),
    );
  }
}
