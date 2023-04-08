import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather_7days_getx_app/ui/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return const HomePage();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.red,
              Colors.blue,
            ],
          )),
          child: Center(child: Image.asset('assets/wlogo.png'))),
    );
  }
}
