import 'package:flutter/material.dart';
import 'package:flutter_open/utils/DayFormat.dart';
import '../AuthorInfoWidget.dart';
import 'DynamicResourceTypeCard.dart';
import '../image/CustomImage.dart';

class DynamicVideoCardWidget extends StatelessWidget {
  final data;

  DynamicVideoCardWidget(this.data);

  @override
  Widget build(BuildContext context) {
    var user = data['user'];
    var simpleVideo = data['simpleVideo'];
    return new Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Colors.grey[200], width: 1))),
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: ClipOval(
              child: CustomImage(
                user['avatar'],
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
          _renderRightCard(context, user, simpleVideo),
        ],
      ),
    );
  }

  Expanded _renderRightCard(BuildContext context, user, simpleVideo) {
    return Expanded(
        child: Column(children: <Widget>[
      AuthorInfoWidget(
        name: user['nickname'],
        desc: data['text'],
        id: user['uid'].toString(),
        userType: user['userType'],
        rightBtnType: 'arrow',
        isDark: true,
      ),
      _renderVideoCard(simpleVideo, context, user),
      new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Row(
            children: <Widget>[
              Text(
                data['text'],
                style: TextStyle(fontFamily: 'FZLanTing'),
              ),
              new Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: Text(
                    TimelineUtil.format(data['createDate']),
                    style: TextStyle(color: Colors.grey),
                  )),
            ],
          ),
          new Row(
            children: <Widget>[
              Text(
                simpleVideo['consumption'] == null
                    ? '0'
                    : (simpleVideo['consumption']['collectionCount'])
                        .toString(),
                style: TextStyle(color: Colors.black, fontFamily: 'FZLanTing'),
              ),
              new Padding(
                padding: EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.favorite_border,
                  size: 20,
                  color: Colors.grey,
                ),
              )
            ],
          )
        ],
      )
    ]));
  }

  Container _renderVideoCard(simpleVideo, BuildContext context, user) {
    return new Container(
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(10, 0, 5, 10),
      margin: EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: DynamicResourceTypeCard(
          user: data['user'], simpleVideo: data['simpleVideo']),
    );
  }
}
