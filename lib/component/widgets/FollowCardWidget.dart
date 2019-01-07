import 'package:flutter/material.dart';
import 'package:flutter_open/utils/ActionViewUtils.dart';

class FollowCardWidget extends StatelessWidget {
  final String cover;
  final String avatar;
  final String desc;
  final String title;
  final heroTag;
  final int duration;
  final bool showBottomAvatar;
  final VoidCallback onCoverTap;

  FollowCardWidget({
    @required this.cover,
    @required this.avatar,
    @required this.desc,
    @required this.title,
    @required this.heroTag,
    @required this.duration,
    this.showBottomAvatar = true,
    this.onCoverTap,
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Stack(
            children: <Widget>[
              new GestureDetector(
                  onTap: () {
                    onCoverTap();
                  },
                  child: new Container(
                    height: 180,
                    width: double.infinity,
                    decoration: ActionViewUtils.renderGradientBg([
                      Color.fromRGBO(0, 0, 0, 0.2),
                      Color.fromRGBO(0, 0, 0, 0),
                      Color.fromRGBO(0, 0, 0, 0.2),
                    ], 3),
                    child: new ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        child: new Hero(
                            tag: heroTag,
                            child: new Image.network(
                              cover,
                              fit: BoxFit.cover,
                            ))),
                  )),
              ActionViewUtils.buildDuration(duration)
            ],
          ),
          new Container(
            margin: EdgeInsets.only(top: 10, bottom: 15),
            child: new Row(
              children: <Widget>[
                showBottomAvatar
                    ? new ClipOval(
                        child: new Image.network(
                          avatar,
                          width: 40,
                          height: 40,
                        ),
                      )
                    : new Container(),
                Expanded(
                  child: new Container(
                    padding: EdgeInsets.only(left: 10),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          title,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'FZLanTing'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        new Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: new Text(
                            desc,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontFamily: 'FZLanTing'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                new Container(
                  margin: EdgeInsets.only(right: 10, left: 10),
                  child: Icon(
                    Icons.share,
                    size: 20,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
