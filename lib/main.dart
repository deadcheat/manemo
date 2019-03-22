import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

enum PaymentType { cash, charge }

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: Monemo(title: 'Monemo'),
    );
  }
}

class Monemo extends StatefulWidget {
  Monemo({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MonemoState createState() => _MonemoState();
}

class _MonemoState extends State<Monemo> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Monemo'),
      ),
      body: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('2019/03',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30)),
                    const ListTile(
                      leading: Icon(
                        Icons.attach_money,
                        size: 40.0,
                        color: Colors.indigo,
                      ),
                      title: Text('30,000',
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 30)),
                      subtitle: Text('Cash',
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 10)),
                    ),
                    const ListTile(
                      leading: Icon(
                        Icons.credit_card,
                        size: 40.0,
                        color: Colors.indigo,
                      ),
                      title: Text('30,000',
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 30)),
                      subtitle: Text('Charge',
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 10)),
                    ),
                    ButtonTheme.bar(
                      child: ButtonBar(
                        alignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlatButton(
                            child: const Text('NEXT MONTH'),
                            onPressed: () {/* ... */},
                          ),
                          FlatButton(
                            child: const Text('PREV MONTH'),
                            onPressed: () {/* ... */},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            new Expanded(
              child: new SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: 4,
                    itemBuilder: (context, int index) {
                      return Card(
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.map),
                              title: Text('created ' + index.toString()),
                            )
                          ],
                        ),
                      );
                    },
                  )),
            ),
          ]),
      floatingActionButton: new FloatingActionButton(
          backgroundColor: const Color(0xFF0099ed),
          child: new Icon(Icons.add_circle),
          onPressed: fabPressed),
    );
  }

  final _formKey = GlobalKey<FormState>();
  void fabPressed() {
    showDialog(context: context, builder: (_) => ManemoReceiptDialog());
  }
}

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

    myController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    // This also removes the _printLatestValue listener
    myController.dispose();
    super.dispose();
  }

  _printLatestValue() {
    final n = num.tryParse(myController.text);
    final formattedValue = currencyFormat.format(n);
    print("First text field: ${currencyFormat.format(n)}");
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
            ],
          ))
    ]);
  }
}
