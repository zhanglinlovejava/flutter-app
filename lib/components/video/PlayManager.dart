import 'package:video_player/video_player.dart';

class PlayManager {
  static PlayManager instance;

  static PlayManager getInstance() {
    if (instance == null) {
      instance = new PlayManager();
    }
    return instance;
  }
}
