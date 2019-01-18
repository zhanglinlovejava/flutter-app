import 'package:flutter/material.dart';
import 'package:flutter_open/component/video/LinVideoView.dart';
import 'package:flutter_open/api/HttpController.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_open/component/widgets/AuthorInfoWidget.dart';
import 'package:flutter_open/component/widgets/TheEndWidget.dart';
import 'package:flutter_open/api/API.dart';
import 'package:flutter_open/component/widgets/AnimationTextWidget.dart';
import 'dart:io';
import 'package:flutter_open/component/widgets/VideoSmallCardWidget.dart';
import '../component/loading/LoadingStatus.dart';
import '../component/loading/loading_view.dart';
import '../component/loading/platform_adaptive_progress_indicator.dart';
import '../component/widgets/LoadErrorWidget.dart';
import '../Constants.dart';

class VideoPlayPage extends StatefulWidget {
  final int videoId;

  VideoPlayPage(this.videoId);

  @override
  VideoPlayState createState() => VideoPlayState();
}

class VideoPlayState extends State<VideoPlayPage> {
  LoadingStatus _status = LoadingStatus.loading;
  List _itemList = new List();
  VideoPlayerController _controller;
  ScrollController _scrollController = ScrollController();
  var _videoData;
  String _title;
  String _desc;
  String _category;

  @override
  void initState() {
    super.initState();
    _fetchVideoInfo();
    _getRelatedList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
          alignment: Alignment.center,
          color: Colors.white,
          child: LoadingView(
              status: _status,
              loadingContent: PlatformAdaptiveProgressIndicator(strokeWidth: 2),
              errorContent: LoadErrorWidget(onRetryFunc: () {
                _status = LoadingStatus.loading;
                setState(() {});
                _fetchVideoInfo();
              }),
              successContent: _videoData != null
                  ? new Stack(children: <Widget>[
                      new Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(_videoData['blurred'] ??
                                    'http://img.kaiyanapp.com/cb916f79b1cfe542c2e58eaf00e84232.jpeg?imageMogr2/quality/60/format/jpg'),
                                fit: BoxFit.cover)),
                        padding:
                            EdgeInsets.only(top: Platform.isIOS ? 210 : 190),
                        child: _renderListView(),
                      ),
                      _bgView(context)
                    ])
                  : Container())),
    );
  }

  _renderListView() {
    return new ListView.builder(
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
        });
  }

  _bgView(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Platform.isIOS ? 0 : 20),
      width: MediaQuery.of(context).size.width,
      child: new LinVideoView(
        controller: _controller,
        placeHolder: new Image(
          image: NetworkImage(_videoData['cover']['feed']),
          fit: BoxFit.cover,
        ),
        height: Platform.isIOS ? 210 : 190,
        autoPlay: false,
        title: _title,
      ),
    );
  }

  _buildVideoInfo(BuildContext context) {
    var _consumption = _videoData['consumption'];
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
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: ConsFonts.fzFont),
              maxLines: 1,
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 8),
            child: new AnimationTextWidget(
              _category == null ? '#开眼推荐' : '#$_category / 开眼推荐',
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.white70,
                  fontFamily: ConsFonts.fzFont),
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
                    fontFamily: ConsFonts.fzFont),
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
                          fontFamily: ConsFonts.fzFont,
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
                          fontFamily: ConsFonts.fzFont,
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
    var _author = _videoData['author'];
    String name = _author['name'];
    String desc = _author['description'];
    String avatar = _author['icon'];
    String id = _author['id'].toString();
    String userType = _author['ifPgc'] ? 'PGC' : 'NORMAL';
    return new Container(
        margin: EdgeInsets.only(top: 15),
        child: AuthorInfoWidget(
          name: name,
          desc: desc,
          avatar: avatar,
          id: id,
          userType: userType,
          rightBtnType: 'follow',
        ));
  }

  _onItemTap(_item) {
    _videoData = _item;
    _parseTopData();
    _controller = VideoPlayerController.network(_videoData['playUrl']);
    setState(() {});
    double duration = (_scrollController.offset /
            _scrollController.position.maxScrollExtent) *
        500;
    _scrollController.animateTo(0, duration: Duration(milliseconds: duration.toInt()),curve: Curves.easeIn);
    _getRelatedList();
  }

  _getRelatedList() async {
    Map<String, String> params = new Map();
    params['id'] = widget.videoId.toString();
    await HttpController.getInstance().get(API.VIDEO_RELATED_LIST, (data) {
      var itemList = data['itemList'];
      itemList.forEach((item) {
        if (item['type'] == 'videoSmallCard') {
          _itemList.add(item);
        }
      });
      if (mounted) {
        setState(() {});
      }
    }, params: params);
  }

  _fetchVideoInfo() async {
    await HttpController.getInstance()
        .get('${API.VIDEO_DETAIL}/${widget.videoId}', (data) {
      if (data != null) {
        _videoData = data;
        _parseTopData();
      } else {
        _status = LoadingStatus.error;
      }
      if (mounted) setState(() {});
    }, errorCallback: (_) {
      _status = LoadingStatus.error;
      if (mounted) setState(() {});
    });
  }

  void _parseTopData() {
    _title = _videoData['title'];
    _desc = _videoData['description'];
    _category = _videoData['category'];
    _status = LoadingStatus.success;
    _controller = VideoPlayerController.network(_videoData['playUrl']);
  }
}
