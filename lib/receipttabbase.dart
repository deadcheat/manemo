import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show TextInputType, WhitelistingTextInputFormatter;
import 'package:intl/intl.dart' show DateFormat, NumberFormat;
import 'package:manemo/enum.dart' show BalanceType, PaymentType;
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart'
    show DateTimePickerFormField, InputType;
import 'package:manemo/const.dart';
import 'package:manemo/model.dart';

class ManemoReceiptTabview extends StatefulWidget {
  ManemoReceiptTabview({Key key}) : super(key: key);

  @override
  _ManemoReceiptTabviewState createState() => new _ManemoReceiptTabviewState();
}

class _ManemoReceiptTabviewState extends State<ManemoReceiptTabview> {
  final priceTextController = TextEditingController();
  final dateTextController = TextEditingController();
  final regularDateTextController = TextEditingController();
  final descriptionTextController = TextEditingController();
  final startYearTextController = TextEditingController();
  final endYearTextController = TextEditingController();
  final paymentDayTextController = TextEditingController();
  final currencyFormat = new NumberFormat(CURRENCY_NUMBER_FORMAT, LOCALE_JA_JP);

  DateTime paidDate;
  DateTime lastMonth;
  DateTime payDay;
  DateTime regularPaymentStartsAt;
  String regularPaymentStartYear;
  String regularPaymentStartMonth;
  DateTime regularPaymentEndsAt;
  String regularPaymentEndYear;
  String regularPaymentEndMonth;
  int regularPaymentDate;
  PaymentType _paymentType = PaymentType.cash;
  BalanceType _balanceType = BalanceType.expenses;

  void _setPaymentType(PaymentType newVal) {
    setState(() {
      _paymentType = newVal;
    });
  }

  void _setBalanceType(BalanceType newVal) {
    setState(() {
      _balanceType = newVal;
    });
  }

  @override
  void initState() {
    super.initState();
    priceTextController.text = ZERO_STRING;
    priceTextController.addListener(_printLatestValue);
    var now = DateTime.now();
    paidDate = DateTime(now.year, now.month, now.day, 0, 0, 0, 0, 0);
    regularPaymentStartsAt = DateTime(now.year, now.month, 1, 0, 0, 0, 0, 0);
    regularPaymentStartYear = regularPaymentStartsAt.year.toString();
    startYearTextController.text = regularPaymentStartYear;
    regularPaymentStartMonth =
        DateFormat(DATE_FORMAT_MM).format(regularPaymentStartsAt);
    paymentDayTextController.text = regularPaymentStartsAt.day.toString();
    regularPaymentEndsAt = DateTime(now.year, now.month + 1, 1, 0, 0, 0, 0, 0);
    regularPaymentEndYear = regularPaymentEndsAt.year.toString();
    endYearTextController.text = regularPaymentEndYear;
    regularPaymentEndMonth =
        DateFormat(DATE_FORMAT_MM).format(regularPaymentEndsAt);
    dateTextController.text = StaticInstances.dateFormat.format(paidDate);
    regularDateTextController.text =
        StaticInstances.yearMonthFormat.format(paidDate);
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    // This also removes the _printLatestValue listener
    priceTextController.dispose();
    dateTextController.dispose();
    regularDateTextController.dispose();
    descriptionTextController.dispose();
    startYearTextController.dispose();
    endYearTextController.dispose();
    paymentDayTextController.dispose();
    super.dispose();
  }

  String _previousValue;

  _printLatestValue() {
    final value = priceTextController.text;
    if (value == _previousValue) {
      return;
    }
    if (value == null || value.isEmpty) {
      priceTextController.text = ZERO_STRING;
      return;
    }
    final n = num.tryParse(priceTextController.text);
    final formattedValue = currencyFormat.format(n);
    _previousValue = formattedValue;
    priceTextController.text = formattedValue;
  }

  String _numberValidator(String value) {
    if (value == null || value.isEmpty) {
      return ERROR_NUMBERTEXT_IS_EMPTY;
    }
    final n = num.tryParse(value);
    if (n == null) {
      return '"$value" is not a valid number';
    }
    return null;
  }

  String _dayValidator(String value) {
    final nv = _numberValidator(value);
    if (nv != null) {
      return nv;
    }
    final n = num.tryParse(value);
    if (n < 0 || 31 < n) {
      return '"$value" should be between 1 and 31';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var registerOnceTab = Container(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: new Text(
              DISPLAY_INCOMES_OR_EXPENSES,
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ),
          new Row(
            children: <Widget>[
              new Flexible(
                child: new RadioListTile<BalanceType>(
                  value: BalanceType.incomes,
                  groupValue: _balanceType,
                  onChanged: _setBalanceType,
                  title: new Text(
                    DISPLAY_INCOMES,
                    style: new TextStyle(fontSize: 15.0),
                  ),
                ),
              ),
              new Flexible(
                child: new RadioListTile<BalanceType>(
                  value: BalanceType.expenses,
                  groupValue: _balanceType,
                  onChanged: _setBalanceType,
                  title: new Text(
                    DISPLAY_EXPENSES,
                    style: new TextStyle(fontSize: 15.0),
                  ),
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: new Text(
              DISPLAY_DATE,
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ),
          Container(
            child: DateTimePickerFormField(
              inputType: InputType.date,
              format: StaticInstances.dateFormat,
              controller: dateTextController,
              editable: false,
              initialDate: new DateTime.now(),
              initialValue: new DateTime.now(),
              style: TextStyle(fontSize: 40.0),
              textAlign: TextAlign.center,
              onChanged: (dt) => setState(() => paidDate = dt),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: new Text(
              DISPLAY_TOTAL,
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ),
          TextFormField(
            controller: priceTextController,
            decoration: InputDecoration(
              prefix: Text(DISPLAY_JPY_MARK),
            ),
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
            ],
            validator: _numberValidator,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 40.0),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: new Text(
              DISPLAY_DESCRIPTION,
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: TextFormField(
              controller: descriptionTextController,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 40.0),
            ),
          ),
          new Padding(
            padding: new EdgeInsets.all(8.0),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: new Text(
              DISPLAY_CASH_OR_CHARGE,
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ),
          new Row(
            children: <Widget>[
              new Flexible(
                child: new RadioListTile<PaymentType>(
                  value: PaymentType.cash,
                  groupValue: _paymentType,
                  onChanged: _setPaymentType,
                  title: new Text(
                    DISPLAY_WORD_CASH,
                    style: new TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
              new Flexible(
                child: new RadioListTile<PaymentType>(
                  value: PaymentType.charge,
                  groupValue: _paymentType,
                  onChanged: _setPaymentType,
                  title: new Text(
                    DISPLAY_WORD_CHARGE,
                    style: new TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
            ],
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // FIXME: this calculation is strange
              children: <Widget>[
                Container(
                  height: 40.0,
                  width: (MediaQuery.of(context).size.width) * 0.4,
                  child: _cancelButton(),
                ),
                Container(
                    height: 40.0,
                    width: (MediaQuery.of(context).size.width) * 0.4,
                    child: _addOneTimeReceiptButton()),
              ],
            ),
          ),
        ],
      ),
    );
    var registerRegularTab = Container(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: new Text(
              DISPLAY_INCOMES_OR_EXPENSES,
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ),
          new Row(
            children: <Widget>[
              new Flexible(
                child: new RadioListTile<BalanceType>(
                  value: BalanceType.incomes,
                  groupValue: _balanceType,
                  onChanged: _setBalanceType,
                  title: new Text(
                    DISPLAY_INCOMES,
                    style: new TextStyle(fontSize: 15.0),
                  ),
                ),
              ),
              new Flexible(
                child: new RadioListTile<BalanceType>(
                  value: BalanceType.expenses,
                  groupValue: _balanceType,
                  onChanged: _setBalanceType,
                  title: new Text(
                    DISPLAY_EXPENSES,
                    style: new TextStyle(fontSize: 15.0),
                  ),
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: new Text(
              DISPLAY_START_PAYMENT,
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ),
          Container(
            child: Row(children: <Widget>[
              Container(
                width: (MediaQuery.of(context).size.width) * 0.4,
                child: TextFormField(
                  decoration: new InputDecoration.collapsed(
                    hintText: 'yyyy',
                  ),
                  controller: startYearTextController,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                  validator: _numberValidator,
                  keyboardType: TextInputType.numberWithOptions(decimal: false),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
              Container(
                child: Text(
                  '/',
                  style: TextStyle(fontSize: 35.0),
                ),
              ),
              Container(
                width: (MediaQuery.of(context).size.width) * 0.4,
                alignment: Alignment.center,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: regularPaymentStartMonth,
                    onChanged: (String newValue) {
                      setState(() {
                        regularPaymentEndMonth = newValue;
                      });
                    },
                    items: <String>[
                      '01',
                      '02',
                      '03',
                      '04',
                      '05',
                      '06',
                      '07',
                      '08',
                      '09',
                      '10',
                      '11',
                      '12'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          '   ' + value,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 40.0),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ]),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: new Text(
              DISPLAY_END_PAYMENT,
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ),
          Container(
            child: Row(children: <Widget>[
              Container(
                width: (MediaQuery.of(context).size.width) * 0.4,
                child: TextFormField(
                  decoration: new InputDecoration.collapsed(
                    hintText: 'yyyy',
                  ),
                  controller: endYearTextController,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                  validator: _numberValidator,
                  keyboardType: TextInputType.numberWithOptions(decimal: false),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
              Container(
                child: Text(
                  '/',
                  style: TextStyle(fontSize: 35.0),
                ),
              ),
              Container(
                width: (MediaQuery.of(context).size.width) * 0.4,
                alignment: Alignment.center,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: regularPaymentEndMonth,
                    onChanged: (String newValue) {
                      setState(() {
                        regularPaymentStartMonth = newValue;
                      });
                    },
                    items: <String>[
                      '01',
                      '02',
                      '03',
                      '04',
                      '05',
                      '06',
                      '07',
                      '08',
                      '09',
                      '10',
                      '11',
                      '12'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          '   ' + value,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 40.0),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ]),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: new Text(
              DISPLAY_PAYMENT_DAY,
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: TextFormField(
              controller: paymentDayTextController,
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
              ],
              validator: _dayValidator,
              keyboardType: TextInputType.numberWithOptions(decimal: false),
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 40.0),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: new Text(
              DISPLAY_TOTAL,
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ),
          TextFormField(
            controller: priceTextController,
            decoration: InputDecoration(
              prefix: Text(DISPLAY_JPY_MARK),
            ),
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
            ],
            validator: _numberValidator,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 40.0),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: new Text(
              DISPLAY_DESCRIPTION,
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: TextFormField(
              controller: descriptionTextController,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 40.0),
            ),
          ),
          new Padding(
            padding: new EdgeInsets.all(8.0),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: new Text(
              DISPLAY_CASH_OR_CHARGE,
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ),
          new Row(
            children: <Widget>[
              new Flexible(
                child: new RadioListTile<PaymentType>(
                  value: PaymentType.cash,
                  groupValue: _paymentType,
                  onChanged: _setPaymentType,
                  title: new Text(
                    DISPLAY_WORD_CASH,
                    style: new TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
              new Flexible(
                child: new RadioListTile<PaymentType>(
                  value: PaymentType.charge,
                  groupValue: _paymentType,
                  onChanged: _setPaymentType,
                  title: new Text(
                    DISPLAY_WORD_CHARGE,
                    style: new TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
            ],
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // FIXME: this calculation is strange
              children: <Widget>[
                Container(
                  height: 40.0,
                  width: (MediaQuery.of(context).size.width) * 0.4,
                  child: _cancelButton(),
                ),
                Container(
                    height: 40.0,
                    width: (MediaQuery.of(context).size.width) * 0.4,
                    child: _addRegularReceiptButton()),
              ],
            ),
          ),
        ],
      ),
    );

    return new DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(DISPLAY_REGISTER_PAYMENT),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: DISPLAY_ONE_TIME,
              ),
              Tab(
                text: DISPLAY_REGULARLY,
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            registerOnceTab,
            registerRegularTab,
          ],
        ),
      ),
    );
  }

  RaisedButton _cancelButton() {
    return RaisedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      color: Colors.blueGrey[100],
      child: Text(
        DISPLAY_CANCEL,
        style: TextStyle(fontSize: 16.9),
      ),
      textColor: Colors.white70,
    );
  }

  RaisedButton _addOneTimeReceiptButton() {
    return RaisedButton(
      onPressed: _addOneTimeReceipt,
      color: Colors.green,
      child: Text(
        DISPLAY_ADD,
        style: TextStyle(fontSize: 16.9),
      ),
      textColor: Colors.white70,
    );
  }

  void _addOneTimeReceipt() {
    var priceVal = currencyFormat.parse(priceTextController.text);
    var newReceipt = new OneTimeReceipt(
      utime: paidDate.millisecondsSinceEpoch,
      price: priceVal.toInt(),
      description: descriptionTextController.text,
      paymentType: _paymentType.index,
    );
    StaticInstances.dbprovider.newOneTimeReceipt(newReceipt);

    Navigator.pop(context);
  }

  RaisedButton _addRegularReceiptButton() {
    return RaisedButton(
      onPressed: _addRegularReceipt,
      color: Colors.green,
      child: Text(
        DISPLAY_ADD,
        style: TextStyle(fontSize: 16.9),
      ),
      textColor: Colors.white70,
    );
  }

  void _addRegularReceipt() {
    var priceVal = currencyFormat.parse(priceTextController.text);
    var sYear = int.tryParse(startYearTextController.text);
    var eYear = int.tryParse(endYearTextController.text);
    var sMonth = int.tryParse(regularPaymentStartMonth);
    var eMonth = int.tryParse(regularPaymentEndMonth);

    var sDate = DateTime(sYear, sMonth);
    var eDate = DateTime(eYear, eMonth + 1, 0, 23, 59, 59);
    var newRegularReceipt = new RegularReceipt(
      utimeMonthFrom: sDate.millisecondsSinceEpoch,
      utimeMonthTo: eDate.millisecondsSinceEpoch,
      dayOfMonth: int.tryParse(paymentDayTextController.text),
      price: priceVal.toInt(),
      description: descriptionTextController.text,
      paymentType: _paymentType.index,
    );
    StaticInstances.dbprovider.newRegularReceipt(newRegularReceipt);

    Navigator.pop(context);
  }
}
