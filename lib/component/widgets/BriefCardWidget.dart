import 'package:flutter/material.dart';
import '../../Constants.dart';

class BriefCardWidget extends StatelessWidget {
  final String icon;
  final String title;
  final String desc;
  final VoidCallback onTap;
  final double titleFontSize;

  BriefCardWidget(
      {@required this.icon,
      this.title = '',
      this.onTap,
      this.desc = '',
      this.titleFontSize = 18});

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: GestureDetector(
        onTap: () {
          if (onTap != null) {
            onTap();
          }
        },
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            new Container(
              height: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              foregroundDecoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Color.fromRGBO(0, 0, 0, title == '' ? 0 : 0.3)),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: Image.network(
                  icon,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                      fontSize: titleFontSize,
                      color: Colors.white,
                      fontFamily: ConsFonts.fzFont,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none),
                ),
                desc == '' || desc == null
                    ? Container()
                    : Text(
                        desc,
                        style: TextStyle(
                            fontSize: titleFontSize - 6,
                            color: Colors.white70,
                            fontFamily: 'FZLanTing'),
                      )
              ],
            )
          ],
        ),
      ),
    );
  }
}
