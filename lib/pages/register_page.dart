// import 'package:firebase_auth/firebase_auth.dart';
import 'package:delivery_app/components/diagoonal_painter.dart';
import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../components/my_button.dart';
import '../components/my_square_tile.dart';
import '../components/my_textfield.dart';
import '../navigator_key/navigator.dart';
import '../services/auth/auth_service.dart';
import '../themes/theme_provider.dart';

class RegisterPage extends StatefulWidget {
  // tap go toggle register page
  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmpwordController = TextEditingController();

  // global key for poping loading circle cause context kepps changing withe the async
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void register(BuildContext context) async {
    if (passwordController.text != confirmpwordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match.")));
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      // Await the registration process
      await AuthService().registerWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );

      // Registration successful: Dismiss the loading dialog
      NavigationService.navigatorKey.currentState!.pop();

      // // Show success message
      ScaffoldMessenger.of(
        NavigationService.navigatorKey.currentState!.context,
      ).showSnackBar(const SnackBar(content: Text("Registration successful!")));

      // Optionally navigate to a new screen or perform other actions
    } catch (e) {
      if (!mounted) return;
      // Error: Dismiss the loading dialog
      NavigationService.navigatorKey.currentState!.pop();

      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text(
                "Error Creating Account",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color.fromARGB(255, 107, 107, 107)),
              ),
              content: Text(e.toString(), textAlign: TextAlign.center),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: DiagonalBackground(
        context: context,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // logo
                    Container(
                      margin: EdgeInsets.only(
                        top: 0,
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
                      "Let's setup an account for you.",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: 15,
                      ),
                    ),

                    SizedBox(height: 20),

                    // email textfield
                    MyTextField(
                      hintText: "Enter email",
                      obscureText: false,
                      controller: emailController,
                    ),

                    SizedBox(height: 15),

                    // password textfield
                    MyTextField(
                      hintText: "Enter password",
                      obscureText: true,
                      controller: passwordController,
                    ),

                    SizedBox(height: 15),

                    // password textfield
                    MyTextField(
                      hintText: "Confirm password",
                      obscureText: true,
                      controller: confirmpwordController,
                    ),

                    SizedBox(height: 25),

                    // login button
                    MyButton(
                      buttonText: "Register",
                      onTap: () => register(context),
                    ),

                    SizedBox(height: 30),
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
                              "or register with",
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
                          Text("Already a member ?"),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: Text(
                              " Login now",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
