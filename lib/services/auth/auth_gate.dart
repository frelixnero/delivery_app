import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:delivery_app/pages/cart_page.dart';
import 'package:delivery_app/pages/manage_orders.dart';
import 'package:delivery_app/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../pages/home_page.dart';
import 'login_or_register.dart';

class AuthGate extends StatefulWidget {
  AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  int navBarIndex = 0;
  User? _lastUser; // Track last auth state

  void navigateBottomBar(int index) {
    setState(() {
      navBarIndex = index;
    });
  }

  final List<Widget> _pages = [
    HomePage(),
    ManageOrdersPage(),
    CartPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final currentUser = snapshot.data;

          // 👇 Detect login/logout transitions
          if (currentUser != null && _lastUser == null) {
            // User just logged in
            navBarIndex = 0; // reset to Home
          } else if (currentUser == null && _lastUser != null) {
            // User just logged out
            navBarIndex = 0; // reset to Home
          }

          _lastUser = currentUser; // update last seen state

          if (snapshot.hasData) {
            return Scaffold(
              bottomNavigationBar: Container(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                padding: EdgeInsets.only(top: 0, left: 1, right: 1, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.orange.shade500,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CurvedNavigationBar(
                  index: navBarIndex,
                  height: MediaQuery.of(context).size.height * 0.08,
                  color: Colors.orange.shade500,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  animationDuration: Duration(milliseconds: 300),
                  onTap: navigateBottomBar,
                  items: [
                    Icon(
                      Icons.home,
                      color: Theme.of(context).colorScheme.background,
                    ),
                    Icon(
                      Icons.shopping_bag,
                      color: Theme.of(context).colorScheme.background,
                    ),
                    Icon(
                      Icons.shopping_cart,
                      color: Theme.of(context).colorScheme.background,
                    ),
                    Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ],
                ),
              ),
              body: _pages[navBarIndex],
            );
          } else {
            return LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
