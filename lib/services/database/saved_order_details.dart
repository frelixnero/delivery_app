import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:delivery_app/components/diagoonal_painter.dart';
import 'package:delivery_app/components/time_line_tile.dart';
import 'package:flutter/material.dart';

import '../../pages/track_order_page.dart';

// ignore: must_be_immutable
class SavedOrderDetails extends StatelessWidget {
  final String orderId;
  SavedOrderDetails({super.key, required this.orderId});

  final CollectionReference orders = FirebaseFirestore.instance.collection(
    'orders',
  );
  // firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference orderTracking = FirebaseFirestore.instance.collection(
    'ordersTracking',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
        backgroundColor: Colors.orange.shade500,
        centerTitle: true,
      ),
      body: DiagonalBackground(
        context: context,
        child: StreamBuilder<DocumentSnapshot>(
          stream: orders.doc(orderId).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(child: Text('Order not found'));
            }

            var order = snapshot.data!;

            // Extract the required fields from the Firestore document
            String orderStatus = order['status'];
            Timestamp orderTimestamp = order['orderDate'];
            DateTime orderDate = orderTimestamp.toDate();
            var orderDetails = order['orderData'][0];

            String itemName = orderDetails['food details'];
            String itemPrice = orderDetails["total price"];
            String? addons = orderDetails["user addons"];
            String totalItems = order["itemCount"] ?? "1";
            bool isPackaged = order["isPackaged"];
            bool isEnroute = order["isEnroute"];
            bool isArrived = order["isArrived"];

            // Format the order date

            String formattedOrderDate =
                "${orderDate.year}-${orderDate.month.toString().padLeft(2, '0')}-${orderDate.day.toString().padLeft(2, '0')} ${orderDate.hour.toString().padLeft(2, '0')}:${orderDate.minute.toString().padLeft(2, '0')}:${orderDate.second.toString().padLeft(2, '0')}";

            return buildOrderTile(
              orderStatus,
              formattedOrderDate,
              itemName,
              itemPrice,
              addons,
              totalItems,
              isPackaged,
              isEnroute,
              isArrived,
              context,
            );
          },
        ),
      ),
    );
  }

  //  buildOrderTile function
  Widget buildOrderTile(
    String orderStatus,
    String orderDate,
    String itemName,
    String itemPrice,
    String? addons,
    String totalItems,
    bool isPackaged,
    bool isEnroute,
    bool isArrived,
    BuildContext context,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Card(
        elevation: 4,
        margin: EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                orderStatus,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: orderStatus == "pending" ? Colors.red : Colors.green,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "thank you for your order",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 16),
              Text(orderDate, style: TextStyle(fontSize: 14)),
              SizedBox(height: 8),
              Text(" $itemName", style: TextStyle(fontSize: 16)),
              if (addons != null && addons.isNotEmpty) ...[
                SizedBox(height: 8),
                Text(
                  "Add-ons: $addons",
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Items: $totalItems",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "₦${itemPrice}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              // Image.asset(
              //   "assets/animations/delivery_driver1.png",
              //   fit: BoxFit.contain,
              //   height: 50,
              //   width: 50,
              // ),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade100, Colors.orange.shade900],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyTimeLineTile(
                        isFirst: true,
                        isLast: false,
                        isPast: isPackaged,
                        eventHeader: "Order Placed",
                        eventDesc: "We have received your order",
                      ),
                      MyTimeLineTile(
                        isFirst: false,
                        isLast: false,
                        isPast: isEnroute,
                        eventHeader:
                            isEnroute
                                ? "Order Shipped"
                                : "Order not yet shipped",
                        eventDesc:
                            isEnroute
                                ? "Your order has departed and is enroute"
                                : "Your Order is has not yet departed",
                      ),
                      MyTimeLineTile(
                        isFirst: false,
                        isLast: true,
                        isPast: isArrived,
                        eventHeader:
                            isArrived ? "Delivered" : "Awaiting Delivery",
                        eventDesc:
                            isArrived
                                ? "Your order has been delivered"
                                : "Your order is yet to arrive",
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),

              GestureDetector(
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Center(
                        child: CircularProgressIndicator(color: Colors.amber),
                      );
                    },
                  );

                  DocumentSnapshot snapshot =
                      await orderTracking.doc(orderId).get();
                  if (snapshot.exists) {
                    Navigator.pop(context);
                    Navigator.push(
                      (context),
                      MaterialPageRoute(
                        builder: (context) => TrackOrderPage(orderId: orderId),
                      ),
                    );
                  } else {
                    Navigator.pop(context);
                    DelightToastBar(
                      builder: (context) {
                        return ToastCard(
                          title: Text("Tracking is not yet available"),
                        );
                      },
                      autoDismiss: true,
                      position: DelightSnackbarPosition.top,
                      snackbarDuration: Duration(seconds: 1),
                    ).show(context);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade100, Colors.orange.shade700],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                  padding: EdgeInsets.all(25),
                  margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Track Order",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Container(
//                     decoration: BoxDecoration(
//                       color: isPackaged ? Colors.green : Colors.red,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                     margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                     child: Text("Packaged status: $isPackaged"),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       color: isEnroute ? Colors.green : Colors.red,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                     margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                     child: Text("Is Enroute status: $isEnroute"),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       color: isArrived ? Colors.green : Colors.red,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                     margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                     child: Text("Arrived status: $isArrived"),
//                   ),
