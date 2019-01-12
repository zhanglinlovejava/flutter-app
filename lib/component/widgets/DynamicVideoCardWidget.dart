import 'package:flutter/material.dart';
import 'package:flutter_open/component/widgets/VideoSmallCardWidget.dart';
import 'package:flutter_open/utils/ActionViewUtils.dart';
import 'package:flutter_open/utils/StringUtil.dart';
import 'AuthorInfoWidget.dart';

class DynamicVideoCardWidget extends StatelessWidget {
  final data;

  DynamicVideoCardWidget(this.data);

  @override
  Widget build(BuildContext context) {
    var user = data['user'];
    var simpleVideo = data['simpleVideo'];
    return new Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: ClipOval(
              child: Image.network(
                user['avatar'],
                width: 40,
                height: 40,
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
        desc: '关注：',
        avatar: user['avatar'],
        id: user['uid'].toString(),
        userType: user['userType'],
        rightBtnType: 'arrow',
        showAvatar: false,
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
                    StringUtil.formatMileToDate(miles: data['createDate']),
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
      child: Column(
        children: <Widget>[
          VideoSmallCardWidget(
            id: simpleVideo['id'],
            cover: simpleVideo['cover']['feed'],
            title: simpleVideo['title'],
            duration: simpleVideo['duration'],
            category: simpleVideo['category'],
            onCoverTap: () {
              ActionViewUtils.actionVideoPlayPage(context,
                  desc: simpleVideo['description'],
                  id: simpleVideo['id'],
                  category: simpleVideo['category'],
                  author: user,
                  cover: simpleVideo['cover'],
                  consumption: simpleVideo['consumption'],
                  title: simpleVideo['title']);
            },
          )
        ],
      ),
    );
  }
}
