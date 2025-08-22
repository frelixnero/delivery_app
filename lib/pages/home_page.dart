import 'package:delivery_app/location/my_current_loactio.dart';
import 'package:delivery_app/components/my_description_box.dart';
import 'package:delivery_app/components/my_food_tile.dart';
import 'package:delivery_app/components/my_sliver_appbar.dart';
import 'package:delivery_app/components/my_tab_bar.dart';
import 'package:delivery_app/models/food.dart';
import 'package:delivery_app/models/resturant.dart';
import 'package:delivery_app/pages/food_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0; // Move _selectedIndex to HomePage's state

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: FoodCategory.values.length,
      vsync: this,
    );
    _tabController.addListener(_handleTabChange);
  }

  // handle tab changes
  void _handleTabChange() {
    if (mounted) {
      setState(() {
        _selectedIndex = _tabController.index; // Update _selectedIndex
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  //   // Sort through menu by categories
  List<Food> _filterFoodByCategory(FoodCategory category, List<Food> fullMenu) {
    return fullMenu.where((food) => food.foodCategory == category).toList();
  }

  // return food by categorie
  List<Widget> getFoodInCategory(List<Food> fullMenu) {
    return FoodCategory.values.map((category) {
      List<Food> categoryMenu = _filterFoodByCategory(category, fullMenu);
      return ListView.builder(
        padding: EdgeInsets.all(0),
        physics: NeverScrollableScrollPhysics(),
        itemCount: categoryMenu.length,
        itemBuilder: (context, index) {
          // get individual food
          final food = categoryMenu[index];

          // return food tile
          return MyFoodTile(
            food: food,
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FoodPage(food: food)),
                ),
          );
        },
      );
    }).toList();
  }
  // ... (rest of the HomePage code)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: MyDrawer(),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,

      body: NestedScrollView(
        headerSliverBuilder:
            (context, innerBoxIsScrolled) => [
              MySliverAppbar(
                title: MyTabBar(
                  tabController: _tabController,
                  selectedIndex: _selectedIndex, // Pass _selectedIndex
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [MyCurrentLoaction(), MyDescriptionBox()],
                ),
              ),
            ],
        body: Consumer<Resturant>(
          builder:
              (context, rseturant, child) => TabBarView(
                controller: _tabController,
                children: getFoodInCategory(rseturant.menu),
              ),
        ),
      ),
    );
  }
}
