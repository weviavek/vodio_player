import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MiniLoading extends StatelessWidget {
  const MiniLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset("assets/animations/mini_loading.json");
  }
}
