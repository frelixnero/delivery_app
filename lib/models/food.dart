class Food {
  final String name;
  final String description;
  final String imagePath;
  final double price;
  final FoodCategory foodCategory;
  List<Addons> availabelAddons;

  Food({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.foodCategory,
    required this.availabelAddons,
  });
}

// Food Category
enum FoodCategory { appetizers, maincourses, sidedish, deserts, drinks }

// food addons
class Addons {
  String name;
  double price;

  Addons({required this.name, required this.price});
}
