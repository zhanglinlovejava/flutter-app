import 'package:flutter/material.dart';
import 'package:flutter_open/component/widgets/VideoCardWidget.dart';
import 'package:flutter_open/utils/ActionViewUtils.dart';
import 'package:flutter_open/utils/StringUtil.dart';

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
      margin: EdgeInsets.only(bottom: 20),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _renderAuthorInfo(),
          _renderDescription(),
          _renderTags(),
          VideoCardWidget(
            cover: data['content']['data']['cover']['feed'],
            duration: data['content']['data']['duration'],
            id: data['content']['data']['id'],
            onCoverTap: () {
              ActionViewUtils.actionVideoPlayPage(
                  context, data['content']['data']);
            },
          ),
          _renderBottomBar()
        ],
      ),
    );
  }

  _renderTags() {
    return new Container(
      height: 25,
      margin: EdgeInsets.only(bottom: 10),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: data['content']['data']['tags'].length,
          itemBuilder: (BuildContext context, int index) {
            return new Container(
              margin: EdgeInsets.only(right: 5),
              padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(80, 135, 200, 0.10),
                  borderRadius: BorderRadius.all(Radius.circular(3))),
              child: Text(
                data['content']['data']['tags'][index]['name'],
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xff5087c8), fontSize: 14),
              ),
            );
          }),
    );
  }

  _renderDescription() {
    return new Container(
      margin: EdgeInsets.only(top: 5, bottom: 10),
      child: Stack(
        children: <Widget>[
          Text(
            data['content']['data']['description'],
            style: TextStyle(fontSize: 15, color: Colors.black54),
            maxLines: descMaxLines,
          ),
          new Positioned(
              right: 0,
              bottom: 0,
              child: Offstage(
                offstage: descMaxLines > 2,
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
                          color: Color(0xff5087c8), fontFamily: 'FZLanTing'),
                    ),
                  ),
                ),
              ))
        ],
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
                width: 20,
                height: 20,
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
    return new Container(
      child: new Row(
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.only(right: 8),
            child: ClipOval(
              child: Image.network(
                data['content']['data']['author']['icon'],
                width: 40,
                height: 40,
              ),
            ),
          ),
          Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(bottom: 3),
                  child: Text(
                    data['content']['data']['author']['name'],
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'FZLanTing',
                        fontSize: 16),
                  ),
                ),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      '发布:',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Expanded(
                        child: new Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        data['content']['data']['title'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontFamily: 'FZLanTing'),
                      ),
                    ))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
