import 'package:fire_base_operations/view/login_screen/login_screen.dart';
import 'package:fire_base_operations/view/options_screen/options_screen.dart';
import 'package:fire_base_operations/view/register_screen/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isWaiting = true;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2)).then((value) {
      isWaiting = false;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isWaiting == false
        ? StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return OptionsScreen();
              } else {
                return LoginScreen();
              }
            },
          )
        : Scaffold(
            body: Center(
              child: Text(
                "Splash Screen",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          );
  }
}
