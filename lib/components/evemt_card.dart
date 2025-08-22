import 'package:flutter/material.dart';

class MyEventCard extends StatelessWidget {
  final bool isPast;
  final String eventHeader;
  final String eventDesc;
  MyEventCard({
    super.key,
    required this.isPast,
    required this.eventHeader,
    required this.eventDesc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, bottom: 10),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isPast ? Colors.orange.shade500 : Colors.orange.shade200,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            eventHeader,
            style: TextStyle(
              color: isPast ? Colors.white : Colors.orange.shade600,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            eventDesc,
            style: TextStyle(
              color: isPast ? Colors.orange.shade200 : Colors.orange.shade500,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
