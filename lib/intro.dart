import 'package:citroon/main.dart';
import 'package:flutter/material.dart';
import 'utils/colors_utils.dart';

import 'dart:async';
import 'package:flutter/material.dart';

class IntroSlider extends StatefulWidget {
  const IntroSlider({Key? key}) : super(key: key);

  @override
  _IntroSliderState createState() => _IntroSliderState();
}

class _IntroSliderState extends State<IntroSlider> {
  @override
  void initState() {
    super.initState();

    // Démarrer le délai de 1 seconde avant la navigation
    Timer(Duration(seconds: 2), () {
       // Navigator.pushReplacementNamed(context, '/home'); // Remplacez '/home' par le chemin de votre page d'accueil
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: hexStringToColor("2f6241"),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/logoappbar.png",
            width: 150.0,
            height: 150.0,
          ),
        ],
      ),
    );
  }
}
