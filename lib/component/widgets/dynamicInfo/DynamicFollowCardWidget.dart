import 'package:flutter/material.dart';
import '../AuthorInfoWidget.dart';
import 'package:flutter_open/utils/ActionViewUtils.dart';
import 'package:flutter_open/utils/StringUtil.dart';
import '../image/CustomImage.dart';
import 'package:flutter_open/utils/DayFormat.dart';

class DynamicFollowCardWidget extends StatelessWidget {
  final data;

  DynamicFollowCardWidget(this.data);

  @override
  Widget build(BuildContext context) {
    var user = data['user'];
    var briefCard = data['briefCard'];
    return new Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: ClipOval(
              child: CustomImage(
                user['avatar'],
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
          _renderRightCard(user, briefCard),
        ],
      ),
    );
  }

  Expanded _renderRightCard(user, briefCard) {
    return Expanded(
        child: Container(
      padding: EdgeInsets.only(bottom: 10),
      margin: EdgeInsets.only(bottom: 20),
      decoration: ActionViewUtils.renderBorderBottom(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AuthorInfoWidget(
            name: user['nickname'],
            desc: data['text'],
            id: user['uid'].toString(),
            userType: user['userType'],
            rightBtnType: 'arrow',
            isDark: true,
          ),
          _renderCard(briefCard),
          Text(TimelineUtil.format(data['createDate']))
        ],
      ),
    ));
  }

  _renderCard(briefCard) {
    String type = briefCard['dataType'];
    if (type == 'BriefCard' || type == 'TagBriefCard') {
      return _renderBriefCard(briefCard);
    } else {
      return Text(type);
    }
  }

  Container _renderBriefCard(briefCard) {
    return new Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: AuthorInfoWidget(
        name: briefCard['title'],
        desc: briefCard['description'],
        avatar: briefCard['icon'],
        id: briefCard['id'].toString(),
        userType: 'PGC',
        rightBtnType: 'follow',
        showCircleAvatar: false,
        isDark: true,
      ),
    );
  }
}
