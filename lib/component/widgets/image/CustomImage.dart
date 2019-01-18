import 'package:flutter/material.dart';
import 'package:flutter_open/component/loading/platform_adaptive_progress_indicator.dart';

class CustomImage extends StatelessWidget {
  final String url;
  final bool showLoading;
  final String placeHolePath;
  final double width, height;
  final BoxFit fit;

  CustomImage(
    this.url, {
    this.showLoading = false,
    this.width = 50,
    this.height = 50,
    this.fit = BoxFit.none,
    this.placeHolePath = 'asset/images/default_avatar.png',
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        showLoading
            ? Center(
                child: PlatformAdaptiveProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : new Container(),
        Center(
          child:
          FadeInImage.assetNetwork(
            placeholder: placeHolePath,
            fadeOutDuration: Duration(microseconds: 100),
            image: url??'',
            width: width,
            height: height,
            fit: fit,
          ),
        )
      ],
    );
  }
}
