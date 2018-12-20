import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_app1/components/loading/platform_adaptive_progress_indicator.dart';
import 'package:flutter_app1/utils/StringUtil.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String url;
  final String bgUrl;
  final double height;
  final double width;
  final bool stopPlay;
  final bool autoPlay;

  @override
  VideoPlayerState createState() => VideoPlayerState();

  CustomVideoPlayer(this.url, this.bgUrl, this.height, this.width,
      this.autoPlay, this.stopPlay);
}

class VideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _showCover = true;
  int _current = 0;
  int _total = 0;
  VoidCallback playListener;
  bool _showLoading = false;
  bool _showToolBar = false;
  bool _showPlayBtn = true;

  @override
  void initState() {
    super.initState();
    playListener = () {
      if (_controller.value.position.inSeconds ==
          _controller.value.duration.inSeconds) {
        _releasePlay();
      } else {
        final isPlaying = _controller.value.isPlaying;
        setState(() {
          _current = _controller.value.position.inSeconds;
          _total = _controller.value.duration.inSeconds;
        });
        if (_isPlaying != isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
      }
    };
    if (widget.autoPlay) {
      _startPlay();
    }
  }

  _onScreenTap() {
    setState(() {
      _showToolBar = !_showToolBar;
      _showPlayBtn = !_showPlayBtn;
    });
  }

  /// 点击开始播放
  _startPlay() {
    if (_controller == null) {
      setState(() {
        _showCover = false;
        _showLoading = true;
        _showPlayBtn = false;
      });
      _controller = VideoPlayerController.network(widget.url)
        ..addListener(playListener)
        ..initialize().then((_) {
          _controller.play().then((_) {
            _showPlayBtn = _showToolBar;
            setState(() {
              _isPlaying = true;
              _showLoading = false;
            });
          });
        });
    } else {
      if (!_isPlaying) {
        _controller.play();
      } else {
        _controller.pause();
      }
    }
  }

  ///渲染 进度条
  _buildProgressIndicator() {
    if (_controller != null) {
      return new Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          VideoProgressIndicator(
            _controller,
            allowScrubbing: true,
            padding: EdgeInsets.fromLTRB(55, 9, 55, 7),
          ),
          new Positioned(
            width: 15,
            height: 15,
            bottom: 1,
            left: 53 + (widget.width - 110) / _total * _current,
            child: new Image(image: new AssetImage('images/circle.png')),
          ),
        ],
      );
    } else {
      return new Container();
    }
  }

  ///渲染 视频播放器和背景
  _buildVideoView() {
    if (!_showCover && _controller != null && _controller.value.initialized) {
      return new GestureDetector(
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(
            _controller,
          ),
        ),
        onTap: _onScreenTap,
      );
    } else {
      return new Image.network(
        widget.bgUrl,
        fit: BoxFit.fitWidth,
        height: widget.height,
        width: widget.width,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
          alignment: const FractionalOffset(0.5, 0.5),
          children: <Widget>[
            new Container(
              child: _buildVideoView(),
              width: widget.width,
              height: widget.height,
            ),
            new Positioned(
              child: new Offstage(
                offstage: !_showLoading,
                child: new Container(
                  width: 30,
                  height: 30,
                  child: PlatformAdaptiveProgressIndicator(),
                ),
              ),
            ),
            new Positioned(
              child: _buildPlayBtn(),
            ),
            new Positioned(
              width: widget.width,
              height: widget.height,
              child: _buildToolBar(),
            )
          ]),
    );
  }

  _buildToolBar() {
    return new Offstage(
      offstage: !_showToolBar,
      child: new Stack(
        alignment: const FractionalOffset(0.5, 0.5),
        children: <Widget>[
          new Positioned(
            child: _buildProgressIndicator(),
            height: 20,
            left: 0,
            right: 0,
            bottom: 3,
          ),
          new Positioned(
            left: 5,
            bottom: 5,
            width: 50,
            child: new Text(
              StringUtil.formatDuration(_current),
              textAlign: TextAlign.center,
              style: new TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
          new Positioned(
            right: 5,
            bottom: 5,
            width: 50,
            child: new Text(
              StringUtil.formatDuration(_total),
              textAlign: TextAlign.center,
              style: new TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  _buildPlayBtn() {
    return new Offstage(
        offstage: !_showPlayBtn,
        child: new GestureDetector(
          onTap: _startPlay,
          child: new Container(
            padding: EdgeInsets.all(8),
            child: new Image(
              image: new AssetImage(
                  _isPlaying ? 'images/pause.png' : 'images/play.png'),
              width: 25,
              height: 25,
              fit: BoxFit.fill,
            ),
            decoration: new BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.4),
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
          ),
        ));
  }

  @override
  void didUpdateWidget(CustomVideoPlayer oldWidget) {
    if (widget.stopPlay &&
        _controller != null &&
        _controller.value.initialized &&
        _controller.value.isPlaying) {
      _releasePlay();
    }
    super.didUpdateWidget(oldWidget);
  }

  _releasePlay() {
    if (_controller != null) {
      _controller.removeListener(playListener);
      _controller.dispose();
      _controller = null;
      setState(() {
        _isPlaying = false;
        _showPlayBtn = true;
        _showToolBar = false;
      });
    }
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller.removeListener(playListener);
      _controller.dispose();
    }
    super.dispose();
  }
}
