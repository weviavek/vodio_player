import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../notifiers/notifiers.dart';

class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset("assets/animations/permision.json"),
            const Text(
              "Please Turn on Permission \nManually...!!",
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
                onPressed: () async {
                  await openAppSettings();
                  Timer.periodic(const Duration(seconds: 2), (timer) async {
                    Notifier.notifyFirstScreen();
                    timer.cancel();
                  });
                },
                child: const Text("Go To App Settings"))
          ],
        ),
      ),
    );
  }
}
