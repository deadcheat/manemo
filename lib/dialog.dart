import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:manemo/paymenttype.dart';

class ManemoReceiptDialog extends StatefulWidget {
  ManemoReceiptDialog({Key key}) : super(key: key);

  @override
  _ManemoReceiptDialogState createState() => new _ManemoReceiptDialogState();
}

class _ManemoReceiptDialogState extends State<ManemoReceiptDialog> {
  final myController = TextEditingController();
  final currencyFormat = new NumberFormat("#,###", "ja_JP");
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
    return new SimpleDialog(children: <Widget>[
      Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: new Text(
                  'How much have you spent ?',
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Radio<PaymentType>(
                    value: PaymentType.cash,
                    groupValue: _paymentType,
                    onChanged: _setPaymentType,
                  ),
                  new Text(
                    'Cash',
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  new Radio<PaymentType>(
                    value: PaymentType.charge,
                    groupValue: _paymentType,
                    onChanged: _setPaymentType,
                  ),
                  new Text(
                    'Charge',
                    style: new TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              calculateButton()
            ],
          ))
    ]);
  }

  RaisedButton calculateButton() {
    return RaisedButton(
      onPressed: _calculator,
      color: Colors.green,
      child: Text(
        'Add',
        style: TextStyle(fontSize: 16.9),
      ),
      textColor: Colors.white70,
    );
  }

  void _calculator() {}
}
