import 'package:flutter/material.dart';
import 'package:flutter_open/utils/DayFormat.dart';
import '../AuthorInfoWidget.dart';
import 'DynamicResourceTypeCard.dart';
import '../image/CustomImage.dart';

class DynamicReplyCardWidget extends StatelessWidget {
  final data;

  DynamicReplyCardWidget(this.data);

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.only(bottom: 10, top: 15),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: EdgeInsets.only(right: 10),
            child: ClipOval(
              child: CustomImage(
                data['user']['avatar'],
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: new Column(children: <Widget>[
              AuthorInfoWidget(
                name: data['user']['nickname'],
                desc: data['text'],
                isDark: true,
                rightBtnType: 'hotReply',
                id: data['user']['uid'].toString(),
                userType: data['user']['userType'],
              ),
              new Container(
                alignment: Alignment.centerLeft,
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
                  child: DynamicResourceTypeCard(
                      user: data['user'], simpleVideo: data['simpleVideo'])),
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
                            TimelineUtil.format(data['createDate']),
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
