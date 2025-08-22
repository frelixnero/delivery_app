import 'package:flutter/material.dart';

import '../services/database/hive/order_summary.dart';

class OrderTile extends StatelessWidget {
  final OrderSummary orderSummary;
  const OrderTile({super.key, required this.orderSummary});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.orange.shade500
                : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Order ID: ${orderSummary.orderId}',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
