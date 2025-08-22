import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  MyTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        cursorColor: Theme.of(context).colorScheme.tertiary,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          fillColor: Theme.of(context).colorScheme.background,
          filled: true,
        ),
      ),
    );
  }
}
