import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:manemo/const.dart';
import 'package:manemo/enum.dart';
import 'package:manemo/model.dart';
import 'package:manemo/receipttabbase.dart';
import 'package:manemo/viewmodel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APPNAME,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Monemo(title: APPNAME),
    );
  }
}

class Monemo extends StatefulWidget {
  Monemo({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MonemoState createState() => _MonemoState();
}

final formatter = DateFormat(DATE_FORMAT_YYYY_MM, LOCALE_JA_JP);
final currencyFormat =
    NumberFormat(DISPLAY_CURRENCY_NUMBER_FORMAT, LOCALE_JA_JP);

class _MonemoState extends State<Monemo> {
  DateTime _displayDateTime;
  String _currentDisplayYearMonth = '';
  List<Receipt> _receipts = List<Receipt>();
  String _cashSumText = '';
  String _chargeSumText = '';
  String _accountBalanceSumText = '';

  @override
  void initState() {
    super.initState();
    initializeDateFormatting(LOCALE_JA_JP);
    _displayDateTime = DateTime.now();
    _currentDisplayYearMonth = formatter.format(_displayDateTime);
  }

  void updateDisplayToCurrentMonth() {
    setState(() {
      _displayDateTime = DateTime.now();
      _currentDisplayYearMonth = formatter.format(_displayDateTime);
    });
  }

  void updateDisplayToNextMonth() {
    setState(() {
      _displayDateTime =
          DateTime(_displayDateTime.year, _displayDateTime.month + 1, 1);
      _currentDisplayYearMonth = formatter.format(_displayDateTime);
    });
  }

  void updateDisplayToPrevMonth() {
    setState(() {
      _displayDateTime =
          DateTime(_displayDateTime.year, _displayDateTime.month - 1, 1);
      _currentDisplayYearMonth = formatter.format(_displayDateTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    var controllButtons = <Widget>[];
    return Scaffold(
      appBar: AppBar(
        title: Text(APPNAME),
      ),
      body: FutureBuilder<List<Receipt>>(
        future: StaticInstances.dbprovider
            .listAllReceipts(_displayDateTime.year, _displayDateTime.month),
        builder: (BuildContext context, AsyncSnapshot<List<Receipt>> snapshot) {
          _receipts = snapshot.data;
          if (_receipts == null) {
            _receipts = List<Receipt>();
          }
          var sumResult = sumReceipts(_receipts);
          _cashSumText = currencyFormat.format(sumResult.sumOfCashPayment);
          _chargeSumText = currencyFormat.format(sumResult.sumOfChargePayment);
          _accountBalanceSumText =
              currencyFormat.format(sumResult.sumOfAccountBalance);
          controllButtons.removeRange(0, controllButtons.length);
          controllButtons.add(FlatButton(
            child: const Icon(
              Icons.chevron_left,
              color: Colors.indigo,
              size: 50.0,
            ),
            onPressed: updateDisplayToNextMonth,
          ));
          var now = DateTime.now();
          if (now.year != _displayDateTime.year ||
              now.month != _displayDateTime.month) {
            controllButtons.add(FlatButton(
              child: const Icon(
                Icons.undo,
                color: Colors.indigo,
                size: 50.0,
              ),
              onPressed: updateDisplayToCurrentMonth,
            ));
          }
          controllButtons.add(FlatButton(
            child: const Icon(
              Icons.chevron_right,
              color: Colors.indigo,
              size: 50.0,
            ),
            onPressed: updateDisplayToPrevMonth,
          ));
          return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
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
                                Icons.account_balance_wallet,
                                size: 40.0,
                                color: Colors.indigo,
                              ),
                              title: Text(_cashSumText,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontSize: 30)),
                              subtitle: Text(DISPLAY_WORD_CASH,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontSize: 10)),
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.credit_card,
                                size: 40.0,
                                color: Colors.indigo,
                              ),
                              title: Text(_chargeSumText,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontSize: 30)),
                              subtitle: Text(DISPLAY_WORD_CHARGE,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontSize: 10)),
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.account_balance,
                                size: 40.0,
                                color: Colors.indigo,
                              ),
                              title: Text(_accountBalanceSumText,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontSize: 30)),
                              subtitle: Text(DISPLAY_WORD_ACCOUNT,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontSize: 10)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                          height: 200,
                          child: ListView.builder(
                            itemCount: _receipts.length,
                            itemBuilder: (context, int index) {
                              var receipt = _receipts[index];
                              return Dismissible(
                                onDismissed: (direction) {
                                  setState(() {
                                    _receipts.removeAt(index);
                                    StaticInstances.dbprovider.deleteReceipt(
                                        receipt.id,
                                        ContinuationType
                                            .values[receipt.continuationType]);
                                  });
                                },
                                key: Key(receipt.id.toString()),
                                child: Card(
                                  child: Column(
                                    children: <Widget>[
                                      ListTileTheme(
                                        iconColor: _listItemColor(BalanceType
                                            .values[receipt.balanceType]),
                                        textColor: _listItemColor(BalanceType
                                            .values[receipt.balanceType]),
                                        child: ListTile(
                                          leading: _moneyTypeIcon(MoneyType
                                              .values[receipt.moneyType]),
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Expanded(
                                                  child: Text(
                                                      receipt.description,
                                                      textAlign:
                                                          TextAlign.left)),
                                              Expanded(
                                                  child: Text(
                                                      currencyFormat.format(
                                                          receipt.price),
                                                      textAlign:
                                                          TextAlign.right)),
                                            ],
                                          ),
                                          subtitle: Text(_utimeToDateTimeString(
                                              receipt.utime)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )),
                    ),
                  ]));
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: controllButtons,
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.indigo,
          child: Icon(Icons.add_circle),
          onPressed: openTab),
    );
  }

  String _utimeToDateTimeString(int utime) {
    return StaticInstances.dateFormat
        .format(DateTime.fromMillisecondsSinceEpoch(utime));
  }

  Color _listItemColor(BalanceType balanceType) {
    if (balanceType == BalanceType.expenses) {
      return Colors.redAccent;
    }
    return Colors.green;
  }

  Icon _moneyTypeIcon(MoneyType moneyType) {
    switch (moneyType) {
      case MoneyType.cash:
        return Icon(Icons.account_balance_wallet);
      case MoneyType.charge:
        return Icon(Icons.credit_card);
      case MoneyType.account:
        return Icon(Icons.pool);
    }
    throw Exception('Illegal payment type');
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
