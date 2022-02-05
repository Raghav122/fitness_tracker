import 'package:fitness_tracker/daily_goals.dart';
import 'package:fitness_tracker/login_screen.dart';
import 'package:fitness_tracker/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'calculateBMI.dart';
import 'resultBmi.dart';
import 'weeklyData.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> islogged() async {
    try {
      final User user = await _firebaseAuth.currentUser;
      return user != null;
    } catch (e) {
      return false;
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final Auth _auth = Auth();
  final bool islogged = await _auth.islogged();
  runApp(fitnesstracker(islogged: islogged));
}

class fitnesstracker extends StatelessWidget {
  fitnesstracker({@required this.islogged});

  final bool islogged;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: islogged ? homeScreen.id : welcomeScreen.id,
      routes: {
        welcomeScreen.id: (context) => welcomeScreen(),
        loginScreen.id: (context) => loginScreen(),
        homeScreen.id: (context) => homeScreen(),
        calculateBMI.id: (context) => calculateBMI(),
        resultBmi.id: (context) => resultBmi(),
        weekly_data.id: (context) => weekly_data(),
        daily_goals.id: (context) => daily_goals(),
      },
    );
  }
}
