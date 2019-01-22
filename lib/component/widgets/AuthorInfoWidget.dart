import 'package:flutter/material.dart';
import 'package:flutter_open/pages/StickyHeaderTabPage.dart';
import 'package:flutter_open/component/widgets/button/FollowBtnWidget.dart';
import 'image/CustomImage.dart';
import '../../Constants.dart';
import '../../api/API.dart';
import 'button/ShareBtnWidget.dart';

class AuthorInfoWidget extends StatelessWidget {
  final String name;
  final String desc;
  final String avatar;
  final bool isDark;
  final String id;
  final String rightBtnType;
  final bool showCircleAvatar;
  final int maxLines;
  final String actionUrl;
  final String userType;
  final VoidCallback onCacheVideo;

  AuthorInfoWidget(
      {this.name = '',
      this.desc = '',
      this.avatar = '',
      this.isDark = false,
      this.id,
      this.maxLines = 1,
      this.showCircleAvatar = true,
      this.rightBtnType = 'none',
      this.userType,
      this.onCacheVideo,
      this.actionUrl = ''});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (id == '') return;
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            Map<String, String> params = new Map();
            params['id'] = id;
            if (actionUrl.startsWith('eyepetizer://tag')) {
              return StickyHeaderTabPage(
                url: API.TAG_INFO_TAB,
                params: params,
                type: 'tagInfo',
              );
            } else {
              params['userType'] = userType.toUpperCase();
              return StickyHeaderTabPage(url: API.USER_TABS, params: params);
            }
          }));
        },
        child: new Container(
          color: Colors.transparent,
          child: new Row(
            children: <Widget>[
              avatar == ''
                  ? new Container()
                  : (showCircleAvatar
                      ? new ClipOval(
                          child: CustomImage(
                            avatar,
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                          ),
                        )
                      : CustomImage(
                          avatar,
                          height: 45,
                          width: 45,
                          fit: BoxFit.cover,
                        )),
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
                          fontFamily: ConsFonts.fzFont),
                    ),
                    desc == '' || desc == null
                        ? new Container()
                        : new Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: new Text(
                              desc,
                              style: TextStyle(
                                  color:
                                      isDark ? Colors.grey : Color(0xffdddddd),
                                  fontSize: 12,
                                  fontFamily: ConsFonts.fzFont),
                              maxLines: maxLines,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                  ],
                ),
              )),
              _renderRightBtn()
            ],
          ),
        ));
  }

  _renderRightBtn() {
    if (rightBtnType == 'share') {
      return ShareBtnWidget(
        actionType: ShareType.authorVideo,
        onCacheVideo: () {
          if (onCacheVideo != null) onCacheVideo();
        },
      );
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
    } else if (rightBtnType == 'hotReply') {
      return _renderHotReply();
    } else {
      return new Container();
    }
  }

  _renderHotReply() {
    return new Row(
      children: <Widget>[
        new Container(
          padding: EdgeInsets.fromLTRB(7, 2, 7, 2),
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
              border: Border.all(color: ConsColors.mainColor, width: 0.5),
              borderRadius: BorderRadius.all(Radius.circular(4))),
          child: Text(
            '热评',
            style: TextStyle(
                color: ConsColors.mainColor,
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
    );
  }
}
