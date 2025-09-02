import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frubix/generated/assets.dart';
import 'package:frubix/generated/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SuccessScreen extends StatefulWidget {
  SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 5), () {
      context.go(Routes.homeScreen);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Center(child: Lottie.asset(Assets.animSuccess))),
    );
  }
}
