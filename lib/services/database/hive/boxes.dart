// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'order_status_details.dart';
// import 'order_summary.dart';

// class ToDoBox extends ChangeNotifier {
//   // Best Working Version
//   final _testBox = Hive.box("testBox");

//   void saveToHive(
//     String userId,
//     List<OrderSummary> userOrderList,
//     OrderSummary orderSummary,
//   ) {
//     // Store updated list in Hive
//     List<dynamic> userOrderList2 = _testBox.get(userId) ?? []; //trial
//     print(
//       "T H I S  I S  D A T A    R U N T Y P E  2 :${userOrderList2.runtimeType}",
//     );
//     // userOrderList2.clear();
//     userOrderList2.add(orderSummary);
//     _testBox.put(userId, userOrderList2); // Save all orders for this user

//     notifyListeners();
//   }

//   Future<List<dynamic>> loadOrderSummaries(String userId) async {
//     // final userOrdersBox = Hive.box<List<dynamic>>('userOrdersBox');

//     // final dynamic retrievedData = userOrdersBox.get(userId);
//     final dynamic retrievedData = _testBox.get(userId);

//     print("Retrieved data type: ${retrievedData.runtimeType}"); // Debugging

//     if (retrievedData == null) {
//       print("Retrieved data is null. Returning empty list.");
//       return [];
//     }

//     if (retrievedData is List) {
//       try {
//         List<dynamic> orderList = retrievedData.cast<dynamic>().toList();
//         print("Successfully casted to List<OrderSummary>");
//         return orderList;
//       } catch (e) {
//         print("Error casting to List<OrderSummary>: $e");
//         return [];
//       }
//     } else {
//       print("Retrieved data is not a List. Returning empty list.");
//       return [];
//     }
//   }

//   void listenForOrderUpdates(String orderId) {
//     FirebaseFirestore.instance
//         .collection("orders")
//         .where("orderId", isEqualTo: orderId) // 🔍 Query by orderId field
//         .snapshots()
//         .listen((snapshot) {
//           if (snapshot.docs.isNotEmpty) {
//             var doc = snapshot.docs.first;
//             debugPrint("✅ Order Data: ${doc.data()}"); // Print full document

//             if (doc.data().containsKey("status")) {
//               // Ensure "status" field exists
//               String newStatus = doc["status"];

//               final orderStatusBox = Hive.box<OrderStatusDetails>(
//                 'orderStatusBox',
//               );
//               orderStatusBox.put(
//                 orderId,
//                 OrderStatusDetails(currentStatus: newStatus),
//               );
//             } else {
//               debugPrint("⚠️ Status field missing in Firestore document.");
//             }
//           } else {
//             debugPrint("❌ No order found for ID: $orderId");
//           }
//         });
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'order_status_details.dart';
import 'order_summary.dart';

class ToDoBox extends ChangeNotifier {
  final _testBox = Hive.box("testBox");

  void saveToHive(
    String userId,
    List<OrderSummary> userOrderList,
    OrderSummary orderSummary,
  ) {
    List<dynamic> userOrderList2 = _testBox.get(userId) ?? [];
    print(
      "T H I S  I S  D A T A    R U N T Y P E  2 :${userOrderList2.runtimeType}",
    );
    userOrderList2.add(orderSummary);
    _testBox.put(userId, userOrderList2);
    notifyListeners();
  }

  Future<List<dynamic>> loadOrderSummaries(String userId) async {
    final dynamic retrievedData = _testBox.get(userId);

    print("Retrieved data type: ${retrievedData.runtimeType}");

    if (retrievedData == null) {
      print("Retrieved data is null. Returning empty list.");
      return [];
    }

    if (retrievedData is List) {
      try {
        List<dynamic> orderList = retrievedData.cast<dynamic>().toList();
        print("Successfully casted to List<OrderSummary>");
        return orderList;
      } catch (e) {
        print("Error casting to List<OrderSummary>: $e");
        return [];
      }
    } else {
      print("Retrieved data is not a List. Returning empty list.");
      return [];
    }
  }

  void listenForOrderUpdates(String orderId) {
    FirebaseFirestore.instance
        .collection("orders")
        .where("orderId", isEqualTo: orderId)
        .snapshots()
        .listen((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            var doc = snapshot.docs.first;
            debugPrint("✅ Order Data: ${doc.data()}");

            if (doc.data().containsKey("status")) {
              String newStatus = doc["status"];

              final orderStatusBox = Hive.box<OrderStatusDetails>(
                'orderStatusBox',
              );
              orderStatusBox.put(
                orderId,
                OrderStatusDetails(currentStatus: newStatus),
              );
            } else {
              debugPrint("⚠️ Status field missing in Firestore document.");
            }
          } else {
            debugPrint("❌ No order found for ID: $orderId");
          }
        });
  }

  // New method to delete an order from Hive
  void deleteOrderFromHive(String userId, String orderId) {
    List<dynamic> rawOrderList = _testBox.get(userId) ?? [];
    List<OrderSummary> orderList = rawOrderList.cast<OrderSummary>();

    // Find the index of the order to delete
    int index = orderList.indexWhere((order) => order.orderId == orderId);

    if (index != -1) {
      // Remove the order from the list
      orderList.removeAt(index);

      // Save the updated list back to Hive
      _testBox.put(userId, orderList);

      notifyListeners(); // Notify listeners of the change
    } else {
      print("Order with ID $orderId not found in Hive.");
    }
  }
}
