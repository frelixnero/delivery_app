import 'package:delivery_app/components/diagoonal_painter.dart';
import 'package:delivery_app/components/my_button.dart';
import 'package:delivery_app/components/special_icon_button.dart';
import 'package:delivery_app/services/storage/storage_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../services/auth/auth_service.dart';
import '../services/storage/get_image_url.dart';
import '../themes/theme_provider.dart';

// ignore: must_be_immutable
class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  ThemeProvider _themeProvider = ThemeProvider();
  AuthService authService = AuthService();

  void deleteHiveBox(String boxName) async {
    try {
      await Hive.deleteBoxFromDisk(boxName);
      print('Box "$boxName" deleted successfully.');
    } catch (e) {
      print('Error deleting box "$boxName": $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final String imageOwnerId = authService.getCurrentUser()!.uid;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          context.watch<StorageService>().isLoading
              ? "Getting Profile..."
              : context.watch<StorageService>().imageUrls[imageOwnerId] != null
              ? "Profile"
              : "No Profile",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
        ),
        backgroundColor: Colors.orange.shade500,
      ),
      body: DiagonalBackground(
        context: context,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              // main page column
              children: [
                // user profile
                GetImageUrl(imageOwnerId: imageOwnerId),

                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 20),
                  padding: EdgeInsets.only(
                    left: 12,
                    right: 8,
                    top: 10,
                    bottom: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      width: 2,
                    ),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person),
                        Text(
                          "Logged In as: ${authService.getCurrentUser()!.email}",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(
                    left: 12,
                    right: 8,
                    top: 10,
                    bottom: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      width: 2,
                    ),

                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // widget name
                          Padding(
                            padding: const EdgeInsets.only(top: 0, bottom: 15),
                            child: Text(
                              "Change Settings",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color:
                                    _themeProvider.isDarkMode
                                        ? Colors.orange.shade500
                                        : const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.settings),
                            title: Text(
                              "Change Theme",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: // CupertinoSwitch
                                CupertinoSwitch(
                              activeTrackColor: Colors.orange.shade500,
                              value:
                                  Provider.of<ThemeProvider>(
                                    context,
                                    listen: false,
                                  ).isDarkMode,
                              onChanged:
                                  (value) =>
                                      Provider.of<ThemeProvider>(
                                        context,
                                        listen: false,
                                      ).toggleTheme(),
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.notifications_active),
                            title: Text(
                              "Notifications",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: // CupertinoSwitch
                                CupertinoSwitch(
                              activeTrackColor: Colors.orange.shade500,
                              value: true,
                              onChanged: (value) {},
                            ),
                          ),

                          SizedBox(height: 50),
                          MyButton(
                            buttonText: "Clear Orders",
                            onTap: () => deleteHiveBox('userOrdersBox'),
                          ),
                          SizedBox(height: 50),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 50),

                Container(
                  padding: EdgeInsets.only(
                    left: 12,
                    right: 8,
                    top: 10,
                    bottom: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // widget name
                          Padding(
                            padding: const EdgeInsets.only(top: 0, bottom: 15),
                            child: Text(
                              "Account Settings",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color:
                                    _themeProvider.isDarkMode
                                        ? Colors.orange.shade500
                                        : const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.account_box),
                            title: Text(
                              "Stay logged In",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: // CupertinoSwitch
                                CupertinoSwitch(
                              activeTrackColor: Colors.orange.shade500,
                              value: true,
                              onChanged: (value) {},
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.location_pin),
                            title: Text(
                              "Always Request Address",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: // CupertinoSwitch
                                CupertinoSwitch(
                              activeTrackColor: Colors.orange.shade500,
                              value: true,
                              onChanged: (value) {},
                            ),
                          ),

                          SizedBox(height: 50),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.8,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    SpecialIconButton(
                      buttonText: "Logout",
                      onTap: () {
                        // sign out
                        AuthService authService = AuthService();
                        authService.signOut();
                      },
                      icon: Icons.logout,
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.8,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50),

                // blocked users
              ],
            ),
          ),
        ),
      ),
    );
  }
}
