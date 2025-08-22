import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../themes/theme_provider.dart';

class MySquareTile extends StatelessWidget {
  final String imagePath;
  final double? imageSize;
  final Function()? onTap;
  const MySquareTile({
    super.key,
    required this.imagePath,
    required this.imageSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color:
              Provider.of<ThemeProvider>(context).isDarkMode
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.primary,
        ),
        child: Image.asset(imagePath, height: imageSize, width: imageSize),
      ),
    );
  }
}
