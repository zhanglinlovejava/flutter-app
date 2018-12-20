import 'package:flutter/material.dart';
import 'package:flutter_app1/api/HttpController.dart';
import 'package:flutter_app1/components/video/CustomVideoPlayer.dart';
import 'package:flutter_app1/components/loading/loading_view.dart';
import 'package:flutter_app1/components/loading/LoadingStatus.dart';
import 'package:flutter_app1/components/loading/platform_adaptive_progress_indicator.dart';
import 'package:flutter_app1/utils/StringUtil.dart';

class VideoList extends StatefulWidget {
  @override
  ListState createState() {
    ListState listState = ListState();
    return listState;
  }
}

class ListState extends State<VideoList> {
  var itemList = new List();
  LoadingStatus _status = LoadingStatus.loading;
  bool stopPlay = false;
  String nextPageUrl;
  String url = 'v2/feed?';
  ScrollController _scrollController = ScrollController();

  @override
  initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getData(nextPageUrl, false);
      }
    });
    getData(url, false);
  }

  getData(url, isRefresh) async {
    HttpController.getInstance().get(url, (data) {
      var list = data['issueList'][0]['itemList'];
      list.removeWhere((item) {
        return item['type'] != 'video';
      });
      if (isRefresh) {
        itemList = list;
      } else {
        itemList.addAll(list);
      }
      nextPageUrl = data['nextPageUrl'];
      setState(() {
        itemList = itemList;
        _status = LoadingStatus.success;
      });
    }, errorCallback: (error) {
      print("error:$error");
      setState(() {
        _status = LoadingStatus.error;
      });
    }, token: 'videoList');
  }

  Future onRefresh() async {
    await getData(url, true);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: new LoadingView(
          status: _status,
          loadingContent: const PlatformAdaptiveProgressIndicator(),
          errorContent: new GestureDetector(
            onTap: () {
              getData(url, true);
            },
            child: new Row(
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
          ),
          successContent: new ListView.builder(
            controller: _scrollController,
            cacheExtent: 100,
            itemCount: itemList.length,
            itemBuilder: (BuildContext context, int index) {
              return new Container(
                child: new Column(
                  children: <Widget>[
                    new Stack(
                      alignment: const FractionalOffset(0.5, 0.5),
                      children: <Widget>[
                        new Container(
                          width: double.infinity,
                          height: 180,
                          child: new CustomVideoPlayer(
                            itemList[index]['data']['playUrl'],
                            itemList[index]['data']['cover']['feed'],
                            180,
                            MediaQuery.of(context).size.width,
                            false,
                            stopPlay,
                          ),
                        ),
                        new Positioned(
                          child: new GestureDetector(
                            onTap: _handleOnTap,
                            child: new Material(
                              color: Color.fromRGBO(0, 0, 0, 0.5),
                              borderRadius: BorderRadius.circular(20),
                              child: new Padding(
                                padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
                                child: new Text(
                                  StringUtil.formatDuration(
                                      itemList[index]['data']['duration']),
                                  style: new TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          right: 10,
                          bottom: 40,
                        )
                      ],
                    ),
                    _buildVideoInfo(index)
                  ],
                ),
              );
            },
          ),
        ),
        onRefresh: onRefresh);
  }

  _handleOnTap() {
    setState(() {
      stopPlay = !stopPlay;
    });
  }

  _buildVideoInfo(index) {
    return new Container(
        margin: EdgeInsets.fromLTRB(8, 5, 12, 5),
        child: new Row(children: <Widget>[
          new ClipOval(
            child: new Image.network(itemList[index]['data']['author']['icon'],
                height: 40, width: 40),
          ),
          new Expanded(
              child: new Container(
            padding: EdgeInsets.only(left: 5),
            child: new Text(
              itemList[index]['data']['author']['name'],
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: new TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          )),
          new Padding(
            padding: EdgeInsets.only(right: 10),
            child: new Text(
              "关注",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
          new Image(
            image: new AssetImage('images/comment.png'),
            width: 25,
            height: 20,
          ),
          new Text(
              itemList[index]['data']['consumption']['replyCount'].toString()),
          new Padding(
              padding: EdgeInsets.only(left: 15),
              child: new GestureDetector(
                onTap: _onMoreTap,
                child: new Icon(
                  Icons.more_horiz,
                  color: Colors.black54,
                ),
              ))
        ]));
  }

  _onMoreTap() {
    print("更多---");
  }

  @override
  void dispose() {
    HttpController.getInstance().cancelRequest('videoList');
    super.dispose();
  }
}
