// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:delivery_app/location/store%20_latlng.dart';
// import 'package:delivery_app/models/resturant.dart';
// import 'package:delivery_app/services/database/hive/boxes.dart';
// import 'package:flutter/widgets.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';
// import '../auth/auth_service.dart';
// import 'hive/order_summary.dart';

// String generateOrderId(String userId) {
//   return "${userId}_${DateTime.now().millisecondsSinceEpoch}";
// }

// Future<void> createOrder(BuildContext context) async {
//   final user = AuthService().getCurrentUser();
//   if (user == null) throw Exception("User not authenticated");

//   final String userId = user.uid;
//   // ignore: unused_local_variable
//   final String? useremail = user.email;

//   final resturantProvider = Provider.of<Resturant>(context, listen: false);
//   final cart = resturantProvider.cart;

//   final orderId = generateOrderId(userId);

//   final orderRef = FirebaseFirestore.instance
//       .collection('orders')
//       .doc(orderId); // Use orderId as doc ID

//   final String userFood = resturantProvider.getOrderForDb(cart);
//   final String userAddons = resturantProvider.getAddons(cart);

//   final String totalPrice = resturantProvider.getTotalPrice().toString();
//   final String itemCount = resturantProvider.getTotalItemCount().toString();
//   // bools
//   final bool isPackaged = true;
//   final bool isEnroute = false;
//   final bool isArrived = false;

//   // Create instance of todobox
//   ToDoBox toDoBox = Provider.of<ToDoBox>(context, listen: false);
//   StoreLatlng storLngLat = Provider.of<StoreLatlng>(context, listen: false);

//   // get longitude and latitude
//   LatLng? myLatlng = storLngLat.selectedLocation;
//   final latitude = myLatlng?.latitude;
//   final longitude = myLatlng?.longitude;

//   // get order data
//   final List<Map<String, dynamic>> orderData = [
//     {
//       "food details": userFood,
//       "user addons": userAddons,
//       "total price": totalPrice,
//     },
//   ];

//   await orderRef.set({
//     'orderId': orderId,
//     'userId': userId,
//     'orderData': orderData,
//     'orderDate': FieldValue.serverTimestamp(),
//     "itemCount": itemCount,
//     'status': 'pending',
//     'isPackaged': isPackaged,
//     'isEnroute': isEnroute,
//     'isArrived': isArrived,
//     'latitude': latitude,
//     'longitude': longitude,
//     // Initial status
//   });

//   print("L A T I T U D E :$latitude,  L O N G I T U D E: $longitude");
//   // Fetch timestamp from Firestore
//   DocumentSnapshot orderSnapshot = await orderRef.get();
//   Timestamp firebaseTimestamp = orderSnapshot['orderDate'];

//   // Store order summary in Hive
//   final orderSummary = OrderSummary(
//     orderId: orderId,
//     orderDate: firebaseTimestamp.toDate(),
//     isCompleted: false,
//   );

//   List<OrderSummary> userOrderList = [];

//   // save to hive
//   toDoBox.saveToHive(userId, userOrderList, orderSummary);
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/location/store%20_latlng.dart';
import 'package:delivery_app/models/resturant.dart';
import 'package:delivery_app/services/database/hive/boxes.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../auth/auth_service.dart';
import 'hive/order_summary.dart';
import 'package:intl/intl.dart'; // Import intl package

String generateOrderId(String userId) {
  return "${userId}_${DateTime.now().millisecondsSinceEpoch}";
}

Future<void> createOrder(BuildContext context) async {
  final user = AuthService().getCurrentUser();
  if (user == null) throw Exception("User not authenticated");

  final String userId = user.uid;
  // ignore: unused_local_variable
  final String? useremail = user.email;

  final resturantProvider = Provider.of<Resturant>(context, listen: false);
  final cart = resturantProvider.cart;

  final orderId = generateOrderId(userId);

  final orderRef = FirebaseFirestore.instance
      .collection('orders')
      .doc(orderId); // Use orderId as doc ID

  final String userFood = resturantProvider.getOrderForDb(cart);
  final String userAddons = resturantProvider.getAddons(cart);

  final String totalPrice = resturantProvider.getTotalPrice().toString();
  final String itemCount = resturantProvider.getTotalItemCount().toString();
  // bools
  final bool isPackaged = true;
  final bool isEnroute = false;
  final bool isArrived = false;

  // Create instance of todobox
  ToDoBox toDoBox = Provider.of<ToDoBox>(context, listen: false);
  StoreLatlng storLngLat = Provider.of<StoreLatlng>(context, listen: false);

  // get longitude and latitude
  LatLng? myLatlng = storLngLat.selectedLocation;
  final latitude = myLatlng?.latitude;
  final longitude = myLatlng?.longitude;

  // get order data
  final List<Map<String, dynamic>> orderData = [
    {
      "food details": userFood,
      "user addons": userAddons,
      "total price": totalPrice,
    },
  ];

  await orderRef.set({
    'orderId': orderId,
    'userId': userId,
    'orderData': orderData,
    'orderDate': FieldValue.serverTimestamp(),
    "itemCount": itemCount,
    'status': 'pending',
    'isPackaged': isPackaged,
    'isEnroute': isEnroute,
    'isArrived': isArrived,
    'latitude': latitude,
    'longitude': longitude,
    // Initial status
  });

  print("L A T I T U D E :$latitude,  L O N G I T U D E: $longitude");
  // Fetch timestamp from Firestore
  DocumentSnapshot orderSnapshot = await orderRef.get();
  Timestamp firebaseTimestamp = orderSnapshot['orderDate'];

  // Convert Timestamp to DateTime
  DateTime orderDateTime = firebaseTimestamp.toDate();

  // Format the DateTime
  String formattedDate = DateFormat(
    'EEEE, MMMM d, yyyy',
  ).format(orderDateTime); // Example: Friday, October 27, 2023

  // Store order summary in Hive
  final orderSummary = OrderSummary(
    orderId: orderId,
    orderDate: orderDateTime, // Store DateTime in Hive
    isCompleted: false,
  );

  List<OrderSummary> userOrderList = [];

  // save to hive
  toDoBox.saveToHive(userId, userOrderList, orderSummary);

  print("Formatted Date: $formattedDate"); // Print the formatted date
}
