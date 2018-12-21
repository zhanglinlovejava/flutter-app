import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_app1/components/video/VideoControlsView.dart';

class LinVideoView extends StatefulWidget {
  final double height;
  final bool autoPlay;
  final VideoPlayerController _controller;
  final Widget placeHolder;

  LinVideoView(this._controller,
      {this.height = 180, this.autoPlay = false, this.placeHolder});

  @override
  _LinVideoViewState createState() => _LinVideoViewState();
}

class _LinVideoViewState extends State<LinVideoView> {
  bool _hideToolsView = false;

  @override
  Widget build(BuildContext context) {
    return new Container(
        height: widget.height,
        width: MediaQuery.of(context).size.width,
        child: new Stack(
          children: <Widget>[
            widget.placeHolder == null
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
                  ),
            new GestureDetector(
                onTap: () {
                  setState(() {
                    _hideToolsView = !_hideToolsView;
                  });
                },
                child: AspectRatio(
                  aspectRatio:
                      MediaQuery.of(context).size.width / widget.height,
                  child: VideoPlayer(
                    widget._controller,
                  ),
                )),
            new Positioned(
                top: 0,
                child: new VideoControlsView(
                  widget.height,
                  widget._controller,
                  _hideToolsView,
                  autoPlay: widget.autoPlay,
                )),
          ],
        ));
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
}
