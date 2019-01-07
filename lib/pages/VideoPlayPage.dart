import 'package:flutter/material.dart';
import 'package:flutter_open/component/video/LinVideoView.dart';
import 'package:flutter_open/utils/StringUtil.dart';
import 'package:flutter_open/api/HttpController.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_open/component/widgets/AuthorInfoWidget.dart';
import 'package:flutter_open/component/widgets/TheEndWidget.dart';

class VideoPlayPage extends StatefulWidget {
  final Object item;

  @override
  VideoPlayState createState() => VideoPlayState();

  VideoPlayPage(this.item);
}

class VideoPlayState extends State<VideoPlayPage> {
  var _itemData;
  List _itemList = new List();
  VideoPlayerController _controller;
  ScrollController _scrollController = ScrollController();
  var _tag;

  @override
  void initState() {
    super.initState();
    _itemData = widget.item;
    _tag = _itemData['id'];
    _controller = VideoPlayerController.network(_itemData['playUrl']);
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
                  image: NetworkImage(_itemData['cover']['blurred'] ??
                      'http://img.kaiyanapp.com/cb916f79b1cfe542c2e58eaf00e84232.jpeg?imageMogr2/quality/60/format/jpg'),
                  fit: BoxFit.cover)),
          padding: EdgeInsets.only(top: 190),
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
                  return _renderVideoCard(context, _item);
                }
              }),
        ),
        new Container(
          height: 190,
          margin: EdgeInsets.only(top: 20),
          width: MediaQuery.of(context).size.width,
          child: new LinVideoView(
            controller: _controller,
            placeHolder: new Hero(
                tag: _tag,
                child: new Image(
                  image: NetworkImage(_itemData['cover']['feed']),
                  fit: BoxFit.cover,
                )),
            height: 190,
            autoPlay: false,
            title: _itemData['title'],
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
          new Text(
            _itemData['title'],
            style: TextStyle(
                fontSize: 16, color: Colors.white, fontFamily: 'FZLanTing'),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          new Padding(
            padding: EdgeInsets.only(top: 8),
            child: new Text(
              '#${_itemData['category']} / 开眼推荐',
              style: TextStyle(
                  fontSize: 13, color: Colors.white70, fontFamily: 'FZLanTing'),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          new Padding(
              padding: EdgeInsets.only(top: 8, bottom: 10),
              child: new Text(
                _itemData['description'],
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    fontFamily: 'FZLanTing'),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
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
                      _itemData['consumption'] == null
                          ? '0'
                          : _itemData['consumption']['collectionCount']
                              .toString(),
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
                      _itemData['consumption'] == null
                          ? '0'
                          : _itemData['consumption']['shareCount'].toString(),
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
                      _itemData['consumption'] == null
                          ? '0'
                          : _itemData['consumption']['replyCount'].toString(),
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
          _itemData['author'] == null
              ? new Container()
              : new Container(
                  margin: EdgeInsets.only(top: 10),
                  child: AuthorInfoWidget(
                    name: _itemData['author']['name'],
                    desc: _itemData['author']['description'],
                    avatar: _itemData['author']['icon'],
                  ),
                )
        ],
      ),
    );
  }

  _renderVideoCard(context, _item) {
    return new GestureDetector(
      onTap: () {
        _onItemTap(_item);
      },
      child: new Container(
        margin: EdgeInsets.fromLTRB(10, 7, 5, 7),
        height: 90,
        child: new Row(
          children: <Widget>[
            new Stack(
              children: <Widget>[
                new ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  child: new Image.network(
                    _item['cover']['feed'],
                    width: 160,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                _buildDuration(_item['duration']),
              ],
            ),
            new Expanded(
                child: new Container(
              padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text(
                    _item['title'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'FZLanTing'),
                  ),
                  new Text(
                    '#${_item['category']} / 开眼精选',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontFamily: 'FZLanTing'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  _buildDuration(int duration) {
    return new Positioned(
        right: 5,
        bottom: 5,
        child: new Container(
          padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(3)),
            color: Color.fromRGBO(0, 0, 0, 0.6),
          ),
          child: Text(
            StringUtil.formatDuration(duration),
            style: TextStyle(
                color: Colors.white, fontSize: 12, fontFamily: 'FZLanTing'),
          ),
        ));
  }

  _onItemTap(_item) {
    setState(() {
      _itemData = _item;
      _controller = VideoPlayerController.network(_item['playUrl']);
    });
    _scrollController.jumpTo(0);
    _getRelatedList();
  }

  _getRelatedList() async {
    Map<String, String> params = new Map();
    params['id'] = _itemData['id'].toString();
    await HttpController.getInstance().get('v4/video/related', (data) {
      var itemList = data['itemList'];
      itemList.forEach((item) {
        if (item['type'] == 'videoSmallCard') {
          _itemList.add(item);
        }
      });
      _itemList.add(_itemData);
      if (mounted) {
        setState(() {});
      }
    }, params: params);
  }
}
