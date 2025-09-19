import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_app/screens/signup_screen.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async{
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('loggedIn') ?? false;
    final isRegistered = prefs.containsKey('emailOrPhone');

    await Future.delayed(Duration(seconds: 4));

    if(isLoggedIn){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen(),));
    }
    else if(isRegistered){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
    }
    else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignupScreen(),));
    }
    
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.indigoAccent,
      child:  const Center(
        child: FittedBox(
          child: Text(
            "Task Manager",
            style: TextStyle(
              fontSize: 40,
              color: Colors.white,
              letterSpacing: 3,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
