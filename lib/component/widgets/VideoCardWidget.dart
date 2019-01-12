import 'package:flutter/material.dart';
import 'package:flutter_open/utils/ActionViewUtils.dart';

class VideoCardWidget extends StatelessWidget {
  final double height;
  final String cover;
  final id;
  final int duration;
  final VoidCallback onCoverTap;

  VideoCardWidget(
      {this.height = 190,
      @required this.cover,
      @required this.id,
      @required this.duration,
      @required this.onCoverTap});

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: height,
      child: new Stack(
        children: <Widget>[
          new GestureDetector(
            onTap: () {
              onCoverTap();
            },
            child: new Container(
                width: MediaQuery.of(context).size.width,
                decoration: ActionViewUtils.renderGradientBg([
                  Color.fromRGBO(0, 0, 0, 0.2),
                  Color.fromRGBO(0, 0, 0, 0),
                  Color.fromRGBO(0, 0, 0, 0.2),
                ], 5),
                child: new ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                    child:  new Image.network(
                          cover,
                          width: 170,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ))),
          ),
          ActionViewUtils.buildDuration(duration)
        ],
      ),
    );
  }
}
