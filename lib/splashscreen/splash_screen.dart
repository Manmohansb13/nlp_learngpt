import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../pages/prompt_page.dart';



class splashScreen extends StatelessWidget {
  const splashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: LottieBuilder.asset("ass/Animation - 1717558551512.json"))
            ],
          ),
        ),
      ),
      duration: 4000,
      splashIconSize: 450,
      backgroundColor: Colors.white,
      nextScreen: PromptPage(),
    );
  }
}