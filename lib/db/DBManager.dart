import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:flutter_open/entity/TabList.dart';
import 'package:flutter_open/entity/TabInfo.dart';

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
        "CREATE TABLE HomeTabList (id INTEGER , name TEXT, apiUrl TEXT, bgPicture TEXT)");
    await db.execute(
        "CREATE TABLE CommunityTabList (id INTEGER , name TEXT, apiUrl TEXT, bgPicture TEXT)");
  }

  //insert
  saveHomeTabList(TabList tabList) async {
    var dbClient = await db;
    var batch = dbClient.batch();
    TabInfo tabInfo = new TabInfo(-5, '关注', '', '');
    batch.insert('HomeTabList', tabInfo.toMap());
    tabList.tabList.forEach((tabInfo) {
      batch.insert('HomeTabList', tabInfo.toMap());
    });
    await batch.commit();
  }

  saveCommunityTabList(TabList tabList) async {
    var dbClient = await db;
    var batch = dbClient.batch();
    tabList.tabList.forEach((tabInfo) {
      batch.insert('CommunityTabList', tabInfo.toMap());
    });
    await batch.commit();
  }

  Future<TabList> queryCommunityTabList() async {
    var dbClient = await db;
    List<dynamic> tabList = new List();
    try {
      tabList = await dbClient.query("CommunityTabList");
    } catch (e) {
      print(e);
    }
    return TabList.map(tabList);
  }

  //query
  Future<TabList> queryHomeTabList() async {
    var dbClient = await db;
    List<dynamic> tabList = new List();
    try {
      tabList = await dbClient.query("HomeTabList");
    } catch (e) {
      print(e);
    }
    return TabList.map(tabList);
  }
}
