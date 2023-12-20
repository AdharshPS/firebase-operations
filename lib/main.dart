import 'package:fire_base_operations/view/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDCLeObbGWy-C2K99l6WYyfmDmTUAq71H0",
      appId: "1:684647965637:android:1b762c5b7e41441062e1ac",
      messagingSenderId: "",
      projectId: "fir-operations-6150a",
      storageBucket: "fir-operations-6150a.appspot.com",
    ),
  );
  runApp(MainScreen());
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen());
  }
}
