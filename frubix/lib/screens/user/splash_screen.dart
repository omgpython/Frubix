import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frubix/generated/assets.dart';
import 'package:frubix/generated/pref_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../generated/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    PrefManager manager = PrefManager();
    Timer(Duration(seconds: 3), () {
      if (manager.getUserLoginStatus()) {
        context.pushReplacement(Routes.homeScreen);
      } else {
        context.pushReplacement(Routes.userLoginScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Lottie.asset(Assets.animSplash, height: 300, width: 300),
        ),
      ),
    );
  }
}
