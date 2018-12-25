import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
class PlayManager {
  VideoPlayerController _controller;
  VideoPlayerValue _latestValue;
  static PlayManager instance;

  static PlayManager getInstance() {
    if (instance == null) {
      instance = new PlayManager();
    }
    return instance;
  }

//初始化
  void init(String url,VoidCallback callback) {
    dispose();
    _controller = VideoPlayerController.network(url);
    _controller.addListener(_updateState);
    _updateState();
  }

//播放
  void play() {
    if(_latestValue!=null&&_latestValue.initialized){
      _controller.play();
    }else{

    }
  }

//暂停
  void pause() {
    if (_latestValue != null &&
        _latestValue.initialized &&
        _latestValue.isPlaying) {
      _controller.play();
    }
  }

//释放资源
  void dispose() {
    if (_controller != null) {
      _controller.dispose();
    }
  }

//播放监听
  void _updateState() {
    _latestValue = _controller.value;
  }
}
