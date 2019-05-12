import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:manemo/enum.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:manemo/model.dart';
import 'package:manemo/const.dart';

class ManemoReceiptTabview extends StatefulWidget {
  ManemoReceiptTabview({Key key}) : super(key: key);

  @override
  _ManemoReceiptTabviewState createState() => new _ManemoReceiptTabviewState();
}

class _ManemoReceiptTabviewState extends State<ManemoReceiptTabview> {
  final priceTextController = TextEditingController();
  final dateTextController = TextEditingController();
  final descriptionTextController = TextEditingController();
  final currencyFormat = new NumberFormat(CURRENCY_NUMBER_FORMAT, LOCALE_JA_JP);

  DateTime paidDate;
  DateTime lastMonth;
  DateTime payDay;
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
    dateTextController.text = StaticInstances.dateFormat.format(paidDate);
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    // This also removes the _printLatestValue listener
    priceTextController.dispose();
    dateTextController.dispose();
    descriptionTextController.dispose();
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

  @override
  Widget build(BuildContext context) {
    var registerOnceTab = Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: new Text(
              DISPLAY_INCOMES_OR_EXPENSES,
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
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
                    style: new TextStyle(fontSize: 18.0),
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
                    style: new TextStyle(fontSize: 18.0),
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
                fontSize: 18.0,
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
                fontSize: 18.0,
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
                fontSize: 18.0,
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
                fontSize: 18.0,
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
          SizedBox(height: 100.0),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // FIXME: this calculation is strange
              children: <Widget>[
                Container(
                  height: 50.0,
                  width: (MediaQuery.of(context).size.width) * 0.4,
                  child: _cancelButton(),
                ),
                Container(
                    height: 50.0,
                    width: (MediaQuery.of(context).size.width) * 0.4,
                    child: _addOneTimeReceiptButton()),
              ],
            ),
          ),
        ],
      ),
    );
    var registerContinuousTab = Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: new Text(
              DISPLAY_INCOMES_OR_EXPENSES,
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
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
                    style: new TextStyle(fontSize: 18.0),
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
                    style: new TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: new Text(
              DISPLAY_YEAR_AND_MONTH,
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
          Container(
            child: DateTimePickerFormField(
              inputType: InputType.date,
              format: StaticInstances.yearMonthFormat,
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
                fontSize: 18.0,
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
                fontSize: 18.0,
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
                fontSize: 18.0,
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
          SizedBox(height: 100.0),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // FIXME: this calculation is strange
              children: <Widget>[
                Container(
                  height: 50.0,
                  width: (MediaQuery.of(context).size.width) * 0.4,
                  child: _cancelButton(),
                ),
                Container(
                    height: 50.0,
                    width: (MediaQuery.of(context).size.width) * 0.4,
                    child: _addOneTimeReceiptButton()),
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
            registerContinuousTab,
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
    var newReceipt = new Receipt(
      utime: paidDate.millisecondsSinceEpoch,
      price: priceVal.toInt(),
      description: descriptionTextController.text,
      continuationType: ContinuationType.onetime.index,
      paymentType: _paymentType.index,
    );
    StaticInstances.dbprovider.newReceipt(newReceipt);

    Navigator.pop(context);
  }
}
