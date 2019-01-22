import 'package:flutter/material.dart';
import 'AuthorInfoWidget.dart';
import 'SquareCardCollectionWidget.dart';
import 'package:flutter_open/utils/ActionViewUtils.dart';

class VideoCollectionWithBriefWidget extends StatelessWidget {
  final data;

  VideoCollectionWithBriefWidget(this.data);

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: ActionViewUtils.renderBorderBottom(),
      margin: EdgeInsets.only(bottom: 10),
      child: new Column(
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: AuthorInfoWidget(
              name: data['header']['title'],
              desc: data['header']['description'],
              avatar: data['header']['icon'],
              isDark: true,
              id: data['header']['id'].toString(),
              userType: 'PGC',
              rightBtnType: 'follow',
            ),
          ),
          SquareCardCollectionWidget(data,
              showTopView: false, showBottomAvatar: false)
        ],
      ),
    );
  }
}
