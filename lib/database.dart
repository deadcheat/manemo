import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:manemo/model.dart';

class ManemoDBProvider {
  ManemoDBProvider._();
  static final ManemoDBProvider db = ManemoDBProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  newReceipt(Receipt newReceipt) async {
    final db = await database;
    var res = await db.insert('receipts', newReceipt.toMap());
    return res;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "monemo.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE receipts ("
          "id INTEGER PRIMARY KEY,"
          "utime INTEGER,"
          "description TEXT,"
          "price INTEGER,"
          "continuation_type INTEGER,"
          "payment_type INTEGER"
          ")");
    });
  }
}
