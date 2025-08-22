import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:delivery_app/components/diagoonal_painter.dart';
import 'package:delivery_app/services/database/saved_order_details.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../navigator_key/navigator.dart';
import '../services/auth/auth_service.dart';
import '../services/database/hive/boxes.dart';
import '../services/database/hive/order_summary.dart';
import '../themes/theme_provider.dart';

class ManageOrdersPage extends StatefulWidget {
  const ManageOrdersPage({super.key});

  @override
  State<ManageOrdersPage> createState() => _ManageOrdersPageState();
}

class _ManageOrdersPageState extends State<ManageOrdersPage> {
  final ThemeProvider _themeProvider = ThemeProvider();

  late ScrollController _scrollController;
  late ScrollController _horizontalScrollController;

  // ValueNotifier to trigger rebuilds
  final ValueNotifier<List<OrderSummary>> _orderListNotifier = ValueNotifier(
    [],
  );

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _horizontalScrollController = ScrollController();
    _loadInitialOrders(); // Load initial orders on init
    scrollDown();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _horizontalScrollController.dispose();
    _orderListNotifier.dispose(); // Dispose the notifier
    super.dispose();
  }

  void scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients &&
          _scrollController.position.maxScrollExtent > 0) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  void goToDetailsPage(String orderId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SavedOrderDetails(orderId: orderId),
      ),
    );
  }

  // show options
  void _showOptions(BuildContext context, String orderId, String userId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.flag_sharp),
                title: Text("Delete Order"),
                onTap: () async {
                  // Make it async
                  Navigator.pop(context);
                  Provider.of<ToDoBox>(
                    context,
                    listen: false,
                  ).deleteOrderFromHive(userId, orderId);
                  DelightToastBar(
                    builder: (context) {
                      return ToastCard(title: Text("Order Deleted"));
                    },
                    autoDismiss: true,
                    position: DelightSnackbarPosition.top,
                    snackbarDuration: Duration(seconds: 1),
                  ).show(context);

                  // Reload the order list after deletion
                  await _loadInitialOrders(); // Call _loadInitialOrders here
                },
              ),
              ListTile(
                leading: Icon(Icons.cancel_sharp),
                title: Text("Cancel"),
                onTap: () => NavigationService.navigatorKey.currentState!.pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to load initial orders and update the notifier
  Future<void> _loadInitialOrders() async {
    final rawOrders = await Provider.of<ToDoBox>(
      context,
      listen: false,
    ).loadOrderSummaries(AuthService().getCurrentUser()?.uid ?? "");
    // Cast List<dynamic> to List<OrderSummary>
    List<OrderSummary> orders = rawOrders.cast<OrderSummary>();
    _orderListNotifier.value = orders;
  }

  String formatFirebaseTimestampDayMonth(Timestamp? timestamp) {
    if (timestamp == null) {
      return "Invalid Date"; // Or handle null timestamp as you prefer
    }

    try {
      DateTime dateTime = timestamp.toDate();
      String dayName = DateFormat(
        'EEEE',
      ).format(dateTime); // Full day name (e.g., Friday)
      String monthName = DateFormat(
        'MMMM',
      ).format(dateTime); // Full month name (e.g., October)
      return '$dayName, $monthName';
    } catch (e) {
      print("Error formatting date: $e");
      return "Error Formatting Date"; // Or handle the error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Manage Orders"),
        backgroundColor: Colors.orange.shade500,
      ),
      body: DiagonalBackground(
        context: context,
        child: ValueListenableBuilder<List<OrderSummary>>(
          valueListenable: _orderListNotifier,
          builder: (context, orderList, child) {
            if (orderList.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              ); // Or an empty state
            }
            //sort the list by date.
            orderList.sort((a, b) => b.orderDate.compareTo(a.orderDate));
            return ListView.builder(
              controller: _scrollController,
              reverse: false,
              itemCount: orderList.length,
              itemBuilder: (context, index) {
                final orderSummary = orderList[index];

                return GestureDetector(
                  onLongPress:
                      () => _showOptions(
                        context,
                        orderSummary.orderId,
                        AuthService().getCurrentUser()?.uid ?? "",
                      ),
                  onTap: () => goToDetailsPage(orderSummary.orderId),
                  // ... your order display code ...
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color:
                          _themeProvider.isDarkMode
                              ? Colors.orange.shade500
                              : Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order ID: ${orderSummary.orderId}',
                                style: TextStyle(
                                  decoration:
                                      orderSummary.isCompleted
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                  color:
                                      orderSummary.isCompleted
                                          ? Theme.of(
                                            context,
                                          ).colorScheme.secondary
                                          : Colors.black,

                                  fontSize: 20,
                                  fontFamily: "fake",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: _horizontalScrollController,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(
                                            orderSummary.isCompleted
                                                ? 'Completed'
                                                : 'Pending',
                                          ),
                                        ),
                                        orderSummary.isCompleted
                                            ? Container(
                                              margin: const EdgeInsets.only(
                                                left: 10,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: Colors.orange.shade500,
                                              ),
                                              child: IconButton(
                                                icon: const Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                ),
                                                onPressed:
                                                    () => _completeOrder(
                                                      orderSummary.orderId,
                                                    ),
                                              ),
                                            )
                                            : Container(
                                              margin: const EdgeInsets.only(
                                                left: 10,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: Colors.grey,
                                              ),
                                              child: IconButton(
                                                icon: const Icon(
                                                  Icons.hourglass_top_outlined,
                                                ),
                                                onPressed:
                                                    () => _completeOrder(
                                                      orderSummary.orderId,
                                                    ),
                                              ),
                                            ),
                                      ],
                                    ),
                                    SizedBox(width: 20),
                                    Text(
                                      'Date: ${orderSummary.orderDate}',
                                      style: TextStyle(
                                        color:
                                            orderSummary.isCompleted
                                                ? Theme.of(
                                                  context,
                                                ).colorScheme.secondary
                                                : Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _completeOrder(String orderId) async {
    final user = AuthService().getCurrentUser();
    if (user != null) {
      final _testBox = Hive.box("testBox");
      List<dynamic> rawOrderList = _testBox.get(user.uid) ?? [];
      List<OrderSummary> orderList = rawOrderList.cast<OrderSummary>();
      int index = orderList.indexWhere((order) => order.orderId == orderId);

      if (index != -1) {
        List<OrderSummary> updatedList = List.from(orderList);
        updatedList[index] = OrderSummary(
          orderId: orderList[index].orderId,
          orderDate: orderList[index].orderDate,
          isCompleted: true,
        );

        _testBox.put(user.uid, updatedList);

        // Update the ValueNotifier
        _orderListNotifier.value = updatedList;

        // Create instance of todobox
        ToDoBox toDoBox = Provider.of<ToDoBox>(context, listen: false);
        toDoBox.listenForOrderUpdates(orderId);
      }
    }
  }
}
