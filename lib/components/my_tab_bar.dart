import 'package:delivery_app/models/food.dart';
import 'package:flutter/material.dart';

class MyTabBar extends StatelessWidget {
  final TabController tabController;
  final int selectedIndex; // Receive selectedIndex from HomePage

  MyTabBar({
    super.key,
    required this.tabController,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      isScrollable: true,
      controller: tabController,
      labelPadding: EdgeInsets.zero,
      dividerColor: Colors.transparent,
      tabs:
          FoodCategory.values.asMap().entries.map((entry) {
            int index = entry.key;
            String categoryName = entry.value.toString().split(".").last;

            bool isSelected =
                selectedIndex == index; // Use received selectedIndex

            return Tab(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color:
                      isSelected ? Colors.orange.shade600 : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  categoryName,
                  style: TextStyle(
                    color:
                        isSelected
                            ? Theme.of(context).colorScheme.background
                            : Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}






// DelightToastBar(
//                               builder: (context) {
//                                 return ToastCard(
//                                   title: Text("Add Some Items To Your Cart"),
//                                 );
//                               },
//                               autoDismiss: true,
//                               position: DelightSnackbarPosition.top,
//                               snackbarDuration: Duration(seconds: 1),
//                             ).show(context); // Use the current context here