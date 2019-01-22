import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';
import '../entity/SearchEntity.dart';
import '../entity/CollectionEntity.dart';

class DBManager {
  static final DBManager _instance = new DBManager.internal();

  factory DBManager() => _instance;
  static Database _db;
  static const String SEARCH_LIST = 'SEARCH_HISTORY_LIST';
  static const String COLLECTION_LIST = 'COLLECTION_LIST';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  DBManager.internal();

  initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'lin.db');
    var _db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return _db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $SEARCH_LIST (id INTEGER PRIMARY KEY , name TEXT )');
    await db.execute(
        'CREATE TABLE $COLLECTION_LIST (id INTEGER PRIMARY KEY ,resourceType TEXT , itemId INTEGER ,source TEXT , title TEXT ,duration INTEGER , cover TEXT ,category TEXT ,type TEXT )');
  }

  //insert
  saveSearchHisList(SearchEntity entity) async {
    List<SearchEntity> list = await querySearchHisList();
    bool notExist = true;
    for (var i = 0; i < list.length; i++) {
      if (list[i].name == entity.name) {
        notExist = false;
        break;
      }
    }
    var dbClient = await db;
    var batch = dbClient.batch();
    if (!notExist) {
      batch.rawUpdate('DELETE FROM $SEARCH_LIST WHERE id = ?', [entity.id]);
    }
    batch.insert(SEARCH_LIST, entity.toMap());
    await batch.commit();
  }

  //query
  Future<List<SearchEntity>> querySearchHisList() async {
    var dbClient = await db;
    List<SearchEntity> searchList = new List();
    try {
      List<dynamic> list = await dbClient.query(SEARCH_LIST);
      list.forEach((item) {
        searchList.add(SearchEntity.map(item));
      });
    } catch (e) {
      print(e);
    }
    searchList.sort((a, b) => b.id.compareTo(a.id));
    return searchList;
  }

  deleteSearchHis(SearchEntity entity) async {
    var dbClient = await db;
    var batch = dbClient.batch();
    batch.rawDelete('DELETE FROM $SEARCH_LIST WHERE id = ?', [entity.id]);
    await batch.commit();
  }

  saveCollection(CollectionEntity entity) async {
    bool isExist = await isCollectExist(entity.itemIdO,entity.sourceO);
    if (isExist) {
      return;
    }
    var dbClient = await db;
    var batch = dbClient.batch();
    batch.insert(COLLECTION_LIST, entity.toMap());
    await batch.commit();
  }

  Future<List<CollectionEntity>> queryCollectionList(String source) async {
    var dbClient = await db;
    List<CollectionEntity> collectionList = new List();
    try {
      List<dynamic> list = await dbClient
          .rawQuery('SELECT *FROM $COLLECTION_LIST WHERE source = ? ', [source]);
      list.forEach((item) {
        collectionList.add(CollectionEntity.map(item));
      });
    } catch (e) {
      print(e);
    }
    collectionList.sort((a, b) => b.idO.compareTo(a.idO));
    return collectionList;
  }

  deleteCollection(int itemId, String source) async {
    var dbClient = await db;
    var batch = dbClient.batch();
    batch.rawDelete(
        'DELETE FROM $COLLECTION_LIST WHERE itemId = ? and source= ?',
        [itemId, source]);
    await batch.commit();
  }

  Future<bool> isCollectExist(int itemId,String source) async {
    List<CollectionEntity> list = await queryCollectionList(source);
    bool exist = true;
    for (var i = 0; i < list.length; i++) {
      if (list[i].itemIdO == itemId) {
        exist = false;
        break;
      }
    }
    return !exist;
  }
}
