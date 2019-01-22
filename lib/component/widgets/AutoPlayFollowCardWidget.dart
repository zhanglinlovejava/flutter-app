import 'package:flutter/material.dart';
import 'package:flutter_open/component/widgets/VideoCardWidget.dart';
import 'package:flutter_open/utils/ActionViewUtils.dart';
import 'package:flutter_open/utils/DayFormat.dart';
import 'package:flutter_open/component/widgets/UgcPictureWidget.dart';
import 'AuthorInfoWidget.dart';
import '../../Constants.dart';
import '../../pages/StickyHeaderTabPage.dart';
import '../../api/API.dart';
import 'package:flutter_open/component/widgets/button/FavouriteBtnWidget.dart';
import 'button/ShareBtnWidget.dart';
import '../../db/DBManager.dart';
import '../../entity/CollectionEntity.dart';

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
  DBManager _db;

  @override
  void initState() {
    super.initState();
    _db = DBManager();
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
          ActionViewUtils.actionVideoPlayPage(context, _data['id']);
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
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        Map<String, String> params = new Map();
                        params['id'] = tags[index]['id'].toString();
                        return StickyHeaderTabPage(
                            url: API.TAG_INFO_TAB,
                            params: params,
                            type: 'tagInfo');
                      }));
                    },
                    child: new Container(
                      margin: EdgeInsets.only(right: 5),
                      padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(80, 135, 200, 0.10),
                          borderRadius: BorderRadius.all(Radius.circular(3))),
                      child: Text(
                        tags[index]['name'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ConsColors.mainColor, fontSize: 14),
                      ),
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
                            color: ConsColors.mainColor,
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
    var _data = data['content']['data'];
    String _type = _data['dataType'];
    String title, cover, category, type, resourceType;
    int id, duration;
    if (_type == 'VideoBeanForClient' || _type == 'UgcVideoBean') {
      cover = _data['cover']['feed'];
      type = 'video';
      duration = _data['duration'];
    } else if (_type == 'UgcPictureBean') {
      type = 'picture';
      cover = _data['url'];
      resourceType = _data['resourceType'];
    }
    category = '#开眼精选';
    title = _data['description'];
    id = _data['id'];
    return new Container(
      margin: EdgeInsets.only(top: 15, left: 10, right: 10),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FavouriteBtnWidget(
            id,
            title: title,
            type: type,
            category: category,
            duration: duration,
            cover: cover,
            resourceType: resourceType,
          ),
          new Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                },
                child: Image(
                  image: AssetImage('asset/images/comment_grey.png'),
                  width: 18,
                  height: 18,
                ),
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
            TimelineUtil.format(data['content']['data']['releaseTime']),
            style: TextStyle(color: Colors.grey),
          ),
          ShareBtnWidget(
              actionType: _type == 'UgcPictureBean'
                  ? ShareType.picture
                  : ShareType.authorVideo,
              onSaveImage: () {
                print('保存图片');
              },
              onCacheVideo: () async {
                if (_type == 'UgcPictureBean') return;
                var _data = data['content']['data'];
                CollectionEntity ce = CollectionEntity(
                    source: DBSource.cache,
                    title: _data['title'],
                    category: '已缓存',
                    type: 'video',
                    cover: _data['cover']['feed'],
                    duration: _data['duration'],
                    itemId: _data['id']);
                await _db.saveCollection(ce);
              })
        ],
      ),
    );
  }

  _renderAuthorInfo() {
    var author = data['content']['data']['author'];
    var owner = data['content']['data']['owner'];
    String icon, name, id, userType;
    if (owner != null) {
      icon = owner['avatar'];
      name = owner['nickname'];
      id = owner['uid'].toString();
      userType = 'NORMAL';
    } else if (author != null) {
      icon = author['icon'];
      name = author['name'];
      id = author['id'].toString();
      userType = 'PGC';
    } else {
      return Container();
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
