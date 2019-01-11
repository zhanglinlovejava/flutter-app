import 'package:flutter/material.dart';
import 'package:flutter_open/component/widgets/SingleBannerWidget.dart';

class HorizontalScrollCardWidget extends StatelessWidget {
  final List itemList;

  HorizontalScrollCardWidget({@required this.itemList});

  @override
  Widget build(BuildContext context) {
    return _renderView(context);
  }

  _renderView(BuildContext context) {
    return new Container(
      height: 190,
      padding: EdgeInsets.only(top: 10,bottom: 10),
      alignment: Alignment.center,
      child: ListView.builder(
          cacheExtent: 10,
          scrollDirection: Axis.horizontal,
          itemCount: itemList.length,
          itemBuilder: (BuildContext context, int index) {
            var data = itemList[index]['data'];
            return _renderSingleImage(context, data);
          }),
    );
  }

  _renderSingleImage(BuildContext context, data) {
    double width =
        MediaQuery.of(context).size.width - (itemList.length <= 1 ? 30 : 60);
    return new Container(
      height: 180,
      width: width,
      margin: EdgeInsets.only(right: 7),
      child: SingleBannerWidget(data['image'], height: 180),
    );
  }
}
