import 'package:delivery_app/components/diagoonal_painter.dart';
import 'package:delivery_app/components/my_button.dart';
import 'package:delivery_app/components/my_textfield.dart';
import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../components/my_square_tile.dart';
import '../navigator_key/navigator.dart';
import '../services/auth/auth_service.dart';
import '../themes/theme_provider.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final TextEditingController emailcontroller = TextEditingController();

  final TextEditingController passwordcontroller = TextEditingController();

  // login function
  void login(BuildContext context) async {
    // if (!mounted) return;
    // get auth service
    final authService = AuthService();
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    // try login
    try {
      await authService.signInWithEmailAndPassword(
        emailcontroller.text,
        passwordcontroller.text,
      );

      NavigationService.navigatorKey.currentState!.pop();
      // if (!mounted) return;
      ScaffoldMessenger.of(
        NavigationService.navigatorKey.currentState!.context,
      ).showSnackBar(const SnackBar(content: Text("Login successful!")));
    } catch (e) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: DiagonalBackground(
        context: context,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Column(
              children: [
                // logo
                Container(
                  margin: EdgeInsets.only(
                    top: 20,
                    bottom: 10,
                    left: 60,
                    right: 60,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color:
                        Provider.of<ThemeProvider>(context).isDarkMode
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.primary,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.tertiary,
                      width: 3,
                    ),
                  ),
                  child: DotLottieLoader.fromAsset(
                    "assets/animations/delivery_truck1.lottie",
                    frameBuilder: (BuildContext ctx, DotLottie? dotlottie) {
                      if (dotlottie != null) {
                        return Lottie.memory(
                          dotlottie.animations.values.single,
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
                // message/app sloggan
                Text(
                  "Welcome back! You've been missed.",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 15,
                  ),
                ),

                SizedBox(height: 20),

                // email field
                MyTextField(
                  hintText: "Email",
                  obscureText: false,
                  controller: emailcontroller,
                ),

                SizedBox(height: 15),

                // password field
                MyTextField(
                  hintText: "Password",
                  obscureText: true,
                  controller: passwordcontroller,
                ),

                SizedBox(height: 30),

                // login button
                MyButton(buttonText: "Login", onTap: () => login(context)),

                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "or continue with",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 109, 108, 108),
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),
                // google + apple sign up
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // google logo
                    MySquareTile(
                      imagePath: "assets/images/google_png.png",
                      imageSize: 50,
                      onTap: () {},
                    ),
                    MySquareTile(
                      imagePath: "assets/images/apple_logo2.png",
                      imageSize: 50,
                      onTap: () {},
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // register now
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                    right: 10,
                    bottom: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Not a member ?"),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          " Register now",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
