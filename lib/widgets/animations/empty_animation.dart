import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyScreen extends StatelessWidget {
  final String pageName;
  const EmptyScreen({super.key, required this.pageName});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            "$pageName is Empty",
            style:const TextStyle(fontSize: 25),
          ),
        ),
        Lottie.asset("assets/animations/empty_animation.json"),
      ],
    );
  }
}
