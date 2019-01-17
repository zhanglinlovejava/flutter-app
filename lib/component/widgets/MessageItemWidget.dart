import 'package:flutter/material.dart';
import 'package:flutter_open/utils/DayFormat.dart';

class MEssageItemWidget extends StatelessWidget {
  final msgItem;

  MEssageItemWidget(this.msgItem);

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Colors.grey[200], width: 1))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[400], width: 1),
                borderRadius: BorderRadius.all(Radius.circular(25))),
            margin: EdgeInsets.only(right: 10),
            child:
                Image.asset('asset/images/kaiyan.png', width: 40, height: 40),
          ),
          Expanded(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    msgItem['title'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'FZLanTing'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 8),
                    child: Text(
                      TimelineUtil.format(msgItem['date']),
                      style: TextStyle(color: Colors.black45),
                    ),
                  ),
                  Text(
                    msgItem['content'],
                    style: TextStyle(color: Colors.black54),
                  )
                ],
              )),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Image.asset('asset/images/arrow_right.png',
                    height: 18, width: 18),
              )
            ],
          ))
        ],
      ),
    );
  }
}
