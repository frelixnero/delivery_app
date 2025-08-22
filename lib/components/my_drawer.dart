import 'package:delivery_app/pages/profile_page.dart';
import 'package:flutter/material.dart';

import '../services/auth/auth_service.dart';
import 'drawer_tile.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // logo
              DrawerHeader(
                child: // logo
                    Icon(
                  Icons.lock_open,
                  size: 120,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: DrawerTile(
                  icon: Icon(Icons.home),
                  text: Text("H O M E"),
                  onTaped: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: DrawerTile(
                  icon: Icon(Icons.settings),
                  text: Text("S E T T I N G S"),
                  onTaped: () {
                    // pop drawer
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: DrawerTile(
                  icon: Icon(Icons.person_2_sharp),
                  text: Text("P R O F I L E"),
                  onTaped: () {
                    // pop drawer
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(left: 25, bottom: 30),
            child: DrawerTile(
              icon: Icon(Icons.logout),
              text: Text("L O G O U T"),
              onTaped: () {
                // sign out
                AuthService authService = AuthService();
                authService.signOut();
              },
            ),
          ),
        ],
      ),
    );
  }
}
