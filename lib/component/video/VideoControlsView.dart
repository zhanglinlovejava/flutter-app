import 'package:flutter/material.dart';
import 'package:flutter_open/component/video/CustomProgressBar.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_open/utils/StringUtil.dart';
import 'package:flutter_open/component/loading/platform_adaptive_progress_indicator.dart';
import 'dart:async';

class VideoControlsView extends StatefulWidget {
  final VideoPlayerController controller;
  final double height;
  final bool autoPlay;
  final String title;

  final Future<dynamic> Function() toggleFullScreen;
  final bool isScreen;

  VideoControlsView(
      {Key key,
      @required this.height,
      @required this.controller,
      @required this.isScreen,
      @required this.toggleFullScreen,
      this.autoPlay = false,
      this.title = ''})
      : super(key: key);

  @override
  _VideoControlsViewState createState() => _VideoControlsViewState();
}

class _VideoControlsViewState extends State<VideoControlsView> {
  VideoPlayerValue _latestValue;
  bool _showLoading = false;
  VideoPlayerController _controller;
  bool _hideToolsView = false;
  Timer timer;

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

    if (widget.autoPlay&&(_latestValue == null || !_latestValue.initialized)) {
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
        _hideToolsView = true;
      });
    });
  }

  void _togglePlay() async {
    if (_latestValue != null && _latestValue.initialized) {
      if (_latestValue.isPlaying) {
        await _controller.pause();
        _timerToHideToolsBar();
      } else {
        await _controller.play();
        _timerToHideToolsBar();
      }
    } else {
      _firstPlay();
    }
  }

  @override
  void dispose() {
    if (timer != null) timer.cancel();
    super.dispose();
  }

  void _updateState() {
    setState(() {
      _latestValue = _controller.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        if (_latestValue != null && _latestValue.initialized)
          setState(() {
            _hideToolsView = !_hideToolsView;
          });
        _timerToHideToolsBar();
      },
      child: new Container(
        color: Colors.transparent,
        height: widget.height,
        width: MediaQuery.of(context).size.width,
        child: new Stack(
          children: <Widget>[
            _buildTopView(),
            _buildLoadingView(),
            _buildCenterPlayBtn(),
            _buildBottom()
          ],
        ),
      ),
    );
  }

  _buildTopView() {
    if (!_hideToolsView && !_showLoading) {
      return widget.isScreen
          ? _buildFullScreenTopView()
          : _buildNormalTopView();
    } else {
      return new Container();
    }
  }

  void _timerToHideToolsBar() {
    if (!_hideToolsView && _latestValue != null && _latestValue.isPlaying) {
      if (timer != null) {
        timer.cancel();
        timer = null;
      }
      timer = Timer(const Duration(seconds: 4), () {
        setState(() {
          _hideToolsView = true;
        });
        timer = null;
      });
    } else {
      if (timer != null) {
        timer.cancel();
        timer = null;
      }
    }
  }

  _buildBottom() {
    if (_latestValue != null && _latestValue.initialized) {
      if (!_hideToolsView && !_showLoading) {
        return _buildBottomBar();
      }
      if (_hideToolsView) {
        return _buildBottomProgress();
      }
    }
    return new Container();
  }

  _buildNormalTopView() {
    return new Positioned(
        top: 10,
        left: 10,
        child: new GestureDetector(
          onTap: _onCloseTap,
          child: new Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.5),
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: Icon(
              Icons.close,
              color: Colors.white,
              size: 20,
            ),
          ),
        ));
  }

  _onCloseTap() {
    Navigator.of(context).pop();
  }

  _buildFullScreenTopView() {
    return new Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: new Container(
            padding: EdgeInsets.fromLTRB(0, 5, 10, 5),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromRGBO(0, 0, 0, 0.3),
              Color.fromRGBO(0, 0, 0, 0),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: new Row(
              children: <Widget>[
                new GestureDetector(
                  onTap: widget.toggleFullScreen,
                  child: new Image(
                    image: AssetImage('asset/images/back.png'),
                    width: 60,
                    height: 25,
                  ),
                ),
                new Expanded(
                  child: new Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            )));
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
    double btnSize = widget.isScreen ? 40 : 30;
    return new Positioned(
      left: MediaQuery.of(context).size.width / 2 - btnSize / 2 - 5,
      top: (widget.isScreen
                  ? MediaQuery.of(context).size.height
                  : widget.height) /
              2 -
          btnSize / 2 -
          5,
      child: new Offstage(
        offstage: _hideToolsView || _showLoading,
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
              size: btnSize,
            ),
          ),
        ),
      ),
    );
  }

  _buildBottomProgress() {
    return new Positioned(
      top: (widget.isScreen
              ? MediaQuery.of(context).size.height
              : widget.height) -
          10,
      left: 0,
      right: 0,
      child: new Container(
          height: 20,
          child: new CustomProgressBar(
            widget.controller,
            type: 'small',
          )),
    );
  }

  _buildBottomBar() {
    return new Positioned(
        top: (widget.isScreen
                ? MediaQuery.of(context).size.height
                : widget.height) -
            40,
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
                    StringUtil.formatDuration(
                        _latestValue != null && _latestValue.position != null
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
                    StringUtil.formatDuration(
                        _latestValue != null && _latestValue.duration != null
                            ? _latestValue.duration.inSeconds
                            : 0),
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
                new GestureDetector(
                  onTap: () {
                    widget.toggleFullScreen();
                  },
                  child: new Icon(
                    widget.isScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ],
            )));
  }

  @override
  void didUpdateWidget(VideoControlsView oldWidget) {
    if (widget.controller.dataSource != _controller.dataSource) {
      _controller.removeListener(_updateState);
      _controller.dispose();
      _controller = widget.controller;
      _init();
      _firstPlay();
    }
    super.didUpdateWidget(oldWidget);
  }
}
