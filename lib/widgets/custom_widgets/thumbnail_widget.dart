import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../functions/storage_functions/thumbnail_functions.dart';

class ThumbnailWidget {
  Future<Widget> thumbnailImage(String currentPath) async {
    String thumPath = (await getApplicationDocumentsDirectory()).path;
    return await File(
                "$thumPath/${currentPath.split("/").last.replaceAll('.mp4', '.jpg')}")
            .exists()
        ? Image.file(
            File(
                "$thumPath/${currentPath.split("/").last.replaceAll('.mp4', '.jpg')}"),
            fit: BoxFit.cover,
          )
        : FutureBuilder(
            future: ThumbanailFunctions().generateVideoThumbnail(currentPath),
            builder: (context, snapshot) => snapshot.hasData &&
                    snapshot.data != null
                ? Image.file(File(
                    "$thumPath/${currentPath.split("/").last.replaceAll('.mp4', '.jpg')}"))
                : const Center(child: CircularProgressIndicator()));
  }
}
