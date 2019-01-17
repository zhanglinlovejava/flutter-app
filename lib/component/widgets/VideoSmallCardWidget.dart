import 'package:flutter/material.dart';
import 'package:flutter_open/utils/ActionViewUtils.dart';

class VideoSmallCardWidget extends StatelessWidget {
  final id;
  final String cover;
  final int duration;
  final String title;
  final String category;
  final VoidCallback onCoverTap;
  final isDarkTheme;

  VideoSmallCardWidget(
      {this.id,
      @required this.cover,
      this.duration = 0,
      @required this.title,
      @required this.onCoverTap,
      this.isDarkTheme = true,
      @required this.category});

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 90,
      margin: EdgeInsets.only(top: 10),
      child: new GestureDetector(
          onTap: () {
            onCoverTap();
          },
          child: new Row(
            children: <Widget>[
              new Stack(
                children: <Widget>[
                  new Container(
                    height: 200,
                    width: 160,
                    decoration: ActionViewUtils.renderGradientBg([
                      Color.fromRGBO(0, 0, 0, 0.2),
                      Color.fromRGBO(0, 0, 0, 0),
                      Color.fromRGBO(0, 0, 0, 0.2),
                    ], 5),
                    child: new ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        child: new Image.network(
                          cover == '' ? 'http://' : cover,
                          width: 160,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        )),
                  ),
                  duration == 0
                      ? new Container()
                      : ActionViewUtils.buildDuration(duration)
                ],
              ),
              Expanded(
                child: new Container(
                  padding: EdgeInsets.all(10),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text(
                        title,
                        style: TextStyle(
                            fontSize: 14,
                            color: isDarkTheme ? Colors.black : Colors.white,
                            fontFamily: 'FZLanTing'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      new Text(
                        '#$category',
                        style: TextStyle(
                            fontSize: 12,
                            color: isDarkTheme ? Colors.grey : Colors.white70,
                            fontFamily: 'FZLanTing'),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
