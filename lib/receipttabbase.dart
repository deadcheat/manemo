import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:manemo/enum.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:manemo/database.dart';
import 'package:manemo/model.dart';

class ManemoReceiptTabview extends StatefulWidget {
  ManemoReceiptTabview({Key key}) : super(key: key);

  @override
  _ManemoReceiptTabviewState createState() => new _ManemoReceiptTabviewState();
}

class _ManemoReceiptTabviewState extends State<ManemoReceiptTabview> {
  final priceTextController = TextEditingController();
  final dateTextController = TextEditingController();
  final descriptionTextController = TextEditingController();
  final currencyFormat = new NumberFormat("#,###", "ja_JP");
  final dateFormat = DateFormat('yyyy-MM-dd');
  DateTime paidDate;
  DateTime lastMonth;
  DateTime payDay;
  PaymentType _paymentType = PaymentType.cash;
  BalanceType _balanceType = BalanceType.expenses;
  final _dbProvider = ManemoDBProvider.db;

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
    priceTextController.text = '0';
    priceTextController.addListener(_printLatestValue);
    var now = DateTime.now();
    paidDate = DateTime(now.year, now.month, now.day, 0, 0, 0, 0, 0);
    dateTextController.text = dateFormat.format(paidDate);
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
      priceTextController.text = '0';
      return;
    }
    final n = num.tryParse(priceTextController.text);
    final formattedValue = currencyFormat.format(n);
    _previousValue = formattedValue;
    priceTextController.text = formattedValue;
  }

  String _numberValidator(String value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
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
              'incomes or expenses',
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
                    'Incomes',
                    style: new TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
              new Flexible(
                child: new RadioListTile<BalanceType>(
                  value: BalanceType.expenses,
                  groupValue: _balanceType,
                  onChanged: _setBalanceType,
                  title: new Text(
                    'Expenses',
                    style: new TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: new Text(
              'Date',
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
          Container(
            child: DateTimePickerFormField(
              inputType: InputType.date,
              format: DateFormat('yyyy-MM-dd'),
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
              'Total',
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
          TextFormField(
            controller: priceTextController,
            decoration: InputDecoration(
              prefix: Text("￥"),
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
              'Description',
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
              'Cash or Charge',
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
                    'Cash',
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
                    'Charge',
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
                    child: _addButton()),
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
              'incomes or expenses',
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
                    'Incomes',
                    style: new TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
              new Flexible(
                child: new RadioListTile<BalanceType>(
                  value: BalanceType.expenses,
                  groupValue: _balanceType,
                  onChanged: _setBalanceType,
                  title: new Text(
                    'Expenses',
                    style: new TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: new Text(
              'Date',
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
          Container(
            child: DateTimePickerFormField(
              inputType: InputType.date,
              format: DateFormat('yyyy-MM-dd'),
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
              'Total',
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
          TextFormField(
            controller: priceTextController,
            decoration: InputDecoration(
              prefix: Text("￥"),
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
              'Description',
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
              'Cash or Charge',
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
                    'Cash',
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
                    'Charge',
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
                    child: _addButton()),
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
          title: Text('regsiter payment'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: 'one-time',
              ),
              Tab(
                text: 'regularly',
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
        'Cancel',
        style: TextStyle(fontSize: 16.9),
      ),
      textColor: Colors.white70,
    );
  }

  RaisedButton _addButton() {
    return RaisedButton(
      onPressed: _addReceipt,
      color: Colors.green,
      child: Text(
        'Add',
        style: TextStyle(fontSize: 16.9),
      ),
      textColor: Colors.white70,
    );
  }

  void _addReceipt() {
    var newReceipt = new Receipt(
      utime: paidDate.millisecondsSinceEpoch,
      price: num.tryParse(priceTextController.text),
      description: descriptionTextController.text,
    );
    // DEBUG: delete finally
    print(paidDate.toString());
    print(newReceipt.toMap());
    // _dbProvider.newReceipt(newReceipt);
  }
}
