import "dart:async";

import "package:flutter/material.dart";

import "home_page.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
            () =>
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomePage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 120,),
          Image.asset("assets/Checklist.jpg"),
          Padding(
            padding: const EdgeInsets.only(top: 28.0,left: 28,right: 28,bottom: 10),
            child: Text("Manage your Everyday task list",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 28, right: 28),
              child: Text(
                "organize tasks according to your preferences, and personalize settings to suit your workflow.",
                style: TextStyle(fontWeight: FontWeight.w300,
                  fontSize: 20,
                  color: Colors.black,),) ,
          ),
        ],
      ),
    );
  }
}
