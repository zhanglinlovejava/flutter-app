import 'package:flutter/material.dart';
import '../../../db/DBManager.dart';
import '../../../entity/CollectionEntity.dart';
import '../../../Constants.dart';

class FavouriteBtnWidget extends StatefulWidget {
  final int id;
  final int duration;
  final bool showCount;
  final int count;
  final String title;
  final String cover;
  final String type;
  final String category;
  final bool isDark;
  final String resourceType;

  FavouriteBtnWidget(this.id,
      {this.type = '',
      this.showCount = false,
      this.count = 0,
      this.title = '',
      this.category = '',
      this.cover = '',
      this.duration = 0,
      this.resourceType,
      this.isDark = true});

  @override
  _FavouriteBtnWidgetState createState() => _FavouriteBtnWidgetState();
}

class _FavouriteBtnWidgetState extends State<FavouriteBtnWidget> {
  DBManager _db;
  bool isCollected = false;

  @override
  void initState() {
    super.initState();
    _db = DBManager();
    _checkIsCollected();
  }

  _checkIsCollected() async {
    isCollected =
        await _db.isCollectExist(widget.id, DBSource.collection);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isCollected) {
          _db.deleteCollection(widget.id, DBSource.collection);
          isCollected = false;
        } else {
          CollectionEntity ce = CollectionEntity(
            source: DBSource.collection,
            title: widget.title,
            itemId: widget.id,
            cover: widget.cover,
            category: widget.category,
            type: widget.type,
            duration: widget.duration,
            resourceType: widget.resourceType,
          );
          _db.saveCollection(ce);
          isCollected = true;
        }
        setState(() {});
      },
      child: Container(
        child: new Row(
          children: <Widget>[
            Icon(
              isCollected ? Icons.favorite : Icons.favorite_border,
              size: 20,
              color: isCollected
                  ? Colors.red
                  : (widget.isDark ? Colors.grey : Colors.white),
            ),
            widget.showCount
                ? new Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      widget.count.toString(),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none,
                          color: widget.isDark ? Colors.grey : Colors.white),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
