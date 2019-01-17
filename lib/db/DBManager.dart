import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';
import '../entity/SearchEntity.dart';

class DBManager {
  static final DBManager _instance = new DBManager.internal();

  factory DBManager() => _instance;
  static Database _db;

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
        "CREATE TABLE SEARCH_HISTORY_LIST (id INTEGER PRIMARY KEY , name TEXT )");
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
      batch.rawDelete(
          'DELETE FROM SEARCH_HISTORY_LIST WHERE id = ?', [entity.id]);
    }
    batch.insert('SEARCH_HISTORY_LIST', entity.toMap());
    await batch.commit();
  }

  //query
  Future<List<SearchEntity>> querySearchHisList() async {
    var dbClient = await db;
    List<SearchEntity> searchList = new List();
    try {
      List<dynamic> list = await dbClient.query("SEARCH_HISTORY_LIST");
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
    batch
        .rawDelete('DELETE FROM SEARCH_HISTORY_LIST WHERE id = ?', [entity.id]);
    await batch.commit();
  }
}
