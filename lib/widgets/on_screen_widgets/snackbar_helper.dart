import 'package:flutter/material.dart';

class SnackBarhelper {
  static snack(BuildContext snackContext, String content) {
    ScaffoldMessenger.of(snackContext).showSnackBar(SnackBar(
      content: Text(content),
      duration: const Duration(seconds: 1),
    ));
  }
}
