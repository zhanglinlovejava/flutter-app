import 'package:flutter/material.dart';

class FollowBtnWidget extends StatefulWidget {
  final bool isDark;

  FollowBtnWidget({this.isDark = false});

  @override
  _FollowBtnWidget createState() => _FollowBtnWidget();
}

class _FollowBtnWidget extends State<FollowBtnWidget> {
  bool isFollowed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isFollowed = !isFollowed;
        });
      },
      child: new Container(
        margin: EdgeInsets.only(left: 10),
        padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(3)),
            border: Border.all(
                color: widget.isDark ? Colors.black : Colors.white,
                width: 0.5)),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Icon(
            isFollowed?Icons.check:  Icons.add,
              size: 15,
              color: widget.isDark ? Colors.black : Colors.white,
            ),
            new Text(
              isFollowed ? '已关注' : "关注",
              style: TextStyle(
                  color: widget.isDark ? Colors.black : Colors.white,
                  fontSize: 11,
                  fontFamily: 'FZLanTing',
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none),
            )
          ],
        ),
      ),
    );
  }
}
