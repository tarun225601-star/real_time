import 'package:video_player/video_player.dart';

class VideoPlayerUtils {
  static Future<VideoPlayerController> initializeVideoPlayerController(String videoUrl) async {
    final videoPlayerController = VideoPlayerController.network(videoUrl);
    await videoPlayerController.initialize();
    return videoPlayerController;
  }
}