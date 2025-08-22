import 'package:delivery_app/pages/cart_page.dart';
import 'package:flutter/material.dart';

class MySliverAppbar extends StatelessWidget {
  final Widget child;
  final Widget title;
  MySliverAppbar({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SliverAppBar(
      expandedHeight: 320,
      collapsedHeight: 120,
      floating: false,
      pinned: false,
      centerTitle: true,
      actions: [
        // Icon
        IconButton(
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              ),
          icon: Icon(Icons.shopping_cart),
        ),
      ],
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text("Cito"),
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: child,
        ),
        title: title,
        centerTitle: true,
        expandedTitleScale: 1,
      ),
    );
  }
}
