import 'package:flutter/material.dart';
import 'package:flutter_app1/views/base/BaseAliveState.dart';
import 'package:flutter_app1/components/loading/loading_view.dart';
import 'package:flutter_app1/components/loading/LoadingStatus.dart';
import 'package:flutter_app1/components/loading/platform_adaptive_progress_indicator.dart';
import 'package:flutter_app1/utils/StringUtil.dart';
import 'package:flutter_app1/api/HttpController.dart';
import 'package:flutter_app1/views/VideoPlayPage.dart';

class FollwPage extends StatefulWidget {
  @override
  FollowPageState createState() => FollowPageState();
}

class FollowPageState extends BaseAliveState<FollwPage> {
  LoadingStatus _status = LoadingStatus.loading;
  var _itemList = new List();
  String _url = 'v4/tabs/follow';
  String _nextPageUrl = '';
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getFollowList(_nextPageUrl);
      }
    });
    _getFollowList(_url);
  }

  @override
  Widget build(BuildContext context) {
    return new LoadingView(
      status: _status,
      loadingContent: const PlatformAdaptiveProgressIndicator(),
      errorContent: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Icon(
            Icons.error,
            color: Colors.red,
          ),
          Text(
            "出错了",
            style: new TextStyle(fontSize: 18),
          )
        ],
      ),
      successContent: new ListView.separated(
          itemCount: _itemList.length,
          controller: _scrollController,
          cacheExtent: 100,
          separatorBuilder: (BuildContext context, int index) =>
              _buildSeparator(context),
          itemBuilder: (BuildContext context, int index) {
            return _renderRow(context, index);
          }),
    );
  }

  _renderRow(BuildContext context, int index) {
    return new Container(
      padding: EdgeInsets.all(10),
      child: new Column(
        children: <Widget>[
          _renderTopView(context, index),
          _renderMiddleView(context, index),
        ],
      ),
    );
  }

  _buildSeparator(BuildContext context) {
    return new Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      color: Color(0xffdddddd),
      height: 1,
    );
  }

  _renderTopView(BuildContext context, int index) {
    return new Container(
      width: MediaQuery.of(context).size.width,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new ClipOval(
            child: Image.network(
              _itemList[index]['data']['header']['icon'],
              width: 40,
              height: 40,
            ),
          ),
          new Container(
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width - 110,
            padding: EdgeInsets.only(left: 10, right: 10),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  _itemList[index]['data']['header']['title'],
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                new Text(
                  _itemList[index]['data']['header']['description'],
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                )
              ],
            ),
          ),
          new Container(
            width: 50,
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.all(color: Colors.black45, width: 1)),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Icon(
                  Icons.add,
                  size: 15,
                  color: Colors.black45,
                ),
                new Text(
                  "关注",
                  style: TextStyle(color: Colors.black45),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _renderMiddleView(BuildContext context, int index) {
    var childList = _itemList[index]['data']['itemList'];
    return new Container(
      padding: EdgeInsets.only(top: 10),
      height: 240,
      child: ListView.builder(
          cacheExtent: 10,
          scrollDirection: Axis.horizontal,
          itemCount: childList.length,
          itemBuilder: (BuildContext context, int j) {
            var item = childList[j]['data'];
            return new GestureDetector(
              onTap: () {
                _onCoverTap(item);
              },
              child: new Container(
                width: MediaQuery.of(context).size.width - 70,
                padding: EdgeInsets.only(right: 10),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Hero(
                        tag: item['id'],
                        child: Image.network(
                          item['cover']['feed'],
                          width: double.infinity,
                          fit: BoxFit.cover,
                          height: 180,
                        )),
                    new Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: new Text(
                        item['title'],
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    new Text(
                      '${StringUtil.buildTags(item['tags'])}/${StringUtil.formatDuration2(item['duration'])}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  _onCoverTap(item) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
      return new VideoPlayPage(item);
    }));
  }

  _getFollowList(String url) async {
   await HttpController.getInstance().get(url, (data) {
      var temList = data['itemList'];
      _itemList.addAll(temList);
      _nextPageUrl = data['nextPageUrl'];
      setState(() {
        _itemList = _itemList;
        _status = LoadingStatus.success;
      });
    });
  }
}
