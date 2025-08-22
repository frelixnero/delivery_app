import "package:dotlottie_loader/dotlottie_loader.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:lottie/lottie.dart";
import "services/auth/auth_gate.dart";
// import 'package:splash_screen';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(Duration(seconds: 4), () {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => AuthGate()));
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade100, Colors.grey.shade900],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DotLottieLoader.fromAsset(
                  "assets/animations/delivery_truck1.lottie",
                  frameBuilder: (BuildContext ctx, DotLottie? dotlottie) {
                    if (dotlottie != null) {
                      return Lottie.memory(dotlottie.animations.values.single);
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
