import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_app1/components/video/VideoControlsView.dart';
import 'package:flutter/services.dart';

class LinVideoView extends StatefulWidget {
  final double height;
  final bool autoPlay;
  final Widget placeHolder;
  final VideoPlayerController controller;
  final String title;

  LinVideoView(
      {@required this.controller,
      @required this.height,
      this.autoPlay = false,
      this.placeHolder,
      this.title = ''});

  @override
  _LinVideoViewState createState() => _LinVideoViewState();
}

class _LinVideoViewState extends State<LinVideoView> {
  bool _isScreen = false;
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        height: widget.height,
        width: MediaQuery.of(context).size.width,
        child: _buildVideo(
            isFull: false,
            ratio: MediaQuery.of(context).size.width / widget.height,
            isScreen: false,
            height: widget.height,
            toggleFullScreen: () {
              setState(() {
                _isScreen = true;
              });
              _pushFullScreenWidget(context);
            }));
  }

  Future<dynamic> _pushFullScreenWidget(BuildContext context) async {
    final isAndroid = Theme.of(context).platform == TargetPlatform.android;
    TransitionRoute<Null> route = new PageRouteBuilder<Null>(
      settings: new RouteSettings(isInitialRoute: false),
      pageBuilder: _fullScreenRoutePageBuilder,
    );
    SystemChrome.setEnabledSystemUIOverlays([]);
    if (isAndroid) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
    await Navigator.of(context).push(route);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Widget _fullScreenRoutePageBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return new AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget child) {
        return _buildFullScreenVideo(context, animation);
      },
    );
  }

  Widget _buildFullScreenVideo(
      BuildContext context, Animation<double> animation) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new Container(
          alignment: Alignment.center,
          color: Colors.black,
          child: new WillPopScope(
              child: _buildVideo(
                isFull: true,
                ratio: _controller.value.aspectRatio,
                isScreen: _isScreen,
                height: MediaQuery.of(context).size.width,
                toggleFullScreen: () {
                  setState(() {
                    _isScreen = false;
                  });
                  new Future<dynamic>.value(Navigator.of(context).pop());
                },
              ),
              onWillPop: () {
                setState(() {
                  _isScreen = false;
                });
                new Future.value(Navigator.of(context).pop());
              })),
    );
  }

  Widget _buildVideo(
      {Key key,
      @required bool isFull,
      @required double ratio,
      @required bool isScreen,
      @required double height,
      @required Function toggleFullScreen}) {
    return new Stack(
      children: <Widget>[
        isFull ? new Container() : _buildPlaceHolder(),
        AspectRatio(
          aspectRatio: ratio,
          child: VideoPlayer(
            _controller,
          ),
        ),
        new Positioned(
            top: 0,
            child: new VideoControlsView(
              height: height,
              controller: _controller,
              isScreen: isScreen,
              toggleFullScreen: toggleFullScreen,
              autoPlay: widget.autoPlay,
              title: widget.title,
            )),
      ],
    );
  }

  Widget _buildPlaceHolder() {
    return widget.placeHolder == null
        ? new Container(
            height: widget.height,
            width: MediaQuery.of(context).size.width,
            decoration: _renderGradientBg(),
          )
        : new Container(
            decoration: _renderGradientBg(),
            height: widget.height,
            width: MediaQuery.of(context).size.width,
            child: widget.placeHolder,
          );
  }

  _renderGradientBg() {
    return BoxDecoration(
        gradient: LinearGradient(colors: [
      Color.fromRGBO(0, 0, 0, 0),
      Color.fromRGBO(0, 0, 0, 0),
      Color.fromRGBO(0, 0, 0, 0),
      Color.fromRGBO(0, 0, 0, 0.04),
      Color.fromRGBO(0, 0, 0, 0.2),
    ], begin: Alignment.topCenter, end: Alignment.bottomCenter));
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller != null) {
      _controller.dispose();
    }
  }
  @override
  void didUpdateWidget(LinVideoView oldWidget) {
    if (widget.controller.dataSource != _controller.dataSource) {
      setState(() {
        _controller = widget.controller;
      });
    }
    super.didUpdateWidget(oldWidget);
  }
}
