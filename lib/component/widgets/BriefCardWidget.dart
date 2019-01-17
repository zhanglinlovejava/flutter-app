import 'package:flutter/material.dart';
import 'package:flutter_open/utils/ActionViewUtils.dart';

class BriefCardWidget extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;

  BriefCardWidget({@required this.icon, this.title = '', this.onTap});

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.only(bottom: 10),
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
              foregroundDecoration: BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, title == '' ? 0 : 0.3)),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(3)),
                child: Image.network(
                  icon,
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              title,
              style: TextStyle(
                  fontSize: 18, color: Colors.white, fontFamily: 'FZLanTing'),
            )
          ],
        ),
      ),
    );
  }
}
