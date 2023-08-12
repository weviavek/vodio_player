import 'package:hive_flutter/hive_flutter.dart';

import 'video_model.dart';
part 'mostly_played_model.g.dart';

@HiveType(typeId: 5)
class MostlyPlayedModel {
  @HiveField(0)
  final VideoModel videoModel;
  @HiveField(1)
  int count;
  MostlyPlayedModel(this.videoModel, this.count);
}
