import 'package:flutter/material.dart';
import '../../functions/database_functions/playlist_database_funtions.dart';
import '../../functions/dialogs/daialog_functions.dart';
import '../../functions/dialogs/warning_popups.dart';
import '../../we_player/video_player.dart';
import '../../widgets/animations/empty_animation.dart';
import '../main_screens/home_screen.dart';

class PlayListsList extends StatefulWidget {
  const PlayListsList({super.key});

  @override
  State<PlayListsList> createState() => _PlayListsListState();
}

class _PlayListsListState extends State<PlayListsList> {
  @override
  void initState() {
    PlaylistFuntions().getPlaylistFromDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Playlists"),
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back))),
      body: ValueListenableBuilder(
          valueListenable: playlistNotifier,
          builder: (context, playlists, _) => playlists.isNotEmpty
              ? ListView.separated(
                  itemBuilder: (context, index) => ListTile(
                        leading: const Icon(
                          Icons.playlist_add_rounded,
                          size: 45,
                        ),
                        title: Text(
                          playlists[index].playlistName,
                          style: const TextStyle(fontSize: 18),
                        ),
                        subtitle: Text(
                            "${playlists[index].playlistItem.length} Videos"),
                        onTap: () {
                          currentPlaylistName = playlists[index].playlistName;
                          currentPlaylistItems = playlists[index].playlistItem;
                          currentPlaylistIndex = index;
                          currentRouteName = '/playlistPage';
                          Navigator.pushNamed(context, '/playlistPage');
                        },
                        trailing: IconButton(
                            onPressed: () => WarningPopup.deletePlaylistDialog(
                                context, playlists[index].playlistName),
                            icon: const Icon(Icons.delete_outline, size: 30)),
                      ),
                  separatorBuilder: ((context, index) => const Divider()),
                  itemCount: playlists.length)
              :const EmptyScreen(pageName: "Playlist")),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Dialogs().createPlaylistDialog(context);
        },
        child: const Icon(Icons.playlist_add_rounded),
      ),
    );
  }
}
