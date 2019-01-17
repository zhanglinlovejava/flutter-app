import 'package:flutter/material.dart';
import 'package:flutter_open/component/video/LinVideoView.dart';
import 'package:flutter_open/utils/StringUtil.dart';
import 'package:flutter_open/api/HttpController.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_open/component/widgets/AuthorInfoWidget.dart';
import 'package:flutter_open/component/widgets/TheEndWidget.dart';
import 'package:flutter_open/api/API.dart';
import 'package:flutter_open/component/widgets/AnimationTextWidget.dart';
import 'dart:io';
import 'package:flutter_open/component/widgets/VideoSmallCardWidget.dart';

class VideoPlayPage extends StatefulWidget {
  final consumption;
  final author;
  final cover;
  final String title;
  final String category;
  final String playUrl;
  final String desc;
  final String id;

  @override
  VideoPlayState createState() => VideoPlayState();

  VideoPlayPage(
      {this.consumption,
      this.author,
      this.cover,
      this.title,
      this.category,
      this.playUrl,
      this.desc,
      this.id});
}

class VideoPlayState extends State<VideoPlayPage> {
  var _consumption;
  var _author;
  var _cover;
  String _title;
  String _category;
  String _playUrl;
  String _desc;
  String _id;
  List _itemList = new List();
  VideoPlayerController _controller;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _consumption = widget.consumption;
    _author = widget.author;
    _title = widget.title;
    _playUrl = widget.playUrl;
    _desc = widget.desc;
    _id = widget.id;
    _cover = widget.cover;
    _controller = VideoPlayerController.network(_playUrl);
    _getRelatedList();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Stack(
      children: <Widget>[
        new Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(_cover['blurred'] ??
                      'http://img.kaiyanapp.com/cb916f79b1cfe542c2e58eaf00e84232.jpeg?imageMogr2/quality/60/format/jpg'),
                  fit: BoxFit.cover)),
          padding: EdgeInsets.only(top: Platform.isIOS ? 210 : 190),
          child: new ListView.builder(
              shrinkWrap: true,
              itemCount: _itemList.length,
              controller: _scrollController,
              itemBuilder: (BuildContext context, int index) {
                var _item = _itemList[index]['data'];
                var type = _itemList[index]['type'];
                if (index == 0) {
                  return _buildVideoInfo(context);
                } else if (index == _itemList.length - 1) {
                  return TheEndWidget();
                } else if (type == 'videoSmallCard') {
                  return Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: VideoSmallCardWidget(
                        cover: _item['cover']['feed'],
                        title: _item['title'],
                        onCoverTap: () {
                          _onItemTap(_item);
                        },
                        category: '${_item['category']} / 开眼精选',
                        duration: _item['duration'],
                        isDarkTheme: false),
                  );
                }
              }),
        ),
        new Container(
          margin: EdgeInsets.only(top: Platform.isIOS ? 0 : 20),
          width: MediaQuery.of(context).size.width,
          child: new LinVideoView(
            controller: _controller,
            placeHolder: new Image(
              image: NetworkImage(_cover['feed']),
              fit: BoxFit.cover,
            ),
            height: Platform.isIOS ? 210 : 190,
            autoPlay: false,
            title: _title,
          ),
        ),
      ],
    ));
  }

  _buildVideoInfo(BuildContext context) {
    return new Container(
      padding: EdgeInsets.all(10),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Offstage(
            offstage: _title == '',
            child: new AnimationTextWidget(
              _title,
              style: TextStyle(
                  fontSize: 16, color: Colors.white, fontFamily: 'FZLanTing'),
              maxLines: 1,
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 8),
            child: new AnimationTextWidget(
              _category == null ? '#开眼推荐' : '#$_category / 开眼推荐',
              style: TextStyle(
                  fontSize: 13, color: Colors.white70, fontFamily: 'FZLanTing'),
              maxLines: 1,
            ),
          ),
          new Padding(
              padding: EdgeInsets.only(top: 8, bottom: 15),
              child: new AnimationTextWidget(
                _desc,
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    fontFamily: 'FZLanTing'),
              )),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                    size: 20,
                  ),
                  new Padding(
                    padding: EdgeInsets.only(left: 7),
                    child: new Text(
                      _consumption == null
                          ? '0'
                          : _consumption['collectionCount'].toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'FZLanTing',
                          fontSize: 12),
                    ),
                  )
                ],
              ),
              new Row(
                children: <Widget>[
                  new Icon(
                    Icons.share,
                    color: Colors.white,
                    size: 20,
                  ),
                  new Padding(
                    padding: EdgeInsets.only(left: 7),
                    child: new Text(
                      _consumption == null
                          ? '0'
                          : _consumption['shareCount'].toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'FZLanTing',
                          fontSize: 12),
                    ),
                  )
                ],
              ),
              new Row(
                children: <Widget>[
                  new Icon(
                    Icons.comment,
                    color: Colors.white,
                    size: 20,
                  ),
                  new Padding(
                    padding: EdgeInsets.only(left: 7),
                    child: new Text(
                      _consumption == null
                          ? '0'
                          : _consumption['replyCount'].toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'FZLanTing',
                          fontSize: 12),
                    ),
                  )
                ],
              ),
              new Row(
                children: <Widget>[
                  new Icon(
                    Icons.file_download,
                    color: Colors.white,
                    size: 20,
                  ),
                  new Padding(
                    padding: EdgeInsets.only(left: 7),
                    child: new Text(
                      '缓存',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'FZLanTing',
                          fontSize: 12),
                    ),
                  )
                ],
              )
            ],
          ),
          renderAuthorInfo()
        ],
      ),
    );
  }

  renderAuthorInfo() {
    if (_author == null) {
      return new Container();
    }
    String name = _author['name'] ?? _author['nickname'];
    String desc = _author['description'];
    String avatar = _author['icon'] ?? _author['avatar'];
    String id = (_author['id'] ?? _author['uid']).toString();
    String userType = _author['name'] != null ? 'PGC' : 'NORMAL';
    return new Container(
      margin: EdgeInsets.only(top: 15),
      child: AuthorInfoWidget(
        name: name,
        desc: desc,
        avatar: avatar,
        id: id,
        userType: userType,
        rightBtnType: 'follow',
      ),
    );
  }

  _onItemTap(_item) {
    setState(() {
      _consumption = _item['consumption'];
      _author = _item['author'];
      _title = _item['title'];
      _desc = _item['description'];
      _id = _item['id'].toString();
      _cover = _item['cover'];
      _category = _item['category'];
      _playUrl = _item['playUrl'];
      _controller = VideoPlayerController.network(_playUrl);
    });
    _scrollController.jumpTo(0);
    _getRelatedList();
  }

  _getRelatedList() async {
    Map<String, String> params = new Map();
    params['id'] = _id;
    await HttpController.getInstance().get(API.VIDEO_RELATED_LIST, (data) {
      var itemList = data['itemList'];
      itemList.forEach((item) {
        if (item['type'] == 'videoSmallCard') {
          _itemList.add(item);
        }
      });
      _itemList.add(_itemList[0]);
      if (mounted) {
        setState(() {});
      }
    }, params: params);
  }
}
