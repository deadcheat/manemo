import 'package:intl/intl.dart';
import 'package:manemo/database.dart';

const APPNAME = 'MANEMO';
const LOCALE_JA_JP = 'ja_JP';
const CURRENCY_NUMBER_FORMAT = '#,###';
const DATE_FORMAT_YYYY_MM = 'yyyy/MM';
const DATE_FORMAT_YYYY = 'yyyy';
const DATE_FORMAT_MM = 'MM';
const DATE_FORMAT_YYYY_MM_DD = 'yyyy/MM/dd';

const DISPLAY_CURRENCY_NUMBER_FORMAT = '￥ #,###';
const DISPLAY_WORD_CHARGE = 'Charge';
const DISPLAY_WORD_CASH = 'Cash';
const DISPLAY_INCOMES_OR_EXPENSES = 'INCOMES OR EXPENSES';
const DISPLAY_INCOMES = 'INCOMES';
const DISPLAY_EXPENSES = 'EXPENSES';
const DISPLAY_DATE = 'DATE';
const DISPLAY_YEAR_AND_MONTH = 'YEAR / MONTH';
const DISPLAY_START_PAYMENT = 'PAYMENT START AT (YEAR / MONTH)';
const DISPLAY_END_PAYMENT = 'PAYMENT END AT (YEAR / MONTH)';
const DISPLAY_PAYMENT_DAY = 'PAYMENT DAY';
const DISPLAY_TOTAL = 'TOTAL';
const DISPLAY_JPY_MARK = '￥';
const DISPLAY_DESCRIPTION = 'DESCRIPTION';
const DISPLAY_CASH_OR_CHARGE = 'CASH OR CHARGE';
const DISPLAY_ADD = 'ADD';
const DISPLAY_CANCEL = 'CANCEL';
const DISPLAY_REGISTER_PAYMENT = 'REGSITER PAYMENT';
const DISPLAY_ONE_TIME = 'ONE-TIME';
const DISPLAY_REGULARLY = 'REGULARLY';

const ZERO_STRING = '0';

const ERROR_NUMBERTEXT_IS_EMPTY = 'Please enter numbers';

class StaticInstances {
  static final dateFormat = DateFormat(DATE_FORMAT_YYYY_MM_DD);
  static final yearMonthFormat = DateFormat(DATE_FORMAT_YYYY_MM);
  static final dbprovider = ManemoDBProvider.db;
}
