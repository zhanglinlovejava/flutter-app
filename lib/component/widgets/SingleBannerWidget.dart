import 'package:flutter/material.dart';
import 'package:flutter_open/utils/ActionViewUtils.dart';
import 'package:flutter_open/pages/WebViewPage.dart';
import '../../pages/LightTopicPage.dart';
import '../../utils/StringUtil.dart';

class SingleBannerWidget extends StatelessWidget {
  final data;
  final double height;

  SingleBannerWidget(this.data, {this.height = 180});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        String actionUrl = data['actionUrl'];
        print('--- $actionUrl');
        ActionViewUtils.actionByActionUrl(context, actionUrl,
            id: data['id'], title: data['title']);
      },
      child: new Container(
          margin: EdgeInsets.only(bottom: 5, top: 5),
          height: height,
          decoration: ActionViewUtils.renderGradientBg([
            Color.fromRGBO(0, 0, 0, 0.2),
            Color.fromRGBO(0, 0, 0, 0),
            Color.fromRGBO(0, 0, 0, 0.2),
          ], 5),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            child: Image.network(
              data['image'],
              fit: BoxFit.fill,
              width: double.infinity,
            ),
          )),
    );
  }
}
