import 'package:flutter/material.dart';
import 'package:vodio_player/functions/sorting/sorting_functions.dart';
import 'package:vodio_player/screens/main_screens/home_screen.dart';
import 'package:vodio_player/we_player/video_player.dart';
import 'package:vodio_player/widgets/animations/empty_animation.dart';
import 'package:vodio_player/widgets/custom_widgets/custom_icons.dart';
import 'package:vodio_player/widgets/custom_widgets/custom_listtile.dart';

import '../../functions/storage_functions/initial_functions.dart';
import '../../notifiers/notifiers.dart';

ValueNotifier<bool> folderNotifier = ValueNotifier(true);
Widget folderList() {
  return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 244, 249),
      appBar: AppBar(
        leading: const Icon(Icons.folder),
        title: const Text("Folder List"),
        actions: [
          PopupMenuButton(
            icon: const Icon(CustomIcon.sortAmountDown),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Name A to Z'),
                onTap: () {
                  listOfKeys = SortingFunctions.sortFolderAtoB(
                      videoDirectories.keys.toList(), null);
                  Notifier.notifyFolders();
                },
              ),
              PopupMenuItem(
                child: const Text('Name Z to A'),
                onTap: () {
                  listOfKeys = SortingFunctions.sortFolderAtoB(
                      videoDirectories.keys.toList(), true);
                  Notifier.notifyFolders();
                },
              )
            ],
          )
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: folderNotifier,
        builder: (context, value, child) => listOfKeys.isNotEmpty
            ? ListView.separated(
                itemBuilder: (context, index) => CustomListTile(
                      title: Text(
                        listOfKeys[index],
                        style: listTileTitleText,
                      ),
                      subTitle: Text(
                        "${videoDirectories[listOfKeys[index]]!.length} Videos",
                        style: listTileSubTitleText,
                      ),
                      leading: const Icon(
                        Icons.folder,
                        size: 80,
                        color: Color.fromARGB(255, 88, 111, 127),
                      ),
                      onTap: () {
                        int i = 0;
                        for (String currentName in videoDirectories.keys) {
                          if (currentName == listOfKeys[index]) {
                            break;
                          }
                          i++;
                        }
                        currentFolderIndex = i;
                        Navigator.pushNamed(context, '/currentFolderView');
                        currentRouteName = '/currentFolderView';
                      },
                      trailing: const SizedBox(),
                    ),
                separatorBuilder: (context, index) => const Divider(),
                itemCount: videoDirectories.length)
            :const EmptyScreen(
                pageName: "Folder List",
              ),
      ));
}
