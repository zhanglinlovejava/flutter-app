import 'package:flutter/material.dart';
import 'package:flutter_open/component/widgets/FollowCardWidget.dart';
import 'package:flutter_open/component/widgets/SingleBannerWidget.dart';
import 'package:flutter_open/utils/ActionViewUtils.dart';
import 'BriefCardWidget.dart';
import '../../Constants.dart';
import 'TextCardWidget.dart';
import '../../api/API.dart';

class SquareCardCollectionWidget extends StatelessWidget {
  final data;
  final bool showTopView;
  final showBottomAvatar;
  double height = 190;
  final VoidCallback onRightTap;
  final VoidCallback onTitleTap;

  SquareCardCollectionWidget(this.data,
      {this.showTopView = true,
      this.showBottomAvatar = true,
      this.onRightTap,
      this.onTitleTap});

  @override
  Widget build(BuildContext context) {
    List childList = data['itemList'];
    String type = childList[0]['type'];
    if (type == 'followCard') {
      height = 300;
    } else if (type == 'banner' || type == 'banner2' || type == 'banner3') {
      height = 220;
    } else if (type == 'video') {
      height = 242;
    } else if (type == 'squareCardOfCategory') {
      height = 150;
    }
    return new Container(
      margin: EdgeInsets.only(top: 10),
      height: height,
      child: new Column(
        children: <Widget>[
          showTopView ? _renderTopView() : new Container(),
          showTopView ? _renderMiddleView() : new Container(),
          Expanded(
            child: _renderBottomView(context, childList, type),
          )
        ],
      ),
    );
  }

  _renderTopView() {
    return data['header']['subTitle'] == null
        ? new Container()
        : new Container(
            alignment: Alignment.topLeft,
            child: new Text(
              data['header']['subTitle'],
              style: TextStyle(
                  fontFamily: ConsFonts.fzFont,
                  color: Colors.black45,
                  fontSize: 12),
            ),
          );
  }

  _renderMiddleView() {
    return TextCardWidget(
      title: data['header']['title'],
      rightBtnText: data['header']['rightText'],
      onRightBtnTap: () {
        if (onRightTap != null) {
          onRightTap();
        }
      },
      onTitleTap: () {
        if (onTitleTap != null) {
          onTitleTap();
        }
      },
      align: MainAxisAlignment.spaceBetween,
    );
  }

  _renderBottomView(BuildContext context, childList, type) {
    double width =
        MediaQuery.of(context).size.width - (childList.length <= 1 ? 30 : 60);
    return new Container(
      padding: EdgeInsets.only(top: 5),
      child: ListView.builder(
          cacheExtent: 10,
          scrollDirection: Axis.horizontal,
          itemCount: childList.length,
          itemBuilder: (BuildContext context, int index) {
            var item = childList[index]['data'];
            if (type == 'followCard') {
              var _data = item['content']['data'];
              return new Container(
                width: width,
                margin: EdgeInsets.only(right: 10),
                child: FollowCardWidget(
                  cover: _data['cover']['feed'],
                  avatar: item['header']['icon'],
                  title: item['header']['title'],
                  desc: item['header']['description'],
                  duration: _data['duration'],
                  id: _data['author']['id'].toString(),
                  userType: 'PGC',
                  onCoverTap: () {
                    ActionViewUtils.actionVideoPlayPage(context, _data['id']);
                  },
                ),
              );
            } else if (type == 'banner2' || type == 'banner') {
              return new Container(
                width: width,
                margin: EdgeInsets.only(right: 10, top: 5),
                child: SingleBannerWidget(
                  item,
                  height: height,
                ),
              );
            } else if (type == 'video') {
              return new Container(
                width: width,
                margin: EdgeInsets.only(right: 10),
                child: FollowCardWidget(
                    cover: item['cover']['feed'],
                    avatar: item['author']['icon'],
                    title: item['title'],
                    desc: item['description'],
                    duration: item['duration'],
                    id: item['author']['id'].toString(),
                    userType: 'PGC',
                    showBottomAvatar: false,
                    onCoverTap: () {
                      ActionViewUtils.actionVideoPlayPage(context, item['id']);
                    }),
              );
            } else if (type == 'squareCardOfCategory') {
              return Container(
                width: 150,
                height: double.infinity,
                margin: EdgeInsets.only(right: 10),
                child: BriefCardWidget(
                    icon: item['image'],
                    title: item['title'],
                    onTap: () {
                      ActionViewUtils.actionTagInfoPage(
                          API.CATEGORY_INFO_TAB, context, item['actionUrl'],
                          type: 'categoryInfo');
                    }),
              );
            } else {
              return Text(type + "----");
            }
          }),
    );
  }
}
