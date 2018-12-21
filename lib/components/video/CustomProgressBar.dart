import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomProgressBar extends StatefulWidget {
  final VideoPlayerController _controller;

  CustomProgressBar(this._controller);

  @override
  _CustomProgressState createState() => _CustomProgressState();
}

class _CustomProgressState extends State<CustomProgressBar> {
  VideoPlayerValue _lastestValue;
  int _current = 0;
  int _total = 0;
  double progressBarHeight = 48;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future _init() async {
    widget._controller.addListener(_updateState);
    _updateState();
  }

  void _updateState() {
    setState(() {
      _lastestValue = widget._controller.value;
      _current = _lastestValue != null && _lastestValue.duration != null
          ? _lastestValue.duration.inSeconds
          : 1;
      _total = _lastestValue != null && _lastestValue.position != null
          ? _lastestValue.position.inSeconds
          : 0;
    });
  }

  @override
  void dispose() {
    widget._controller.removeListener(_updateState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void seekToRelativePosition(Offset globalPosition) {
      final RenderBox box = context.findRenderObject();
      final Offset tapPos = box.globalToLocal(globalPosition);
      final double relative = tapPos.dx / box.size.width;
      final Duration position = _lastestValue.duration * relative;
      widget._controller.seekTo(position);
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
                  painter:
                      new ProgressPainter(widget._controller, _current, _total),
                ),
              )),
          GestureDetector(
            onHorizontalDragUpdate: (DragUpdateDetails details){
                if(_lastestValue!=null&&_lastestValue.initialized){
                  seekToRelativePosition(details.globalPosition);
                }
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

  ProgressPainter(this._controller, this._current, this._total) {
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
    _progressPaint.strokeWidth = 4;
    _progressPaint.isAntiAlias = true;

    _bgPaint = Paint();
    _bgPaint.color = Colors.grey;
    _bgPaint.strokeCap = StrokeCap.round;
    _bgPaint.style = PaintingStyle.fill;
    _bgPaint.strokeWidth = 4;
    _bgPaint.isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset(0, 0), Offset(size.width, 0), _bgPaint);
    canvas.drawLine(Offset(0, 0), Offset((size.width / _current * _total), 0),
        _progressPaint);
    canvas.drawCircle(
        Offset(size.width / _current * _total, 0), 6, _circlePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
