import 'package:flutter/material.dart';
import 'package:flutter_app1/components/video/CustomProgressBar.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_app1/utils/StringUtil.dart';
import 'package:flutter_app1/components/loading/platform_adaptive_progress_indicator.dart';
import 'dart:async';

class VideoControlsView extends StatefulWidget {
  final VideoPlayerController controller;
  final double height;
  final bool autoPlay;
  final bool hideToolsView;
  final Future<dynamic> Function() toggleFullScreen;
  final bool isScreen;

  VideoControlsView(
      {Key key,
      @required this.height,
      @required this.controller,
      @required this.hideToolsView,
      @required this.isScreen,
      @required this.toggleFullScreen,
      this.autoPlay = false})
      : super(key: key);

  @override
  _VideoControlsViewState createState() => _VideoControlsViewState();
}

class _VideoControlsViewState extends State<VideoControlsView> {
  VideoPlayerValue _latestValue;
  bool _showLoading = false;
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future _initVideoController() async {
    await _controller.initialize();
    await _controller.play();
  }

  Future _init() async {
    _controller = widget.controller;
    _controller.addListener(_updateState);
    _updateState();

    if (widget.autoPlay) {
      _firstPlay();
    }
  }

  void _firstPlay() {
    setState(() {
      _showLoading = true;
    });
    _initVideoController().then((_) {
      setState(() {
        _showLoading = false;
      });
    });
  }

  void _togglePlay() {
    if (_latestValue != null && _latestValue.initialized) {
      if (_latestValue.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    } else {
      _firstPlay();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_updateState);
    super.dispose();
  }

  void _updateState() {
    setState(() {
      _latestValue = _controller.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: widget.height,
      width: MediaQuery.of(context).size.width,
      child: new Stack(
        children: <Widget>[
          _buildLoadingView(),
          _buildCenterPlayBtn(),
          _buildBottomBar(),
        ],
      ),
    );
  }

  _buildLoadingView() {
    return new Positioned(
        left: MediaQuery.of(context).size.width / 2 - 15,
        top: widget.height / 2 - 15,
        child: new Offstage(
          offstage: !_showLoading,
          child: new Container(
            width: 30,
            height: 30,
            child: PlatformAdaptiveProgressIndicator(),
          ),
        ));
  }

  _buildCenterPlayBtn() {
    return new Positioned(
      left: MediaQuery.of(context).size.width / 2 - 25,
      top: (widget.isScreen
                  ? MediaQuery.of(context).size.height
                  : widget.height) /
              2 -
          25,
      child: new Offstage(
        offstage: widget.hideToolsView || _showLoading,
        child: new GestureDetector(
          onTap: _togglePlay,
          child: new Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.4),
                borderRadius: BorderRadius.all(Radius.circular(30))),
            child: new Icon(
              _latestValue != null &&
                      _latestValue.initialized &&
                      _latestValue.isPlaying
                  ? Icons.pause
                  : Icons.play_arrow,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }

  _buildBottomBar() {
    return new Positioned(
        top: (widget.isScreen
                ? MediaQuery.of(context).size.height
                : widget.height) -
            40,
        child: new Offstage(
            offstage: !(_latestValue != null && _latestValue.initialized) ||
                widget.hideToolsView ||
                _showLoading,
            child: new Container(
                height: 48,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Color.fromRGBO(0, 0, 0, 0),
                  Color.fromRGBO(0, 0, 0, 0.3),
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                padding: EdgeInsets.only(left: 10, right: 10),
                width: MediaQuery.of(context).size.width,
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: new Text(
                        StringUtil.formatDuration(_latestValue != null &&
                                _latestValue.position != null
                            ? _latestValue.position.inSeconds
                            : 0),
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                    new Expanded(
                        child: new Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: new CustomProgressBar(_controller),
                    )),
                    new Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: new Text(
                        StringUtil.formatDuration(_latestValue != null &&
                                _latestValue.duration != null
                            ? _latestValue.duration.inSeconds
                            : 0),
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                    new GestureDetector(
                      onTap: () => widget.toggleFullScreen(),
                      child: new Icon(
                        widget.isScreen
                            ? Icons.fullscreen_exit
                            : Icons.fullscreen,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ],
                ))));
  }
}
