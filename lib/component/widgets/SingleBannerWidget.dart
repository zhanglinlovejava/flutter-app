import 'package:flutter/material.dart';
import 'package:flutter_open/utils/ActionViewUtils.dart';
import 'package:flutter_open/pages/WebViewPage.dart';

class SingleBannerWidget extends StatelessWidget {
  final String imageUrl;
  final double height;
  final String actionUrl;

  SingleBannerWidget(this.imageUrl, {this.height = 180, this.actionUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(new MaterialPageRoute(builder: (BuildContext context) {
          return WebViewPage();
        }));
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
              imageUrl,
              fit: BoxFit.fill,
              width: double.infinity,
            ),
          )),
    );
  }
}
