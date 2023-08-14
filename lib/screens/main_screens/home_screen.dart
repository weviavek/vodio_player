import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../functions/database_functions/database_functions.dart';
import '../../model/video_model.dart';
import '../../widgets/custom_widgets/custom_icons.dart';
import '../list_screens/video_list.dart';

int currentIndex = 0;
List<VideoModel> currentVideoList = [];
int currentFolderIndex = 0;
String currentPlaylistName = '';
List<VideoModel> currentPlaylistItems = [];
int currentPlaylistIndex = 0;

BuildContext? floatingContext;
List<BottomNavigationBarItem> bottomItems = const [
  BottomNavigationBarItem(icon: Icon(CustomIcon.folderOpen), label: "Folders"),
  BottomNavigationBarItem(
      icon: Icon(CustomIcon.videocam, color: Colors.black),
      label: "All Videos"),
  BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorites"),
  BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings")
];
int selectedIndex = 0;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

bool isFirstTime = true;

class _HomeScreenState extends State<HomeScreen> {
  void onTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    floatingContext = context;
    DatabaseFunctions().getAllVideoFromDB();
    return Scaffold(
      extendBody: true,
      body: HomeScreenItem.currentView(selectedIndex),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
        child: Theme(
          data:
              ThemeData(canvasColor: const Color.fromARGB(255, 244, 244, 249)),
          child: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            unselectedItemColor: const Color.fromARGB(255, 136, 160, 159),
            selectedItemColor: const Color.fromARGB(255, 47, 69, 80),
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(CustomIcon.folderOpen), label: "Folders"),
              BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.video), label: "All Videos"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite), label: "Favorites"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: "Settings")
            ],
            currentIndex: selectedIndex,
            onTap: (value) => onTapped(value),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
