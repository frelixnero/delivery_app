import 'package:hive/hive.dart';

part 'order_summary.g.dart'; // Will be generated

@HiveType(typeId: 0) // Unique type ID
class OrderSummary {
  @HiveField(0)
  final String orderId;

  @HiveField(1)
  final DateTime orderDate;

  @HiveField(2)
  final bool isCompleted;

  OrderSummary({
    required this.orderId,
    required this.orderDate,
    required this.isCompleted,
  });

  @override
  String toString() {
    return 'OrderSummary(orderId: $orderId, orderDate: $orderDate, isCompleted: $isCompleted)';
  }
}
