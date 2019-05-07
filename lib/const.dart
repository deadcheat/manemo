import 'package:intl/intl.dart';
import 'package:manemo/database.dart';

const APPNAME = 'MANEMO';
const LOCALE_JA_JP = 'ja_JP';
const CURRENCY_NUMBER_FORMAT = '#,###';
const DISPLAY_CURRENCY_NUMBER_FORMAT = '￥ #,###';
const DATE_FORMAT_YYYY_MM = 'yyyy/MM';
const DATE_FORMAT_YYYY_MM_DD = 'yyyy-MM-dd';
const DISPLAY_WORD_CHARGE = 'Charge';
const DISPLAY_WORD_CASH = 'Cash';

class StaticInstances {
  static final dateFormat = DateFormat(DATE_FORMAT_YYYY_MM_DD);
  static final dbprovider = ManemoDBProvider.db;
}
