import 'dart:io';

import '../../model/mostly_played_model.dart';
import '../../model/video_model.dart';

class SortingFunctions {
  List<VideoModel> mergeSortByNameAtoZ(List<VideoModel> list, bool? isReverse) {
    if (list.length <= 1) {
      return list;
    }

    int mid = list.length ~/ 2;
    List<VideoModel> leftList = list.sublist(0, mid);
    List<VideoModel> rightList = list.sublist(mid);

    leftList = mergeSortByNameAtoZ(leftList, null);
    rightList = mergeSortByNameAtoZ(rightList, null);
    if (isReverse == true) {
      return merge(leftList, rightList).reversed.toList();
    }
    return merge(leftList, rightList);
  }

  List<VideoModel> merge(
      List<VideoModel> leftList, List<VideoModel> rightList) {
    List<VideoModel> mergedList = [];
    int leftIndex = 0;
    int rightIndex = 0;

    while (leftIndex < leftList.length && rightIndex < rightList.length) {
      if (leftList[leftIndex]
              .videoName
              .toLowerCase()
              .compareTo(rightList[rightIndex].videoName.toLowerCase()) <=
          0) {
        mergedList.add(leftList[leftIndex]);
        leftIndex++;
      } else {
        mergedList.add(rightList[rightIndex]);
        rightIndex++;
      }
    }

    while (leftIndex < leftList.length) {
      mergedList.add(leftList[leftIndex]);
      leftIndex++;
    }

    while (rightIndex < rightList.length) {
      mergedList.add(rightList[rightIndex]);
      rightIndex++;
    }

    return mergedList;
  }

  List<VideoModel> mergeSortBySizeStoL(List<VideoModel> list, bool? isReverse) {
    if (list.length <= 1) {
      return list;
    }

    int mid = list.length ~/ 2;
    List<VideoModel> leftList = list.sublist(0, mid);
    List<VideoModel> rightList = list.sublist(mid);

    leftList = mergeSortBySizeStoL(leftList, null);
    rightList = mergeSortBySizeStoL(rightList, null);
    if (isReverse == true) {
      return mergeSize(leftList, rightList).reversed.toList();
    }
    return mergeSize(leftList, rightList);
  }

  List<VideoModel> mergeSize(
      List<VideoModel> leftList, List<VideoModel> rightList) {
    List<VideoModel> mergedList = [];
    int leftIndex = 0;
    int rightIndex = 0;

    while (leftIndex < leftList.length && rightIndex < rightList.length) {
      if (File(leftList[leftIndex].videoPath).lengthSync() <
          File(rightList[rightIndex].videoPath).lengthSync()) {
        mergedList.add(leftList[leftIndex]);
        leftIndex++;
      } else {
        mergedList.add(rightList[rightIndex]);
        rightIndex++;
      }
    }

    while (leftIndex < leftList.length) {
      mergedList.add(leftList[leftIndex]);
      leftIndex++;
    }

    while (rightIndex < rightList.length) {
      mergedList.add(rightList[rightIndex]);
      rightIndex++;
    }

    return mergedList;
  }

  static List<String> sortFolderAtoB(List<String> listOfKeys, bool? reverse) {
    for (int i = 0; i < listOfKeys.length; i++) {
      for (int j = 0; j < listOfKeys.length; j++) {
        if (listOfKeys[i]
                .toLowerCase()
                .compareTo(listOfKeys[j].toLowerCase()) <=
            0) {
          final temp = listOfKeys[i];
          listOfKeys[i] = listOfKeys[j];
          listOfKeys[j] = temp;
        }
      }
    }
    if (reverse == true) {
      return listOfKeys.reversed.toList();
    }
    return listOfKeys;
  }

  static List<MostlyPlayedModel> sortMostPlayedFisrt(
      List<MostlyPlayedModel> currentList) {
    for (int i = 0; i < currentList.length; i++) {
      MostlyPlayedModel tempLarge = currentList[i];
      for (int j = i; j < currentList.length; j++) {
        if (tempLarge.count < currentList[j].count) {
          tempLarge = currentList[j];
        }
      }
      currentList[i] = tempLarge;
    }
    return currentList;
  }
}
