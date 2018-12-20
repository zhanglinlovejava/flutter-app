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
    return new Container(
      width: MediaQuery.of(context).size.width,
      constraints: BoxConstraints(maxHeight: 50),
      child: new CustomPaint(
        painter: new ProgressPainter(
            widget._controller, _lastestValue, _current, _total),
      ),
    );
  }
}

class ProgressPainter extends CustomPainter {
  VideoPlayerController _controller;
  VideoPlayerValue _lastestValue;
  Paint _circlePaint;
  Paint _progressPaint;
  Paint _bgPaint;
  int _current = 0;
  int _total = 0;

  ProgressPainter(
      this._controller, this._lastestValue, this._current, this._total) {
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
