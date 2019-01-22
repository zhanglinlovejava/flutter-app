import 'package:flutter/material.dart';
import '../db/DBManager.dart';
import '../utils/ActionViewUtils.dart';
import '../entity/CollectionEntity.dart';
import '../component/widgets/VideoSmallCardWidget.dart';
import '../pages/UgcPicturePreviewPage.dart';
import '../component/loading/LoadingStatus.dart';
import '../component/loading/loading_view.dart';
import '../component/loading/platform_adaptive_progress_indicator.dart';
import '../component/widgets/LoadEmptyWidget.dart';
import '../component/widgets/TheEndWidget.dart';
class CollectionPage extends StatefulWidget {
  final String source;
  final String title;
  CollectionPage(this.source,{this.title});

  @override
  _CollectionPageState createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage>
    with TickerProviderStateMixin {
  List<CollectionEntity> _itemList = [];
  DBManager _db;
  LoadingStatus _status = LoadingStatus.loading;
  @override
  void initState() {
    super.initState();
    _db = DBManager();
    _queryCollectionList();
  }

  _queryCollectionList() async {
    _itemList = await _db.queryCollectionList(widget.source);
    if (_itemList.length > 0) {
      _status = LoadingStatus.success;
    } else {
      _status = LoadingStatus.empty;
    }
    if (mounted) setState(() {});
  }

  _delete(int id) async {
    await _db.deleteCollection(id,widget.source);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ActionViewUtils.buildAppBar(title: widget.title),
      body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 15, right: 15),
          child: LoadingView(
              status: _status,
              loadingContent: PlatformAdaptiveProgressIndicator(
                strokeWidth: 2,
              ),
              errorContent: null,
              emptyContent: LoadEmptyWidget(onRetryFunc: () {
                _status = LoadingStatus.loading;
                setState(() {});
                _queryCollectionList();
              }),
              successContent: ListView.builder(
                  itemCount: _itemList.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == _itemList.length) {
                      return TheEndWidget(color: 0xff000000);
                    } else {
                      return _renderDeleteView(index, context);
                      ;
                    }
                  }))),
    );
  }

  _renderDeleteView(int index, BuildContext context) {
    return Dismissible(
        background: Container(color: Colors.red),
        direction: DismissDirection.endToStart,
        key: Key(_itemList[index].itemId.toString()),
        child: _renderItem(index, context),
        onDismissed: (_) {
          _delete(_itemList[index].itemId);
          _itemList.removeAt(index);
          if (_itemList.length == 0) {
            _status = LoadingStatus.empty;
            setState(() {});
          }
          Scaffold.of(context)
              .showSnackBar(new SnackBar(content: new Text("已删除")));
        });
  }

  _renderItem(int index, BuildContext context) {
    var data = _itemList[index];
    String type = data.typeO;
    return VideoSmallCardWidget(
        id: data.idO,
        duration: data.durationO ?? 0,
        cover: data.coverO,
        title: data.titleO,
        onCoverTap: () {
          if (type == 'video') {
            ActionViewUtils.actionVideoPlayPage(context, data.itemIdO);
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return UgcPicturePreviewWidget(
                  resourceType: data.resourceTypeO, id: data.itemIdO);
            }));
          }
        },
        category: data.categoryO);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
