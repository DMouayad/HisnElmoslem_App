import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hisnelmoslem/models/fakeHaith.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

FakeHadithDatabaseHelper fakeHadithDatabaseHelper = FakeHadithDatabaseHelper();

class FakeHadithDatabaseHelper {
  /* ************* Variables ************* */

  static const String DB_NAME = "fakeHadith.db";
  static const int DATABASE_VERSION = 1;

  /* ************* Singelton Constractor ************* */

  static FakeHadithDatabaseHelper? _databaseHelper;
  static Database? _database;

  FakeHadithDatabaseHelper._createInstance();

  factory FakeHadithDatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = FakeHadithDatabaseHelper._createInstance();
    }
    return _databaseHelper!;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initDatabase();
    }
    return _database!;
  }

  /* ************* Database Creation ************* */

  // init
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, DB_NAME);

    final exist = await databaseExists(path);

    //Check if database is already in that Directory
    if (!exist) {
      // Database isn't exist > Create new Database
      _copyFromAssets(path: path);
    }

    return await openDatabase(
      path,
      version: DATABASE_VERSION,
      onCreate: _onCreateDatabase,
      onUpgrade: _onUpgradeDatabase,
      onDowngrade: _onDowngradeDatabase,
    );
  }

  // On create database
  _onCreateDatabase(Database db, int version) async {
    //
  }

  // On upgrade database version
  _onUpgradeDatabase(Database db, int oldVersion, int newVersion) {
    //
  }

  // On downgrade database version
  _onDowngradeDatabase(Database db, int oldVersion, int newVersion) {
    //
  }

  // Copy database from assets to Database Direcorty of app
  _copyFromAssets({required String path}) async {
    //
    try {
      await Directory(dirname(path)).create(recursive: true);

      ByteData data = await rootBundle.load(join("assets", "db", DB_NAME));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /* ************* Functions ************* */
  // Get all hadith from database
  Future<List<DbFakeHaith>> getAllFakeHadiths() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('fakehadith');

    return List.generate(maps.length, (i) {
      return DbFakeHaith.fromMap(maps[i]);
    });
  }

  // Get read hadith only
  Future<List<DbFakeHaith>> getReadFakeHadiths() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('fakehadith');

    return List.generate(maps.length, (i) {
      return DbFakeHaith.fromMap(maps[i]);
    }).where((element) => element.isRead == 1).toList();
  }

  // Get unread hadith only
  Future<List<DbFakeHaith>> getUnreadFakeHadiths() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('fakehadith');

    return List.generate(maps.length, (i) {
      return DbFakeHaith.fromMap(maps[i]);
    }).where((element) => element.isRead == 0).toList();
  }

  // Mark haduth as read
  Future<void> markAsRead({required DbFakeHaith dbFakeHaith}) async {
    final db = await database;

    await db.rawUpdate(
        'UPDATE fakehadith SET isRead = ? WHERE _id = ?', [1, dbFakeHaith.id]);
  }

  // Mark hadith as unread
  Future<void> markAsUnRead({required DbFakeHaith dbFakeHaith}) async {
    final db = await database;

    await db.rawUpdate(
        'UPDATE fakehadith SET isRead = ? WHERE _id = ?', [0, dbFakeHaith.id]);
  }

  // Close database
  Future close() async {
    final db = await database;
    db.close();
  }
}
