import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomProgressBar extends StatefulWidget {
  final VideoPlayerController controller;
  final String type;

  CustomProgressBar(this.controller, {this.type = 'normal'});

  @override
  _CustomProgressState createState() => _CustomProgressState();
}

class _CustomProgressState extends State<CustomProgressBar> {
  VideoPlayerController _controller;
  VideoPlayerValue _latestValue;
  int _current = 0;
  int _total = 0;
  double progressBarHeight = 48;

  @override
  void initState() {
    super.initState();
    progressBarHeight = widget.type == 'normal' ? progressBarHeight : 20;
    _init();
  }

  Future _init() async {
    _controller = widget.controller;
    _controller.addListener(_updateState);
    _updateState();
  }

  void _updateState() {
    setState(() {
      _latestValue = _controller.value;
      _current = _latestValue != null && _latestValue.duration != null
          ? _latestValue.duration.inSeconds
          : 1;
      _total = _latestValue != null && _latestValue.position != null
          ? _latestValue.position.inSeconds
          : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    void seekToRelativePosition(Offset globalPosition) {
      if (_latestValue != null &&
          _latestValue.initialized &&
          widget.type == 'normal') {
        final RenderBox box = context.findRenderObject();
        final Offset tapPos = box.globalToLocal(globalPosition);
        final double relative = tapPos.dx / box.size.width;
        final Duration position = _latestValue.duration * relative;
        _controller.seekTo(position);
      }
    }

    return new Center(
      child: new Stack(
        children: <Widget>[
          new Positioned(
              bottom: progressBarHeight / 2,
              left: 0,
              right: 0,
              child: new Container(
                width: MediaQuery.of(context).size.width,
                constraints: BoxConstraints(maxHeight: progressBarHeight),
                child: new CustomPaint(
                  painter: new ProgressPainter(_controller, _current, _total,
                      type: widget.type),
                ),
              )),
          GestureDetector(
            onHorizontalDragUpdate: (DragUpdateDetails details) {
              seekToRelativePosition(details.globalPosition);
            },
            onTapDown: (TapDownDetails details) {
              seekToRelativePosition(details.globalPosition);
            },
            child: new Container(
              color: Colors.transparent,
            ),
          )
        ],
      ),
    );
  }
}

class ProgressPainter extends CustomPainter {
  VideoPlayerController _controller;
  Paint _circlePaint;
  Paint _progressPaint;
  Paint _bgPaint;
  int _current = 0;
  int _total = 0;
  String type = 'normal';

  ProgressPainter(this._controller, this._current, this._total, {this.type}) {
    _circlePaint = Paint();
    _circlePaint.color = Colors.white;
    _circlePaint.strokeCap = StrokeCap.round;
    _circlePaint.style = PaintingStyle.fill;
    _circlePaint.strokeWidth = 1;
    _circlePaint.isAntiAlias = true;

    _progressPaint = Paint();
    _progressPaint.color = Colors.red;
    _progressPaint.strokeCap = StrokeCap.round;
    _progressPaint.style = PaintingStyle.fill;
    _progressPaint.strokeWidth = type == 'normal' ? 1 : 3;
    _progressPaint.isAntiAlias = true;

    _bgPaint = Paint();
    _bgPaint.color = Colors.white70;
    _bgPaint.strokeCap = StrokeCap.round;
    _bgPaint.style = PaintingStyle.fill;
    _bgPaint.strokeWidth = type == 'normal' ? 1 : 3;
    _bgPaint.isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset(0, 0), Offset(size.width, 0), _bgPaint);
    canvas.drawLine(Offset(0, 0), Offset((size.width / _current * _total), 0),
        _progressPaint);
    if (type == 'normal') {
      canvas.drawCircle(
          Offset(size.width / _current * _total, 0), 6, _circlePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
