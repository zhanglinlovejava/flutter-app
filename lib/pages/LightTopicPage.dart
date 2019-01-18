import 'package:flutter/material.dart';
import '../api/API.dart';
import '../api/HttpController.dart';
import '../Constants.dart';
import '../component/loading/loading_view.dart';
import '../component/loading/LoadingStatus.dart';
import '../component/loading/platform_adaptive_progress_indicator.dart';
import '../component/widgets/LoadEmptyWidget.dart';
import '../component/widgets/LoadErrorWidget.dart';
import '../component/widgets/AutoPlayFollowCardWidget.dart';
import '../component/widgets/TheEndWidget.dart';
import '../utils/ActionViewUtils.dart';

class LightTopicPage extends StatefulWidget {
  final String title;
  final int topicId;

  LightTopicPage({@required this.topicId, this.title = ' '});

  @override
  _LightTopicPageState createState() => _LightTopicPageState();
}

class _LightTopicPageState extends State<LightTopicPage> {
  LoadingStatus _status = LoadingStatus.loading;
  var _itemData;
  List _itemList = [];

  @override
  void initState() {
    super.initState();
    _fetchTopicList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          ActionViewUtils.buildAppBar(title: widget.title, actions: <Widget>[
        GestureDetector(
          onTap: () {},
          child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Icon(Icons.favorite_border, size: 25)),
        ),
        GestureDetector(
          onTap: () {},
          child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.file_download, size: 25)),
        ),
      ]),
      body: Center(
          child: LoadingView(
              status: _status,
              loadingContent: PlatformAdaptiveProgressIndicator(
                strokeWidth: 2,
              ),
              errorContent: LoadErrorWidget(onRetryFunc: () {
                _fetchTopicList();
              }),
              emptyContent: LoadEmptyWidget(onRetryFunc: () {
                _fetchTopicList();
              }),
              successContent: ListView.builder(
                  itemCount: _itemList.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    return _renderItem(context, index);
                  }))),
    );
  }

  _renderHeader() {
    return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Colors.grey[300], width: 6))),
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            height: 240,
            child: Stack(
                overflow: Overflow.visible,
                alignment: AlignmentDirectional(0, 0),
                children: <Widget>[
                  Image.network(_itemData['headerImage'],
                      width: double.infinity, fit: BoxFit.cover, height: 210),
                  Positioned(
                      bottom: -23,
                      child: Container(
                          alignment: Alignment.center,
                          height: 46,
                          width: MediaQuery.of(context).size.width - 40,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              border:
                                  Border.all(color: Colors.grey, width: 0.5)),
                          child: Text(
                            _itemData['brief'],
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: ConsFonts.fzFont,
                                fontSize: 15),
                          )))
                ]),
          ),
          Padding(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 15),
              child: Text(_itemData['text'],
                  style: TextStyle(
                      color: Colors.grey,
                      fontFamily: ConsFonts.fzFont,
                      fontSize: 13)))
        ],
      ),
    );
  }

  _renderItem(BuildContext context, int index) {
    if (index == 0) {
      return _renderHeader();
    } else if (index == _itemList.length) {
      return TheEndWidget(color: 0xff000000);
    } else {
      String type = _itemList[index]['type'];
      var item = _itemList[index]['data'];
      if (type == 'autoPlayFollowCard') {
        return Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 10),
            child: AutoPlayFollowCardWidget(item));
      }
    }
  }

  _fetchTopicList() async {
    await HttpController.getInstance()
        .get('${API.LIGHT_TOPIC_ALL}/${widget.topicId}', (data) {
      _itemData = data;
      _itemList = _itemData['itemList'] ?? [];
      if (_itemData == null || _itemList.length == 0) {
        _status = LoadingStatus.empty;
      } else {
        _itemList.insert(0, _itemList[0]);
        _status = LoadingStatus.success;
      }
      if (mounted) {
        setState(() {});
      }
    }, errorCallback: (_) {
      _status = LoadingStatus.error;
      if (mounted) {
        setState(() {});
      }
    });
  }
}
