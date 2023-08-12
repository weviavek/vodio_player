import 'package:flutter/material.dart';

import '../../model/video_model.dart';
import '../custom_widgets/thumbnail_widget.dart';

class ShowDetails {
  static showDetailsDialog(VideoModel currentModel, BuildContext context) {
    double width = MediaQuery.of(context).orientation == Orientation.portrait
        ? (MediaQuery.of(context).size.width) * .8
        : (MediaQuery.of(context).size.height) * .8;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:const Text(
              "Close",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        contentPadding:const EdgeInsets.all(16.0),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  height: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: FutureBuilder(
                      future: ThumbnailWidget()
                          .thumbnailImage(currentModel.videoPath),
                      builder: (context, snapshot) => snapshot.hasData
                          ? snapshot.data!
                          :const CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width * .23,
                    child:const Text(
                      "File Name",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      currentModel.videoName,
                      style:const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width * .23,
                    child:const Text(
                      "File Location",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      currentModel.videoPath,
                      style:const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width * .23,
                    child:const Text(
                      "File Type",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      currentModel.videoPath.split(".").last,
                      style:const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width * .23,
                    child:const Text(
                      "File Size",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      currentModel.videoSize,
                      style:const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
