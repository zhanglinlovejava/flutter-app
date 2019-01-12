import 'package:flutter/material.dart';
import 'package:flutter_open/pages/UserInfoPage.dart';
import 'package:flutter_open/component/widgets/FollowBtnWidget.dart';

class AuthorInfoWidget extends StatelessWidget {
  final String name;
  final String desc;
  final String avatar;
  final bool isDark;
  final String id;
  final String userType;
  final String rightBtnType;
  final bool showAvatar;
  final bool showCircleAvatar;

  AuthorInfoWidget(
      {this.name = '',
      this.desc = '',
      this.avatar,
      this.isDark = false,
      this.id,
      this.userType,
      this.showCircleAvatar = true,
      this.rightBtnType = 'none',
      this.showAvatar = true});

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Row(
        children: <Widget>[
          showAvatar
              ? GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return UserInfoPage(id: id, userType: userType);
                    }));
                  },
                  child: showCircleAvatar
                      ? new ClipOval(
                          child: new Image.network(
                            avatar,
                            height: 40,
                            width: 40,
                          ),
                        )
                      : new Image.network(
                          avatar,
                          height: 40,
                          width: 40,
                        ),
                )
              : new Container(),
          new Expanded(
              child: new Container(
            padding: EdgeInsets.only(left: 5),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: isDark ? Colors.black : Colors.white,
                      fontSize: 14,
                      decoration: TextDecoration.none,
                      fontFamily: 'FZLanTing'),
                ),
                desc == '' || desc == null
                    ? new Container()
                    : new Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: new Text(
                          desc,
                          style: TextStyle(
                              color: isDark ? Colors.grey : Color(0xffdddddd),
                              fontSize: 12,
                              fontFamily: 'FZLanTing'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
              ],
            ),
          )),
          _renderRightBtn()
        ],
      ),
    );
  }

  _renderRightBtn() {
    if (rightBtnType == 'share') {
      return _renderShareBtn();
    } else if (rightBtnType == 'follow') {
      return FollowBtnWidget(isDark: isDark);
    } else if (rightBtnType == 'arrow') {
      return Container(
        child: Image.asset(
          'asset/images/arrow_right.png',
          width: 15,
          height: 20,
        ),
      );
    } else {
      return new Container();
    }
  }

  _renderShareBtn() {
    return Container(
      child: Icon(
        Icons.share,
        size: 20,
        color: isDark ? Colors.grey : Colors.white,
      ),
    );
  }
}
