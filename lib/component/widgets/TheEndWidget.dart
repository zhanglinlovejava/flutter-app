import 'package:flutter/material.dart';

class TheEndWidget extends StatelessWidget {
  final int color;

  TheEndWidget({this.color = 0xffffffff});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 50, bottom: 50),
      alignment: Alignment.center,
      child: Text(
        '- the end -',
        style:
            TextStyle(color: Color(color), fontSize: 20, fontFamily: 'Lobster'),
      ),
    );
  }
}
