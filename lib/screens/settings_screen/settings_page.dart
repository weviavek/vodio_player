import 'package:flutter/material.dart';

import '../../we_player/video_player.dart';
import '../list_screens/playlists_list.dart';
import 'privacy_policy.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
const String aboutDialogContent = '''
Vodio Player is a feature-rich multimedia player designed to provide you with an exceptional media playback experience. With support for various file formats and powerful features, Vodio Player is your ultimate choice for enjoying your favorite audio and video content.

Features:
- Smooth and seamless playback of video files.

- Support for various media file formats, including MP4, AVI, MKV, and more.
- Intuitive and user-friendly interface for easy navigation.
- Create and manage playlists for your favorite tracks and videos.

Contact Us:
If you have any questions, suggestions, or feedback, feel free to reach out to us at:
Email: we.viavek@gmail.com
''';
class _SettingsPageState extends State<SettingsPage> {
  bool showAudioFiles = false;
  @override
  Widget build(BuildContext context) {
    List<Map> settingsItem = [
      {
        'icon': const Icon(
          Icons.playlist_add_rounded,
          size: 40,
        ),
        'title': "Playlists",
        'ontap': () => Navigator.push(context,
            MaterialPageRoute(builder: (buildContex) => const PlayListsList()))
      },
      {
        'icon': const Icon(
          Icons.find_replace_outlined,
          size: 40,
        ),
        'title': "Mostly Played Videos",
        'ontap': () {
          currentRouteName = '/mostlyplayedPage';
          Navigator.pushNamed(context, '/mostlyplayedPage');
        }
      },
      {
        'icon': const Icon(
          Icons.history,
          size: 40,
        ),
        'title': "History",
        'ontap': () => Navigator.pushNamed(context, '/history')
      },
      {
        'icon': const Icon(
          Icons.privacy_tip_outlined,
          size: 40,
        ),
        'title': "Privacy Policy",
        'ontap': ()=>Navigator.push(context, MaterialPageRoute(builder:(context) =>const PrivacyPolicy(),))
      },
      {
        'icon': const Icon(
          Icons.info_outline,
          size: 40,
        ),
        'title': "About Us",
        'ontap': () => showAboutDialog(applicationName: "Vodio Player",applicationVersion: "1.0.0",applicationLegalese: aboutDialogContent,context: context)
      }
    ];

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.settings),
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.separated(
            itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(
                    right: 40,
                  ),
                  child: ListTile(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(25),
                              bottomRight: Radius.circular(25))),
                      tileColor: const Color.fromARGB(255, 184, 219, 217),
                      leading: settingsItem[index]['icon'],
                      title: Text(settingsItem[index]['title']),
                      onTap: settingsItem[index]['ontap']),
                ),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: settingsItem.length),
      ),
    );
  }
}
