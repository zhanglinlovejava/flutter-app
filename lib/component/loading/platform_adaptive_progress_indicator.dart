import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformAdaptiveProgressIndicator extends StatelessWidget {
  final double strokeWidth;

  const PlatformAdaptiveProgressIndicator({this.strokeWidth = 4}) : super();

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? const CupertinoActivityIndicator()
        : CircularProgressIndicator(
            strokeWidth: strokeWidth,
          );
  }
}
