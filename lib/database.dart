import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:manemo/model.dart';

class ManemoDBProvider {
  ManemoDBProvider._();
  static final ManemoDBProvider db = ManemoDBProvider._();
  static Database _database;
  final tableNameReceipts = 'receipts';
  final tableNameRegularPayments = 'regular_payments';

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  newReceipt(Receipt newReceipt) async {
    final db = await database;
    var res = await db.insert(tableNameReceipts, newReceipt.toMap());
    return res;
  }

  deleteReceipt(int id) async {
    final db = await database;
    var res =
        await db.delete(tableNameReceipts, where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<List<Receipt>> listReceipts(int year, int month) async {
    var firstDayOfMonth = new DateTime(year, month);
    var lastDayOfMonth = new DateTime(year, month + 1, 0);
    final db = await database;
    var res = await db.query(tableNameReceipts,
        where: 'utime >= ? and utime <= ?',
        whereArgs: [
          firstDayOfMonth.millisecondsSinceEpoch,
          lastDayOfMonth.millisecondsSinceEpoch
        ]);
    var receipts = List<Receipt>();
    res.forEach((elem) {
      receipts.add(Receipt.fromMap(elem));
    });
    return receipts;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "monemo.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE IF NOT EXISTS receipts ("
          "id INTEGER PRIMARY KEY,"
          "utime INTEGER,"
          "description TEXT,"
          "price INTEGER,"
          "payment_type INTEGER"
          ")");
      await db.execute(
          "CREATE INDEX IF NOT EXISTS index_list_receipts ON receipts(utime)");
      await db.execute("CREATE TABLE IF NOT EXISTS regular_payments ("
          "id INTEGER PRIMARY KEY,"
          "utime_month_from INTEGER,"
          "utime_month_to INTEGER,"
          "day_of_month INTEGER"
          "description TEXT,"
          "price INTEGER,"
          "payment_type INTEGER"
          ")");
      await db.execute(
          "CREATE INDEX IF NOT EXISTS index_list_regular_payments ON regular_payments(utime_month_from, utime_month_to)");
    });
  }
}
