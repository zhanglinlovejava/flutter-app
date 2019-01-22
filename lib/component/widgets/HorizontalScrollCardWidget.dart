import 'package:flutter/material.dart';
import 'package:flutter_open/component/widgets/SingleBannerWidget.dart';
import 'BriefCardWidget.dart';
import '../../utils/ActionViewUtils.dart';

class HorizontalScrollCardWidget extends StatelessWidget {
  final List itemList;

  HorizontalScrollCardWidget({@required this.itemList});

  @override
  Widget build(BuildContext context) {
    return _renderView(context);
  }

  _renderView(BuildContext context) {
    String type = itemList[0]['type'];
    double height = 190;
    if (type == 'squareCardOfTag') {
      height = 70;
    }
    return new Container(
      height: height,
      padding: EdgeInsets.only(bottom: 10),
      alignment: Alignment.center,
      child: ListView.builder(
          cacheExtent: 10,
          scrollDirection: Axis.horizontal,
          itemCount: itemList.length,
          itemBuilder: (BuildContext context, int index) {
            var data = itemList[index]['data'];
            String type = itemList[index]['type'];
            if (type == 'squareCardOfTag') {
              return Container(
                height: height,
                width: 130,
                padding: EdgeInsets.only(right: 5),
                child: BriefCardWidget(
                    titleFontSize: 16,
                    icon: data['bgPicture'],
                    title: data['tagName'],
                    onTap: () {
                      ActionViewUtils.actionByActionUrl(
                          context, data['actionUrl']);
                    }),
              );
            } else {
              return _renderSingleImage(context, data, height);
            }
          }),
    );
  }

  _renderSingleImage(BuildContext context, data, double height) {
    double width =
        MediaQuery.of(context).size.width - (itemList.length <= 1 ? 30 : 60);
    return new Container(
      height: height,
      width: width,
      margin: EdgeInsets.only(right: 10),
      child: SingleBannerWidget(data, height: 180),
    );
  }
}
