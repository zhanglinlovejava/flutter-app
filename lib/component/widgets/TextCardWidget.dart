import 'package:flutter/material.dart';

class TextCardWidget extends StatelessWidget {
  final data;

  TextCardWidget(this.data);

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.only(bottom: 10, top: 10),
      child: new Row(
        children: <Widget>[
          new Text(
            data['text'],
            style: TextStyle(fontSize: 20, fontFamily: 'FZLanTing'),
          ),
          new Padding(
            padding: EdgeInsets.only(left: 5),
            child: Image(
              image: AssetImage('asset/images/arrow_right.png'),
              width: 10,
              height: 15,
            ),
          )
        ],
      ),
    );
  }
}
