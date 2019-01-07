import 'package:flutter/material.dart';

class AuthorInfoWidget extends StatelessWidget {
  final String name;
  final String desc;
  final String avatar;
  final bool isDark;

  AuthorInfoWidget({this.name, this.desc, this.avatar, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Row(
        children: <Widget>[
          new ClipOval(
            child: new Image.network(
              avatar,
              height: 40,
              width: 40,
            ),
          ),
          new Expanded(
              child: new Container(
            padding: EdgeInsets.only(left: 5),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  name,
                  style: TextStyle(
                      color: isDark ? Colors.black : Colors.white,
                      fontSize: 14,
                      fontFamily: 'FZLanTing'),
                ),
                new Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: new Text(
                    desc,
                    style: TextStyle(
                        color: isDark ? Colors.grey : Color(0xffdddddd),
                        fontSize: 12,
                        fontFamily: 'FZLanTing'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          )),
          new Container(
            width: 50,
            margin: EdgeInsets.only(left: 10),
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(3)),
                border: Border.all(
                    color: isDark ? Colors.black : Colors.white, width: 0.5)),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Icon(
                  Icons.add,
                  size: 15,
                  color: isDark ? Colors.black : Colors.white,
                ),
                new Text(
                  "关注",
                  style: TextStyle(
                      color: isDark ? Colors.black : Colors.white,
                      fontSize: 11,
                      fontFamily: 'FZLanTing'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
