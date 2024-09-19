import 'package:ev_station_finder/screens/SplashScreen.dart';
import 'package:ev_station_finder/screens/user/user_signin.dart';
import 'package:ev_station_finder/screens/user/user_signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EleCharge',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/user_signin': (context) => const signIn(),
          '/user_signup': (context) => const SignUpScreen(),
        });
  }
}
