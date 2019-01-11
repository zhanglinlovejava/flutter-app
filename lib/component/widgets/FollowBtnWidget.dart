import 'package:flutter/material.dart';

class FollowBtnWidget extends StatefulWidget {
  final bool isDark;

  FollowBtnWidget({this.isDark = false});

  @override
  _FollowBtnWidget createState() => _FollowBtnWidget();
}

class _FollowBtnWidget extends State<FollowBtnWidget> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      width: 50,
      margin: EdgeInsets.only(left: 10),
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3)),
          border: Border.all(
              color: widget.isDark ? Colors.black : Colors.white, width: 0.5)),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Icon(
            Icons.add,
            size: 15,
            color: widget.isDark ? Colors.black : Colors.white,
          ),
          new Text(
            "关注",
            style: TextStyle(
                color: widget.isDark ? Colors.black : Colors.white,
                fontSize: 11,
                fontFamily: 'FZLanTing',
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.none),
          )
        ],
      ),
    );
  }
}
