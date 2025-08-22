import 'package:delivery_app/components/evemt_card.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class MyTimeLineTile extends StatelessWidget {
  final isFirst;
  final isLast;
  final isPast;
  final String eventHeader;
  final String eventDesc;
  MyTimeLineTile({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.isPast,
    required this.eventHeader,
    required this.eventDesc,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        // decorate line
        beforeLineStyle: LineStyle(
          color: isPast ? Colors.orange.shade500 : Colors.orange.shade100,
        ),
        // decorate icon
        indicatorStyle: IndicatorStyle(
          color: isPast ? Colors.orange.shade500 : Colors.orange.shade100,
          width: isPast ? 35 : 35,
          iconStyle: IconStyle(
            iconData: isPast ? Icons.done : Icons.disabled_by_default_outlined,
            color: isPast ? Colors.white : Colors.red,
          ),
        ),
        endChild: MyEventCard(
          isPast: isPast,
          eventHeader: eventHeader,
          eventDesc: eventDesc,
        ),
      ),
    );
  }
}
