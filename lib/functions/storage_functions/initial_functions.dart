import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../model/video_model.dart';
import '../../screens/main_screens/home_screen.dart';
import '../file_function/file_functions.dart';
import '../sorting/sorting_functions.dart';

List<String> videoPathList = [];
List<VideoModel> videoList = [];
bool called = false;
List<String> listOfKeys = [];
int androidVersion = 0;

Map<String, List<VideoModel>> videoDirectories = {};

class InitialFunctions {
  static List<String> videoFormats = ["mp4", "avi", "3gp", "mkv"];
  static List<Directory> directoryToCheck = [];
  static List allDirectory = [];

  static late PermissionStatus permissionStatus;

  //this function checks if the given path is a video file
  static bool isVideo(String path) {
    if (videoFormats.contains(path.split(".").last.toLowerCase())) {
      return true;
    }
    return false;
  }

  Future<int?> rootDirec() async {
    isFirstTime = false;
    if (Platform.isAndroid) {
      var androidInfo = DeviceInfoPlugin();
      try {
        await androidInfo.androidInfo.then((value) {
          androidVersion = int.parse(value.version.release);
        });
      } catch (e) {
        androidVersion = 0;
      }
    }
    if (!called) {
      called = true;
      if (androidVersion == 12) {
        permissionStatus = await Permission.storage.request();
        if (permissionStatus.isPermanentlyDenied) {
          called = false;
          return 50;
        } else if (permissionStatus.isDenied) {
          called = false;
          return await rootDirec();
        }
      } else if (androidVersion > 12) {
        permissionStatus = await Permission.videos.request();
        if (permissionStatus.isPermanentlyDenied) {
          called = false;
          return 50;
        } else if (permissionStatus.isDenied) {
          called = false;
          return await rootDirec();
        }
      } else {
        return null;
      }
      await Future.delayed(const Duration(seconds: 3));
      Directory root = Directory('/storage/emulated/0');
      root.listSync().forEach((element) {
        //avoids android folder
        if (element.path.split("/").last.toLowerCase() != 'android' &&
            element is Directory) {
          directoryToCheck.add(element);
        }
        if (element.path.split("/").last.toLowerCase() == 'android' &&
            element is Directory) {
          element.listSync().forEach((current) {
            if (!(current.path.toLowerCase().endsWith("data")) &&
                !(current.path.toLowerCase().endsWith("obb"))) {
              directoryToCheck.add(current as Directory);
            }
          });
        }
        //if the fileSystemEntity in the list is a video file, it is added to list of video files.
        if (isVideo(element.path)) {
          videoPathList.add(element.path);
        }
      });

      for (var currentDirectory in directoryToCheck) {
        //recuresivily listing all directories and files and adding the file if it a video file
        currentDirectory.listSync(recursive: true).forEach((element) {
          if (isVideo(element.path)) {
            videoPathList.add(element.path);
          }
        });
      }
      for (var current in videoPathList) {
        String currentFolderName =
            current.split("/")[current.split("/").length - 2];
        if (!videoDirectories.keys.contains(currentFolderName)) {
          VideoModel currentModel = VideoModel(
              videoPath: current,
              videoName: FileFunctions.videoNameHelper(current),
              videoSize: FileFunctions.videoSizeHelper(current));
          videoDirectories[currentFolderName] = [currentModel];
        } else {
          VideoModel currentModel = VideoModel(
              videoPath: current,
              videoName: FileFunctions.videoNameHelper(current),
              videoSize: FileFunctions.videoSizeHelper(current));
          videoDirectories[currentFolderName]?.add(currentModel);
          videoDirectories[currentFolderName] =
              videoDirectories[currentFolderName]!.toSet().toList();
        }
      }
      videoPathList = videoPathList.toSet().toList();
      for (final currentPath in videoPathList) {
        VideoModel currentModel = VideoModel(
            videoPath: currentPath,
            videoName: FileFunctions.videoNameHelper(currentPath),
            videoSize: FileFunctions.videoSizeHelper(currentPath));
        if (!(videoList.contains(currentModel))) {
          videoList.add(currentModel);
        }
      }
    }
    listOfKeys =
        SortingFunctions.sortFolderAtoB(videoDirectories.keys.toList(), null);

    videoList = SortingFunctions().mergeSortByNameAtoZ(videoList, null);
    await Future.delayed(const Duration(seconds: 3));
    return androidVersion;
  }
}
