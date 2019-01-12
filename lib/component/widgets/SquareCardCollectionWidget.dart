import 'package:flutter/material.dart';
import 'package:flutter_open/component/widgets/FollowCardWidget.dart';
import 'package:flutter_open/component/widgets/SingleBannerWidget.dart';
import 'package:flutter_open/utils/ActionViewUtils.dart';
import 'BriefCardWidget.dart';

class SquareCardCollectionWidget extends StatelessWidget {
  final data;
  final double height;
  final bool showTopView;
  final showBottomAvatar;

  SquareCardCollectionWidget(this.data,
      {this.height = 190,
      this.showTopView = true,
      this.showBottomAvatar = true});

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: height,
      child: new Column(
        children: <Widget>[
          showTopView ? _renderTopView() : new Container(),
          showTopView ? _renderMiddleView() : new Container(),
          Expanded(
            child: _renderBottomView(context),
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
                  fontFamily: 'FZLanTing', color: Colors.black45, fontSize: 12),
            ),
          );
  }

  _renderMiddleView() {
    return new Container(
      margin: EdgeInsets.only(top: 5),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            data['header']['title'],
            style: TextStyle(fontSize: 20, fontFamily: 'FZLanTing'),
          ),
          data['header']['rightText'] == null
              ? new Container()
              : new Row(
                  children: <Widget>[
                    Text(data['header']['rightText'],
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'FZLanTing',
                            color: Color(0xff5087c8))),
                    Image(
                      image: AssetImage('asset/images/arrow_right_blue.png'),
                      width: 10,
                      height: 15,
                    )
                  ],
                )
        ],
      ),
    );
  }

  _renderBottomView(BuildContext context) {
    var childList = data['itemList'];
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
            var type = childList[index]['type'];
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
                    ActionViewUtils.actionVideoPlayPage(context,
                        desc: _data['description'],
                        id: _data['id'],
                        category: _data['category'],
                        author: _data['author'],
                        cover: _data['cover'],
                        consumption: _data['consumption'],
                        title: _data['title']);
                  },
                ),
              );
            } else if (type == 'banner2' || type == 'banner') {
              return new Container(
                width: width,
                margin: EdgeInsets.only(right: 10, top: 5),
                child: SingleBannerWidget(
                  item['image'],
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
                      ActionViewUtils.actionVideoPlayPage(context,
                          desc: item['description'],
                          id: item['id'],
                          category: item['category'],
                          author: item['author'],
                          cover: item['cover'],
                          consumption: item['consumption'],
                          title: item['title']);
                    }),
              );
            } else if (type == 'squareCardOfCategory') {
              return Container(
                  width: 150,
                  height: double.infinity,
                  margin: EdgeInsets.only(right: 10),
                  child: BriefCardWidget(
                      icon: item['image'], title: item['title']));
            } else {
              return Text(type + "----");
            }
          }),
    );
  }
}
