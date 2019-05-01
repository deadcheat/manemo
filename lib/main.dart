import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:manemo/database.dart';
import 'package:manemo/model.dart';
import 'package:manemo/receipttabbase.dart';
import 'package:manemo/viewmodel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Monemo(title: 'Monemo'),
    );
  }
}

class Monemo extends StatefulWidget {
  Monemo({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MonemoState createState() => _MonemoState();
}

final formatter = new DateFormat('yyyy/MM', "ja_JP");
final currencyFormat = new NumberFormat("#,###", "ja_JP");

class _MonemoState extends State<Monemo> {
  DateTime _displayDateTime;
  String _currentDisplayYearMonth = '';
  final _dbProvider = ManemoDBProvider.db;
  List<Receipt> _receipts = List<Receipt>();
  String _cashSumText = '';

  // どこかのライフサイクル？
  @override
  void initState() {
    super.initState();
    initializeDateFormatting("ja_JP");
    _displayDateTime = DateTime.now();
    _currentDisplayYearMonth = formatter.format(_displayDateTime);
  }

  void updateDisplayToNextMonth() {
    setState(() {
      _displayDateTime =
          new DateTime(_displayDateTime.year, _displayDateTime.month + 1, 1);
      _currentDisplayYearMonth = formatter.format(_displayDateTime);
    });
  }

  void updateDisplayToPrevMonth() {
    setState(() {
      _displayDateTime =
          new DateTime(_displayDateTime.year, _displayDateTime.month - 1, 1);
      _currentDisplayYearMonth = formatter.format(_displayDateTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Monemo'),
      ),
      body: FutureBuilder<List<Receipt>>(
        future: _dbProvider.listReceipts(
            _displayDateTime.year, _displayDateTime.month),
        builder: (BuildContext context, AsyncSnapshot<List<Receipt>> snapshot) {
          _receipts = snapshot.data;
          var sumResult = sumReceipts(_receipts);
          _cashSumText = currencyFormat.format(sumResult.sumOfCashPayment);
          return new Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(_currentDisplayYearMonth,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 30)),
                            ListTile(
                              leading: Icon(
                                Icons.attach_money,
                                size: 40.0,
                                color: Colors.indigo,
                              ),
                              title: Text(_cashSumText,
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
                                    onPressed: updateDisplayToNextMonth,
                                  ),
                                  FlatButton(
                                    child: const Text('PREV MONTH'),
                                    onPressed: updateDisplayToPrevMonth,
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
                                      title:
                                          Text('created ' + index.toString()),
                                    )
                                  ],
                                ),
                              );
                            },
                          )),
                    ),
                  ]));
        },
      ),
      floatingActionButton: new FloatingActionButton(
          backgroundColor: const Color(0xFF0099ed),
          child: new Icon(Icons.add_circle),
          onPressed: openTab),
    );
  }

  void openTab() {
    Navigator.push(
      context,
      MaterialPageRoute(
          settings: RouteSettings(name: "/payments/register"),
          builder: (BuildContext context) => ManemoReceiptTabview()),
    );
  }
}
