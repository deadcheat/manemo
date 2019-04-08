import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:manemo/paymenttype.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class ManemoReceiptDialog extends StatefulWidget {
  ManemoReceiptDialog({Key key}) : super(key: key);

  @override
  _ManemoReceiptDialogState createState() => new _ManemoReceiptDialogState();
}

class _ManemoReceiptDialogState extends State<ManemoReceiptDialog> {
  final myController = TextEditingController();
  final currencyFormat = new NumberFormat("#,###", "ja_JP");
  final dateFormat = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
  DateTime paidDate;
  DateTime lastMonth;
  DateTime payDay;
  PaymentType _paymentType = PaymentType.cash;
  void _setPaymentType(PaymentType newVal) {
    setState(() {
      _paymentType = newVal;
    });
  }

  @override
  void initState() {
    super.initState();
    myController.text = '0';
    myController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    // This also removes the _printLatestValue listener
    myController.dispose();
    super.dispose();
  }

  String _previousValue;

  _printLatestValue() {
    final value = myController.text;
    if (value == _previousValue) {
      return;
    }
    if (value == null || value.isEmpty) {
      myController.text = '0';
      return;
    }
    final n = num.tryParse(myController.text);
    final formattedValue = currencyFormat.format(n);
    _previousValue = formattedValue;
    myController.text = formattedValue;
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
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
              editable: true,
              initialDate: new DateTime.now(),
              initialValue: new DateTime.now(),
              style: TextStyle(fontSize: 24.0),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  labelText: 'Date/Time', hasFloatingPlaceholder: false),
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
            controller: myController,
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
          new Padding(
            padding: new EdgeInsets.all(8.0),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: new Text(
              'Which did you pay by?',
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Radio<PaymentType>(
                value: PaymentType.cash,
                groupValue: _paymentType,
                onChanged: _setPaymentType,
              ),
              new Text(
                'Cash',
                style: new TextStyle(fontSize: 20.0),
              ),
              new Radio<PaymentType>(
                value: PaymentType.charge,
                groupValue: _paymentType,
                onChanged: _setPaymentType,
              ),
              new Text(
                'Charge',
                style: new TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 100.0),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // TODO: this calculation is strange
              children: <Widget>[
                Container(
                  width: (MediaQuery.of(context).size.width) / 2 - 30,
                  child: _cancelButton(),
                ),
                Container(
                    width: (MediaQuery.of(context).size.width) / 2 - 30,
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
        children: <Widget>[
          Text('tab2'),
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
                text: 'tab 1',
              ),
              Tab(
                text: 'tab 2',
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

  void _showMonthDialog() {
    showMonthPicker(context: context, initialDate: lastMonth ?? DateTime.now())
        .then((date) => setState(() {
              lastMonth = date;
            }));
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

  void _addReceipt() {}
}
