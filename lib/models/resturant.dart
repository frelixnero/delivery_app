import 'package:collection/collection.dart';
import 'package:delivery_app/models/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/auth/auth_service.dart';
import 'food.dart';

class Resturant extends ChangeNotifier {
  final List<Food> _menu = [
    // A P P E T I Z E R S
    // AKARA
    Food(
      name: "Akara",
      description:
          "Deep-fried bean fritters, crispy on the outside and soft inside",
      imagePath: "assets/food_images/appetizers/akara.png",
      price: 1000,
      foodCategory: FoodCategory.appetizers,
      availabelAddons: [Addons(name: "pepper sauce", price: 200)],
    ),

    // PEPPER SNAIL
    Food(
      name: "Pepper Snail",
      description:
          "Spicy, well-seasoned snails, usually served as a side or appetizer.",
      imagePath: "assets/food_images/appetizers/peppered_snail_bowl.png",
      price: 2000,
      foodCategory: FoodCategory.appetizers,
      availabelAddons: [Addons(name: "pepper sauce", price: 200)],
    ),

    // PUFF PUFF
    Food(
      name: "Puff Puff",
      description:
          "A deep-fried, fluffy dough ball similar to French beignets. Often dusted with sugar or drizzled with honey.",
      imagePath: "assets/food_images/appetizers/puff_puff.png",
      price: 1000,
      foodCategory: FoodCategory.appetizers,
      availabelAddons: [Addons(name: "pepper sauce", price: 200)],
    ),

    // M A I N  D I S H
    Food(
      name: "Fried Rice",
      description:
          "Rice stir-fried with vegetables, liver, and sometimes shrimp",
      imagePath: "assets/food_images/maindish/fried rice.jpg",
      price: 4000,
      foodCategory: FoodCategory.maincourses,
      availabelAddons: [
        Addons(name: "coleslaw", price: 300),
        Addons(name: "Chicken Thigh", price: 1000),
      ],
    ),

    Food(
      name: "Egusi and Pounded Yam",
      description: "Smooth mashed yam served with melon seed soup",
      imagePath: "assets/food_images/maindish/egusipyam.jpg",
      price: 4000,
      foodCategory: FoodCategory.maincourses,
      availabelAddons: [
        Addons(name: "Extra Wrap of semo", price: 300),
        Addons(name: "Chicken Thigh", price: 1000),
      ],
    ),

    Food(
      name: "Jollof Rice",
      description: "A rich, tomato-based rice dish loved across West Africa",
      imagePath: "assets/food_images/maindish/jellofrice.jpg",
      price: 4000,
      foodCategory: FoodCategory.maincourses,
      availabelAddons: [
        Addons(name: "coleslaw", price: 300),
        Addons(name: "Chicken Thigh", price: 1000),
      ],
    ),

    // rice and stew
    Food(
      name: "White Rice and Stew",
      description: "Local unpolished rice with spicy pepper sauce",
      imagePath: "assets/food_images/maindish/riceandstew.jpg",
      price: 4000,
      foodCategory: FoodCategory.maincourses,
      availabelAddons: [
        Addons(name: "coleslaw", price: 300),
        Addons(name: "Chicken Thigh", price: 1000),
      ],
    ),

    // S I D E  D I S H
    // COLESLAW
    Food(
      name: "coleslaw",
      description:
          "A mix of shredded cabbage, carrots, and mayonnaise, often served with rice dishes",
      imagePath: "assets/food_images/sidedish/coleslaw.png",
      price: 500,
      foodCategory: FoodCategory.sidedish,
      availabelAddons: [Addons(name: "Extra Mayo Packet", price: 200)],
    ),

    // FRIED PLANTAIN
    Food(
      name: "Fried Plantain",
      description: "Sweet, golden-brown fried plantain slices",
      imagePath: "assets/food_images/sidedish/fried plantain.png",
      price: 2200,
      foodCategory: FoodCategory.sidedish,
      availabelAddons: [Addons(name: "pepper sauce", price: 200)],
    ),

    // MOI MOI
    Food(
      name: "Moi Moi",
      description:
          "Steamed bean pudding made from blended beans, pepper, and spices",
      imagePath: "assets/food_images/sidedish/moi_moi.png",
      price: 2200,
      foodCategory: FoodCategory.sidedish,
      availabelAddons: [
        Addons(name: "egg", price: 100),
        Addons(name: "smoked fish", price: 300),
      ],
    ),

    // D E S S E R T S
    // BANANA PUDDING
    Food(
      name: "Banana Pudding",
      description:
          "Steamed bean pudding made from blended beans, pepper, and spices",
      imagePath: "assets/food_images/deserts/banana_pudding.png",
      price: 2200,
      foodCategory: FoodCategory.deserts,
      availabelAddons: [Addons(name: "Milk Shake", price: 1500)],
    ),

    // PANCAKES
    Food(
      name: "Banana Pudding",
      description:
          "Steamed bean pudding made from blended beans, pepper, and spices",
      imagePath: "assets/food_images/deserts/pancakes.png",
      price: 2200,
      foodCategory: FoodCategory.deserts,
      availabelAddons: [Addons(name: "Milk Shake", price: 1500)],
    ),

    // Ice Cream
    Food(
      name: "Ice cream",
      description: "Widely loved and available in various flavors",
      imagePath: "assets/food_images/deserts/pancakes.png",
      price: 2200,
      foodCategory: FoodCategory.deserts,
      availabelAddons: [
        Addons(name: "Vanilla", price: 1500),
        Addons(name: "Chocolate", price: 1500),
        Addons(name: "Sprinkles", price: 200),
      ],
    ),

    // Chin Chin
    Food(
      name: "Chin Chin",
      description: "Crunchy, deep-fried snack made from flour, milk, and sugar",
      imagePath: "assets/food_images/deserts/pancakes.png",
      price: 400,
      foodCategory: FoodCategory.deserts,
      availabelAddons: [Addons(name: "Vanilla", price: 1500)],
    ),

    // D R I N K S
    Food(
      name: "Zobo Drink",
      description: "A refreshing local drink make dfrom hisbiscus",
      imagePath: "assets/food_images/drinks/zobo.png",
      price: 500,
      foodCategory: FoodCategory.drinks,
      availabelAddons: [Addons(name: "Extra Glass", price: 400)],
    ),
  ];

  // delivery address he user can
  String _deliveryAddress = "";

  // GETTERS
  List<Food> get menu => _menu;
  List<CartItem> get cart => _cart;
  String get deliveryAddress => _deliveryAddress;

  // OPERATIONS
  // create cart
  List<CartItem> _cart = [];

  // ad to cart
  void addToCart(Food food, List<Addons> selectedAddons) {
    // check if there is acart item with the same food quantity
    CartItem? cartItem = _cart.firstWhereOrNull((item) {
      // check if food items are the same
      bool isSameFood = item.food == food;

      // check if list of selected addons are the same
      bool issameAddon = ListEquality().equals(
        item.selectedAddons,
        selectedAddons,
      );
      return isSameFood && issameAddon;
    });

    // if item exist increase its quantity
    if (cartItem != null) {
      cartItem.quantity++;
    } else {
      _cart.add(CartItem(food: food, selectedAddons: selectedAddons));
    }
    notifyListeners();
  }

  // remove from cart
  void removeFromCart(CartItem cartItem) {
    int cartIndex = _cart.indexOf(cartItem);

    if (cartIndex != -1) {
      if (_cart[cartIndex].quantity > 1) {
        _cart[cartIndex].quantity--;
      } else {
        _cart.removeAt(cartIndex);
      }
    }
    notifyListeners();
  }

  // get total price of cart
  double getTotalPrice() {
    double total = 0.0;

    for (CartItem cartItem in _cart) {
      double itemTotal = cartItem.food.price;

      for (Addons addon in cartItem.selectedAddons) {
        itemTotal += addon.price;
      }
      total += itemTotal * cartItem.quantity;
    }
    return total;
  }

  // get total number of items incart
  int getTotalItemCount() {
    int totalItemCount = 0;

    for (CartItem cartItem in _cart) {
      totalItemCount += cartItem.quantity;
    }
    return totalItemCount;
  }

  // clear cart
  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void updateAddress(String newAddress) {
    _deliveryAddress = newAddress;
    notifyListeners();
  }

  // HELPERS
  // generate receipt
  String displayCartReceipt() {
    final receipt = StringBuffer();

    receipt.writeln("Here's your receipt");
    receipt.writeln();

    // format date to seconds only
    String formattedDate = DateFormat(
      "yyyy-MM-dd HH:mm:ss",
    ).format(DateTime.now());

    receipt.writeln(formattedDate);
    receipt.writeln();
    receipt.writeln("----------");

    for (final cartItem in cart) {
      receipt.writeln(
        "${cartItem.quantity} x ${cartItem.food.name} - ${_formatPrice(cartItem.food.price)}",
      );

      if (cartItem.selectedAddons.isNotEmpty) {
        receipt.writeln(
          "   Add-ons: ${_formatListOfAddons(cartItem.selectedAddons)}",
        );
      }
      receipt.writeln();
    }
    receipt.writeln("---------");
    receipt.writeln();
    receipt.writeln("Total Items: ${getTotalItemCount()}");
    receipt.writeln("Total Price: ${_formatPrice(getTotalPrice())}");
    receipt.writeln();
    receipt.writeln("Deliverying to : $deliveryAddress");
    receipt.writeln();
    receipt.writeln();
    receipt.writeln("OrderId: ${generateReference()}");

    print(receipt);

    return receipt.toString();
  }

  // format double value into money
  String _formatPrice(double price) {
    return "₦ ${price.toStringAsFixed(2)}";
  }

  // format list of addonds into string summary
  String _formatListOfAddons(List<Addons> addons) {
    return addons
        .map((addon) => "${addon.name}  (${_formatPrice(addon.price)})")
        .join(",");
  }

  String generateReference() {
    String orderRef =
        "${AuthService().getCurrentUser()!.uid}_${DateTime.now().millisecondsSinceEpoch}";
    return orderRef;
  }

  // String getOrderForDb() {
  //   for (final cartItem in cart) {
  //     return "${cartItem.quantity} x ${cartItem.food.name} - ${_formatPrice(cartItem.food.price)}";
  //   }
  //   return "No items in the cart"; // Default return statement if cart is empty
  // }

  // String getAddons() {
  //   for (final cartItem in cart) {
  //     if (cartItem.selectedAddons.isNotEmpty) {
  //       return "${_formatListOfAddons(cartItem.selectedAddons)}";
  //     }
  //   }
  //   return "No items in the cart"; // Default return statement if cart is empty
  // }

  // Modified Resturant functions
  String getOrderForDb(List cart) {
    List<String> orderDetails =
        cart.map((cartItem) {
          return "${cartItem.quantity} x ${cartItem.food.name} - ${_formatPrice(cartItem.food.price)}";
        }).toList();
    return orderDetails.join(" | ");
  }

  String getAddons(List cart) {
    List<String> allAddons =
        cart
            .where((cartItem) => cartItem.selectedAddons.isNotEmpty)
            .map((cartItem) => _formatListOfAddons(cartItem.selectedAddons))
            .toList();

    return allAddons.isNotEmpty ? allAddons.join(", ") : "No Addons";
  }
}
