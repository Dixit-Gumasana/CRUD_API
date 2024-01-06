import 'dart:async';

import 'package:flutter/material.dart';


import 'dashboard.dart';
import 'loginscreen.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var userExists = sharedPreferences?.getString("token");

  @override
  void initState() {
    Timer(Duration(seconds: 2), () {
      if(userExists == null){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPg(),), (route) => false);
      } else{
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DashboardPg(),), (route) => false);

      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/splash.jpg"), fit: BoxFit.fill),
        ),
        child: Stack(
          children: [
            Align(
              alignment: AlignmentDirectional.center,
              child: Text(
                "C.R.U.D",
                style: TextStyle(
                    fontSize: 55,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueAccent.withOpacity(0.4)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: "Powerd By ",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.blueGrey)),
                      TextSpan(
                          text: " Dix.IT",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.deepPurple.shade400)),
                    ])),
              ),
            )
          ],
        ),
      ),
    );
  }
}
