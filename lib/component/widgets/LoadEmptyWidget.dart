import 'package:flutter/material.dart';

class LoadEmptyWidget extends StatelessWidget {
  final VoidCallback onRetryFunc;
  final String emptyMsg;

  LoadEmptyWidget({@required this.onRetryFunc, this.emptyMsg = '不好意思，没有数据哦~'});

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: onRetryFunc,
      child: Container(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Icon(
              Icons.hourglass_empty,
              color: Colors.blue,
            ),
            Text(
              emptyMsg,
              style: new TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none),
            )
          ],
        ),
      ),
    );
  }
}
