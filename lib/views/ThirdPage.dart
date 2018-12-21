import 'package:flutter/material.dart';
import 'package:flutter_app1/views/base/BaseAliveState.dart';
import 'package:flutter_app1/components/video/LinVideoView.dart';
import 'package:video_player/video_player.dart';

class ThirdPage extends StatefulWidget {
  @override
  ThirdPageState createState() => ThirdPageState();
}

class ThirdPageState extends BaseAliveState<ThirdPage> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'http://baobab.kaiyanapp.com/api/v1/playUrl?vid=142737&resourceType=video&editionType=default&source=aliyun');
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: new LinVideoView(
      _controller,
      autoPlay: false,
      placeHolder: new Image.network(
        'http://img.kaiyanapp.com/10ca092141fa2a28524b5cc400f4fc86.png?imageMogr2/quality/60/format/jpg',
        fit: BoxFit.cover,
      ),
    ));
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
