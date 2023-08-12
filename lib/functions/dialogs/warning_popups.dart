import 'package:flutter/material.dart';

import '../../model/video_model.dart';
import '../database_functions/playlist_database_funtions.dart';

class WarningPopup {
  static deletePlaylistDialog(
      BuildContext context, String currentPlaylistName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alert..!!!'),
        content:
            Text('Do you want to delete $currentPlaylistName from Playlists'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              PlaylistFuntions().deleteCurrentPlaylist(currentPlaylistName);
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  static deleteVideoFromPlaylistDialog(
      BuildContext context,
      String currentPlaylistName,
      VideoModel currentVideoModelInDB,
      int indexInDB) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alert..!!!'),
        content: Text(
            'Do you want to delete ${currentVideoModelInDB.videoName} from $currentPlaylistName Playlist'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              PlaylistFuntions().removeVideoFromPlaylist(
                  currentPlaylistName, indexInDB, currentVideoModelInDB);
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
