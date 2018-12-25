import 'package:flutter/material.dart';
import 'package:flutter_app1/components/video/LinVideoView.dart';
import 'package:flutter_app1/utils/StringUtil.dart';
import 'package:flutter_app1/api/HttpController.dart';
import 'package:video_player/video_player.dart';

class VideoPlayPage extends StatefulWidget {
  final Object item;

  @override
  VideoPlayState createState() => VideoPlayState();

  VideoPlayPage(
    this.item,
  );
}

class VideoPlayState extends State<VideoPlayPage> {
  var _itemData;
  var _itemList = new List();
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _itemData = widget.item;
    _controller = VideoPlayerController.network(_itemData['playUrl']);
    _getRelatedList();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: Text(_itemData['title']),
        ),
        body: new Stack(
          children: <Widget>[
            new Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                        'http://img.kaiyanapp.com/f31b4170c1b1a9c295b1cd74f3b56b72.jpeg?imageMogr2/quality/60/format/jpg/thumbnail/1000x720',
                      ),
                      fit: BoxFit.cover)),
              padding: EdgeInsets.only(top: 180),
              child: new ListView.builder(
                  shrinkWrap: true,
                  itemCount: _itemList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var _item = _itemList[index]['data'];
                    var type = _itemList[index]['type'];
                    print('type=$type');
                    if (index == 0) {
                      return _buildVideoInfo(context);
                    } else if (type == 'videoSmallCard') {
                      return _renderVideoCard(context, _item);
                    } else if (type == 'textCard') {
                      return _renderTextCard(context, _item);
                    }
                  }),
            ),
            new Container(
              height: 180,
              width: MediaQuery.of(context).size.width,
              child: new LinVideoView(
                  controller: _controller,
                  placeHolder: new Hero(
                      tag: _itemData['id'],
                      child: new Image(
                        image: NetworkImage(_itemData['cover']['feed']),
                        fit: BoxFit.cover,
                      )),
                  height: 180,
                  autoPlay: false),
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
            style: TextStyle(fontSize: 16, color: Colors.white),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          new Padding(
            padding: EdgeInsets.only(top: 3),
            child: new Text(
              '${StringUtil.buildTags(_itemData['tags'])}/${StringUtil.formatDuration2(_itemData['duration'])}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          new Padding(
              padding: EdgeInsets.only(top: 8, bottom: 10),
              child: new Text(
                _itemData['description'],
                style: TextStyle(fontSize: 14, color: Colors.white),
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
                  ),
                  new Padding(
                    padding: EdgeInsets.only(left: 7),
                    child: new Text(
                      _itemData['consumption']['collectionCount'].toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
              new Row(
                children: <Widget>[
                  new Icon(
                    Icons.share,
                    color: Colors.white,
                  ),
                  new Padding(
                    padding: EdgeInsets.only(left: 7),
                    child: new Text(
                      _itemData['consumption']['shareCount'].toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
              new Row(
                children: <Widget>[
                  new Icon(
                    Icons.comment,
                    color: Colors.white,
                  ),
                  new Padding(
                    padding: EdgeInsets.only(left: 7),
                    child: new Text(
                      _itemData['consumption']['replyCount'].toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
              new Row(
                children: <Widget>[
                  new Icon(
                    Icons.file_download,
                    color: Colors.white,
                  ),
                  new Padding(
                    padding: EdgeInsets.only(left: 7),
                    child: new Text(
                      '缓存',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
          _renderAuthorInfo(),
        ],
      ),
    );
  }

  _renderTextCard(context, _item) {
    return new Container(
      padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
      child: new Row(
        children: <Widget>[
          new Text(
            _item['text'],
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          new Icon(
            Icons.arrow_right,
            color: Colors.white,
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
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Color(0xffaaaaaa), width: 0.5))),
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: new Row(
          children: <Widget>[
            new Image.network(
              _item['cover']['feed'],
              width: 140,
              height: 75,
              fit: BoxFit.cover,
            ),
            new Expanded(
                child: new Container(
              padding: EdgeInsets.only(left: 10),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    _item['title'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  new Container(
                    padding: EdgeInsets.only(top: 8),
                    child: new Text(
                        '${StringUtil.buildTags(_item['tags'])}/${StringUtil.formatDuration2(_item['duration'])}',
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  _onItemTap(_item) {
    _controller = VideoPlayerController.network(_item['playUrl']);
    setState(() {
      _itemData = _item;
    });
    _getRelatedList();
  }

  _renderAuthorInfo() {
    return new Container(
      decoration: BoxDecoration(
          border: Border(
        top: BorderSide(color: Color(0xffaaaaaa), width: 0.5),
      )),
      padding: EdgeInsets.only(top: 10),
      margin: EdgeInsets.only(top: 10),
      child: new Row(
        children: <Widget>[
          new ClipOval(
            child: new Image.network(
              _itemData['author']['icon'],
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
                  _itemData['author']['name'],
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                new Text(
                  _itemData['author']['description'] +
                      _itemData['author']['description'],
                  style: TextStyle(color: Color(0xffdddddd), fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          )),
          new Container(
            width: 50,
            margin: EdgeInsets.only(left: 10),
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.all(color: Colors.white, width: 1)),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Icon(
                  Icons.add,
                  size: 15,
                  color: Colors.white,
                ),
                new Text(
                  "关注",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _getRelatedList() async {
    Map<String, String> params = new Map();
    params['id'] = _itemData['id'].toString();
    await HttpController.getInstance().get('v4/video/related', (data) {
      var itemList = data['itemList'];
      if (mounted) {
        setState(() {
          _itemList = itemList;
        });
      }
    }, params: params);
  }
}
