import 'package:flutter/material.dart';
import 'package:flutter_open/component/widgets/VideoCardWidget.dart';
import 'package:flutter_open/utils/ActionViewUtils.dart';
import 'package:flutter_open/utils/StringUtil.dart';
import 'package:flutter_open/component/widgets/UgcPictureWidget.dart';
import 'AuthorInfoWidget.dart';

class AutoPlayFollowCardWidget extends StatefulWidget {
  final data;

  AutoPlayFollowCardWidget(this.data);

  @override
  _AutoPlayFollowCardWidgetState createState() {
    return _AutoPlayFollowCardWidgetState();
  }
}

class _AutoPlayFollowCardWidgetState extends State<AutoPlayFollowCardWidget> {
  var data;
  int descMaxLines = 2;

  @override
  void initState() {
    super.initState();
    data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: ActionViewUtils.renderBorderBottom(),
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.only(bottom: 10),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _renderAuthorInfo(),
          _renderDescription(),
          _renderTags(),
          _renderMiddleCard(),
          _renderBottomBar()
        ],
      ),
    );
  }

  _renderMiddleCard() {
    var _data = data['content']['data'];
    String type = _data['dataType'];
    if (type == 'VideoBeanForClient' || type == 'UgcVideoBean') {
      return VideoCardWidget(
        cover: _data['cover']['feed'],
        duration: _data['duration'],
        id: _data['id'],
        onCoverTap: () {
          ActionViewUtils.actionVideoPlayPage(context,
              desc: _data['description'],
              id: _data['id'],
              category: _data['category'],
              author: _data['author']??_data['owner'],
              cover: _data['cover'],
              consumption: _data['consumption'],
              title: _data['title']);
        },
      );
    } else if (type == 'UgcPictureBean') {
      return UgcPictureWidget(data['content']['data']);
    } else {
      return new Text(type);
    }
  }

  _renderTags() {
    var tags = data['content']['data']['tags'] ?? [];
    return tags.length == 0
        ? SizedBox(
            height: 10,
          )
        : new Container(
            height: 25,
            margin: EdgeInsets.only(bottom: 10, top: 10),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tags.length,
                itemBuilder: (BuildContext context, int index) {
                  return new Container(
                    margin: EdgeInsets.only(right: 5),
                    padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(80, 135, 200, 0.10),
                        borderRadius: BorderRadius.all(Radius.circular(3))),
                    child: Text(
                      tags[index]['name'],
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xff5087c8), fontSize: 14),
                    ),
                  );
                }),
          );
  }

  _renderDescription() {
    String desc = data['content']['data']['description'] ?? '';
    return Offstage(
      offstage: desc.length == 0,
      child: new Container(
        margin: EdgeInsets.only(top: 5),
        child: Stack(
          children: <Widget>[
            Text(
              desc,
              style: TextStyle(fontSize: 15, color: Colors.black54),
              maxLines: descMaxLines,
            ),
            new Positioned(
                right: 0,
                bottom: 0,
                child: Offstage(
                  offstage: descMaxLines > 2 || desc.length < 50,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        descMaxLines = descMaxLines > 2 ? 2 : 20;
                      });
                    },
                    child: new Container(
                      padding: EdgeInsets.fromLTRB(5, 2, 0, 2),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 0.8)),
                      child: Text(
                        '更多',
                        style: TextStyle(
                            color: Color(0xff5087c8),
                            fontFamily: 'FZLanTing',
                            fontSize: 13),
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  _renderBottomBar() {
    return new Container(
      margin: EdgeInsets.only(top: 15),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Row(
            children: <Widget>[
              Icon(
                Icons.favorite_border,
                size: 20,
                color: Colors.grey,
              ),
              new Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  data['content']['data']['consumption']['collectionCount']
                      .toString(),
                  style: TextStyle(color: Colors.grey),
                ),
              )
            ],
          ),
          new Row(
            children: <Widget>[
              Image(
                image: AssetImage('asset/images/comment_grey.png'),
                width: 18,
                height: 18,
              ),
              new Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  data['content']['data']['consumption']['replyCount']
                      .toString(),
                  style: TextStyle(color: Colors.grey),
                ),
              )
            ],
          ),
          Text(
            StringUtil.formatMileToDate(
                miles: data['content']['data']['releaseTime']),
            style: TextStyle(color: Colors.grey),
          ),
          Icon(
            Icons.share,
            size: 20,
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  _renderAuthorInfo() {
    var author = data['content']['data']['author'];
    var owner = data['content']['data']['owner'];
    String icon, name, id, userType;
    if (author == null) {
      icon = owner['avatar'];
      name = owner['nickname'];
      id = owner['uid'].toString();
      userType = owner['userType'];
    } else {
      icon = author['icon'];
      name = author['name'];
      id = author['id'].toString();
      userType = 'PGC';
    }
    return AuthorInfoWidget(
      name: name,
      avatar: icon,
      desc: '发布:',
      isDark: true,
      rightBtnType: 'none',
      id: id,
      userType: userType,
    );
  }
}
