import 'package:audio_service/audio_service.dart';
import 'package:video_player/video_player.dart';

class PlayKits {
  static VideoPlayerController _controller;

  static play(String url) {
    _controller = VideoPlayerController.network(url)
        ..initialize();
  }
}
