import 'package:flutter/material.dart';

class LoadErrorWidget extends StatelessWidget {
  final VoidCallback onRetryFunc;
  final String errMsg;

  LoadErrorWidget({@required this.onRetryFunc, this.errMsg = '出错了'});

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: onRetryFunc,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Icon(
            Icons.error,
            color: Colors.red,
          ),
          Text(
            errMsg,
            style: new TextStyle(fontSize: 18),
          )
        ],
      ),
    );
  }
}
