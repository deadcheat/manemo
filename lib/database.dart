import 'dart:io';

import 'package:manemo/enum.dart';
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
    Sqflite.devSetDebugModeOn(true);
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  deleteReceipt(int id, ContinuationType c) async {
    switch (c) {
      case ContinuationType.onetime:
        return await deleteOneTimeReceipt(id);
      case ContinuationType.regularly:
        return await deleteRegularReceipt(id);
      default:
        throw Exception("wrong continuation type for deletion");
    }
  }

  newOneTimeReceipt(OneTimeReceipt newReceipt) async {
    final db = await database;
    var res = await db.insert(tableNameReceipts, newReceipt.toMap());
    return res;
  }

  deleteOneTimeReceipt(int id) async {
    final db = await database;
    var res =
        await db.delete(tableNameReceipts, where: 'id = ?', whereArgs: [id]);
    return res;
  }

  newRegularReceipt(RegularReceipt newReceipt) async {
    final db = await database;
    var res = await db.insert(tableNameRegularPayments, newReceipt.toMap());
    return res;
  }

  deleteRegularReceipt(int id) async {
    final db = await database;
    var res = await db
        .delete(tableNameRegularPayments, where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<List<Receipt>> listAllReceipts(int year, int month) async {
    var receipts = List<Receipt>();
    var regularReceipts = await listRegularReceipts(year, month);
    regularReceipts.forEach((regularReceipt) {
      receipts.add(regularReceipt.toReceipt(year, month));
    });

    var oneTimeReceipts = await listOneTimeReceipts(year, month);
    oneTimeReceipts.forEach((oneTimeReceipt) {
      receipts.add(oneTimeReceipt.toReceipt());
    });

    return receipts;
  }

  Future<List<OneTimeReceipt>> listOneTimeReceipts(int year, int month) async {
    var firstDayOfMonth = new DateTime(year, month);
    var lastDayOfMonth = new DateTime(year, month + 1, 0, 23, 59, 59);
    final db = await database;
    var res = await db.query(tableNameReceipts,
        where: 'utime >= ? and utime <= ?',
        whereArgs: [
          firstDayOfMonth.millisecondsSinceEpoch,
          lastDayOfMonth.millisecondsSinceEpoch
        ]);
    var receipts = List<OneTimeReceipt>();
    res.forEach((elem) {
      receipts.add(OneTimeReceipt.fromMap(elem));
    });
    return receipts;
  }

  Future<List<RegularReceipt>> listRegularReceipts(int year, int month) async {
    var firstDayOfMonth = new DateTime(year, month);
    var lastDayOfMonth = new DateTime(year, month + 1, 0, 23, 59, 59);
    final db = await database;
    var res = await db.query(tableNameRegularPayments,
        where: 'utime_month_from <= ? and utime_month_to >= ?',
        whereArgs: [
          firstDayOfMonth.millisecondsSinceEpoch,
          lastDayOfMonth.millisecondsSinceEpoch
        ]);
    var receipts = List<RegularReceipt>();
    res.forEach((elem) {
      receipts.add(RegularReceipt.fromMap(elem));
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
          "balance_type INTEGER,"
          "payment_type INTEGER"
          ")");
      await db.execute(
          "CREATE INDEX IF NOT EXISTS index_list_receipts ON receipts(utime)");
      await db.execute("CREATE TABLE IF NOT EXISTS regular_payments ("
          "id INTEGER PRIMARY KEY,"
          "utime_month_from INTEGER,"
          "utime_month_to INTEGER,"
          "day_of_month INTEGER,"
          "description TEXT,"
          "price INTEGER,"
          "balance_type INTEGER,"
          "payment_type INTEGER"
          ")");
      await db.execute(
          "CREATE INDEX IF NOT EXISTS index_list_regular_payments ON regular_payments(utime_month_from, utime_month_to)");
    });
  }
}
