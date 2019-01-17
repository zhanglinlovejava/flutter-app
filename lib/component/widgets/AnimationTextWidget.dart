import 'package:flutter/material.dart';

class AnimationTextWidget extends StatefulWidget {
  final String text;
  final TextStyle style;
  final int miles;
  final int maxLines;
  final int delay;

  AnimationTextWidget(this.text,
      {this.style = const TextStyle(color: Colors.black),
      this.miles = 500,
      this.maxLines = 5,
      this.delay = 200});

  @override
  _AnimationTextWidget createState() => _AnimationTextWidget();
}

class _AnimationTextWidget extends State<AnimationTextWidget>
    with SingleTickerProviderStateMixin {
  String _showText = '';
  String _hideText = '';
  AnimationController _animationController;
  Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.miles));
    _animation = IntTween(begin: 0, end: widget.text.length).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
    _animation.addListener(() {
      setState(() {
        _showText = widget.text.substring(0, _animation.value);
        _hideText = widget.text.substring(_animation.value, widget.text.length);
      });
    });
    Future.delayed(Duration(milliseconds: widget.delay), () {
      _animationController.forward(from: 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: widget.maxLines,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(children: <TextSpan>[
        TextSpan(text: _showText, style: widget.style),
        TextSpan(
            text: _hideText,
            style: widget.style.copyWith(color: Colors.transparent))
      ]),
    );
  }
}
