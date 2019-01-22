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
import 'package:flutter_open/component/widgets/button/FavouriteBtnWidget.dart';
import '../db/DBManager.dart';
import '../entity/CollectionEntity.dart';
import '../component/widgets/button/ShareBtnWidget.dart';

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
  DBManager _db;

  @override
  void initState() {
    super.initState();
    _db = DBManager();
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
                  showShareBtn: true,
                  onCacheVideo: () async {
                    CollectionEntity ce = CollectionEntity(
                      source: DBSource.cache,
                      itemId: _videoData['id'],
                      type: 'video',
                      cover: _videoData['cover']['feed'],
                      title: _title,
                      duration: _videoData['duration'],
                      category: '已缓存',
                    );
                    await _db.saveCollection(ce);
                  },
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
        autoPlay: bool.fromEnvironment("dart.vm.product"),
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
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FavouriteBtnWidget(widget.videoId,
                    title: _title,
                    category: _category,
                    duration: _videoData['duration'],
                    cover: _videoData['cover']['feed'],
                    type: 'video',
                    isDark: false),
                new Row(
                  children: <Widget>[
                    Icon(Icons.share, color: Colors.white, size: 20),
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
                            fontFamily: ConsFonts.fzFont,
                            fontSize: 12),
                      ),
                    )
                  ],
                ),
                ShareBtnWidget(
                  colorType: 1,
                  showRightText: true,
                  actionType: ShareType.video,
                  onCacheVideo: () async {
                    CollectionEntity ce = CollectionEntity(
                        source: DBSource.cache,
                        title: _title,
                        category: '已缓存',
                        type: 'video',
                        cover: _videoData['cover']['feed'],
                        duration: _videoData['duration'],
                        itemId: _videoData['id']);
                    await _db.saveCollection(ce);
                  },
                ),
              ],
            ),
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

  _saveWatchHistory() async {
    CollectionEntity ce = CollectionEntity(
        source: DBSource.watch,
        title: _title,
        category: _category,
        type: 'video',
        cover: _videoData['cover']['feed'],
        duration: _videoData['duration'],
        itemId: _videoData['id']);
    await _db.saveCollection(ce);
  }

  _onItemTap(_item) {
    _videoData = _item;
    _parseTopData();
    setState(() {});
    double duration = (_scrollController.offset /
            _scrollController.position.maxScrollExtent) *
        500;
    _scrollController.animateTo(0,
        duration: Duration(milliseconds: duration.toInt()),
        curve: Curves.easeIn);
    _getRelatedList();
    _saveWatchHistory();
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
        _saveWatchHistory();
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
