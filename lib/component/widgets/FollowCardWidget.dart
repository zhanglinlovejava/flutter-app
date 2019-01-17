import 'package:flutter/material.dart';
import 'package:flutter_open/utils/ActionViewUtils.dart';
import 'AuthorInfoWidget.dart';

class FollowCardWidget extends StatelessWidget {
  final String cover;
  final String avatar;
  final String desc;
  final String title;
  final int duration;
  final bool showBottomAvatar;
  final VoidCallback onCoverTap;
  final String id;
  final String userType;

  FollowCardWidget({
    @required this.cover,
    @required this.avatar,
    @required this.desc,
    @required this.title,
    @required this.duration,
    @required this.id,
    @required this.userType,
    this.showBottomAvatar = true,
    this.onCoverTap,
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Stack(
            children: <Widget>[
              new GestureDetector(
                  onTap: () {
                    onCoverTap();
                  },
                  child: new Container(
                    height: 170,
                    width: double.infinity,
                    decoration: ActionViewUtils.renderGradientBg([
                      Color.fromRGBO(0, 0, 0, 0.2),
                      Color.fromRGBO(0, 0, 0, 0),
                      Color.fromRGBO(0, 0, 0, 0.2),
                    ], 3),
                    child: new ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        child: new Image.network(
                          cover,
                          fit: BoxFit.cover,
                        )),
                  )),
              ActionViewUtils.buildDuration(duration)
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, right: 5, bottom: 10),
            child: AuthorInfoWidget(
                name: title,
                desc: desc,
                avatar: showBottomAvatar ? avatar : '',
                id: id,
                userType: userType,
                isDark: true,
                rightBtnType: 'share'),
          )
        ],
      ),
    );
  }
}
