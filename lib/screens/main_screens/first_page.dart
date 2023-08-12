import 'package:flutter/material.dart';
import 'package:vodio_player/widgets/animations/unsupported_device.dart';

import '../../functions/storage_functions/initial_functions.dart';
import '../../widgets/animations/loading_animation.dart';
import '../../widgets/animations/permission_denied.dart';
import 'home_screen.dart';

ValueNotifier firstScreenNotifier = ValueNotifier(0);

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => FirstScreenState();
}

class FirstScreenState extends State<FirstScreen> {
  void setStateHelper() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: firstScreenNotifier,
      builder: (context, value, child) => FutureBuilder(
          future: InitialFunctions().rootDirec(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              videoList.length;
              if (snapshot.data == null) {
                //returns Null if unsuported android version
                return const UnsupportedScreen();
              } else if (snapshot.data == 50) {
                //allow permission manually
                return const PermissionScreen();
              } else {
                return const HomeScreen();
              }
            } else {
              return const LoadingWidget();
            }
          }),
    );
  }
}
