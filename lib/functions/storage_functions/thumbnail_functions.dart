import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ThumbanailFunctions {
  Future<String?> generateVideoThumbnail(String videoPath) async {
    
    String? thumpnailPath = await VideoThumbnail.thumbnailFile(
      timeMs: 1000,
      video: videoPath,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 120,
      quality: 100,
    );
    return thumpnailPath ?? 'Failed to generate thumpnail';
  }
}
