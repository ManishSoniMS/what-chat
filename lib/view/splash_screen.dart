import 'dart:async';


import '../view/home_screen.dart';
import '../view/sign_in_screen.dart';
import 'package:flutter/material.dart';
import '../helper/helper_function.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static bool userIsLoggedIn = false;

  @override
  void initState() {
    super.initState();
    getLoggedInStatus().whenComplete(
      () async {
        Timer(
          Duration(seconds: 2),
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => userIsLoggedIn ? HomeScreen() : SignIn(),
            ),
          ),
        );
      },
    );
  }

  getLoggedInStatus() async {
    await HelperFunctions.getUserLoggedIn().then((value) {
      setState(() {
        userIsLoggedIn = value!;
      });
    });
    print("user is logged in or not:" + userIsLoggedIn.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedTextKit(
            animatedTexts: [
              ScaleAnimatedText(
                "WhatChat",
                textStyle: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
          Image.asset("assets/images/splash.gif"),
        ],
      ),
    );
  }
}
