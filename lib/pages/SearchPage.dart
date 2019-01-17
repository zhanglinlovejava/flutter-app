import 'package:flutter/material.dart';
import 'package:flutter_open/api/API.dart';
import 'package:flutter_open/api/HttpController.dart';
import 'package:flutter_open/utils/ActionViewUtils.dart';
import 'package:flutter_open/component/loading/LoadingStatus.dart';
import 'package:flutter_open/pages/SearchResultPage.dart';
import '../Constants.dart';
import '../db/DBManager.dart';
import '../entity/SearchEntity.dart';
import '../utils/Tools.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<SearchEntity> _hotAndHisList = [];
  List _preSearchList = [];
  TextEditingController _editingController;
  String _type = 'hot';
  LoadingStatus status = LoadingStatus.loading;
  bool hasNoMoreData = false;
  DBManager _db;
  int _historyLength = 0;
  Map<String, String> _params = new Map();

  @override
  void initState() {
    super.initState();
    _db = DBManager();
    _editingController = TextEditingController();
    _hotAndHisList.add(SearchEntity('搜索历史'));
    _querySearchHisList();
    _fetchHotList();
  }

  _querySearchHisList() async {
    await _db.querySearchHisList().then((list) {
      _historyLength = list.length;
      _hotAndHisList.addAll(list);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: Tools.getStatusHeight(context)),
        child: Column(
          children: <Widget>[
            _renderTopBar(),
            Expanded(child: _renderContent())
          ],
        ),
      ),
    );
  }

  _renderContent() {
    if (_type == 'preSearch') {
      return ListView.builder(
          itemCount: _preSearchList.length,
          itemBuilder: (BuildContext context, int index) {
            return _renderPreSearchItem(index);
          });
    } else if (_type == 'search') {
      return SearchResultPage(
        API.SEARCH,
        params: _params,
      );
    } else if (_type == 'hot') {
      return ListView.builder(
          itemCount: _hotAndHisList.length,
          itemBuilder: (BuildContext context, int index) {
            return _renderHotAndHisItem(context, index);
          });
    }
  }

  _renderPreSearchItem(int index) {
    String item = _preSearchList[index];
    String query = _editingController.text;
    List<TextSpan> textSpans = _buildTextSpans(item, query);
    return textSpans.length > 0
        ? GestureDetector(
            onTap: () {
              _onSubmitted(context, SearchEntity(item));
            },
            child: Container(
                padding: EdgeInsets.all(10),
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(children: textSpans),
                )),
          )
        : new Container();
  }

  List<TextSpan> _buildTextSpans(String item, String query) {
    List indexs = [];
    for (var i = 0; i < item.length; i++) {
      for (var x = 0; x < query.length; x++) {
        if (item[i] == query[x]) {
          if (!indexs.contains(i)) indexs.add(i);
        }
      }
    }
    List<TextSpan> textSpans = [];
    for (var j = 0; j < indexs.length; j++) {
      if (j == 0) {
        textSpans.add(_buildTextSpan(item, 0, indexs[j], Colors.black));
      } else {
        textSpans.add(
            _buildTextSpan(item, indexs[j - 1] + 1, indexs[j], Colors.black));
      }
      textSpans
          .add(_buildTextSpan(item, indexs[j], indexs[j] + 1, Colors.blue));
      if (j == indexs.length - 1 && indexs[j] + 1 < item.length) {
        textSpans.add(
            _buildTextSpan(item, indexs[j] + 1, item.length, Colors.black));
      }
    }
    return textSpans;
  }

  TextSpan _buildTextSpan(String item, int start, int end, Color color) {
    return TextSpan(
        text: item.substring(start, end),
        style: TextStyle(color: color, fontFamily: ConsFonts.fzFont));
  }

  _renderTopBar() {
    return Container(
      decoration: ActionViewUtils.renderBorderBottom(),
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              height: 35,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: TextField(
                onChanged: _onEditChanged,
                onSubmitted: (text) {
                  _onSubmitted(context, SearchEntity(text));
                },
                textInputAction: TextInputAction.search,
                style: TextStyle(fontSize: 14, color: Colors.black),
                cursorColor: ConsColors.mainColor,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 6),
                    border: InputBorder.none,
                    hintText: '搜索视频、作者、用户及标签',
                    suffixIcon: Offstage(
                      offstage: _editingController.text == '',
                      child: GestureDetector(
                        onTap: () {
                          HttpController.getInstance()
                              .cancelRequest('perSearch');
                          _editingController.text = '';
                          _type = 'hot';
                          setState(() {});
                          if (_hotAndHisList.length == _historyLength + 1) {
                            _fetchHotList();
                          }
                        },
                        child: Container(
                          child: Icon(
                            Icons.cancel,
                            color: Colors.grey[400],
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 20,
                    )),
                controller: _editingController,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                '取消',
                style: TextStyle(color: Colors.black87, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }

  _onSubmitted(BuildContext context, SearchEntity item) {
    _editingController.text = item.name;
    _type = 'search';
    List<SearchEntity> hisList = _hotAndHisList.sublist(1, _historyLength + 2);
    bool notExist = true;
    for (var i = 0; i < hisList.length; i++) {
      if (hisList[i].name == item.name) {
        notExist = false;
        break;
      }
    }
    if (notExist) {
      _historyLength += 1;
      _hotAndHisList.insert(1, item);
      _db.saveSearchHisList(item);
    }
    _params['query'] = item.name;
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {});
  }

  _onEditChanged(String text) {
    if (text == '') {
      _type = 'hot';
      setState(() {});
      return;
    }
    _fetchPerSearchList(text);
  }

  _renderHotAndHisItem(BuildContext context, index) {
    bool isHisItem = index > 0 && index <= _historyLength;
    bool isHeader = index == 0 || index == _historyLength + 1;
    SearchEntity item = _hotAndHisList[index];
    return GestureDetector(
      onTap: () {
        if (!isHeader) {
          _onSubmitted(context, item);
        }
      },
      child: Container(
          decoration: ActionViewUtils.renderBorderBottom(),
          padding: EdgeInsets.only(
              left: 15, right: 15, bottom: 15, top: index == 0 ? 0 : 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child: Text(item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: isHeader ? Colors.black : ConsColors.mainColor,
                          fontSize: isHeader ? 24 : 14,
                          fontFamily: ConsFonts.fzFont))),
              GestureDetector(
                onTap: () {
                  _hotAndHisList.removeAt(index);
                  _historyLength -= 1;
                  _db.deleteSearchHis(item);
                  setState(() {});
                },
                child: isHisItem
                    ? Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(
                          Icons.delete,
                          size: 20,
                          color: Colors.grey,
                        ),
                      )
                    : new Container(),
              )
            ],
          )),
    );
  }

  _fetchHotList() async {
    await HttpController.getInstance().get(API.SEARCH_HOT, (data) {
      if (data != null && data.length > 0) {
        _hotAndHisList.add(SearchEntity('热搜关键词'));
        data.forEach((item) {
          _hotAndHisList.add(SearchEntity(item));
        });
        if (mounted) {
          setState(() {});
        }
      }
    }, token: 'preSearch');
  }

  _fetchPerSearchList(String text) async {
    if (text.trim() == '' || text == null) {
      return;
    }
    Map<String, String> params = new Map();
    params['query'] = text;
    await HttpController.getInstance().get(API.SEARCH_PER, (data) {
      if (data != null && data.length > 0) {
        _preSearchList = data;
        _type = 'preSearch';
        if (mounted) {
          setState(() {});
        }
      }
    }, params: params);
  }
}
