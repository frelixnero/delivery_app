import 'package:hive/hive.dart';

part 'order_status_details.g.dart'; // Will be generated

@HiveType(typeId: 1) // Unique type ID
class OrderStatusDetails {
  @HiveField(0)
  final String currentStatus;

  @HiveField(1)
  final DateTime? lastUpdate;

  @HiveField(2)
  final String? trackingNumber;

  OrderStatusDetails({
    required this.currentStatus,
    this.lastUpdate,
    this.trackingNumber,
  });

  @override
  String toString() {
    return 'OrderSummary(O D E R S T A T U S: $currentStatus, orderDate: $lastUpdate, isCompleted: $trackingNumber)';
  }
}
