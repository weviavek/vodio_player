import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class UnsupportedScreen extends StatelessWidget {
  const UnsupportedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset("assets/animations/working_on_it.json"),
              const Padding(
                padding: EdgeInsets.only( left:8.0,right: 8,bottom: 20),
                child: Text(
                  "Oops you device does not support Vodio Player. \nWe are working on it",
                  style: TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),),
                  onPressed: () async {
                    exit(0);
                  },
                  child:const Text("Close Vodio Player"))
            ],
          ),
        ),
      ),
    );
  }
}
