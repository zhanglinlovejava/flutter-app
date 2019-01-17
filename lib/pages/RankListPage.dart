import 'package:flutter/material.dart';
import '../api/API.dart';
import '../api/HttpController.dart';
import '../component/loading/LoadingStatus.dart';
import '../component/loading/loading_view.dart';
import '../component/loading/platform_adaptive_progress_indicator.dart';

class RankListPage extends StatefulWidget {
  @override
  _RankListPageState createState() => _RankListPageState();
}

class _RankListPageState extends State<RankListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('eyepetizer', style: TextStyle(color: Colors.black)),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
//    body: Center(
//      child: Container(child: ,),
//    )
    );
  }
}
