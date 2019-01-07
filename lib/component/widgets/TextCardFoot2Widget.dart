import 'package:flutter/material.dart';

class TextCardFoot2Widget extends StatelessWidget {
  final String title;

  TextCardFoot2Widget({@required this.title});

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.only(bottom: 10, top: 10),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          new Text(
            title,
            style: TextStyle(
                fontSize: 13, fontFamily: 'FZLanTing', color: Color(0xff5087c8)),
          ),
          new Padding(
            padding: EdgeInsets.only(left: 5),
            child: Image(
              image: AssetImage('asset/images/arrow_right_blue.png'),
              width: 10,
              height: 15,
            ),
          )
        ],
      ),
    );
  }
}
