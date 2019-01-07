import 'package:flutter/material.dart';
import 'package:flutter_open/component/widgets/VideoSmallCardWidget.dart';
import 'package:flutter_open/utils/ActionViewUtils.dart';
import 'package:flutter_open/utils/StringUtil.dart';

class DynamicInfoCardWidget extends StatelessWidget {
  final data;

  DynamicInfoCardWidget(this.data);

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.only(bottom: 10),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: EdgeInsets.only(right: 10),
            child: ClipOval(
              child: Image.network(
                data['user']['avatar'],
                height: 40,
                width: 40,
              ),
            ),
          ),
          Expanded(
            child: new Column(children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        data['user']['nickname'],
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'LZLanTing',
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '评论:',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.fromLTRB(7, 2, 7, 2),
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(0xff5087c8), width: 0.5),
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        child: Text(
                          '热评',
                          style: TextStyle(
                              color: Color(0xff5087c8),
                              fontFamily: 'FZLanTing',
                              fontSize: 12),
                        ),
                      ),
                      Image(
                        image: AssetImage('asset/images/arrow_right.png'),
                        height: 10,
                        width: 10,
                      )
                    ],
                  )
                ],
              ),
              new Container(
                margin: EdgeInsets.only(top: 8),
                child: Text(
                  data['reply']['message'],
                  style: TextStyle(color: Colors.black45),
                ),
              ),
              new Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(10, 0, 5, 10),
                margin: EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: VideoSmallCardWidget(
                  id: data['reply']['videoId'],
                  cover: data['simpleVideo']['cover']['feed'],
                  title: data['reply']['videoTitle'],
                  duration: data['simpleVideo']['duration'],
                  category: data['simpleVideo']['category'],
                  onCoverTap: () {
                    ActionViewUtils.actionVideoPlayPage(
                        context, data['simpleVideo']);
                  },
                ),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      Text(
                        '回复',
                        style: TextStyle(fontFamily: 'FZLanTing'),
                      ),
                      new Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: Text(
                            StringUtil.formatMileToDate(
                                miles: data['createDate']),
                            style: TextStyle(color: Colors.grey),
                          )),
                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      Text(
                        data['reply']['likeCount'].toString(),
                        style: TextStyle(
                            color: Colors.black, fontFamily: 'FZLanTing'),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(
                          Icons.favorite_border,
                          size: 20,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  )
                ],
              )
            ]),
          )
        ],
      ),
    );
  }
}
