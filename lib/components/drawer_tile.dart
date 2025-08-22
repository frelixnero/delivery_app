import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final Icon icon;
  final text;
  final void Function()? onTaped;

  DrawerTile({
    super.key,
    required this.icon,
    required this.text,
    required this.onTaped,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListTile(leading: icon, title: text, onTap: onTaped);
  }
}
