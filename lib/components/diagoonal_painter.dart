// import 'package:flutter/material.dart';

// class DiagonalBackground extends StatelessWidget {
//   final Widget child;

//   const DiagonalBackground({super.key, required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // Background with diagonal color split
//         Positioned.fill(
//           child: CustomPaint(painter: DiagonalBackgroundPainter()),
//         ),
//         // Page content
//         Positioned.fill(child: child),
//       ],
//     );
//   }
// }

// class DiagonalBackgroundPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint orangePaint = Paint()..color = Colors.orange.shade600;
//     Paint whitePaint = Paint()..color = Colors.white;

//     Path orangePath = Path();
//     orangePath.moveTo(0, 0); // Top-left corner
//     orangePath.lineTo(size.width * 1.0, 0); // 75% width from the left
//     orangePath.lineTo(size.width * 0.5, size.height * 0.4); // Diagonal line
//     orangePath.lineTo(0, size.height * 0.5); // Continue diagonal
//     orangePath.close();

//     canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), whitePaint);
//     canvas.drawPath(orangePath, orangePaint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

// import 'package:flutter/material.dart';

// class DiagonalBackground extends StatelessWidget {
//   final Widget child;

//   const DiagonalBackground({super.key, required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // Background with diagonal color split
//         Positioned.fill(
//           child: CustomPaint(painter: DiagonalBackgroundPainter()),
//         ),
//         // Page content
//         Positioned.fill(child: child),
//       ],
//     );
//   }
// }

// class DiagonalBackgroundPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint orangePaint = Paint()..color = Colors.orange.shade600;
//     Paint whitePaint = Paint()..color = Colors.white;

//     Path orangePath = Path();
//     orangePath.moveTo(0, 0); // Top-left corner
//     orangePath.lineTo(size.width * 1.0, 0); // Top Right corner

//     // Create a curved path (corrected control point)
//     orangePath.quadraticBezierTo(
//       size.width * 0.25, // Control point x - Moved closer to the start
//       size.height * 0.4, // Control point y - Adjusted to pull inward
//       size.width * 0.5, // End point x
//       size.height * 0.4, // End point y
//     );

//     orangePath.lineTo(0, size.height * 0.5); // Continue diagonal to bottom left
//     orangePath.close();

//     canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), whitePaint);
//     canvas.drawPath(orangePath, orangePaint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

import 'package:delivery_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiagonalBackground extends StatelessWidget {
  final BuildContext context;
  final Widget child;

  const DiagonalBackground({
    super.key,
    required this.child,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return Stack(
      children: [
        // Background with diagonal color split
        Positioned.fill(
          child: CustomPaint(
            painter: DiagonalBackgroundPainter(isDarkMode: isDarkMode),
          ),
        ),
        // Page content
        Positioned.fill(child: child),
      ],
    );
  }
}

class DiagonalBackgroundPainter extends CustomPainter {
  final bool isDarkMode;
  DiagonalBackgroundPainter({required this.isDarkMode});
  @override
  void paint(Canvas canvas, Size size) {
    Paint orangePaint = Paint()..color = Colors.orange.shade600;
    Paint whitePaint =
        Paint()
          ..color =
              isDarkMode
                  ? const Color.fromARGB(255, 0, 0, 0)
                  : const Color.fromARGB(255, 255, 255, 255);

    Path orangePath = Path();
    orangePath.moveTo(0, 0); // Top-left corner
    orangePath.lineTo(size.width * 1.0, 0.1); // Top Right corner

    // Create a curved path ending at mid-length
    orangePath.quadraticBezierTo(
      size.width * 0.25, // Control point x
      size.height * 0.25, // Control point y
      size.width * 0.0625 * 0.1, // End point x (mid-length)
      size.height * 0.75, // End point y (mid-height)
    );

    orangePath.lineTo(
      0,
      size.height * 0.75,
    ); // Continue diagonal to bottom left
    orangePath.close();

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), whitePaint);
    canvas.drawPath(orangePath, orangePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
