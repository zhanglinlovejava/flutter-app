import 'package:flutter/material.dart';
import 'package:flutter_open/utils/ActionViewUtils.dart';

class SingleBannerWidget extends StatelessWidget {
  final String imageUrl;
  final double height;

  SingleBannerWidget(this.imageUrl, {this.height = 180});

  @override
  Widget build(BuildContext context) {
    return new Container(
        height: height,
        width: double.infinity,
        decoration: ActionViewUtils.renderGradientBg([
          Color.fromRGBO(0, 0, 0, 0.2),
          Color.fromRGBO(0, 0, 0, 0),
          Color.fromRGBO(0, 0, 0, 0.2),
        ], 5),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(3)),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ));
  }
}
