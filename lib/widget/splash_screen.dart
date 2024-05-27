import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:tractor4your/Start/Login.dart';

class splash_screen extends StatefulWidget {
  const splash_screen({Key? key});

  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  startTimer() {
    var duration = const Duration(seconds: 3);
    return Timer(duration, () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Login_Page(),
          ));
    });
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: content(),
    );
  }

  Widget content() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/animation/Animation - 1715522844248.json'),
            AnimatedTextKit(animatedTexts: [
              FadeAnimatedText("WELL COME TO TRACTOR 4 U",
                  textStyle: const TextStyle(fontFamily: "Bebas"),
                  duration: const Duration(seconds: 3)),
            ])
          ],
        ),
      ),
    );
  }
}
